{ pkgs, ... }:

{
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      timeout = 30;
      grub = {
        enable = false;
        efiSupport = true;
        device = "/dev/disk/by-uuid/df46494f-a7c5-4959-8007-c1304b801413";
        theme = pkgs.fetchFromGitHub {
          owner = "OliveThePuffin";
          repo = "yorha-grub-theme";
          rev = "4d9cd37baf56c4f5510cc4ff61be278f11077c81";
          hash = "sha256-ye7EoL9gyjNKPVFfJvHopxREUhe8hpHZEeytAtlEd3c=";
          # TODO: check that this works
          postFetch = ''
            mv $out/yorha-2560x1440/* $out/
            cd $out && rm -r yorha* README.md preview.png
          '';
        };
      };
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
