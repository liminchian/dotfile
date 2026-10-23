#!/usr/bin/env bash
# tasks.sh — Waybar Google Tasks 模組：常駐跑 uatu tasks daemon，清單一變就輸出數量
# 有逾期 → class overdue；有今天到期 → class today；tooltip 列出每項的期限與標題

uatu tasks daemon | jq --unbuffered -c '
  map(.title |= (split("\n")[0])) |
  {
    text: "󰄲 \(length)",
    tooltip: (map("\(.due // "")\t\(.title)") | join("\n")),
    class: (if any(.overdue) then "overdue" elif any(.today) then "today" else "normal" end)
  }'
