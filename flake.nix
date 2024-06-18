{

    description = "Server Flake";

    inputs = {
        nixpkgs.url = "nixpkgs/nixos-23.11";
        nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

        home-manager.url = "github:nix-community/home-manager/release-23.11";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";

        nixos-wsl = {
            url = "github:nix-community/NixOS-WSL";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        disko = {
            url = "github:nix-community/disko";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        impermanence = {
            url = "github:nix-community/impermanence";
        };

        nixvim = {
            url = "github:nix-community/nixvim/nixos-23.11";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };


    outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... } @ inputs: 
      let
          lib = nixpkgs.lib;
      in {
      nixosConfigurations = {
          none =	
          let
              system = "x86_64-linux";
              pkgs = nixpkgs.legacyPackages.${system};
              pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
          in 
          nixpkgs.lib.nixosSystem {
              inherit system;
              specialArgs = {
                  inherit inputs;
                  inherit pkgs-unstable;
              };
              modules = [
                  inputs.disko.nixosModules.default
                  (import ./hosts/none/disko.nix)

                  inputs.impermanence.nixosModules.impermanence

                  ./hosts/none/configuration.nix 
                  inputs.nixvim.nixosModules.nixvim
              ];
          };
          lixos =	
          let
              system = "x86_64-linux";
              pkgs = nixpkgs.legacyPackages.${system};
              pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
          in 
          nixpkgs.lib.nixosSystem {
              inherit system;
              specialArgs = {
                  inherit inputs;
                  inherit pkgs-unstable;
              };
              modules = [
                  inputs.disko.nixosModules.default
                  (import ./hosts/lixos/disko.nix)

                  inputs.impermanence.nixosModules.impermanence

                  ./hosts/lixos/configuration.nix 
                  inputs.nixvim.nixosModules.nixvim
              ];
          };
    /* nixpi = 
        let
            system = "aarch64-linux";
            pkgs = nixpkgs.legacyPackages.${system};
            pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
        in
        nixpkgs.lib.nixosSystem {
            inherit system;
            specialArgs = {
                inherit inputs;
                inherit pkgs-unstable;
            };
            modules = [
              inputs.disko.nixosModules.default
              (import ./hosts/nixpi/disko.nix)

              inputs.impermanence.nixosModules.impermanence

              ./hosts/nixpi/configuration.nix 
              inputs.nixvim.nixosModules.nixvim
            ];
        };
    }; */

      #homeConfigurations = {
      #   osmo = home-manager.lib.homeManagerConfiguration {
      #     inherit pkgs;
      #     modules = [ ./home.nix ];
      #   };
      #};
    };
}