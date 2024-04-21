{ inputs, pkgs, ... }:

{
  imports =
    [ ./hardware-configuration.nix ./base ./fonts ./modules/sunshine.nix ];

  system.stateVersion = "24.05";

  networking.hostName = "nixos";
  networking.hostId = "968d12a1";
  networking.networkmanager.enable = true; # Automatic networking confiugration
  services.resolved.enable = true; # DNS caching

  # Set your time zone.
  time.timeZone = "America/Toronto";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_CA.UTF-8";

  nix.settings = {
    # Enable flakes and new 'nix' command
    experimental-features = "nix-command flakes";
    # Deduplicate and optimize nix store
    auto-optimise-store = true;
  };

  nixpkgs = {
    overlays = [
      inputs.neovim-nightly-overlay.overlay
      inputs.nvidia-patch.overlays.default
    ];
    config = { allowUnfree = true; };
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
}

