{ config, ... }:

let colors = config.colors;
in {
  programs.zellij = {
    enable = true;
    settings = {
      pane_frames = false;
      default_mode = "locked";
      session_serialization = true;

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

