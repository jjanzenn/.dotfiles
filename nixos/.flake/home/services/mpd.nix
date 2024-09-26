{ config, pkgs, ... }:

{
  services.mpd = {
    enable = true;
    musicDirectory = "~/Music";
    extraConfig = ''
    audio_output {
      type "pipewire"
      name "Pipewire"
      mixer_type "hardware"
      enabled "yes"
    }
    '';
  };
}
