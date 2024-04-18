{ inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./base
    ./modules/sunshine.nix
  ];

  networking.hostName = "liam-desktop";
  system.stateVersion = "24.05";

  nix.settings = {
    # Enable flakes and new 'nix' command
    experimental-features = "nix-command flakes";
    # Deduplicate and optimize nix store
    auto-optimise-store = true;
  };

  nixpkgs = {
    overlays = [ inputs.nvidia-patch.overlays.default ];
    config = {
      allowUnfree = true;
    };
  };

  users.users = {
    saghen = {
      # TODO: You can set an initial password for your user.
      # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
      # Be sure to change it (using passwd) after rebooting!
      initialPassword = "correcthorsebatterystaple";
      isNormalUser = true;
      extraGroups = ["wheel" "docker"];
    };
  };

  # enable alongside home-manager for completions
  programs.fish.enable = true; 
}

