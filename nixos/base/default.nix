{ ... }:

{
  imports = [
    ./boot.nix
    ./gaming.nix
    ./security.nix
    ./sound.nix
  ];

  config = { 
    virtualisation.docker = {
      enable = true;
      enableNvidia = true;
    };
    # required for nvidia support in docker
    hardware.opengl.driSupport32Bit = true;

    # VPNs
    services.tailscale = {
      enable = true;
      openFirewall = true;
    };
    services.mullvad-vpn.enable = true;
  };
}
