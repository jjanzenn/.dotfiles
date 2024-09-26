{ config, pkgs, ... }:

{
  imports = [
    ./mpd.nix
    ./syncthing.nix
  ];

  home.packages = with pkgs; [
    mako # TODO
    mpdscribble
  ];
}
