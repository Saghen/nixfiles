{ lib, pkgs, config, inputs, ... }:

let
  monitors = config.monitors;
  colors = config.colors;
  convertHL = c: "0xff" + builtins.substring 1 6 c;
in {
  home.packages = with pkgs; [ wl-clipboard ];

  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [ "~/pictures/wallpaper.png" ];
      wallpaper = map (m: "${m},~/pictures/wallpaper.png") monitors;
    };
  };

  services.hypridle = {
    enable = true; # TODO: breaks VRR
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
        # TODO: 10 bit breaks wayfreeze and screen sharing
        "${builtins.elemAt monitors 0}, 3840x2160@240, 3840x0, 1"
        "${builtins.elemAt monitors 1}, 3840x2160@240, 0x0, 1"
        "Unknown-1, disable"
      ];
      xwayland = { force_zero_scaling = true; };

      # assign 6 workspaces to each monitor
      workspace = builtins.genList (x:
        let
          ws = toString (x + 1);
          monitor = builtins.elemAt monitors (x / 6);
        in "${ws}, monitor:${monitor}") (builtins.length monitors * 6)
        # Hide gaps on single window in workspace
        ++ [ "w[tv1], gapsout:0, gapsin:0" "f[1], gapsout:0, gapsin:0" ];

      # TODO: doesnt apply to foot because it runs as a server
      env = [
        "XDG_BACKEND,wayland"
        "XDG_SESSION_TYPE,wayland"
        "XDG_CURRENT_DESKTOP,hyprland"
        "QT_QPA_PLATFORM,wayland"

        # scaling
        "GDK_SCALE,1.25"
        "QT_SCALE_FACTOR,1.25" # todo: does this do anything?
        "STEAM_FORCE_DESKTOPUI_SCALING,1.25" # todo: is this needed?

        # enable wayland in all apps
        # "NIXOS_OZONE_WL,1"

        # Nvidia
        "LIBVA_DRIVER_NAME,nvidia"
        "NVD_BACKEND,direct"
      ];

      ## Settings
      general = {
        gaps_out = 8;
        gaps_in = 8;
        allow_tearing = true;

        "col.inactive_border" = convertHL colors.base;
        "col.active_border" = convertHL colors.primary;
      };
      decoration = { blur = { enabled = false; }; };
      cursor = {
        no_hardware_cursors = true;
        no_warps = true;
        default_monitor = "DP-1";
        # set the minimum refresh rate of the monitor to prevent flicker
        min_refresh_rate = 48;
      };
      input = {
        # 2 allows cursor focus separate from keyboard focus
        # to allow for scrolling without focusing
        follow_mouse = 2;
        float_switch_override_focus = 0;

        touchpad = { natural_scroll = true; };

        kb_options = "caps:super";
        repeat_rate = 40;
        repeat_delay = 240;
      };
      misc = {
        # focus when applications request it
        focus_on_activate = true;

        # causes background apps to run at 60fps, primarily for elden ring
        render_unfocused_fps = 60;

        disable_hyprland_logo = true;
        background_color = convertHL colors.crust;
        force_default_wallpaper = 0;

        enable_swallow = true;
        swallow_regex = "footclient";

        # Whether mouse moving into a different monitor should focus it
        mouse_move_focuses_monitor = false;
        # WARN: buggy, starts rendering before your monitor displays a frame in order to lower latency
        render_ahead_of_time = false;
        render_ahead_safezone = 2;

        disable_xdg_env_checks = true;

        # Reduces latency by showing frames as they come in, and eliminates tearing
        vrr = 0;
      };
      render = { direct_scanout = true; };
      # debug = { disable_logs = false; };

      ## Animations
      animation = [ "global,1,1,default," ];

      ## Binds
      bind = let
        wayfreeze =
          "${inputs.wayfreeze.packages.${pkgs.system}.wayfreeze}/bin/wayfreeze";
        wayshot = "${pkgs.wayshot}/bin/wayshot";
        slurp = "${pkgs.slurp}/bin/slurp";
        pkill = "${pkgs.procps}/bin/pkill";
        wl-copy = "${pkgs.wl-clipboard}/bin/wl-copy";
        wl-paste = "${pkgs.wl-clipboard}/bin/wl-paste";
        satty = "${pkgs.satty}/bin/satty";
        jq = "${pkgs.jq}/bin/jq";

        # https://github.com/Jappie3/wayfreeze/issues/14
        screenshotTmpl = args:
          "${wayfreeze} --hide-cursor --after-freeze-cmd='"
          + "${wayshot} ${args} --stdout | ${wl-copy}" # take screenshot and copy to clipboard
          + " && ${wl-paste} > ~/pictures/screenshots/$(date +%Y-%m-%d_%H-%M-%S).png" # save to file
          + " && cat < ~/pictures/screenshots/$(date +%Y-%m-%d_%H-%M-%S).png" # stdout filename for satty
          + "; ${pkill} wayfreeze'"; # unfreeze

        screenshotRegion = screenshotTmpl ''-s "$(${slurp})"'';

        # never touch this...
        # format from docs: https://github.com/emersion/slurp
        windowSlurp = pkgs.writeShellScriptBin "window-slurp" ''
          VISIBLE_WORKSPACES=$(hyprctl monitors -j | ${jq} -r 'map(.activeWorkspace.id) | tostring')
          hyprctl clients -j | ${jq} "map(select([.workspace.id] | inside($VISIBLE_WORKSPACES))) | map(select(.hidden | not))" | ${jq} -r '.[] | "\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"' | ${slurp}
        '';
        screenshotWindow =
          screenshotTmpl ''-s "$(${windowSlurp}/bin/window-slurp)"'';

        monitorSlurp = pkgs.writeShellScriptBin "monitor-slurp" ''
          hyprctl monitors -j | ${jq} -r '.[] | "\(.x),\(.y) \(.width)x\(.height)"' | ${slurp}
        '';
        screenshotMonitor =
          screenshotTmpl ''-s "$(${monitorSlurp}/bin/monitor-slurp)"'';

        subtext = builtins.substring 1 6 colors.subtext-1;
        launchNeovimZellij = pkgs.writeShellScriptBin "launch-neovim-zellij" ''
          WINDOW_ADDRESS=$(hyprctl clients -j | jq 'map(select(.class == "zellij-neovim")) | .[0].address' -r)
          if [ "$WINDOW_ADDRESS" == "null" ]; then
            footclient \
              -o colors.foreground=${subtext} \
              -o pad=0x0 \
              --window-size-pixels=3840x2160 \
              --app-id zellij-neovim \
              --title zellij-neovim \
              fish -c "zellij --session neovim --new-session-with-layout neovim || zellij attach neovim"
          else
            hyprctl dispatch focuswindow zellij-neovim
          fi
        '';

        swayosdClient = "${pkgs.swayosd}/bin/swayosd-client";
      in [
        # applications
        "$mod, Space, exec, tofi-drun --drun-launch=true"
        "$mod, Return, exec, footclient"
        # NOTE: specifying the window size avoids a flash of smaller window
        # NOTE: specifying the foreground color sets the cursor color when the background/foreground are the same
        "$mod, c, exec, ${launchNeovimZellij}/bin/launch-neovim-zellij"
        "$mod + SHIFT, c, exec, footclient -o colors.foreground=${subtext} -o pad=0x0 --window-size-pixels=2560x1440 --app-id neovim --title neovim nvim"
        "$mod + SHIFT, Return, exec, foot" # fallback in case foot.service fails

        # screenshots
        ", Print, exec, ${screenshotRegion}"
        "SHIFT, Print, exec, ${screenshotRegion} | ${satty} --early-exit --filename -"
        "CTRL, Print, exec, ${screenshotWindow}"
        "CTRL + SHIFT, Print, exec, ${screenshotWindow} | ${satty} --early-exit --filename -"
        "ALT, Print, exec, ${screenshotMonitor}"
        "ALT + SHIFT, Print, exec, ${screenshotMonitor} | ${satty} --early-exit --filename -"

        # window management
        "$mod, q, focusmonitor, +1"
        # TODO: figure out how to alterzindex since bringactivetotop is deprecated
        "$mod, r, exec, hyprctl dispatch cyclenext && hyprctl dispatch bringactivetotop"
        "$mod + SHIFT, r, cyclenext, prev"
        "$mod, a, movewindow, mon:+1"
        "$mod, w, exec, hyprctl activewindow -j | jq '.fullscreen == 0' -e && hyprctl dispatch closewindow activewindow"
        "$mod + ALT, w, closewindow, activewindow"
        "$mod + ALT + SHIFT, w, killactive"
        "$mod, f, togglefloating"
        "$mod + SHIFT, f, fullscreen"
        "$mod, s, swapactiveworkspaces, ${lib.concatStringsSep " " monitors}"
        "$mod, d, centerwindow"

        # bar
        "$mod, b, exec, systemctl --user restart limbo"
        "$mod + SHIFT, b, exec, systemctl --user stop limbo"
        "$mod + ALT, b, exec, systemctl --user start limbo"

        # special
        ## swayosd  TODO: never tested
        ", XF86AudioRaiseVolume, exec, ${swayosdClient} --output-volume raise"
        ", XF86AudioLowerVolume, exec, ${swayosdClient} --output-volume lower"
        ", XF86AudioMute, exec, ${swayosdClient} --output-volume mute-toggle"
        ", XF86AudioMicMute, exec, ${swayosdClient} --input-volume mute-toggle"
        ", XF86MonBrightnessUp, exec, ${swayosdClient} --brightness raise"
        ", XF86MonBrightnessDown, exec, ${swayosdClient} --brightness lower"
        ## media
        ", XF86AudioPlay, exec, playerctl --player=spotify,tauon play-pause"
        ", XF86AudioNext, exec, playerctl --player=spotify,tauon next"
        ", XF86AudioPrev, exec, playerctl --player=spotify,tauon previous"
        "CTRL, XF86AudioPlay, exec, playerctl --player=firefox play-pause"
        "CTRL, XF86AudioNext, exec, playerctl --player=firefox next"
        "CTRL, XF86AudioPrev, exec, playerctl --player=firefox previous"

        "$mod + ALT, n, exit"
      ] ++ (
        # workspaces
        # binds $mod + [alt +] {1..6} to [move to] workspace {1..6}
        builtins.concatLists (builtins.genList (x:
          let
            ws = let c = (x + 1) / 10; in builtins.toString (x + 1 - (c * 10));
            # TODO: changes depending on monitor order
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
        # Hide border on single window in workspace
        "bordersize 0, floating:0, onworkspace:w[tv1]"
        "bordersize 0, floating:0, onworkspace:f[1]"

        # Default all floating
        "float,class:(.*)"
        "float,title:(.*)"

        # Firefox
        "tile,class:(firefox-nightly)"
        "float,class:(firefox-nightly),title:(Enter name of file to save to...)"
        "float,class:(firefox-nightly),title:(File Upload)"
        "size 1200 800,class(firefox-nightly),title:(Enter name of file to save to...)"
        "size 1200 800,class(firefox-nightly),title:(File Upload)"

        # Games: fullscreen, workspace 3, always focused for workspace, ignore activate
        "fullscreen,class:(steam_app_.+|tf_linux64|gamescope)"
        "workspace 3,class:(steam_app_.+|tf_linux64|gamescope)"
        "renderunfocused,class:(steam_app_.+|tf_linux64|gamescope)"
        # Shouldn't be needed with VRR
        "immediate,class:(steam_app_.+|tf_linux64|gamescope)"
        # TODO: Can't click out of the game window onto the other monitor
        # "stayfocused,class:(steam_app_.+|tf_linux64|gamescope)"

        # Jellyfin
        "fullscreen,class:(com.github.iwalton3.jellyfin-media-player)"

        # Tiled
        "tile,class:(Spotify),title:(Spotify)" # must be specific, otherwise popups will tile
        "workspace 7,class:(Spotify),title:(Spotify)"
        "tile,class:(vesktop)"
        "workspace 7,class:(vesktop)"
        "tile,class:(neovim)"
        "tile,class:(zellij-neovim)"
        "tile,class:(thunderbird),title:(Mozilla Thunderbird)" # must be specific, otherwise popups will tile

        # Sizing
        "size 900 1000,class:(org.gnome.SystemMonitor)"
        "size 1200 800,class:(org.gnome.Nautilus)"
        "size 1800 1200,class:(steam),title:^(Steam)$"
        "minsize 640 480,class:(qimgv)"

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

        # Disable animations
        "noanim 1,class:(foot(client)?)"
      ];

      ## Autostart
      exec-once = [
        "[workspace 1 silent] firefox-nightly"
        "[workspace 7 silent] spotify"
        # TODO: https://github.com/Vencord/Vesktop/issues/342
        # needed for working drag and drop
        "[workspace 7 silent] vesktop"
        "${pkgs.swayosd}/bin/swayosd-server"
        # constantly set volume to 1 to counteract something adjusting it
        "while true; do sleep 1 && ${pkgs.pulseaudio}/bin/pactl set-source-volume @DEFAULT_SOURCE@ 100%; done &"
      ];
    };
  };
}
