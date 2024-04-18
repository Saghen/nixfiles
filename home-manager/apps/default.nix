{ pkgs, ... }:

{
  imports = [
    ./firefox
    ./thunderbird
    ./spotify.nix
  ];
  config = {
    home.packages = with pkgs; [
      gnome.nautilus
      obsidian
      pavucontrol
    ];
  };
}
