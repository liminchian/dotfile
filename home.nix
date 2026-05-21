{
  config,
  pkgs,
  inputs,
  system,
  ...
}: {
  imports = [
    ./modules/shell.nix
    ./modules/terminal.nix
    ./modules/editor.nix
    ./modules/tools.nix
    ./modules/wm/niri.nix
    ./modules/wm/hyprland.nix
    ./modules/desktop/waybar.nix
    ./modules/desktop/mako.nix
    ./modules/desktop/wlogout.nix
    ./modules/desktop/ags.nix
    ./modules/launcher/anyrun.nix
    ./modules/launcher/rofi.nix
  ];

  home.username = "sei";
  home.homeDirectory = "/home/sei";
  home.stateVersion = "24.11";

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.local/share"
    "$HOME/.local/bin/scripts"
    "$HOME/.cargo/bin"
  ];

  home.sessionVariables = {
    LANG = "zh_TW.UTF-8";
    LC_ALL = "zh_TW.UTF-8";
    RUST_WRAPPER = "sccache";
    JUPYTERLAB_DIR = "$HOME/.local/share/jupyter/lab";
    SKIM_DEFAULT_OPTIONS = "--ansi --regex";

    # Fcitx5 input method
    XMODIFIERS = "@im=fcitx";
    QT_IM_MODULE = "fcitx";
    SDL_IM_MODULE = "fcitx";
    INPUT_METHOD = "fcitx";
  };

  home.packages = with pkgs; [
    # Utilities used by abbr.fish and scripts
    eza
    bat
    dust
    procs
    skim
    ripgrep
    xcp
    fd
    sccache

    # Pokemon colorscripts (referenced in config.fish)
    pokemon-colorscripts-mac

    # Fonts
    nerd-fonts.victor-mono

    # Launchers / utilities not covered by dedicated modules
    anyrun
    swaylock
    swayidle
    mpvpaper
    imagemagick

    # Apps mentioned in README
    zed-editor

    # Wayland/screenshot/clipboard helpers
    wl-clipboard
    slurp
    grim
    swappy
    brightnessctl
    pavucontrol

    # Input method
    fcitx5
    fcitx5-chinese-addons
    fcitx5-configtool
  ];

  # Install user scripts into ~/.local/bin/scripts/
  home.file.".local/bin/scripts/blur-wallpaper" = {
    source = ./scripts/blur-wallpaper;
    executable = true;
  };
  home.file.".local/bin/scripts/launcher" = {
    source = ./scripts/launcher;
    executable = true;
  };
  home.file.".local/bin/scripts/livewallpaper" = {
    source = ./scripts/livewallpaper;
    executable = true;
  };
  home.file.".local/bin/scripts/lock" = {
    source = ./scripts/lock;
    executable = true;
  };
  home.file.".local/bin/scripts/note_sync" = {
    source = ./scripts/note_sync;
    executable = true;
  };
  home.file.".local/bin/scripts/powermenu" = {
    source = ./scripts/powermenu;
    executable = true;
  };
  home.file.".local/bin/scripts/volume" = {
    source = ./scripts/volume;
    executable = true;
  };
  home.file.".local/bin/pomobar" = {
    source = ./scripts/pomobar;
    executable = true;
  };

  programs.home-manager.enable = true;
}
