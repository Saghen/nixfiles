{ pkgs, ... }:

{
  xdg = {
    enable = true;
    mimeApps.enable = true;
    portal = {
      enable = true;
      config.common.default = [ "gtk" ];
      extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
      xdgOpenUsePortal = true;
    };
  };
}
