{
  config,
  inputs,
  ...
}:
{
  # hardware-specific modules
  imports = [
    inputs.hardware.nixosModules.common-gpu-nvidia-nonprime
    inputs.hardware.nixosModules.common-pc-ssd
  ];

  config = {
    networking.hostName = "liam-desktop";
    networking.hostId = "968d12a1";

    # Nvidia
    # use the beta nvidia driver and
    # adds support for nvfbc hardware capture and higher nvenc limits
    nixpkgs.config.nvidia.acceptLicense = true;
    nixpkgs.overlays = [ inputs.nvidia-patch.overlays.default ];
    hardware.graphics.enable = true;
    hardware.nvidia = {
      open = false;
      package = config.boot.kernelPackages.nvidiaPackages.beta;
      # package = pkgs.nvidia-patch.patch-nvenc (pkgs.nvidia-patch.patch-fbc
      #   config.boot.kernelPackages.nvidiaPackages.beta);

      # required
      modesetting.enable = true;

      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
      # Enable this if you have graphical corruption issues or application crashes after waking
      # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
      # of just the bare essentials.
      powerManagement.enable = false;

      # Fine-grained power management. Turns off GPU when not in use.
      # Experimental and only works on modern Nvidia GPUs (Turing or newer).
      powerManagement.finegrained = false;
    };
  };
}
