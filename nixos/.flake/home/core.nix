{ config, pkgs, ... }:

{
  imports = [
    ./cursor.nix
    ./fonts.nix
    ./hyprland.nix
    ./programs/core.nix
    ./services/core.nix
  ];

  home.username = "jane";
  home.homeDirectory = "/home/jane";

  home.stateVersion = "24.05";
  programs.home-manager.enable = true;
}
