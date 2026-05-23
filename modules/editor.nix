{
  config,
  pkgs,
  ...
}: {
  programs.helix = {
    enable = true;
    settings = builtins.fromTOML (builtins.readFile ../config/helix/config.toml);
  };

  # Custom themes referenced by helix config.toml
  xdg.configFile."helix/themes" = {
    source = ../config/helix/themes;
    recursive = true;
  };
}
