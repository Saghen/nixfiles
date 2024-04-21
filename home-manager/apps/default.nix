{ pkgs, ... }:

{
  imports = [ ./firefox ./thunderbird ./spotify.nix ];
  config = {
    home.packages = with pkgs; [
      gnome.nautilus # File management
      gnome.gnome-system-monitor # System resource monitor
      obsidian # Notes
      pavucontrol # GUI Volume mixer and device settings
      helvum # GUI Audio routing: Control what apps get what audio
    ];
  };
}
