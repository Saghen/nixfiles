{ pkgs, ... }:

rec {
  # Cursor theme (system-wide)
  home.pointerCursor = {
    name = "catppuccin-mocha-dark-cursors";
    package = pkgs.catppuccin-cursors.mochaDark;
  };

  # Icon theme (system-wide)
  gtk.iconTheme = {
    name = "Papirus-Dark";
    package = pkgs.papirus-icon-theme;
  };
  # expected by many gtk apps
  home.packages = with pkgs; [ gnome.adwaita-icon-theme ];

  # GTK Theme
  # https://github.com/catppuccin/gtk?tab=readme-ov-file#for-nix-users
  gtk.theme = {
    name = "Catppuccin-Mocha-Standard-Blue-Dark";
    package = pkgs.catppuccin-gtk.override {
      accents = [ "blue" ];
      size = "standard"; # "compact" or "standard"
      tweaks = [ "rimless" ]; # "rimless" disables the 1px border around windows
      variant = "mocha";
    };
  };

  xdg.configFile = {
    "gtk-3.0/assets".source =
      "${gtk.theme.package}/share/themes/${gtk.theme.name}/gtk-3.0/assets";
    "gtk-3.0/gtk.css".source =
      "${gtk.theme.package}/share/themes/${gtk.theme.name}/gtk-3.0/gtk.css";
    "gtk-3.0/gtk-dark.css".source =
      "${gtk.theme.package}/share/themes/${gtk.theme.name}/gtk-3.0/gtk-dark.css";

    "gtk-4.0/assets".source =
      "${gtk.theme.package}/share/themes/${gtk.theme.name}/gtk-4.0/assets";
    "gtk-4.0/gtk.css".source =
      "${gtk.theme.package}/share/themes/${gtk.theme.name}/gtk-4.0/gtk.css";
    "gtk-4.0/gtk-dark.css".source =
      "${gtk.theme.package}/share/themes/${gtk.theme.name}/gtk-4.0/gtk-dark.css";
  };

  # TODO: QT Theme
  qt.style = { };
}
