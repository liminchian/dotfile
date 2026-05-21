{
  config,
  pkgs,
  ...
}: {
  programs.zathura = {
    enable = true;
  };

  # Raw zathura config (any custom keybindings/colors not covered by the module)
  xdg.configFile."zathura/zathurarc" = {
    source = ../config/zathura/zathurarc;
  };
}
