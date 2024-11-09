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
    # Cardano IOG cache
    trusted-substituters =
      [ "https://cache.iog.io" "https://devenv.cachix.org" ];
    trusted-public-keys = [
      "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
    ];
    trusted-users = [ "root" "saghen" ];
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

  # Trim SSD (https://kokada.capivaras.dev/blog/an-unordered-list-of-hidden-gems-inside-nixos/)
  services.fstrim.enable = true;
  boot.initrd.luks.devices."luks-1f9e8a13-0706-49fa-b0d3-ef7cdfd17c16".allowDiscards =
    true;
  boot.initrd.luks.devices."luks-b003795a-f145-4b70-8bdb-79817697732b".allowDiscards =
    true;

  # Fish
  users.defaultUserShell = pkgs.fish;
  programs.fish.enable = true;
  programs.fish.useBabelfish = true;
  programs.command-not-found.enable = false;
  # Fish enables this by default for autocomplete but it adds +15s to build
  documentation.man.generateCaches = false;
}

