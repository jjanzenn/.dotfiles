{ config, pkgs, ... }:

{
  home.file.".icons/default".source = "${pkgs.vanilla-dmz}/share/icons/Vanilla-DMZ";
  xresources.properties = {
    "Xcursor.size" = 16;
  };
}
