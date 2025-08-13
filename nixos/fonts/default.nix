{ pkgs, ... }:
{
  fonts = {
    enableDefaultPackages = true;
    # fontDir.enable = true;
    packages = with pkgs; [
      nerd-fonts.fira-code
      noto-fonts-emoji
      cantarell-fonts

      (callPackage ./feather { })
      (callPackage ./iosevka-nerd { })
      (callPackage ./operator-nerd { })
    ];
  };
}
