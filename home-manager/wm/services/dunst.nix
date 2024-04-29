{ pkgs, config, ... }:

{
  home.packages = with pkgs; [ libnotify ]; # provides notify-send
  services.dunst = {
    enable = true;

    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };

    settings = {
      global = {
        frame_color = config.colors.primary;
        frame_width = 2;
        separator_color = "frame";
        corner_radius = 0;
      };
      urgency_low = {
        background = config.colors.base;
        foreground = config.colors.text;
      };
      urgency_normal = {
        background = config.colors.base;
        foreground = config.colors.text;
      };
      urgency_critical = {
        background = config.colors.base;
        foreground = config.colors.text;
        frame_color = config.colors.red;
      };
    };
  };
}
