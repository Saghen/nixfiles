{ pkgs, config, ... }:

{
  imports = [ ./firefox ./thunderbird ./discord.nix ./spotify.nix ./video.nix ];
  config = {
    home.packages = with pkgs; [
      vesktop # Discord with screen share and audio
      nautilus # File management
      gnome-system-monitor # System resource monitor
      gparted # Disk management
      blueman # Bluetooth manager
      obsidian # Notes
      pavucontrol # GUI Volume mixer and device settings
      helvum # GUI Audio routing: Control what apps get what audio
      mpv # Video player
      vlc # Video player
      jellyfin-media-player # Jellyfin video player
      feh # Image viewer
      qimgv # Image viewer
      nomacs # Image viewer
      lutris # Game manager
      winetricks # Required by lutris
      seabird # Kubernetes client
      obs-studio # Record
      (tauon.override { withDiscordRPC = true; }) # Music player
      jellyfin-media-player # Media player
    ];

    xdg.configFile.qimgv-theme = let
      toINI = pkgs.lib.generators.toINI { };
      colors = config.colors;
    in {
      target = "qimgv/theme.conf";
      text = toINI {
        Colors = {
          accent = colors.primary;
          background = colors.base;
          background_fullscreen = colors.base;
          folderview = colors.base;
          folderview_topbar = colors.mantle;
          icons = colors.subtext-2;
          overlay = colors.core;
          overlay_text = colors.text;
          scrollbar = colors.surface-0;
          text = colors.text;
          widget = colors.core;
          widget_border = colors.surface-0;
        };
      };
    };
  };
}
