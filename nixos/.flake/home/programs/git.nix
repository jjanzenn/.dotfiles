{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Jacob Janzen";
    userEmail = "jacob.a.s.janzen@gmail.com";
  };
}
