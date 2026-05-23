{
  config,
  pkgs,
  ...
}: {
  # Install rofi-wayland but manage config files manually since the existing
  # setup uses a large tree of RASI themes/applets/launchers that the
  # home-manager `programs.rofi` module would conflict with.
  home.packages = [pkgs.rofi-wayland];

  xdg.configFile."rofi" = {
    source = ../../config/rofi;
    recursive = true;
  };
}
