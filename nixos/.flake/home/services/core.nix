{ config, pkgs, ... }:

{
  imports = [
    ./emacs.nix
    ./mako.nix
    ./mpd.nix
    ./syncthing.nix
  ];

  home.packages = with pkgs; [
    mpdscribble
  ];
}
