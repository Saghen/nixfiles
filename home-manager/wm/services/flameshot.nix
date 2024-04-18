{ pkgs, ... }:

{
  services.flameshot = {
    enable = true;

    settings = {
      general = {
        uiColor = "#1c6ecf";
        contrastOpacity = 90;
        contrastUiColor = "#000e32";
        drawColor = "#0000ff";
        saveAfterCopy = true;
        savePath = "$HOME/pictures/screenshots";
        showHelp = false;
      };
    };
  };
}
