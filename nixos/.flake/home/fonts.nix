{ config, pkgs, ... }:

{
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    cm_unicode
    (pkgs.nerdfonts.override { fonts = [ "SourceCodePro" ]; })
  ];
}
