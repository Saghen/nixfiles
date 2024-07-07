{ lib, pkgs, config, ... }:

let
  monitors = config.monitors;
  colors = config.colors;
  convertHL = c: "0xff" + builtins.substring 1 6 c;
in {
  home.packages = with pkgs; [ wl-clipboard hyprshot hyprpicker ];

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
      wallpaper = map (m: "${m},~/pictures/wallpaper.png") monitors;
    };
  };

  programs.hyprlock = {
    enable = true;
    # Workaround for lag https://github.com/hyprwm/hyprlock/issues/128
    package = pkgs.hyprlock.overrideAttrs (old: {
      version = "git";
      src = pkgs.fetchFromGitHub {
        owner = "hyprwm";
        repo = "hyprlock";
        rev = "2bce52f";
        sha256 = "36qa6MOhCBd39YPC0FgapwGRHZXjstw8BQuKdFzwQ4k=";
      };
      patchPhase = ''
        substituteInPlace src/core/hyprlock.cpp \
        --replace "5000" "6"
      '';
    });
    settings = {
      background =
        [{ path = "~/pictures/wallpapers/cyberpunk/skyline-catppuccin.png"; }];

      general = {
        disable_loading_bar = true;
        ignore_empty_input = true;
      };

      # input
      input-field = [{
        size = "250, 40";
        outline_thickness = 1;
        dots_size = 0.2; # Scale of input-field height, 0.2 - 0.8
        dots_spacing = 0.2; # Scale of dots' absolute size, 0.0 - 1.0
        dots_center = true;
        rounding = -1;
        outer_color = "rgba(0, 0, 0, 0)";
        inner_color = convertHL colors.base;
        font_color = convertHL colors.text;
        fail_color = convertHL colors.red;
        check_color = convertHL colors.yellow;
        fade_on_empty = false;
        # font_family = "JetBrains Mono Nerd Font Mono"
        # placeholder_text = ''
        #   <i><span foreground="#${colors.subtext-0}">Input Password...</span></i>'';
        hide_input = false;
        position = "0, -120";
        halign = "center";
        valign = "center";
      }];

      label = [
        # time
        {
          text = ''cmd[update:1000] echo "$(date +"%-I:%M%p")"'';
          color = convertHL colors.text;
          font_size = 120;
          # font_family = "JetBrains Mono Nerd Font Mono ExtraBold";
          position = "0, -300";
          halign = "center";
          valign = "top";
        }
        # user
        {
          text = "Hi there, ${config.home.username}";
          color = convertHL colors.text;
          font_size = 25;
          # font_family = "JetBrains Mono Nerd Font Mono";
          position = "0, -40";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        # avoid starting multiple hyprlock instances
        lock_cmd = "${pkgs.procps}/bin/pidof hyprlock || hyprlock";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        # turn screen off after 5 minutes
        {
          timeout = 300;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        # lock after 10 minutes
        {
          timeout = 600;
          on-timeout = "${pkgs.systemd}/bin/loginctl lock-session";
        }
      ];
    };
  };

  # Night light
  services.gammarelay.enable = true;

  # TODO: switch to https://codeberg.org/dnkl/fuzzel ? for the application icons
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
      drun-launch = true;
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      "$mod" = "SUPER";

      monitor = [
        "${builtins.elemAt monitors 0}, 2560x1440@144, 2560x0, 1"
        "${builtins.elemAt monitors 1}, 2560x1440@144, 0x0, 1"
        "Unknown-1, disable"
      ];

      # assign 6 workspaces to each monitor
      workspace = builtins.genList (x:
        let
          ws = toString (x + 1);
          monitor = builtins.elemAt monitors (x / 6);
        in "${ws}, monitor:${monitor}") (builtins.length monitors * 6);

      # TODO: doesnt apply to foot because it runs as a server
      env = [
        "XDG_BACKEND,wayland"
        "XDG_SESSION_TYPE,wayland"

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
      general = {
        gaps_out = 8;
        gaps_in = 8;

        "col.inactive_border" = convertHL colors.base;
        "col.active_border" = convertHL colors.primary;
      };
      dwindle = { no_gaps_when_only = 1; };
      decoration = { blur = { enabled = false; }; };
      cursor = {
        no_hardware_cursors = true;
        no_warps = true;
        default_monitor = "DP-1";
      };
      input = {
        # 2 allows cursor focus separate from keyboard focus
        # to allow for scrolling without focusing
        follow_mouse = 2;
        float_switch_override_focus = 0;

        repeat_rate = 40;
        repeat_delay = 240;
      };
      misc = {
        disable_hyprland_logo = true;
        background_color = convertHL colors.crust;
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

      ## Animations
      animation = [ "global,1,1,default," ];

      ## Binds
      bind = let
        hyprshot = "${pkgs.hyprshot}/bin/hyprshot";
        satty = "${pkgs.satty}/bin/satty";
        swayosdClient = "${pkgs.swayosd}/bin/swayosd-client";
      in [
        # applications
        "$mod, Space, exec, tofi-drun --drun-launch=true"
        "$mod, Return, exec, footclient"
        # NOTE: specifying the window size avoids a flash of smaller window
        "$mod, c, exec, footclient -o pad=0x0 --window-size-pixels=2560x1440 --app-id nvim --title nvim nvim"
        "$mod + SHIFT, Return, exec, foot" # fallback in case foot.service fails
        ", Print, exec, ${hyprshot} -m region -o ~/pictures/screenshots/hyprshot"
        "SHIFT, Print, exec, ${hyprshot} -m region -o ~/pictures/screenshots/hyprshot --raw | ${satty} --filename -"
        "$mod, Print, exec, ${hyprshot} -m window -o ~/pictures/screenshots/hyprshot"
        "$mod + SHIFT, Print, exec, ${hyprshot} -m window -o ~/pictures/screenshots/hyprshot --raw | ${satty} --filename -"
        "ALT, Print, exec, ${hyprshot} -m output -o ~/pictures/screenshots/hyprshot"
        "ALT + SHIFT, Print, exec, ${hyprshot} -m output -o ~/pictures/screenshots/hyprshot --raw | ${satty} --filename -"

        # window management
        "$mod, q, focusmonitor, +1"
        # TODO: figure out how to alterzindex since bringactivetotop is deprecated
        "$mod, r, exec, hyprctl dispatch cyclenext && hyprctl dispatch bringactivetotop"
        "$mod + SHIFT, r, cyclenext, prev"
        "$mod, a, movewindow, mon:+1"
        "$mod, w, exec, hyprctl activewindow -j | jq '.fullscreen | not' -e && hyprctl dispatch closewindow activewindow"
        "$mod + ALT, w, killactive"
        "$mod, f, togglefloating"
        "$mod + SHIFT, f, fullscreen"
        "$mod, s, swapactiveworkspaces, ${lib.concatStringsSep " " monitors}"
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
        # binds $mod + [alt +] {1..6} to [move to] workspace {1..6}
        # TODO: should handle mouse being on a different monitor while switching to an empty workspace
        # breaking the focus. possible beacuse of the follow_mouse setting
        builtins.concatLists (builtins.genList (x:
          let
            ws = let c = (x + 1) / 10; in builtins.toString (x + 1 - (c * 10));
            is_main_monitor =
              "test $(hyprctl activeworkspace -j | jq '.monitorID') -eq 0";
            get_workspace =
              "${is_main_monitor} && echo ${toString (x + 1)} || echo ${
                toString (x + 7)
              }";
          in [
            "$mod, ${ws}, exec, hyprctl dispatch workspace $(${get_workspace})"
            "$mod + ALT, ${ws}, exec, hyprctl dispatch movetoworkspace $(${get_workspace})"
          ]) 6));

      bindm = [
        # mouse movements
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
      ];

      ## Rules
      windowrulev2 = [
        # Default all floating
        "float,class:(.*)"
        "float,title:(.*)"

        # Firefox
        "tile,class:(firefox-aurora)"
        "float,class:(firefox-aurora),title:(Enter name of file to save to...)"
        "size 1200 800,class(firefox-aurora),title:(Enter name of file to save to...)"

        # Tiled
        "tile,class:(Spotify),title:(Spotify)" # must be specific, otherwise popups will tile
        "tile,class:(discord)"
        "tile,class:(nvim)"
        "fullscreen,class:(gamescope)"

        # Sizing
        "size 900 1000,class:(org.gnome.SystemMonitor)"
        "size 1200 800,class:(org.gnome.Nautilus)"
        "size 1800 1200,class:(steam),title:^(Steam)$"

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
        "[workspace 7 silent] vesktop"
        "${pkgs.swayosd}/bin/swayosd-server"
      ];
    };
  };
}
