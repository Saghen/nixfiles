{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix.url = "github:Mic92/sops-nix";

    hardware.url = "github:nixos/nixos-hardware";
    nvidia-patch = {
      url = "github:icewind1991/nvidia-patch-nixos";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix.url = "github:the-argus/spicetify-nix";
    limbo = {
      url = "github:saghen/limbo";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # rust toolchain
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, home-manager, sops-nix, hardware, ... }: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./nixos/configuration.nix

          sops-nix.nixosModules.sops

          hardware.nixosModules.common-gpu-nvidia-nonprime
          hardware.nixosModules.common-pc-ssd

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useUserPackages = true;
              useGlobalPkgs = true;
              extraSpecialArgs = {
                inherit (inputs) spicetify-nix;
                inherit (inputs) fenix;
                inherit (inputs) limbo;
              };
              sharedModules = [ sops-nix.homeManagerModules.sops ];
              users.saghen = import ./home-manager/home.nix;
            };
          }
        ];
        specialArgs = { inherit inputs; };
      };
    };
  };
}
