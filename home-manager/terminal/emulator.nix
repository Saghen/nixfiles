{ ... }:

{
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
      tab_title_template = ''
        "{fmt.bg._1e1e28}{fmt.fg._332e41}{fmt.fg.default}{fmt.bg._332e41}{fmt.fg._dadae8} {title} {fmt.fg.default}{fmt.bg.default}{fmt.fg._332e41}{fmt.fg.default}"'';
      active_tab_title_template = ''
        "{fmt.bg._1e1e28}{fmt.fg._a4b9ef}{fmt.fg.default}{fmt.bg._a4b9ef}{fmt.fg._1e1e28} {title} {fmt.fg.default}{fmt.bg.default}{fmt.fg._a4b9ef}{fmt.fg.default}"'';

      # theming
      foreground = "#DADAE8";
      background = "#1E1E28";
      selection_foreground = "#1E1E28";
      selection_background = "#F2CECF";

      cursor = "#F2CECF";
      cursor_text_color = "#1E1E28";

      # URL underline color when hovering with mouse
      url_color = "#A4B9EF";

      active_border_color = "#E5B4E2";
      inactive_border_color = "#332E41";
      bell_border_color = "#EBDDAA";

      wayland_titlebar_color = "system";
      # macos_titlebar_color = "system";

      # Tab bar colors
      active_tab_foreground = "#1E1E28";
      active_tab_background = "#E5B4E2";
      inactive_tab_foreground = "#DADAE8";
      inactive_tab_background = "#332E41";
      tab_bar_background = "#1E1E28";

      # colors for marks (marked text in the terminal)
      mark1_foreground = "#1E1E28";
      mark1_background = "#A4B9EF";
      mark2_foreground = "#1E1E28";
      mark2_background = "#BEE4ED";
      mark3_foreground = "#1E1E28";
      mark3_background = "#C6AAE8";

      # 16 terminal colors

      # black
      color0 = "#332E41";
      color8 = "#575268";

      # red
      color1 = "#E38C8F";
      color9 = "#E38C8F";

      # green
      color2 = "#B1E3AD";
      color10 = "#B1E3AD";

      # yellow
      color3 = "#EBDDAA";
      color11 = "#EBDDAA";

      # blue
      color4 = "#A4B9EF";
      color12 = "#A4B9EF";

      # magenta
      color5 = "#E5B4E2";
      color13 = "#E5B4E2";

      # cyan
      color6 = "#BEE4ED";
      color14 = "#BEE4ED";

      # white
      color7 = "#C3BAC6";
      color15 = "#DADAE8";
    };
  };
}
