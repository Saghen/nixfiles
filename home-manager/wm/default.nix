{ pkgs, ... }:

{
  imports = [
    ./bspwm.nix
    ./sxhkd
    ./services/dunst.nix
    ./services/flameshot.nix
    ./services/rofi
    ./polybar
    ./theme.nix
    ./xdg.nix
  ];
  config = rec {
    home = {
      sessionVariables = {
        DISPLAY1 = "DP-0";
        DISPLAY2 = "DP-2";
      };
      packages = with pkgs; [ xorg.xrandr xclip feh ];
    };
    systemd.user.sessionVariables = home.sessionVariables;
  };
}
