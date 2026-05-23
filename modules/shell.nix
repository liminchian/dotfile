{
  config,
  pkgs,
  ...
}: {
  programs.fish = {
    enable = true;

    shellInit = ''
      # Conditionally set Wayland/Input env vars (don't overwrite login manager defaults)
      if test -z "$GDK_BACKEND"
          set -gx GDK_BACKEND wayland
          set -gx QT_QPA_PLATFORM wayland
          set -gx CLUTTER_BACKEND wayland
          set -gx MOZ_ENABLE_WAYLAND 1
          set -gx OZONE_PLATFORM wayland
      end

      # Autojump
      set -gx AUTO_PATH $HOME/.autojump/share/autojump/autojump.fish
      if test -f "$AUTO_PATH"
          source "$AUTO_PATH"
      end
    '';

    interactiveShellInit = ''
      # Pokemon colorscripts on startup
      pokemon-colorscripts --no-title -r 1,3,6

      # Editor & cursor settings
      set -g fish_cursor_default     block
      set -g fish_cursor_insert      line
      set -g fish_cursor_replace_one underscore
      set -g fish_cursor_visual      block
      set -g fish_escape_delay_ms    100
    '';

    shellAbbrs = {
      svim = "sudo -E nvim";
      fcd = "cd \$(sk)";
      fopen = "bat \$(sk)";
      hx = "helix";
      ack = "sk -i -c 'rg --color always --line-number \"{}\"'";
      du = "dust";
      ps = "procs --sortd cpu";
      ls = "exa -la --header";
      cat = "bat";
      mv = "mv";
      cp = "xcp";
      rm = "rm -i";
      mkdir = "mkdir -p";
    };
  };

  # Source fish files that aren't easily expressible in Nix (functions, key bindings)
  xdg.configFile."fish/functions" = {
    source = ../config/fish/functions;
    recursive = true;
  };
  xdg.configFile."fish/themes" = {
    source = ../config/fish/themes;
    recursive = true;
  };
  xdg.configFile."fish/completions" = {
    source = ../config/fish/completions;
    recursive = true;
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    settings = builtins.fromTOML (builtins.readFile ../config/starship.toml);
  };

  programs.atuin = {
    enable = true;
    enableFishIntegration = true;
    settings = builtins.fromTOML (builtins.readFile ../config/atuin/config.toml);
  };
}
