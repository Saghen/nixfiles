{ pkgs, ... }:
{
  home.packages = with pkgs; [
    mpv
    vlc
    jellyfin-mpv-shim
  ];

  xdg.configFile.mpv = {
    target = "jellyfin-mpv-shim/mpv.conf";
    text = ''
      profile=high-quality
      vo=gpu-next
      cache=yes
      cache-secs=3600
      cache-on-disk=yes
      demuxer-max-bytes=5000000KiB
    '';
  };
}
