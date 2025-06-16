{ pkgs, ... }:

{
  services.libinput.touchpad.naturalScrolling = true;

  # window manager
  programs.hyprland.enable = true;
  security.pam.services.hyprlock = { }; # required to allow hyprlock to unlock
  services.displayManager.defaultSession = "hyprland";

  # login screen
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "where_is_my_sddm_theme";
  };
  environment.systemPackages = with pkgs;
    [
      (callPackage ../modules/where-is-my-sddm-theme.nix {
        qtgraphicaleffects = pkgs.libsForQt5.qt5.qtgraphicaleffects;
        themeConfig = {
          General = {
            background = toString ./wallpaper.png;
            backgroundMode = "fill";
            passwordFontSize = "24";
            usersFontSize = "16";
          };
        };
      })
    ];

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = false; # breaks it
  };

  # required by various gtk apps, such as nautilus for detecting removable drives
  services.gvfs.enable = true;
}
