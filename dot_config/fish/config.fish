if status is-interactive
    # Commands to run in interactive sessions can go here
end

if status --is-login
  if test -z "$DISPLAY" && test "$(tty)" = "/dev/tty1"
    set -gx LANG zh_TW.UTF-8
    
    set -gx QT_WAYLAND_DISABLE_WINDOWDECORATION 1
    set -gx GDK_BACKEND wayland
    set -gx CLUTER_BACKEND wayland
    set -gx QT_QPA_PLATFORM wayland
    
    set -gx XCURSOR_SIZE 24
    set -gx DESKTOP_SESSION Hyprland
    set -gx AUTOJUMP_PATH $HOME/.autojump/share/autojump/autojump.fish

    set -gx GLFW_IM_MODULE wayland 
    set -gx QT_IM_MODULE "wayland;fcitx;ibus"
    set -gx SDL_IM_MODULE fcitx
    set -gx INPUT_METHOD fcitx
    set -gx XMODIFIERS @im fcitx
    
    set -gx HYPRLAND_LOG_WLR 1
    set -gx SAL_USE_VCLPLUGIN gtk3 
    
    exec Hyprland
  end
end

if test -e "$AUTOJUMP_PATH"
  source "$AUTOJUMP_PATH"
end

set find_key_bindings fish_user_key_bindings fish_mode_prompt
set fish_cursor_default     block
set fish_cursor_insert      line      
set fish_cursor_replace_one underscore
set fish_cursor_visual      block
set -g fish_escape_delay_ms    100

starship init fish | source
pokemon-colorscripts --no-title -r 1,3,6
