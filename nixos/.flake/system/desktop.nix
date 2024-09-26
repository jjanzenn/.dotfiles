{ config, lib, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  security.pam.services.hyprlock = {};
  services.flatpak.enable = true;
  xdg.portal.enable = true;
  services.xserver.enable = true;
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --remember --remember-session --sessions ${pkgs.hyprland}/share/wayland-sessions --cmd \"dbus-run-session Hyprland\"";
	user = "greeter";
      };
    };
  };
  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StanardOutput = "tty";
    StandardError = "journal";
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };

  programs.hyprland.enable = true;

  services.xserver.xkb.layout = "us";

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };
  environment.systemPackages = with pkgs; [
    dolphin
    firefox
    git
    greetd.tuigreet
    kitty
    neovim
    wget
  ];
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  programs.zsh.enable = true;
  environment.variables.EDITOR = "vim";
  environment.pathsToLink = [ "/share/zsh" ];

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
}
