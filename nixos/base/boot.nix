{ pkgs, ... }:

{
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      timeout = 30;
      grub = {
        enable = true;
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

    # Loading animation
    plymouth = {
      enable = true;
      theme = "spinner";
    };

    # zfs 
    supportedFilesystems = [ "zfs" ];
    zfs.extraPools = [ "storage" ];
  };
}
