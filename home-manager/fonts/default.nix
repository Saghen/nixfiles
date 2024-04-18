{ pkgs, ... }:

 {
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    (nerdfonts.override {
      fonts = [ "FiraCode" ];
    })
    noto-fonts-emoji

    ( pkgs.callPackage ./feather {} )
    ( pkgs.callPackage ./iosevka-nerd {} )
    ( pkgs.callPackage ./operator-nerd {} )
  ];
}
