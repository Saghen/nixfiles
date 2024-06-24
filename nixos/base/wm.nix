{ pkgs, ... }:

{
  services.xserver = {
    # enable = true;
    xkb.layout = "us";

    autoRepeatDelay = 240;
    autoRepeatInterval = 40;

    # windowManager.bspwm.enable = true;
    # displayManager.gdm.enable = true;
  };
  programs.hyprland.enable = true;
  security.pam.services.hyprlock = { }; # required to allow hyprlock to unlock
  services.displayManager = {
    defaultSession = "hyprland";
    # defaultSession = "none+bspwm";
    sddm = {
      enable = true;
      wayland.enable = true;
      theme = "where_is_my_sddm_theme";
    };
  };
  environment.systemPackages = with pkgs;
    [
      (callPackage ../modules/where-is-my-sddm-theme.nix {
        qtgraphicaleffects = pkgs.libsForQt5.qt5.qtgraphicaleffects;
        themeConfig = {
          General = {
            background = toString ./wallpaper.jpg;
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
}
