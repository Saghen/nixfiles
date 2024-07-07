{ inputs, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ./base ./fonts ];

  system.stateVersion = "24.05";

  networking.hostName = "nixos";
  networking.hostId = "968d12a1";

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  nix.settings = {
    # Enable flakes and new 'nix' command
    experimental-features = "nix-command flakes";
    # Deduplicate and optimize nix store
    auto-optimise-store = true;
    # Some old nix commands don't use XDG dirs, this forces it
    use-xdg-base-directories = true;
  };

  nixpkgs = {
    overlays =
      [ inputs.nvidia-patch.overlays.default inputs.fenix.overlays.default ];
    config.allowUnfree = true;
  };

  users.users = {
    saghen = {
      isNormalUser = true;
      extraGroups = [ "wheel" "docker" "networkmanager" ];
    };
  };

  # Fish
  users.defaultUserShell = pkgs.fish;
  programs.fish.enable = true;
  programs.fish.useBabelfish = true;
  programs.command-not-found.enable = false;
  # Fish enables this by default for autocomplete but it adds +15s to build
  documentation.man.generateCaches = false;
}

