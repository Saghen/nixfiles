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
  gtk.theme = {
    name = "Colloid-Teal-Dark-Catppuccin";
    package = pkgs.colloid-gtk-theme.override {
      colorVariants = [ "dark" ];
      themeVariants = [ "teal" ];
      sizeVariants = [ "standard" ];
      tweaks = [ "catppuccin" "rimless" ];
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
