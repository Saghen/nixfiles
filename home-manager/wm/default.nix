{ pkgs, ... }:

{
  imports = [
    ./bspwm.nix
    ./hyprland.nix
    ./limbo.nix
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

    systemd.user.services.set-keyboard-rate = {
      Unit = {
        Description = "Set keyboard rate";
        After = [ "xorg.target" ];
      };
      Service = {
        Type = "oneshot";
        ExecStart = "${pkgs.xorg.xset}/bin/xset r rate 240 40";
      };
    };
    systemd.user.timers.set-keyboard-rate = {
      Unit = { Description = "Backup game saves"; };
      Timer = {
        OnCalendar = "*:0/1"; # every minute
        Unit = "set-keyboard-rate.service";
      };
    };
  };
}
