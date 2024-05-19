# https://github.com/the-argus/spicetify-nix
{ pkgs, spicetify-nix, ... }:
let spicePkgs = spicetify-nix.packages.${pkgs.system}.default;
in {
  imports = [ spicetify-nix.homeManagerModule ];

  programs.spicetify = {
    enable = true;
    # gives a warning on first setup, but it seems to be fine and avoids
    # an issue with windowManagerPatch = true where the desktop entry doesn't exist
    # https://github.com/the-argus/spicetify-nix/issues/10
    spotifyPackage = pkgs.spotifywm;
    theme = spicePkgs.themes.catppuccin;
    colorScheme = "mocha";

    enabledExtensions = with spicePkgs.extensions; [ hidePodcasts bookmark ];
  };
}
