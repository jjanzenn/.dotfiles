{ config, pkgs, ... }:

{
  imports = [
    ./fastfetch.nix
    ./foot.nix
    ./git.nix
    ./hyprlock.nix
    ./ncmpcpp.nix
    ./ssh.nix
    ./waybar.nix
    ./zsh.nix
  ];

  home.packages = with pkgs; [
    discord # not FOSS
    fuzzel
    htop
    hyfetch
    hyprshot
    mpc-cli
    networkmanagerapplet
    obs-studio
    pavucontrol
    prismlauncher # minecraft
    python3
    swaybg
    texliveFull
  ];
}
