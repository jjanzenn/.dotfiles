{ config, pkgs, ... }:

{
  services.emacs = {
    enable = true;
    client.enable = true;
    socketActivation.enable = true;
  };
}
