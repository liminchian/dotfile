#!/usr/bin/env python3
"""mood.py — Waybar 模組：訂閱 uatu 的 mood socket，每行狀態轉成 waybar JSON。
連不上就隱藏並結束，由 waybar 的 restart-interval 重連。"""
import json, os, socket, sys


def render(line):
    status = json.loads(line)
    scores = sorted(status.get("scores", {}).items(), key=lambda kv: -kv[1])
    return {"text": status["text"], "tooltip": "\n".join(f"{k}  {v:.0%}" for k, v in scores)}


def main():
    path = os.path.join(os.environ["XDG_RUNTIME_DIR"], "uatu-mood.sock")
    try:
        sock = socket.socket(socket.AF_UNIX)
        sock.connect(path)
        for line in sock.makefile(encoding="utf-8"):
            if line.strip():
                print(json.dumps(render(line), ensure_ascii=False), flush=True)
    except OSError:
        pass
    print('{"text": ""}', flush=True)
    sys.exit(1)


if __name__ == "__main__":
    assert render('{"text":"💻 80%","key":"coding","confidence":0.8,"scores":{"idle":0.2,"coding":0.8}}') == {
        "text": "💻 80%", "tooltip": "coding  80%\nidle  20%"}
    assert render('{"text":"❔"}') == {"text": "❔", "tooltip": ""}  # 第一次判斷完成前沒有 scores
    main()
