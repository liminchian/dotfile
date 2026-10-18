# 語系設定 (建議放在這裡以確保所有子程序正確讀取)
set -gx LANG zh_TW.UTF-8
set -gx LC_ALL zh_TW.UTF-8

if status is-interactive
    # 互動模式下的工具
    starship init fish | source
    atuin init fish | source
    
    # 顯示寶可夢圖案
    pokemon-colorscripts --no-title -r 1,3,6
    
    # 編輯器與遊標設定
    set -g fish_cursor_default     block
    set -g fish_cursor_insert      line
    set -g fish_cursor_replace_one underscore
    set -g fish_cursor_visual       block
    set -g fish_escape_delay_ms    100
end

# 只有在沒有定義時才設置 Wayland/Input 相關變數
# 這樣可以避免覆蓋登入管理器預設的環境變數
if test -z "$GDK_BACKEND"
    set -gx GDK_BACKEND wayland
    set -gx QT_QPA_PLATFORM wayland
    set -gx CLUTTER_BACKEND wayland
    set -gx MOZ_ENABLE_WAYLAND 1
    set -gx OZONE_PLATFORM wayland
end

# Fcitx5 輸入法設定
set -gx XMODIFIERS @im=fcitx
set -gx QT_IM_MODULE fcitx
set -gx SDL_IM_MODULE fcitx
set -gx INPUT_METHOD fcitx

# Autojump
set -gx AUTO_PATH $HOME/.autojump/share/autojump/autojump.fish
if test -f "$AUTO_PATH"
    source "$AUTO_PATH"
end

alias think 'NVIM_APPNAME=nvim-think neovide --wayland_app_id=think'
alias pair  'NVIM_APPNAME=nvim-pair neovide --wayland_app_id=pair'
