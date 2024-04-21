{ config, ... }:

{
  services.flameshot = {
    enable = true;

    settings = {
      General = {
        uiColor = "#1c6ecf";
        contrastOpacity = 90;
        contrastUiColor = "#000e32";
        drawColor = "#0000ff";
        saveAfterCopy = true;
        savePath = "/home/${config.home.username}/pictures/screenshots";
        showHelp = false;
      };
    };
  };
}
