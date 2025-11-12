{ pkgs, ... }:
{
  boot = {
    # 1000hz keyboard polling rate
    # who knows if that actually does anything
    kernelParams = [
      "quiet"
      "usbhid.kbpoll=1"
    ];
    kernelPackages = pkgs.linuxPackages_latest;

    loader = {
      efi.canTouchEfiVariables = true;
      timeout = 5;
      systemd-boot.enable = true;
    };

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
