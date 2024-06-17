{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hardware.url = "github:nixos/nixos-hardware";
    nvidia-patch = {
      url = "github:icewind1991/nvidia-patch-nixos";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix.url = "github:the-argus/spicetify-nix";
    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # rust toolchain
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, home-manager, hardware, spicetify-nix
    , neovim-nightly, nvidia-patch, nix-index-database, fenix, ... }: {
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./nixos/configuration.nix
            hardware.nixosModules.common-gpu-nvidia-nonprime
            hardware.nixosModules.common-pc-ssd

            # provides an index of the nix packages so that things like command-not-found
            # can query the index to find the package that provides a command
            nix-index-database.nixosModules.nix-index
            { programs.command-not-found.enable = false; }

            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useUserPackages = true;
                useGlobalPkgs = true;
                extraSpecialArgs = {
                  inherit spicetify-nix;
                  inherit fenix;
                };
                users.saghen = import ./home-manager/home.nix;
              };
            }
          ];
          specialArgs = { inherit inputs; };
        };
      };
    };
}
