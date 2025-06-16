{ lib, ... }:

with lib;

let
  bootDevice = {
    diskUuid = mkOption {
      type = types.str;
      description = "Device path (lsblk -f)";
    };
    
    type = mkOption {
      type = types.str;
      description = "Filesystem type (e.g., ext4, btrfs)";
    };
    
    options = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "Mount options";
    };
  };

  luksDevice = {
    luksUuid = mkOption {
      type = types.str;
      description = "LUKS device name (lsblk -f | grep crypto_LUKS)";
    };
    
    diskUuid = mkOption {
      type = types.str;
      description = "Device path after unlocking (lsblk -f, unlock with cryptsetup luksOpen /dev/nvme...)";
    };
    
    type = mkOption {
      type = types.str;
      description = "Filesystem type (e.g., f2fs, btrfs)";
    };
    
    options = mkOption {
      type = types.listOf types.str;
      default = [];
      description = "Mount options";
    };

    trim = mkOption {
      type = types.bool;
      default = true;
      description = "Trim filesystem";
    };
  };
in {
  options.machine = {
    scalingFactor = lib.mkOption {
      type = lib.types.float;
      default = 1.0;
      description = "Global UI scaling factor";
    };

    monitors = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "List of monitor names";
      default = [ "DP-4" "DP-6" ];
    };

    optimizePower = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Optimize power usage";
    };

    nvidia = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable NVIDIA GPU support";
    };

    disks = lib.mkOption {
      type = lib.types.submodule {
        options = {
          boot = bootDevice;
          root = luksDevice;
          swap = luksDevice;
        };
      };
      description = "Disks configuration";
    };
  };
}
