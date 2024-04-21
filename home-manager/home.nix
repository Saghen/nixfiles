{ config, ... }:

{
  imports = [ ./apps ./terminal ./wm ];
  config = {
    home = {
      username = "saghen";
      homeDirectory = "/home/${config.home.username}";
      stateVersion = "24.05";
      sessionPath = [ "$HOME/.local/bin" ];
      sessionVariables = { FLAKE = "$HOME/code/personal/nixfiles"; };
      language.base = "en_CA.UTF-8";
    };
  };
}
