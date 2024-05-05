{ config, ... }:

let strip = base: "_" + (builtins.substring 1 (-1) base);
in {
  home.sessionVariables.TERMINAL = "kitty";
  programs.kitty = {
    enable = true;

    extraConfig = ''
      modify_font strikethrough_position 130%
      modify_font strikethrough_thickness 0.1px
      modify_font underline_position 150%
      modify_font underline_thickness 1px
      modify_font cell_height 110%

      font_family Iosevka Custom Nerd Font
      font_size 14

      font_features IosevkaCustomNF +calt +liga +dlig +ss01 +ss02 +ss03 +ss04 +ss05 +ss06 +ss07 +ss08
      font_features IosevkaCustomNF-Bold +calt +liga +dlig +ss01 +ss02 +ss03 +ss04 +ss05 +ss06 +ss07 +ss08
      font_features IosevkaCustomNF-BoldItalic +calt +liga +dlig +ss01 +ss02 +ss03 +ss04 +ss05 +ss06 +ss07 +ss08
      font_features IosevkaCustomNF-Italic +calt +liga +dlig +ss01 +ss02 +ss03 +ss04 +ss05 +ss06 +ss07 +ss08
    '';

    settings = {
      allow_remote_control = true;
      listen_on = "unix:/tmp/kitty";

      strip_trailing_spaces = "smart";
      enable_audio_bell = false;
      window_padding_width = 8;

      remember_window_size = false;
      initial_window_width = 1400;
      initial_window_height = 840;
      repaint_delay = 3;
      sync_to_monitor = false;

      tab_bar_edge = "top";
      tab_bar_margin_width = 8;
      tab_bar_margin_height = "8 0";
      tab_bar_style = "fade";
      tab_fade = 0;
      # lol
      tab_title_template = ''
        "{fmt.bg.${strip config.colors.base}}{fmt.fg.${
          strip config.colors.surface-0
        }}{fmt.fg.default}{fmt.bg.${strip config.colors.surface-0}}{fmt.fg.${
          strip config.colors.text
        }} {title} {fmt.fg.default}{fmt.bg.default}{fmt.fg.${
          strip config.colors.surface-0
        }}{fmt.fg.default}"'';
      active_tab_title_template = ''
        "{fmt.bg.${strip config.colors.base}}{fmt.fg.${
          strip config.colors.blue
        }}{fmt.fg.default}{fmt.bg.${strip config.colors.blue}}{fmt.fg.${
          strip config.colors.base
        }} {title} {fmt.fg.default}{fmt.bg.default}{fmt.fg.${
          strip config.colors.blue
        }}{fmt.fg.default}"'';

      # theming
      foreground = config.colors.text;
      background = config.colors.base;
      selection_foreground = config.colors.base;
      selection_background = "#F2CECF"; # TODO: use color from theme

      cursor = "#F2CECF"; # TODO: use color from theme
      cursor_text_color = config.colors.base;

      # URL underline color when hovering with mouse
      url_color = config.colors.blue;

      active_border_color = config.colors.mauve;
      inactive_border_color = config.colors.surface-0;
      bell_border_color = config.colors.yellow;

      wayland_titlebar_color = "system";
      # macos_titlebar_color = "system";

      # Tab bar colors
      active_tab_foreground = config.colors.base;
      active_tab_background = config.colors.mauve;
      inactive_tab_foreground = config.colors.text;
      inactive_tab_background = config.colors.surface-0;
      tab_bar_background = config.colors.base;

      # colors for marks (marked text in the terminal)
      mark1_foreground = config.colors.base;
      mark1_background = config.colors.blue;
      mark2_foreground = config.colors.base;
      mark2_background = config.colors.cyan;
      mark3_foreground = config.colors.base;
      mark3_background = config.colors.mauve;

      # 16 terminal colors

      # black
      color0 = config.colors.surface-0;
      color8 = config.colors.surface-2;

      # red
      color1 = config.colors.red;
      color9 = config.colors.red;

      # green
      color2 = config.colors.green;
      color10 = config.colors.green;

      # yellow
      color3 = config.colors.yellow;
      color11 = config.colors.yellow;

      # blue
      color4 = config.colors.blue;
      color12 = config.colors.blue;

      # magenta
      color5 = config.colors.mauve;
      color13 = config.colors.mauve;

      # cyan
      color6 = config.colors.cyan;
      color14 = config.colors.cyan;

      # white
      color7 = config.colors.subtext-1;
      color15 = config.colors.subtext-2;
    };
  };
}
