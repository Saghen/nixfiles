{ pkgs, ... }:

{
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      timeout = 5;
      systemd-boot.enable = true;
    };

    # Disable waiting for network because it takes 10s and we don't need it
    # https://askubuntu.com/questions/1018576/what-does-networkmanager-wait-online-service-do
    # FIXME: doesnt work??
    initrd.systemd.network.wait-online.enable = false;

    # Loading animation and LUKS password prompt
    kernelParams = [ "quiet" ];
    initrd.systemd.enable = true;
    plymouth = {
      enable = true;
      extraConfig = ''
        [Daemon]
        ShowDelay=0
      '';
      theme = "breeze";
    };

    # zfs 
    supportedFilesystems = [ "zfs" ]; # does this need to be on boot though?
    zfs.extraPools = [ "storage" ];
  };
}
