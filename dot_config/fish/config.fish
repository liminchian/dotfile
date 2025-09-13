if status is-interactive
    # Commands to run in interactive sessions can go here
    starship init fish | source
    atuin init fish | source
    pokemon-colorscripts --no-title -r 1,3,6
end

if status --is-login
  if test -z "$DISPLAY" && test "$(tty)" = "/dev/tty2"
    set -gx LANG zh_TW.UTF8

    set -gx QT_WAYLAND_DISABLE_WINDOWDECORATION 1
    set -gx GDK_BACKEND wayland
    set -gx CLUTER_BACKEND wayland
    set -gx QT_QPA_PLATFORM wayland

    set -gx XCURSOR_SIZE 24
    set -gx DESKTOP_SESSION Hyprland
    set -gx AUTOJUMP_PATH $HOME/.autojump/share/autojump/autojump.fish
    set -gx MOZ_ENABLE_WAYLAND 1

    set -gx GLFW_IM_MODULE wayland
    set -gx QT_IM_MODULE fcitx
    set -gx SDL_IM_MODULE fcitx
    set -gx INPUT_METHOD fcitx
    set -gx XMODIFIERS fcitx
    set -gx SAL_USE_VCLPLUGIN gtk3
    set -gx OZONE_PLATFORM wayland
    set -gx GSK_RENDERER ngl
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

