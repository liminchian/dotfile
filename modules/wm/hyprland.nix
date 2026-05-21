{
  config,
  pkgs,
  ...
}: {
  # Hyprland configs are split across multiple files;
  # symlink the directory so the existing structure is preserved.
  xdg.configFile."hypr" = {
    source = ../../config/hypr;
    recursive = true;
  };
}
