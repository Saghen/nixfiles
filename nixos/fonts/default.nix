{ pkgs, ... }:

{
  fonts = {
    enableDefaultPackages = true;
    # fontDir.enable = true;
    packages = with pkgs; [
      (nerdfonts.override { fonts = [ "FiraCode" ]; })
      noto-fonts-emoji
      cantarell-fonts

      (callPackage ./feather { })
      (callPackage ./iosevka-nerd { })
      (callPackage ./operator-nerd { })
    ];
  };
}
