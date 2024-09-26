{ config, pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        height = 30;
        spacing = 4;
        modules-left = [ "hyprland/workspaces" ];
        modules-center = [ "hyprland/window" ];
        modules-right = [ "mpd" "pulseaudio" "cpu" "memory" "clock" "tray" ];
        mpd = {
          format = "{stateIcon} {artist} - {album} - {title} ({elapsedTime:%M:%S}/{totalTime:%M:%S}) [{songPosition}|{queueLength}] 🎵";
          format-disconnected = "Disconnected 🎵";
          format-stopped = "{consumeIcon}Stopped 🎵";
          unknown-tag = "N/A";
          interval = 2;
          state-icons = {
              paused = "";
              playing = "";
          };
          tooltip-format = "MPD (connected)";
          tooltip-format-disconnected = "MPD (disconnected)";
          on-click = "foot -e ncmpcpp";
        };
        tray = {
          icon-size = 21;
          spacing = 10;
          show-passive-items = true;
        };
        clock = {
          format = "{:%H:%M\t%Y-%m-%d}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };
        cpu = {
          format = "{usage}% ";
          tooltip = false;
        };
        memory = {
          format = "{}% ";
        };
        network = {
          format-wifi = "";
          tooltip = false;
          format-ethernet = "";
          format-linked = "";
          format-disconnected = "⚠";
          on-click = "kcmshell5 kcm_networkmanagement";
        };
        pulseaudio = {
          format = "{volume}% {icon}";
          format-bluetooth = "{volume}% {icon}";
          format-bluetooth-muted = " {icon}";
          format-muted = " ";
          format-source = "{volume}% ";
          format-source-muted = "";
          format-icons = {
              headphone = "";
              hands-free = "";
              headset = "";
              phone = "";
              portable = "";
              car = "";
              default = ["" "" ""];
          };
          on-click = "pavucontrol";
        };
      };
    };
    style = ''
    window#waybar {
        font-family: FontAwesome, Roboto, Helvetica, Arial, sans-serif;
        font-size: 13px;
        background: transparent;
        color: #ffffff;
        text-shadow: 1px 1px #64727D;
        transition-property: background-color;
        transition-duration: .5s;
    }
    button {
        border: none;
        border-radius: 0;
    }
    button:hover {
        background: inherit;
        box-shadow: inset 0 -3px #ffffff;
    }
    #workspaces button {
        padding: 0 5px;
        text-shadow: 1px 1px #64727D;
        background-color: transparent;
        color: #ffffff;
    }
    #workspaces button:hover {
        background: rgba(0, 0, 0, 0.2);
    }
    #workspaces button.focused {
        background: transparent;
        box-shadow: inset 0 -3px #ffffff;
    }
    #workspaces button.urgent {
        background-color: #eb4d4b;
    }
    #clock,
    #cpu,
    #memory,
    #disk,
    #network,
    #pulseaudio,
    #wireplumber,
    #custom-media,
    #tray,
    #mode,
    #scratchpad,
    #mpd {
        padding: 0 10px;
    }
    #window,
    #workspaces {
        margin: 0 4px;
    }
    .modules-left > widget:first-child > #workspaces {
        margin-left: 0;
    }

    /* If workspaces is the rightmost module, omit right margin */
    .modules-right > widget:last-child > #workspaces {
        margin-right: 0;
    }
    #tray > .passive {
        -gtk-icon-effect: dim;
    }
    #tray > .needs-attention {
        -gtk-icon-effect: highlight;
    }
    #scratchpad {
        background: rgba(0, 0, 0, 0.2);
    }

    #scratchpad.empty {
        background-color: transparent;
    }
    '';
  };
}
