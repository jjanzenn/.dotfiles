{ config, pkgs, ... }:

{
  programs.foot = {
    enable = true;
    settings = {
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
  };
}
