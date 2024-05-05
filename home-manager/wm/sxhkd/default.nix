{ pkgs, ... }:

{
  services.sxhkd = {
    enable = true;
    # TODO: switch to keybindings option or gabe's?
    extraConfig = with {
      center-window = "${
          pkgs.writeShellScriptBin "center-window" ''
            ${builtins.readFile ./scripts/center-window.sh}
          ''
        }/bin/center-window";
      select-local-desktop = "${
          pkgs.writeShellScriptBin "select-local-desktop" ''
            ${builtins.readFile ./scripts/select-local-desktop.sh}
          ''
        }/bin/select-local-desktop";
      reset-desktops = "${
          pkgs.writeShellScriptBin "reset-desktops" ''
            ${pkgs.nodejs_21}/bin/node ${./scripts/reset-desktops.js}
          ''
        }/bin/reset-desktops";
    }; ''
      # -----------
      # applications

      # terminal
      super + Return
        kitty

      super + shift + Return
        bspc rule -a kitty -o rectangle=1920x1080+0+0;\
        kitty

      # program launcher
      super + space
        rofi -show drun -show-icons

      # make sxhkd reload its configuration files:
      super + Escape
      	pkill -USR1 -x sxhkd

      # screenshot
      Print
      	flameshot gui -s -c

      ctrl + Print
        flameshot gui

      # neovim
      super + c
        kitty --class neovim fish -c nvim

      # -----------
      # media control

      XF86AudioPlay
      	playerctl --player=ncspot,spotify play-pause

      XF86AudioNext
      	playerctl --player=ncspot,spotify next

      XF86AudioPrev
      	playerctl --player=ncspot,spotify previous

      shift + XF86AudioNext
        ~/scripts/audio/change-spotify-volume.py +10%

      shift + XF86AudioPrev
        ~/scripts/audio/change-spotify-volume.py -10%

      ctrl + XF86AudioPlay
      	playerctl --player=firefox play-pause

      # -----------
      # bspwm hotkeys

      # quit/restart bspwm
      super + alt + {n,m}
      	bspc {quit,wm -r}

      # close window if not fullscreen
      super + w
        test -n (bspc query -n focused -T | jq .client.state | grep "fullscreen"); and bspc node -c

      # close window regardless of type
      super + alt + w
        bspc node -c

      # kill window
      super + shift + alt + w
        bspc node -k

      # -----------
      # state/flag

      # set the window state
      super + f
      	if test -z (bspc query -N -n focused.floating); \
            bspc node focused -t floating; \
        else; \
            bspc node focused -t tiled; \
        end

      super + shift + f
        bspc node -t \~fullscreen

      super + shift + s
        bspc node -g sticky

      # alternate between the tiled and monocle layout
      super + m
      	bspc desktop -l next

      # -----------
      # move/resize

      # move a window
      super + ctrl + {Left,Down,Up,Right}
      	bspc node -v {-200 0,0 200,0 -200,200 0}

      # center
      super + d
        ${center-window}

      # expand
      super + x
        bspc node -z bottom_rig 200 120;\
        bspc node -z top_left -200 -120

      # contract
      super + z
        bspc node -z bottom_rig -200 -120;\
        bspc node -z top_left 200 120

      # -----------
      # focus/swap

      # focus/swap/send the node in the given direction
      super + {_,alt + ,shift + }{Left,Down,Up,Right}
      	bspc node -{f,s,n} {west,south,north,east} --follow

      # focus the next/previous window in the current desktop
      super + {r,alt + r}
      	bspc node -f {next,prev}.local.!hidden.window

      # focus/send to the given desktop
      super + {_,alt + }{1-9,0}
        ${select-local-desktop} "{desktop -f,node -d}" {1-9,10} --follow

      # focus/send to other monitor and follow
      super + {q,a}
      	bspc {monitor -f,node -m} next --follow

      # send node to last local desktop and follow
      super + ctrl + a
      	bspc node -d last.local --follow

      # swap with other monitor
      super + s
      	bspc desktop focused -s any.active.\!local --follow

      # reset swapped desktops
      super + shift + s
        ${reset-desktops} $DISPLAY1 $DISPLAY2
    '';
  };
}
