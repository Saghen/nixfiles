{ pkgs, ... }:

{
  xdg.enable = true;

  xdg.portal = {
    enable = true;
    config.common.default = "*";
    extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];
    xdgOpenUsePortal = true;
  };

  xdg.mimeApps = let
    firefox = "firefox-developer-edition.desktop";
    nomacs = "nomacs.desktop";
    feh = "feh.desktop";
    nvim = "nvim.desktop";
    files = "org.gnome.Nautilus.desktop";
    mpv = "mpv.desktop";
    vlc = "vlc.desktop";
  in {
    enable = true;

    associations.added = {
      "image/jpeg" = [ feh nomacs ];
      "image/png" = [ feh nomacs ];
      "image/gif" = [ feh nomacs ];
      "image/svg+xml" = [ feh nomacs nvim firefox ];
      "application/xml" = [ nvim "sublime_text.desktop" ];
      "text/plain" = [ nvim "sublime_text.desktop" ];
      "text/html" = [ firefox nvim "sublime_text.desktop" ];
      "application/javascript" = [ nvim ];
      "application/json" = [ nvim ];
      "application/octet-stream" = [ nvim ];
      "application/toml" = [ nvim ];
      "application/x-shellscript" = [ nvim "kitty-open.desktop" ];
      "audio/ogg" = [ mpv vlc ];
      "video/mp4" = [ mpv vlc ];
    };
    defaultApplications = {
      "inode/directory" = [ files ];
      "image/jpeg" = [ feh ];
      "image/png" = [ feh ];
      "text/plain" = [ nvim ];
      "application/json" = [ nvim ];
      "application/x-gnome-saved-search" = [ files ];
      "video/mp4" = [ mpv ];
    };
  };

  # https://discourse.nixos.org/t/xdg-desktop-portal-org-freedesktop-portal-no-such-interface-filechooser-on-window-manager/40353
  # systemd.user.services.xdg-desktop-portal-gtk = {
  #   wantedBy = [ "xdg-desktop-portal.service" ];
  #   before = [ "xdg-desktop-portal.service" ];
  # };
}
