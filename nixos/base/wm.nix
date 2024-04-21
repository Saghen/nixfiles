{ ... }:

{
  services.xserver = {
    enable = true;
    xkb.layout = "us";

    autoRepeatDelay = 240;
    autoRepeatInterval = 40;

    displayManager.gdm.enable = true;
    windowManager.bspwm.enable = true;
  };
  services.displayManager.defaultSession = "none+bspwm";
}
