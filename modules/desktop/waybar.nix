{
  config,
  pkgs,
  ...
}: {
  programs.waybar.enable = true;

  # Symlink config.jsonc + style + scripts as-is to preserve the existing
  # JSONC formatting and CSS theming.
  xdg.configFile."waybar/config.jsonc".source = ../../config/waybar/config.jsonc;
  xdg.configFile."waybar/style.css".source = ../../config/waybar/style.css;
  xdg.configFile."waybar/mocha.css".source = ../../config/waybar/mocha.css;
  xdg.configFile."waybar/oxocarbon.css".source = ../../config/waybar/oxocarbon.css;
  xdg.configFile."waybar/scripts" = {
    source = ../../config/waybar/scripts;
    recursive = true;
  };
}
