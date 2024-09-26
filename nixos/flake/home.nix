{ config, pkgs, ... }:

{
  home.username = "jane";
  home.homeDirectory = "/home/jane";

  home.file.".icons/default".source = "${pkgs.vanilla-dmz}/share/icons/Vanilla-DMZ"; 
  xresources.properties = {
    "Xcursor.size" = 16;
  };

  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    discord
    hyprshot
    (pkgs.nerdfonts.override { fonts = [ "SourceCodePro" ]; })
    fuzzel
    hyfetch
    htop
    networkmanagerapplet
    mako
    emacs
    swaybg
    mpdscribble
    pavucontrol
    mpc-cli
  ];

  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
  };

  services.syncthing = {
    enable = true;
  };

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
	grace = 0;
	hide_cursor = true;
	no_fade_in = false;
      };
      background = [
        {
	  path = "~/.wallpaper";
	  blur_passes = 3;
	  blur_size = 8;
	}
      ];
      input-field = [
        {
	  size = "200, 50";
	  position = "0, -80";
	  monitor = "";
	  dots_center = true;
	  fade_on_empty = false;
          font_color = "rgb(202, 211, 245)";
          inner_color = "rgb(91, 96, 120)";
          outer_color = "rgb(24, 25, 38)";
	  outline_thickness = 5;
	  placeholder_text = "<span foreground=\"##cad3f5\">Password...</span>";
	  shadow_passes = 2;
	}
      ];
    };
  };

  programs.ncmpcpp = {
    enable = true;
    bindings = [
      { key = "j"; command = "scroll_down"; }
      { key = "k"; command = "scroll_up"; }
      { key = "h"; command = "previous_column"; }
      { key = "l"; command = "next_column"; }
      { key = "g"; command = "move_home"; }
      { key = "G"; command = "move_end"; }
      { key = "n"; command = "next_found_item"; }
      { key = "N"; command = "previous_found_item"; }
    ];
    mpdMusicDir = "~/Music";
    settings = {
      ncmpcpp_directory = "~/.config/nmcpcpp";
      mpd_host = "localhost";
      mpd_port = "6600";
    };
  };

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

  programs.zsh = {
    enable = true;
    autocd = true;
    autosuggestion = {
      enable = true;
      # highlight = "fg=#ff00ff,bg=cyan,bold,underline";
    };
    defaultKeymap = "viins";
    history = {
      append = true;
      ignoreAllDups = true;
    };
    shellAliases = {
      "ll" = "ls -alF";
      "la" = "ls -a";
      "l" = "ls -F";
      "sl" = "ls";
    };
    syntaxHighlighting.enable = true;
    initExtra = ''
    which lesspipe.sh &> /dev/null && export LESSOPEN="|lesspipe.sh %s"
    which eza &> /dev/null && alias ls=eza
    which nvim &> /dev/null && alias vi=nvim && alias vim=nvim
    parse_git_dirty() {
      git_status="$(git status 2> /dev/null)"
      [[ "$git_status" =~ "use \"git push\" to publish your local commits" ]] && echo -n " %F{green}%f"
      [[ "$git_status" =~ "Changes to be committed:" ]] && echo -n " %F{magenta}%f"
      [[ "$git_status" =~ "Changes not staged for commit:" ]] && echo -n " %F{yellow}%f"
      [[ "$git_status" =~ "Untracked files:" ]] && echo -n " %F{red}%f"
    }
    setopt prompt_subst
    autoload -Uz vcs_info
    precmd () { vcs_info }
    zstyle ':vcs_info:*' formats ' %F{blue}%b%f' # git(main)
    PS1='%(?..%B%F{red}[%?%\]%f%b )%F{green}%20<...<%~%<<%f$vcs_info_msg_0_$(parse_git_dirty) $ '
    '';
    profileExtra = ''
    if [ ! -S ~/.ssh/ssh_auth_sock ]; then
        eval `ssh-agent` > /dev/null
        ln -sf "$SSH_AUTH_SOCK" ~/.ssh/ssh_auth_sock
    fi
    export SSH_AUTH_SOCK=~/.ssh/ssh_auth_sock
    '';
  };

  programs.git = {
    enable = true;
    userName = "Jacob Janzen";
    userEmail = "jacob.a.s.janzen@gmail.com";
  };

  programs.foot.enable = true;
  programs.foot.settings = {
    main = {
      font = "SauceCodePro Nerd Font:size=10";
      pad = "6x6";
    };
    mouse = {
      hide-when-typing = "yes";
    };
    colors = {
      alpha = "0.9";
      background = "ece0c9";
      foreground = "191916";
      regular0 = "191916";
      regular1 = "ac4438";
      regular2 = "354d52";
      regular3 = "ba9151";
      regular4 = "465b91";
      regular5 = "5b5489";
      regular6 = "4e6062";
      regular7 = "c9ad7a";
      bright0 = "293c3c";
      bright1 = "d8611c";
      bright2 = "4b7b53";
      bright3 = "d8974b";
      bright4 = "2f3d91";
      bright5 = "735e82";
      bright6 = "6b8f92";
      bright7 = "ece0c9";
    };
  };

  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.settings = {
    monitor = [ "DP-2, 2560x1440@180, 0x0, 1" "HDMI-A-2, 1920x1080@60, -1080x-100, 1, transform, 3" ];
    "$terminal" = "foot";
    "$fileManager" = "dolphin";
    "$menu" = "fuzzel";
    exec-once = [
      "nm-applet &"
      "blueman-applet &"
      "waybar"
      "mako"
      "emacs --daemon"
      "swaybg -m fill -i ~/.wallpaper"
      "mpdscribble"
    ];
    env = [
      "XCURSOR_SIZE,24"
      "HYPRCURSOR_SIZE,24"
    ];
    general = {
      gaps_in = 5;
      gaps_out = 20;
      border_size = 2;
      resize_on_border = false;
      layout = "dwindle";
      "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
      "col.inactive_border" = "rgba(595959aa)";
    };
    decoration = {
      rounding = 10;
      active_opacity = 1.0;
      inactive_opacity = 1.0;
      drop_shadow = true;
      shadow_range = 4;
      shadow_render_power = 3;
      "col.shadow" = "rgba(1a1a1aee)";
      blur = {
        enabled = true;
	size = 3;
	passes = 1;
	vibrancy = "0.1696";
      };
    };
    animations = {
      enabled = true;
      bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
      animation = [
        "windows, 1, 7, myBezier"
	"windowsOut, 1, 7, default, popin 80%"
	"border, 1, 10, default" "borderangle, 1, 8, default"
	"fade, 1, 7, default" "workspaces, 1, 6, default"
      ];
    };
    dwindle = {
      pseudotile = true;
      preserve_split = true;
    };
    master = {
      new_status = "master";
    };
    input = {
      kb_layout = "us";
      follow_mouse = 1;
      sensitivity = 0;
    };
    "$mainMod" = "SUPER";
    bind = [
      "$mainMod, RETURN, exec, $terminal"
      "$mainMod SHIFT, Q, killactive"
      "$mainMod, E, exec, $fileManager"
      "$mainMod SHIFT, SPACE, togglefloating"
      "$mainMod, D, exec, $menu"
      "$mainMod, P, pseudo"
      "$mainMod SHIFT, E, togglesplit"
      "$mainMod, H, movefocus, l"
      "$mainMod, J, movefocus, d"
      "$mainMod, K, movefocus, u"
      "$mainMod, L, movefocus, r"
      "$mainMod, 1, workspace, 1"
      "$mainMod, 2, workspace, 2"
      "$mainMod, 3, workspace, 3"
      "$mainMod, 4, workspace, 4"
      "$mainMod, 5, workspace, 5"
      "$mainMod, 6, workspace, 6"
      "$mainMod, 7, workspace, 7"
      "$mainMod, 8, workspace, 8"
      "$mainMod, 9, workspace, 9"
      "$mainMod, 0, workspace, 10"
      "$mainMod SHIFT, 1, movetoworkspace, 1"
      "$mainMod SHIFT, 2, movetoworkspace, 2"
      "$mainMod SHIFT, 3, movetoworkspace, 3"
      "$mainMod SHIFT, 4, movetoworkspace, 4"
      "$mainMod SHIFT, 5, movetoworkspace, 5"
      "$mainMod SHIFT, 6, movetoworkspace, 6"
      "$mainMod SHIFT, 7, movetoworkspace, 7"
      "$mainMod SHIFT, 8, movetoworkspace, 8"
      "$mainMod SHIFT, 9, movetoworkspace, 9"
      "$mainMod SHIFT, 0, movetoworkspace, 10"
      "$mainMod CONTROL, L, exec, hyprlock"
      "$mainMod, S, exec, hyprshot -m window --clipboard-only"
      "$mainMod SHIFT, S, exec, hyprshot -m region --clipboard-only"
      "$mainMod SHIFT CONTROL, S, exec, hyprshot -m output --clipboard-only"
    ];
    bindel = [
      ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
      ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ",XF86Eject, exec, mpc toggle"
    ];
    bindm = [
      "$mainMod, mouse:272, movewindow"
      "$mainMod, mouse:273, resizewindow"
    ];
    windowrulev2 = "suppressevent maximize, class:.*";
  };
  wayland.windowManager.hyprland.extraConfig = ''
###################
### KEYBINDINGS ###
###################
# Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
bind = $mainMod, M, exit,
  '';

  home.stateVersion = "24.05";

  programs.home-manager.enable = true;
}
