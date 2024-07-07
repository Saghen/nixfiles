# TODO: rename since we include general info such as monitors
# A theme format for use in desktop applications and editors
{ lib, config, pkgs, ... }:
let
  colour = lib.mkOptionType {
    name = "colour";
    description = "hex colour";
    check = s:
      lib.types.str.check s && builtins.match "#[0-9a-fA-F]{6}" s != null;
  };

  mkColourOption = name: default:
    (lib.mkOption {
      type = colour;
      description = "The colour value for the name '${name}'.";
      inherit default;
    });
in {
  options.monitors = lib.mkOption {
    type = lib.types.listOf lib.types.str;
    description = "List of monitor names";
    default = [ "DP-1" "DP-2" ];
  };
  # slightly modified catppuccin theme
  options.colors = builtins.mapAttrs mkColourOption rec {
    crust = "#11111b";
    mantle = "#181825";
    base = "#1e1e2e";
    core = "#2c2c3f";

    surface-0 = "#313244";
    surface-1 = "#45475a";
    surface-2 = "#585b70";

    overlay-0 = "#6c7086";
    overlay-1 = "#7f849c";
    overlay-2 = "#9399b2";

    subtext-0 = "#a6adc8";
    subtext-1 = "#bac2de";
    subtext-2 = "#cdd6f4";
    text = "#f0f4ff";

    primary = blue;
    primary-dark = blue-dark;

    lavender = "#b4befe";
    lavender-dark = "#7f8cfe";

    # blue = "#89b4fa";
    blue = "#a4b9ef"; # not the official blue
    blue-dark = "#5f8cfb";

    sapphire = "#74c7ec";
    sapphire-dark = "#4a9edc";

    sky = "#89dceb";
    sky-dark = "#5f9edc";

    teal = "#94e2d5";
    teal-dark = "#5fb9a8";

    green = "#a6e3a1";
    green-dark = "#5fbf6b";

    yellow = "#f9e2af";
    yellow-dark = "#f5c77b";

    peach = "#fab387";
    peach-dark = "#f5a87b";

    maroon = "#eba0ac";
    maroon-dark = "#c97b84";

    red = "#f38ba8";
    red-dark = "#c97b84";

    mauve = "#cba6f7";
    mauve-dark = "#a17be3";

    pink = "#f5c2e7";

    flamingo = "#f2cdcd";

    rosewater = "#f5e0dc";

    cyan = "#bee4ed";
  };
}
