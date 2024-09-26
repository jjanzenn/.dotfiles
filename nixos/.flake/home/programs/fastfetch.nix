{ config, pkgs, ... }:

{
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
          type = "raw";
          source = "~/.config/fastfetch/logo.sixel";
          width = 40;
          height = 19;
      };
      display = {
        separator = "  ";
      };
      modules = [
        "title"
        {
            type = "custom";
            format = "──────────────────────────────────";
        }
        {
            type = "os";
            key = "";
        }
        {
            type = "kernel";
            key = "󰞸";
        }
        {
            type = "uptime";
            key = "";
        }
        {
            type = "packages";
            key = "";
        }
        {
            type = "shell";
            key = "";
        }
        {
            type = "display";
            key = "󰍹";
        }
        {
            type = "wm";
            key = "";
        }
        {
            type = "terminal";
            key = "";
        }
        {
            type = "cpu";
            key = "";
        }
        {
            type = "gpu";
            key = "";
        }
        {
            type = "memory";
            key = "";
        }
        {
            type = "disk";
            key = "";
        }
        {
            type = "locale";
            key = "";
        }
        "break"
        "colors"
      ];
    };
  };
}
