{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      monitor = [ "DP-2, 2560x1440@180, 0x0, 1" "HDMI-A-2, 1920x1080@60, -1080x-100, 1, transform, 3" ];
      "$terminal" = "foot";
      "$fileManager" = "dolphin";
      "$menu" = "fuzzel";
      exec-once = [
        "nm-applet &"
        "blueman-applet &"
        "waybar"
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
        "$mainMod, M, exit"
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
  };
}
