{ pkgs, ... }:

{
  home = {
    sessionVariables = {
      DISPLAY1 = "DP-0";
      DISPLAY2 = "DP-2";
    };
    packages = with pkgs; [ xorg.xrandr ];
  };

  xsession.enable = true;
  xsession.windowManager.bspwm = {
    enable = true;
    # Sets the second monitor to be on the left side
    # and re-orders displays in bspwm
    extraConfigEarly = ''
      ${pkgs.xorg.xrandr}/bin/xrandr --output $DISPLAY1 --right-of $DISPLAY2
      ${pkgs.bspwm}/bin/bspc wm -O $DISPLAY1 $DISPLAY2
    '';
    monitors = {
      "DP-0" = ["I" "II" "III" "IV" "V" "VI"];
      "DP-2" = ["VII" "VIII" "IX" "X"];
    };
    settings = {
      # Gap
      window_gap = 8;
      gapless_monocle = true;
      borderless_monocle = true;
      single_monocle = true;
      paddingless_monocle = false;

      # Misc
      pointer_motion_interval = 6;
      pointer_modifier = "mod4";
      pointer_action1 = "move";
      pointer_action2 = "resize_side";
      pointer_action3 = "resize_corner";
      remove_disabled_monitors = false;
      remove_unplugged_monitors = false;
      split_ratio = 0.52;

      # Border
      border_width = 2;
      focused_border_color = "#A4B9EF";
      normal_border_color = "#1E1E28";
      active_border_color = "#575268";
      presel_feedback_color = "#E5C07B";

      # TODO: external rules command
    };
    rules = {
      "*" = { state = "floating"; };

      Code = { state = "tiled"; };
      "Code:*:Open Folder" = { state = "floating"; };
      "Code:*:Open File" = { state = "floating"; };
      neovide = { state = "tiled"; };
      neovim = { state = "tiled"; };
      obsidian = { state = "tiled"; desktop = "^3"; };
      thunderbird = { state = "tiled"; desktop = "^6"; };
      firefoxdeveloperedition = { state = "tiled"; };
    };
    startupPrograms = with pkgs; [
      "${xorg.xrandr}/bin/xrandr --output $DISPLAY1 --right-of $DISPLAY2"
      "${sxhkd}/bin/sxhkd"
      "${dunst}/bin/dunst"
      "${flameshot}/bin/flameshot"
      "${feh}/bin/feh --bg-fill ~/pictures/wallpapers/2024/soviet-rocket.jpg"
    ];
  };
}
