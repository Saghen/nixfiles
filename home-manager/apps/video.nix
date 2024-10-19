{ pkgs, ... }:

{
  home.packages = with pkgs; [ vlc ];

  programs.mpv = {
    enable = true;
    config = {
      profile = "gpu-hq";
      cache = "yes";
      demuxer-max-bytes = "5000000KiB"; # 5GB
    };
  };
}
