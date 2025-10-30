{ pkgs, config, ... }:

let
  colors = config.colors;
  convert = c: builtins.substring 1 6 c;
in
{
  systemd.user.services.ghostty = {
    Unit = {
      Description = "ghostty daemon";
      After = [
        "graphical-session.target"
        "dbus.socket"
      ];
      Requires = [ "dbus.socket" ];
    };
    Install.WantedBy = [ "graphical-session.target" ];
    Service = {
      Type = "notify-reload";
      ReloadSignal = "SIGUSR2";
      BusName = "com.mitchellh.ghostty";
      ExecStart = "${pkgs.ghostty}/bin/ghostty --gtk-single-instance=true --initial-window=false";
    };
  };

  programs.ghostty = {
    enable = true;
    settings = {
      theme = "personal";
      font-family = "IosevkaCustom Nerd Font";
      font-size = builtins.floor (13 * config.machine.scalingFactor);

      adjust-cell-height = builtins.floor (7 * config.machine.scalingFactor);
      adjust-underline-position = builtins.floor (3 * config.machine.scalingFactor);
      resize-overlay = "never";
      window-padding-x = 4;
      window-padding-y = 4;
      window-decoration = "none";
      confirm-close-surface = false;
      quit-after-last-window-closed = false;

      # has same issue as foot used to have: https://codeberg.org/dnkl/foot/issues/1761
      # cursor-color = "cell-foreground";
      custom-shader = toString ./cursor-warp.glsl;
    };
    themes = {
      personal = {
        background = convert colors.base;
        cursor-color = convert colors.text;
        foreground = convert colors.text;
        palette = [
          ("0=" + colors.base)
          ("1=" + colors.red)
          ("2=" + colors.green)
          ("3=" + colors.yellow)
          ("4=" + colors.blue)
          ("5=" + colors.pink)
          ("6=" + colors.teal)
          ("7=" + colors.subtext-0)
          ("8=" + colors.surface-1)
          ("9=" + colors.red)
          ("10=" + colors.green)
          ("11=" + colors.yellow)
          ("12=" + colors.blue)
          ("13=" + colors.pink)
          ("14=" + colors.teal)
          ("15=" + colors.subtext-1)
        ];
        selection-background = convert colors.surface-1;
        selection-foreground = convert colors.text;
      };
    };
  };

  home.sessionVariables.TERMINAL = "foot";
  programs.foot = {
    enable = true;
    server.enable = true; # better startup time, must use footclient
    settings = {
      main = {
        font = "Iosevka Custom Nerd Font:size=${
          toString (builtins.floor (14 * config.machine.scalingFactor))
        }";
        line-height = "${toString (builtins.floor (30 * config.machine.scalingFactor))}px";
        underline-thickness = "2px";
        underline-offset = "5px";
        pad = "4x4";
        initial-window-size-pixels = "1750x1050";

        # Caused by Hyprland 0.48+
        # https://www.reddit.com/r/hyprland/comments/1jjnxh2/foot_terminal_issue_after_048_update/
        gamma-correct-blending = false;
      };
      cursor = {
        unfocused-style = "hollow";
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
}
