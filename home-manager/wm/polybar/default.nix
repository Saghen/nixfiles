{ pkgs, ... }:

# TODO: set fonts

let
  polywins = pkgs.writeShellScriptBin "polywins" ''
    ${pkgs.python3}/bin/python ${./scripts/polywins.py}
  '';
  micUsage = pkgs.writeShellScriptBin "mic-usage" ''
    ${builtins.readFile ./scripts/mic-usage.sh}
  '';
  cameraUsage = pkgs.writeShellScriptBin "camera-usage" ''
    ${builtins.readFile ./scripts/camera-usage.sh}
  '';
in
{
  home.packages = with pkgs; [
    twitch-cli
  ];

  services.polybar = {
    enable = true;
    script = ''
      # Terminate already running bar instances
      killall -q polybar

      # To prevent an issue with the launch
      sleep 0.5 
      while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

      # Launch the bar
      # Check if monitor is connected and then launch on that monitor
      if xrandr --listactivemonitors | grep "$DISPLAY2" > /dev/null; then
        MONITOR=$DISPLAY2 polybar &
      fi
      if xrandr --listactivemonitors | grep "$DISPLAY1" > /dev/null; then
        # Sleep so the dock goes on the other monitor
        sleep 0.5
        MONITOR=$DISPLAY1 polybar &
      fi
    '';
    settings = {
      "global/wm" = {
        margin-bottom = 0;
        margin-top = 0;
      };

      "settings" = {
        # The throttle settings lets the eventloop swallow up til X events
        # if they happen within Y millisecond after first event was received.
        # This is done to prevent flood of update event.
        # 
        # For example if 5 modules emit an update event at the same time, we really
        # just care about the last one. But if we wait too long for events to swallow
        # the bar would appear sluggish so we continue if timeout
        # expires or limit is reached.
        throttle-output = 5;
        throttle-output-for = 10;

        # Time in milliseconds that the input handler will wait between processing events
        #throttle-input-for = 30;

        # Reload upon receiving XCB_RANDR_SCREEN_CHANGE_NOTIFY events
        screenchange-reload = false;

        # Compositing operators
        # @see: https://www.cairographics.org/manual/cairo-cairo-t.html#cairo-operator-t
        compositing-background = "source";
        compositing-foreground = "over";
        compositing-overline = "over";
        compositing-underline = "over";
        compositing-border = "over";

        # Enables pseudo-transparency for the bar
        # If set to true the bar can be transparent without a compositor.
        pseudo-transparency = false;
      };

      "colors" = {
        # NOTE: Some modules such as spotify, use format tags (${F#000}) which cannot use custom variables
        # https://github.com/polybar/polybar/issues/615
        # You must find and replace these values

        background = "#1E1E28"; # Bar BG
        background-alt = "#332E41";
        background-alt-2 = "#393348";
        background-alt-3 = "#393348";
        foreground = "#bfc9db";
        accent = "#A4B9EF";
        empty = "#00000000";

        flamingo = "#f2cdcd";
        mauve = "#DDB6F2";
        pink = "#F5C2E7";
        maroon = "#E8A2AF";
        red = "#F28FAD";
        peach = "#F8BD96";
        yellow = "#FAE3B0";
        green = "#98C379";
        teal = "#B5E8E0";
        blue = "#96CDFB";
        sky = "#89DCEB";
        lavendar = "#C9CBFF";
      };

      "bar/mybar" = {
        monitor = "\${env:MONITOR:}";

        # Require the monitor to be in connected state
        # XRandR sometimes reports my monitor as being disconnected (when in use)
        monitor-strict = false;

        # Tell the Window Manager not to configure the window.
        # Use this to detach the bar if your WM is locking its size/position.
        override-redirect = false;

        # Put the bar at the bottom of the screen
        bottom = false;

        # Prefer fixed center position for the `modules-center` block.
        # The center block will stay in the middle of the bar whenever
        # possible. It can still be pushed around if other blocks need
        # more space.
        # When false, the center block is centered in the space between
        # the left and right block.
        fixed-center = true;

        modules-right = "l1 twitch github gap dnd gap pulseaudio gap wlan gap date gap-small";
        modules-center = "l1 spotify camera-usage-indicator mic-usage-indicator r1";
        modules-left = "gap-small bspwm polywins r1";

        width = "100%";
        height = 30;
        offset-x = "0%";
        offset-y = "0%";
        radius = 0.0;
        wm-restack = "bspwm";

        line-height = 4;
        line-size = 3;
        line-color = "#ffffff";

        foreground = "\${colors.foreground}";
        background = "\${colors.background}";
        border-color = "\${colors.background}";
        border-size = 0;

        # fonts
        font-0 = "OperatorMono Nerd Font:size=12;2";
        font-1 = "Feather:style=Bold:size=12;2";
        font-2 = "OperatorMono Nerd Font:size=13;3";

        # font for the rounded thing
        font-3 = "OperatorMono Nerd Font:size=18;5";

        # font for random icons
        # todo: unused
        font-4 = "FuraCode Nerd Font:size=14;2";

        # font for emotes
        font-5 = "Noto Color Emoji:style=Regular:scale=10;2";

        # Position of the system tray window
        # If empty or undefined, tray support will be disabled
        # NOTE: A center aligned tray will cover center aligned modules
        #
        # Available positions:
        #   left
        #   center
        #   right
        #   none
        tray-position = "right";

        # If true, the bar will not shift its
        # contents when the tray changes
        tray-detached = false;

        # Tray icon max size
        tray-maxsize = 16;

        # Background color for the tray container
        # ARGB color (e.g. #f00, #ff992a, #ddff1023)
        # By default the tray container will use the bar
        # background color.
        tray-background = "\${colors.background-alt}";

        # Foreground color for the tray icons
        # This only gives a hint to the tray icon for its color, it will probably only
        # work for GTK3 icons (if at all) because it targets a non-standard part of the
        # system tray protocol by setting the _NET_SYSTEM_TRAY_COLORS atom on the tray
        # window.
        tray-foreground = "\${colors.green}";

        # Offset the tray in the x and/or y direction
        # Supports any percentage with offset
        # Percentages are relative to the monitor width or height for detached trays
        # and relative to the bar window (without borders) for non-detached tray.
        tray-offset-x = 0;
        tray-offset-y = 0;

        # Pad the sides of each tray icon
        tray-padding = 4;

        # Scale factor for tray clients
        tray-scale = 1.0;
      };

      "module/bspwm" = {
        type = "internal/bspwm";

        label-focused = "";
        label-focused-background = "\${colors.background-alt}";
        label-focused-foreground = "\${colors.accent}";
        label-focused-underline = "\${colors.empty}";
        label-focused-padding = 1;

        label-occupied = "";
        label-occupied-background = "\${colors.background-alt}";
        label-occupied-foreground = "\${colors.accent}";
        label-occupied-padding = 1;

        label-urgent = "";
        label-urgent-background = "\${colors.background-alt}";
        label-urgen-foreground = "\${colors.yellow}";
        label-urgent-padding = 1;

        label-empty = "";
        label-empty-foreground = "\${colors.foreground}";
        label-empty-background = "\${colors.background-alt}";
        label-empty-padding = 1;

        label-dimmed-focused-background = "\${colors.background-alt}";
        label-dimmed-focused-foreground = "\${colors.foreground}";
        label-dimmed-focused-padding = 1;
      };

      "module/polywins" = {
        # Can change colors in polywins file. need to use env vars
        type = "custom/script";
        exec = "${polywins} $MONITOR";
        format = "<label>";
        format-background = "\${colors.background-alt}";
        label = "%output%";
        label-padding = 1;
        tail = true;
      };

      "module/date" = {
        type = "internal/date";
        interval = 5;
        date = "";
        date-alt = " %d / %m / %Y";

        time = " %a %I:%M";
        time-alt = "";

        format-underline = "\${colors.empty}";

        label = "%date%%time%";
        label-foreground = "\${colors.accent}";
        label-background = "\${colors.background-alt}";
      };

      "module/wlan" = {
        type = "internal/network";
        interface-type = "wired";
        interval = 5;

        format-disconnected-background = "\${colors.background-alt}";
        format-connected-background = "\${colors.background-alt}";

        format-connected = "";
        format-connected-foreground = "\${colors.accent}";

        format-disconnected = "";
        format-disconnected-foreground = "\${colors.red}";

        ramp-signal-0 = "%{T5} %{T-}";
        ramp-signal-foreground = "\${colors.accent}";
      };

      "module/space" = {
        type = "custom/text";
        content = "  ";
        content-background = "\${colors.background-alt}";
        content-foreground = "\${colors.foreground}";
      };

      "module/sep" = {
        type = "custom/text";
        content = "|  ";
        content-background = "\${colors.background}";
        content-foreground = "\${colors.background-alt-3}";
      };

      "module/pulseaudio" = {
        type = "internal/pulseaudio";
        use-ui-max = true;
        interval = 5;
        click-right = "pavucontrol";

        ramp-volume-0 = "";
        ramp-volume-1 = "";
        ramp-volume-2 = "";

        format-volume = "<ramp-volume>";
        format-volume-foreground = "\${colors.flamingo}";
        format-volume-background = "\${colors.background-alt}";

        label-muted = "";
        label-muted-foreground = "\${colors.red}";
        label-muted-background = "\${colors.background-alt}";
      };

      "module/mic-usage-indicator" = {
        type = "custom/script";
        exec = "${micUsage} \"\" \"\"";
        format-foreground = "\${colors.accent}";
        format-background = "\${colors.background-alt}";
        interal = 5;
      };

      "module/camera-usage-indicator" = {
        type = "custom/script";
        # exec = "${cameraUsage} \" \" \"\"";
        format-foreground = "\${colors.accent}";
        format-background = "\${colors.background-alt}";
        interal = 5;
      };

      "module/gap-dark" = {
        type = "custom/text";
        content = " ";
        content-background = "\${colors.background}";
      };

      "module/gap-small" = {
        type = "custom/text";
        content = " ";
        content-background = "\${colors.background-alt}";
      };

      "module/gap" = {
        type = "custom/text";
        content = "  ";
        content-background = "\${colors.background-alt}";
      };

      "module/r1" = {
        type = "custom/text";
        content = "%{T4}%{T-}";
        content-background = "\${colors.background}";
        content-foreground = "\${colors.background-alt}";
      };

      "module/l1" = {
        type = "custom/text";
        content = "%{T4}%{T-}";
        content-background = "\${colors.background}";
        content-foreground = "\${colors.background-alt}";
      };

      "module/twitch" = {
        type = "custom/script";
        format-font = 6;
        format-foreground = "\${colors.foreground}";
        format-background = "\${colors.background-alt}";
        interval = 60;
        exec = "python ~/scripts/twitch/is-streaming.py";
      };

      "module/github" = {
        type = "custom/script";
        click-left = "exec ~/scripts/github/open-notifications.sh";
        exec = "~/scripts/github/get-notification-count.sh";
        format-prefix = " ";
        format-prefix-font = 2;
        # format-prefix = " " if you don't like feather
        format-foreground = "\${colors.foreground}";
        format-background = "\${colors.background-alt}";
        interval = 20;
      };

      "module/dnd" = {
        type = "custom/script";
        click-left = "dunstctl set-paused toggle";
        exec = "[ 'true' = $(dunstctl is-paused) ] && echo \"\" || echo \"\"";
        format-foreground = "\${colors.red}";
        format-background = "\${colors.background-alt}";
        interval = 1;
      };

      "module/polypomo" = {
        type = "custom/script";

        # MAKE SURE TO RUN ~/scripts/polybar/polypomo/polypomo > /tmp/polypomo.status somewhere.
        # I put this in my bspwmrc which also starts polybar
        exec = "tail -f -n 1 /tmp/polypomo.status";
        tail = true;

        format-foreground = "\${colors.lavendar}";
        format-background = "\${colors.background-alt}";
        click-left = "~/scripts/polybar/polypomo.py toggle";
        click-right = "~/scripts/polybar/polypomo.py end";
        click-middle = "~/scripts/polybar/polypomo.py lock";
      };

      "module/spotify" = {
        type = "custom/script";
        exec = "echo \"%{F#A4B9EF}$([[ 'Playing' == $(playerctl --player=spotify,ncspot status) ]] && echo '' || echo '')%{F-}%{F#A4B9EF}$(playerctl metadata --player=spotify,ncspot xesam:title) -%{F-} %{F#C9CBFF}$(playerctl metadata --player=spotify,ncspot xesam:artist)%{F-} %{F#C9CBFF}$(~/scripts/audio/get-spotify-volume.py)%%{F-} ";

        click-left = "playerctl --player=spotify,ncspot play-pause";
        click-right = "playerctl --player=spotify,ncspot next";
        click-middle = "playerctl --player=spotify,ncspot previous";
        scroll-up = "~/scripts/audio/change-spotify-volume.py +10%";
        scroll-down = "~/scripts/audio/change-spotify-volume.py -10%";

        format = "<label>";
        format-maxlen = 30;
        format-foreground = "\${colors.foreground}";
        format-background = "\${colors.background-alt}";

        interval = 1;
      };
    };
  };
}
