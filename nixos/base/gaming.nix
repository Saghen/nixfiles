{ pkgs, config, inputs, ... }:

{
  nixpkgs.config.nvidia.acceptLicense = true;

  # controller support
  hardware.xone.enable = true;

  # games
  hardware.steam-hardware.enable = true;
  programs.steam.enable = true;
  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        softrealtime = "on";
        inhibit_screensaver = 1;
      };
      gpu = {
        apply_gpu_optimizations = "accept-responsibility";
        gpu_device = 0;
      };
    };
  };
  environment.systemPackages = with pkgs; [
    protontricks
    mangohud
  ];

  # streaming
  services.sunshine = {
    enable = true;
    openFirewall = true;
    capSysAdmin = true;

    settings = {
      origin_web_ui_allowed = "pc";
      # resolutions = ["1280x720" "1920x1080" "2560x1440"];
      # fps = [60 90 120 144];

      capture = "nvfbc"; # hardware capture; requires patched nvidia driver
      encoder = "nvenc"; # hardware encoding
      nvenc_vbv_increase = 100; # allow higher peak bitrates
      fec_percentage = 0; # % of packets used for packet loss recovery
      qp = 20; # quality when vbr is unsupported
    };

    applications = {
      env = { PATH = "$(PATH):$(HOME)/.local/bin"; };
      apps = [
        { 
          name = "Steam";
          output = "";
          cmd = "";
          exclude-global-prep-cmd = "false";
          elevated = "false";
          auto-detach = "true";
          image-path = "steam.png";
          detached = [
            "setsid steam steam:\/\/open\/bigpicture"
          ];
        }
      ];
    };
  };
  # adds support for nvfbc hardware capture and higher nvenc limits
  # nixpkgs.overlays = [inputs.nvidia-patch.overlays.default];
  hardware.nvidia.package = pkgs.nvidia-patch.patch-nvenc (
    pkgs.nvidia-patch.patch-fbc config.boot.kernelPackages.nvidiaPackages.stable
  );
}
