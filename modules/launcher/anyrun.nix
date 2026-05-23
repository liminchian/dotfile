{
  config,
  pkgs,
  ...
}: {
  # Anyrun uses RON configs (Rust object notation) that don't have a
  # home-manager module; symlink the directory directly.
  xdg.configFile."anyrun" = {
    source = ../../config/anyrun;
    recursive = true;
  };
}
