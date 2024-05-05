{ pkgs, ... }:

{
  services.xserver = {
    enable = true;
    xkb.layout = "us";

    autoRepeatDelay = 240;
    autoRepeatInterval = 40;

    windowManager.bspwm.enable = true;
    displayManager.gdm.enable = true;
  };

  environment.systemPackages = with pkgs; [ sddm-chili-theme ];
  services.displayManager = {
    # sddm = {
    #   enable = true;
    #   theme = "chili";
    # };
    defaultSession = "none+bspwm";
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal ];
    config = { common.default = "*"; };
  };
}
