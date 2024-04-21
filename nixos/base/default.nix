{ ... }:

{
  imports = [
    ./boot.nix
    ./gaming.nix
    ./networking.nix
    ./security.nix
    ./sound.nix
    ./wm.nix
  ];

  config = {
    virtualisation.docker = {
      enable = true;
      enableNvidia = true;
    };
    # required for nvidia support in docker
    hardware.opengl.driSupport32Bit = true;
  };
}
