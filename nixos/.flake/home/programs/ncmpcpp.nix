{ config, pkgs, ... }:

{
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
}
