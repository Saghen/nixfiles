{ lib, pkgs, ... }:

{
  boot = {
    # 1000hz keyboard polling rate
    # who knows if that actually does anything
    # disable usb autosuspend because it breaks Grace SDAC
    kernelParams = [ "quiet" "usbhid.kbpoll=1" "usbcore.autosuspend=-1" ];
    # use latest kernel
    kernelPackages = pkgs.linuxKernel.packages.linux_6_14;

    loader = {
      efi.canTouchEfiVariables = true;
      timeout = 5;
      systemd-boot.enable = true;
    };

    # Disable waiting for network because it takes 10s and we don't need it
    # https://askubuntu.com/questions/1018576/what-does-networkmanager-wait-online-service-do
    initrd.systemd.network.wait-online.enable = false;

    # Loading animation and LUKS password prompt
    initrd.systemd.enable = true;
    plymouth = {
      enable = true;
      extraConfig = ''
        [Daemon]
        ShowDelay=0
      '';
      theme = "breeze";
    };
  };
  # (part of zfs) enable again if devices aren't detected
  systemd.services.systemd-udev-settle.enable = lib.mkForce false;
}
