{ ... }:

{
  imports = [
    ./bspwm.nix
    ./sxhkd.nix
    ./services/dunst.nix
    ./services/flameshot.nix
    ./polybar
  ];
}
