{ pkgs, config, inputs, ... }:

{
  # use the beta nvidia driver and
  # adds support for nvfbc hardware capture and higher nvenc limits
  nixpkgs.config.nvidia.acceptLicense = true;
  nixpkgs.overlays = [ inputs.nvidia-patch.overlays.default ];
  hardware.graphics.enable = true;
  hardware.nvidia = {
    open = false;
    package = pkgs.nvidia-patch.patch-nvenc (pkgs.nvidia-patch.patch-fbc
      config.boot.kernelPackages.nvidiaPackages.beta);

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

  # controller support
  hardware.xone.enable = true;

  # games
  hardware.steam-hardware.enable = true;
  programs.steam = {
    enable = true;
    extraPackages = with pkgs; [ mangohud ];
    extraCompatPackages = with pkgs; [ proton-ge-bin ];
    localNetworkGameTransfers.openFirewall = true;
    protontricks.enable = true;
  };
  programs.gamescope = {
    enable = true;
    capSysNice = false; # doesn't work inside of steam
  };
  programs.gamemode = {
    enable = true;
    enableRenice = true;
    settings = {
      general = {
        softrealtime = "on";
        renice = 10;
        inhibit_screensaver = 1;

        # Nvidia specific settings
        # Requires the coolbits extension activated in nvidia-xconfig
        # This corresponds to the desired GPUPowerMizerMode
        # "Adaptive"=0 "Prefer Maximum Performance"=1 and "Auto"=2
        # See NV_CTRL_GPU_POWER_MIZER_MODE and friends in https://github.com/NVIDIA/nvidia-settings/blob/master/src/libXNVCtrl/NVCtrl.h
        nv_powermizer_mode = 1;
      };
      gpu = {
        apply_gpu_optimizations = "accept-responsibility";
        gpu_device = 0;
      };
    };
  };
  environment.systemPackages = with pkgs; [ mangohud ];

  # streaming
  services.sunshine = {
    enable = true;
    openFirewall = true;
    capSysAdmin = true;
    package = pkgs.sunshine.override ({ cudaSupport = true; });

    settings = {
      min_log_level = "debug";
      origin_web_ui_allowed = "pc";
      # resolutions = ["1280x720" "1920x1080" "2560x1440"];
      # fps = [60 90 120 144];

      # TODO: currently doesn't detect any monitors
      # capture = "nvfbc"; # hardware capture; requires patched nvidia driver
      encoder = "nvenc"; # hardware encoding
      nvenc_vbv_increase = 100; # allow higher peak bitrates
      # fec_percentage = 0; # % of packets used for packet loss recovery
      qp = 20; # quality when vbr is unsupported
      av1_mode = 1; # disable av1 since we can't encode it on GPU
    };

    applications = {
      env = { PATH = "$(PATH):$(HOME)/.local/bin"; };
      apps = [{
        name = "Steam";
        output = "";
        cmd = "";
        exclude-global-prep-cmd = "false";
        elevated = "false";
        auto-detach = "true";
        image-path = "steam.png";
        detached = [ "setsid steam steam://open/bigpicture" ];
      }];
    };
  };
}
