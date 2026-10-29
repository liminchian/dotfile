#!/usr/bin/env bash
# mem.sh — Waybar 記憶體模組：RAM / VRAM 取使用率較高者，30/50/70/90 分級上色，
# >50% 時顯示上一個週期內峰值最高的程式。常駐執行，每秒取樣、每 PERIOD 秒輸出一次。

PERIOD=5

ram_pct()  { awk '/^MemTotal/{t=$2} /^MemAvailable/{a=$2} END{printf "%d", (t-a)*100/t}' /proc/meminfo; }
vram_pct() { nvidia-smi --query-gpu=memory.used,memory.total --format=csv,noheader,nounits 2>/dev/null |
             awk -F', ' '{printf "%d", $1*100/$2}'; }

# 輸出「MiB 名稱」；同名行程合併計算（瀏覽器會開很多個）
ram_top() {
    # 最大值直接在 awk 算；`sort | head -1` 會讓 sort 寫進已關閉的管線而報 broken pipe
    ps -eo rss=,comm= | awk '{r=$1; sub(/^ *[0-9]+ /, ""); s[$0]+=r}
        END{for(n in s) if(s[n] > m){m=s[n]; top=n} if(top != "") print int(m/1024), top}'
}
# compute-apps 不含圖形行程，所以解析 nvidia-smi 的行程表；名稱改從 /proc 取，避免被截斷的路徑
vram_top() {
    nvidia-smi 2>/dev/null |
        awk '$5 ~ /^[0-9]+$/ && $(NF-1) ~ /MiB$/ && $(NF-1)+0 > m {m=$(NF-1)+0; pid=$5; name=$(NF-2)}
             END{if(pid) print m, pid, name}' | {
            read -r mib pid name || exit
            echo "$mib $(cat /proc/"$pid"/comm 2>/dev/null || echo "${name##*/}")"
        }
}

while :; do
    peak=0 app=
    for ((i = 0; i < PERIOD; i++)); do
        r=$(ram_pct) v=$(vram_pct)
        if (( ${v:-0} > r )); then pct=$v kind=VRAM icon=󰍹 top=vram_top
        else                       pct=$r kind=RAM  icon=󰍛 top=ram_top; fi
        if (( pct > 50 )); then
            read -r mib name < <($top)
            (( ${mib:-0} > peak )) && peak=$mib app=$name
        fi
        (( i < PERIOD - 1 )) && sleep 1
    done

    class=low
    for t in 30 50 70 90; do (( pct >= t )) && class="p$t"; done

    text="$icon ${pct}%"
    tip="RAM ${r}%  VRAM ${v:-–}%"
    if [[ -n $app ]] && (( pct > 50 )); then
        text="$text 󰣆 ${app:0:8}"
        tip="$tip\n$kind 峰值：$app ${peak} MiB"
    fi
    printf '{"text":"%s","tooltip":"%s","class":"%s"}\n' "$text" "$tip" "$class"
    sleep 1
done
