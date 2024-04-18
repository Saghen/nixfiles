{ pkgs, ... }:

{
  services.dunst = {
    enable = true;

    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };

    settings = {
      global = {
        frame_color = "#A4B9EF";
        frame_width = 2;
        separator_color = "frame";
        corner_radius = 0;
      };
      urgency_low = {
        background = "#1E1E2E";
        foreground = "#D9E0EE";
      };
      urgency_normal = {
        background = "#1E1E2E";
        foreground = "#D9E0EE";
      };
      urgency_critical = {
        background = "#1E1E2E";
        foreground = "#D9E0EE";
        frame_color = "#F8BD96";
      };
    };
  };
}
