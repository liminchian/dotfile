{
  config,
  pkgs,
  ...
}: {
  programs.alacritty = {
    enable = true;
    settings = builtins.fromTOML (builtins.readFile ../config/alacritty/alacritty.toml);
  };

  # Theme imports referenced by alacritty.toml
  xdg.configFile."alacritty/catppuccin-mocha.toml".source =
    ../config/alacritty/catppuccin-mocha.toml;
  xdg.configFile."alacritty/catppuccin-frappe.toml".source =
    ../config/alacritty/catppuccin-frappe.toml;
}
