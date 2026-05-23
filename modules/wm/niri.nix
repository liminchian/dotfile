{
  config,
  pkgs,
  ...
}: {
  # Niri uses a KDL config that doesn't map cleanly to Nix attrs;
  # symlink the raw file from the repo so edits stay simple.
  xdg.configFile."niri/config.kdl".source = ../../config/niri/config.kdl;
}
