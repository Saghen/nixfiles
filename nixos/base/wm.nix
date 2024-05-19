{ pkgs, ... }:

{
  services.xserver = {
    enable = true;
    xkb.layout = "us";

    autoRepeatDelay = 240;
    autoRepeatInterval = 40;

    windowManager.bspwm.enable = true;
    # displayManager.gdm.enable = true;
  };
  services.displayManager = {
    defaultSession = "none+bspwm";
    sddm = {
      enable = true;
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
      # (sddm-chili-theme.override {
      #   themeConfig = {
      #     Background = 
      #     ScreenWidth = "2560";
      #     ScreenHeight = "1440";
      #   };
      # })
    ];

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    config.common.default = "gtk";
    xdgOpenUsePortal = false; # breaks it
  };
}
