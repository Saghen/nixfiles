{ ... }:
{
  services.libinput.touchpad.naturalScrolling = true;

  # window manager
  programs.hyprland.enable = true;
  security.pam.services.hyprlock = { }; # required to allow hyprlock to unlock
  services.displayManager.defaultSession = "hyprland";

  # login screen with auto login
  services.displayManager = {
    autoLogin.user = "saghen";
    gdm.enable = true;
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = false; # breaks it
  };

  # required by various gtk apps, such as nautilus for detecting removable drives
  services.gvfs.enable = true;
}
