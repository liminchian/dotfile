{
  config,
  pkgs,
  inputs,
  system,
  ...
}: let
  # Wrap the existing config/ags/default.nix derivation, threading in the
  # flake inputs (ags, matugen, hyprland) that the derivation expects.
  ags-pkg = pkgs.callPackage ../../config/ags {
    inherit inputs system;
  };
in {
  home.packages = [ags-pkg];
}
