{ config, ... }:
let
  colors = config.colors;
in
{
  programs.zellij = {
    enable = true;
    enableFishIntegration = false;
    settings = {
      pane_frames = false;
      default_mode = "locked";
      session_serialization = false;
      show_startup_tips = false;

      keybinds = {
        _props = {
          clear-defaults = true;
        };
        # doesn't matter what this is,
        # we just need some key so that config validation passes
        normal = {
          bind = {
            _args = [ "left" ];
            MoveFocus = [ "left" ];
          };
        };
      };

      theme = "personal";
      themes = {
        personal = {
          fg = colors.text;
          bg = colors.base;
          black = colors.base;
          red = colors.red;
          green = colors.green;
          yellow = colors.yellow;
          blue = colors.blue;
          magenta = colors.mauve;
          cyan = colors.teal;
          orange = colors.peach;
          white = colors.text;
        };
      };
    };
  };

  xdg.configFile."zellij/layouts/neovim.kdl".text = ''
    layout { 
      pane {
        command "nvim"
        close_on_exit true
      }
    }'';
}
