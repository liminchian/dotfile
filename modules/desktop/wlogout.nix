{
  config,
  pkgs,
  ...
}: {
  xdg.configFile."wlogout" = {
    source = ../../config/wlogout;
    recursive = true;
  };
}
