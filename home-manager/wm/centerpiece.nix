{ config, inputs, ... }:

let colors = config.colors;
in {
  # TODO: using pkgs.system here causes infinite recursion
  imports = [ inputs.centerpiece.hmModules."x86_64-linux".default ];

  programs.centerpiece = {
    enable = true;
    config = {
      color = {
        text = colors.text;
        background = colors.crust;
      };
      plugin = {
        brave_bookmarks.enable = false;
        brave_history.enable = false;
        brave_progressive_web_apps.enable = false;
        git_repositories.enable = false;
        sway_windows.enable = false;
      };
    };
  };
}
