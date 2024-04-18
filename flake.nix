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
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = inputs@{ nixpkgs, home-manager, hardware, spicetify-nix, neovim-nightly-overlay, nvidia-patch, ... }: {
    nixosConfigurations = {
      gigachad = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./nixos/configuration.nix
          hardware.nixosModules.common-gpu-nvidia-nonprime
          hardware.nixosModules.common-pc-ssd
        ];
        specialArgs = { inherit inputs; };
      };
    };

    homeConfigurations = {
      saghen = home-manager.lib.homeManagerConfiguration {
        modules = [ ./home-manager/home.nix ];
        extraSpecialArgs = { inherit spicetify-nix; };
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config.allowUnfree = true;
          overlays = [ neovim-nightly-overlay.overlay ];
        };
      };
    };
  };
}
