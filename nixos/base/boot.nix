{ pkgs, ... }:

{
  boot = {
    # 1000hz keyboard polling rate
    # who knows if that actually does anything
    kernelParams = [ "quiet" "usbhid.kbpoll=1" ];
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
}
