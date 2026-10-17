#!/usr/bin/env bash
# headset-g733.sh — Waybar custom module for Logitech G733 (LIGHTSPEED)
#
# G733 的限制：headsetcontrol 在充電時只回傳 BATTERY_CHARGING，不回傳電量，
# 所以充電進度改用「已充時間 / 預估滿充時間」估算，並在充電結束時發出提示音。
#
# 依賴: headsetcontrol, jq
# 選用: notify-send, pw-play / paplay / canberra-gtk-play
#
# 可調環境變數:
#   G733_FULL_MINUTES   預估滿充分鐘數（預設 180，建議自己實測後校正）
#   G733_FULL_LEVEL     視為「已充飽」的電量門檻（預設 90）
#   G733_LOW_LEVEL      低電量警示門檻（預設 20）
#   G733_SOUND          提示音檔路徑

set -uo pipefail

STATE_DIR="${XDG_RUNTIME_DIR:-/tmp}/headset-g733"
STATE_FILE="$STATE_DIR/state"
mkdir -p "$STATE_DIR"

FULL_MINUTES="${G733_FULL_MINUTES:-180}"
FULL_LEVEL="${G733_FULL_LEVEL:-90}"
LOW_LEVEL="${G733_LOW_LEVEL:-20}"
SOUND="${G733_SOUND:-/usr/share/sounds/freedesktop/stereo/complete.oga}"

now="$(date +%s)"

notify_full() {
    local msg="$1"
    (
        command -v notify-send >/dev/null 2>&1 &&
            notify-send -a "G733" -i audio-headphones -u normal "耳機充電完成" "$msg"
        if [[ -r "$SOUND" ]]; then
            if   command -v pw-play           >/dev/null 2>&1; then pw-play "$SOUND"
            elif command -v paplay            >/dev/null 2>&1; then paplay "$SOUND"
            elif command -v canberra-gtk-play >/dev/null 2>&1; then canberra-gtk-play -f "$SOUND"
            fi
        fi
    ) >/dev/null 2>&1 &
    disown 2>/dev/null || true
}

emit() {  # emit <text> <alt> <tooltip> <class> [percentage]
    if [[ -n "${5:-}" ]]; then
        printf '{"text":"%s","alt":"%s","tooltip":"%s","class":"%s","percentage":%s}\n' \
               "$1" "$2" "$3" "$4" "$5"
    else
        printf '{"text":"%s","alt":"%s","tooltip":"%s","class":"%s"}\n' "$1" "$2" "$3" "$4"
    fi
}

# ---------- 讀取 headsetcontrol ----------
bstatus=""
level=-1

if command -v headsetcontrol >/dev/null 2>&1 && command -v jq >/dev/null 2>&1; then
    raw="$(headsetcontrol -o json 2>/dev/null)"
    if [[ -n "$raw" ]]; then
        dev="$(jq -c '[ .devices[]? | select(.battery != null) ][0] // empty' <<<"$raw" 2>/dev/null)"
        if [[ -n "$dev" ]]; then
            bstatus="$(jq -r '.battery.status // ""' <<<"$dev")"
            level="$(jq -r '.battery.level // -1' <<<"$dev")"
        fi
    fi
fi

# ---------- 載入前次狀態 ----------
prev_mode="off"
prev_level=-1
charge_start=0
level_before=-1
notified=0
# shellcheck disable=SC1090
[[ -f "$STATE_FILE" ]] && source "$STATE_FILE"

# ---------- 耳機不在線 ----------
if [[ "$bstatus" != "BATTERY_CHARGING" && "$bstatus" != "BATTERY_AVAILABLE" ]]; then
    cat >"$STATE_FILE" <<EOF
prev_mode=off
prev_level=$prev_level
charge_start=$charge_start
level_before=$level_before
notified=$notified
EOF
    emit "" "disconnected" "G733 未連線或已關機" "disconnected"
    exit 0
fi

# ---------- 充電中 ----------
if [[ "$bstatus" == "BATTERY_CHARGING" ]]; then
    if [[ "$prev_mode" != "charging" ]]; then
        charge_start="$now"
        level_before="$prev_level"
        notified=0
    fi

    elapsed_min=$(( (now - charge_start) / 60 ))
    base="$level_before"
    (( base < 0 )) && base=0

    # 時間線性估算：base% → 100%，上限 99%（真正的 100% 只在停止充電後確認）
    est=$(( base + (100 - base) * elapsed_min / FULL_MINUTES ))
    (( est > 99 )) && est=99
    (( est < base )) && est="$base"

    # 備援提醒：超過預估滿充時間仍在充，視為已充飽
    if (( elapsed_min >= FULL_MINUTES )) && (( notified == 0 )); then
        notified=1
        notify_full "已充電 ${elapsed_min} 分鐘，預估已充飽"
    fi

    tip="G733 — 充電中\n已充 ${elapsed_min} 分鐘"
    (( level_before >= 0 )) && tip="${tip}（起始 ${level_before}%）"
    tip="${tip}\n預估進度 ~${est}%（依時間推算，非硬體回報）"

    cat >"$STATE_FILE" <<EOF
prev_mode=charging
prev_level=$prev_level
charge_start=$charge_start
level_before=$level_before
notified=$notified
EOF

    emit "~${est}%" "charging" "$tip" "charging" "$est"
    exit 0
fi

# ---------- 未充電 ----------
if (( level < 0 )); then
    emit "" "disconnected" "G733 電量讀取失敗" "disconnected"
    exit 0
fi

# 充電剛結束：確認是否達到門檻
if [[ "$prev_mode" == "charging" ]] && (( notified == 0 )); then
    if (( level >= FULL_LEVEL )); then
        notified=1
        notify_full "G733 已充飽 — ${level}%"
    fi
fi
(( level < FULL_LEVEL - 10 )) && notified=0

class="discharging"
(( level <= LOW_LEVEL )) && class="critical"

tip="G733 — ${level}%\n未充電"

cat >"$STATE_FILE" <<EOF
prev_mode=idle
prev_level=$level
charge_start=$charge_start
level_before=$level_before
notified=$notified
EOF

emit "${level}%" "discharging" "$tip" "$class" "$level"
