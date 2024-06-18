{ pkgs, config, ... }:

{
  home.packages = with pkgs; [ hyprshot hyprpicker ];

  programs.foot = {
    enable = true;
    server.enable = true; # better startup time, must use footclient
    settings = let
      colors = config.colors;
      convert = c: builtins.substring 1 6 c;
    in {
      main = {
        font = "Iosevka Custom Nerd Font:size=14";
        line-height = "26px";
        underline-thickness = "1px";
        underline-offset = "2px";
        pad = "4x4";

        initial-window-size-pixels = "1400x840";
      };
      cursor = {
        unfocused-style = "hollow";
        # color = "${convert colors.base} ${convert colors.text}";
      };
      colors = {
        background = convert colors.base;
        foreground = convert colors.text;

        # black
        bright0 = convert colors.surface-1;
        regular0 = convert colors.surface-2;

        # red
        bright1 = convert colors.red;
        regular1 = convert colors.red;

        # green
        bright2 = convert colors.green;
        regular2 = convert colors.green;

        # yellow
        bright3 = convert colors.yellow;
        regular3 = convert colors.yellow;

        # blue
        bright4 = convert colors.blue;
        regular4 = convert colors.blue;

        # magenta
        bright5 = convert colors.pink;
        regular5 = convert colors.pink;

        # cyan
        bright6 = convert colors.teal;
        regular6 = convert colors.teal;

        # white
        bright7 = convert colors.subtext-1;
        regular7 = convert colors.subtext-0;
      };
    };
  };

  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [ "~/pictures/wallpaper.png" ];
      wallpaper =
        [ "DP-1,~/pictures/wallpaper.png" "DP-2,~/pictures/wallpaper.png" ];
    };
  };

  programs.tofi = {
    enable = true;
    settings = let colors = config.colors;
    in {
      font = "${pkgs.noto-fonts}/share/fonts/noto/NotoSans[wdth,wght].ttf";
      font-size = 16;

      width = 720;
      height = 540;

      outline-width = 0;
      border-width = 1;
      border-color = colors.primary;
      background-color = colors.base;
      text-color = colors.text;
      prompt-color = colors.primary;
      selection-color = colors.yellow;

      fuzzy-match = true;
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    settings = let
      colors = config.colors;
      convert = c: "0xff" + builtins.substring 1 6 c;
    in {
      "$mod" = "SUPER";

      monitor =
        [ "DP-1, 2560x1440@144, 2560x0, 1" "DP-2, 2560x1440@144, 0x0, 1" ];

      workspace = [
        "1, monitor:DP-1"
        "2, monitor:DP-1"
        "3, monitor:DP-1"
        "4, monitor:DP-1"
        "5, monitor:DP-1"
        "6, monitor:DP-1"
        "7, monitor:DP-2"
        "8, monitor:DP-2"
        "9, monitor:DP-2"
        "10, monitor:DP-2"
      ];

      env = [
        "XDG_CURRENT_DESKTOP,hyprland"
        "QT_QPA_PLATFORM,wayland"
        "MOZ_ENABLE_WAYLAND,1"

        # Nvidia
        "LIBVA_DRIVER_NAME,nvidia"
        "XDG_SESSION_TYPE,wayland"
        # "GBM_BACKEND,nvidia-drm"
        # "__GLX_VENDOR_LIBRARY_NAME,nvidia"
        "NVD_BACKEND,direct"
      ];

      ## Settings
      animations = { enabled = false; };
      general = {
        gaps_out = 16;
        gaps_in = 8;

        "col.inactive_border" = convert colors.base;
        "col.active_border" = convert colors.primary;

        no_cursor_warps = true;
        default_cursor_monitor = "DP-1";
      };
      dwindle = { no_gaps_when_only = 1; };
      decoration = { blur = { enabled = false; }; };
      cursor = {
        # TODO: enable when upgrading to v0.41.0
        # no_warps = true;
        # default_monitor = "DP-1";
      };
      input = {
        # cursor focus separate from keyboard focus
        # to allow for scrolling without focusing
        follow_mouse = 2;
        float_switch_override_focus = 0;

        repeat_rate = 40;
        repeat_delay = 240;
      };
      misc = {
        disable_hyprland_logo = true;
        background_color = convert colors.crust;
        force_default_wallpaper = 0;

        # TODO: doesn't work on nvidia
        # vrr = 1;
        no_direct_scanout = false;
      };
      opengl = {
        # shouldn't be needed on 555
        nvidia_anti_flicker = false;
      };
      debug = { disable_logs = false; };

      ## Binds
      bind = let
        hyprshot = "${pkgs.hyprshot}/bin/hyprshot";
        satty = "${pkgs.satty}/bin/satty";
        swayosdClient = "${pkgs.swayosd}/bin/swayosd-client";
      in [
        # applications
        "$mod, Space, exec, tofi-drun --drun-launch=true"
        "$mod, Return, exec, footclient"
        "$mod, c, exec, footclient --app-id nvim --title nvim nvim"
        "$mod + SHIFT, Return, exec, foot" # fallback in case foot.service fails
        ", Print, exec, ${hyprshot} --freeze -m region -o ~/pictures/screenshots/hyprshot"
        "SHIFT, Print, exec, ${hyprshot} --freeze -m region -o ~/pictures/screenshots/hyprshot --raw | ${satty} --filename -"
        "$mod, Print, exec, ${hyprshot} --freeze -m window -o ~/pictures/screenshots/hyprshot"
        "$mod + SHIFT, Print, exec, ${hyprshot} --freeze -m window -o ~/pictures/screenshots/hyprshot --raw | ${satty} --filename -"
        "ALT, Print, exec, ${hyprshot} --freeze -m output -o ~/pictures/screenshots/hyprshot"
        "ALT + SHIFT, Print, exec, ${hyprshot} --freeze -m output -o ~/pictures/screenshots/hyprshot --raw | ${satty} --filename -"

        # window management
        "$mod, q, focusmonitor, +1"
        "$mod, r, cyclenext"
        "$mod + SHIFT, r, cyclenext, prev"
        "$mod, a, movewindow, mon:l"
        "$mod, w, closewindow, activewindow"
        "$mod + ALT, w, killactive"
        "$mod, f, togglefloating"
        "$mod + SHIFT, f, fullscreen"
        "$mod, s, swapactiveworkspaces"
        "$mod, d, centerwindow"

        # special
        ## swayosd
        ", XF86AudioRaiseVolume, exec, ${swayosdClient} --output-volume raise"
        ", XF86AudioLowerVolume, exec, ${swayosdClient} --output-volume lower"
        ", XF86AudioMute, exec, ${swayosdClient} --output-volume mute-toggle"
        ", XF86AudioMicMute, exec, ${swayosdClient} --input-volume mute-toggle"
        ", XF86MonBrightnessUp, exec, ${swayosdClient} --brightness raise"
        ", XF86MonBrightnessDown, exec, ${swayosdClient} --brightness lower"
        ## media
        ", XF86AudioPlay, exec, playerctl --player=spotify play-pause"
        ", XF86AudioNext, exec, playerctl --player=spotify next"
        ", XF86AudioPrev, exec, playerctl --player=spotify previous"
        "CTRL, XF86AudioPlay, exec, playerctl --player=firefox play-pause"
        "CTRL, XF86AudioNext, exec, playerctl --player=firefox next"
        "CTRL, XF86AudioPrev, exec, playerctl --player=firefox previous"

        "$mod + ALT, n, exit"
      ] ++ (
        # workspaces
        # binds $mod + [alt +] {1..10} to [move to] workspace {1..10}
        builtins.concatLists (builtins.genList (x:
          let
            ws = let c = (x + 1) / 10; in builtins.toString (x + 1 - (c * 10));
          in [
            "$mod, ${ws}, workspace, ${toString (x + 1)}"
            "$mod + ALT, ${ws}, movetoworkspace, ${toString (x + 1)}"
          ]) 10));

      bindm = [
        # mouse movements
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      ## Rules
      windowrulev2 = [
        # Default all floating
        "float,class:(.*)"

        # Tiled
        "tile,class:(firefox-aurora)"
        "tile,class:(Spotify)"
        "tile,class:(discord)"
        "tile,class:(nvim)"
        "tile,class:(steam)"
        "fullscreen,class:(gamescope)"

        # Floating
        "float,class:(utility)"
        "float,class:(notification)"
        "float,class:(toolbar)"
        "float,class:(splash)"
        "float,class:(dialog)"
        "float,class:(file_progress)"
        "float,class:(confirm)"
        "float,class:(dialog)"
        "float,class:(download)"
        "float,class:(error)"
        "float,class:(notification)"
        "float,class:(splash)"
        "float,class:(toolbar)"
      ];

      ## Autostart
      exec-once = [
        "[workspace 1 silent] firefox-developer-edition"
        "[workspace 7 silent] spotify"
        "[workspace 7 silent] ${pkgs.gtk3}/bin/gtk-launch discord"
        "${pkgs.swayosd}/bin/swayosd-server"
      ];
    };
  };
}
