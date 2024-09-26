{ config, lib, pkgs, ... }:

{
  users.users.jane = {
    shell = pkgs.zsh;
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ];
  };
}
