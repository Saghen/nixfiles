{ pkgs, ... }:

{
  home.packages = with pkgs; [ vlc ];

  programs.mpv.enable = true;
}
