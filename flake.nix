{

    description = "Server Flake";

    inputs = {
        nixpkgs.url = "nixpkgs/nixos-24.05";
        nixpkgs-23-11.url = "nixpkgs/nixos-23.11";
        nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

	nur.url = "github:nix-community/NUR";

	nixos-hardware.url = "github:NixOS/nixos-hardware/master";

	nixos-06cb-009a-fingerprint-sensor = {
            url = "github:ahbnr/nixos-06cb-009a-fingerprint-sensor";
            inputs.nixpkgs.follows = "nixpkgs-23-11";
        };

        home-manager.url = "github:nix-community/home-manager/release-24.05";
        home-manager.inputs.nixpkgs.follows = "nixpkgs";

        plasma-manager = {
            url = "github:nix-community/plasma-manager";
            inputs.nixpkgs.follows = "nixpkgs";
      	    inputs.home-manager.follows = "home-manager";
        };

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
            url = "github:nix-community/nixvim/nixos-24.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };
    };


    outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, ... } @ inputs: 
      let
	  inherit (self) outputs;
          inherit (nixpkgs) lib;
	  configLib = import ./lib { inherit lib; };
	  nixosModules = import ./modules/nixos;
      in {
      nixosConfigurations = {
          /*none =	
          let
              system = "x86_64-linux";
              pkgs = nixpkgs.legacyPackages.${system};
              #pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
          in 
          lib.nixosSystem {
              inherit system;
              #inherit specialArgs;
              modules = [
                  inputs.disko.nixosModules.default
                  (import ./hosts/none/disko.nix)

                  inputs.impermanence.nixosModules.impermanence

                  ./hosts/none/configuration.nix 
                  inputs.nixvim.nixosModules.nixvim
              ];
          };*/
          lixos =	
          let
              system = "x86_64-linux";
              pkgs = nixpkgs.legacyPackages.${system};
	      pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
	      specialArgs = { inherit pkgs pkgs-unstable inputs outputs configLib; };
          in 
          lib.nixosSystem {
              inherit system;
	      inherit specialArgs;
              modules = [
                  #inputs.disko.nixosModules.default
                  #(import ./hosts/lixos/disko.nix)
		  inputs.nur.nixosModules.nur
		  inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t470s
		  inputs.nixos-06cb-009a-fingerprint-sensor.nixosModules.open-fprintd
                  inputs.nixos-06cb-009a-fingerprint-sensor.nixosModules.python-validity

		  home-manager.nixosModules.home-manager{
			home-manager.extraSpecialArgs = specialArgs;
          	  }

		  inputs.plasma-manager.homeManagerModules.plasma-manager

                  #inputs.impermanence.nixosModules.impermanence

                  ./hosts/lixos
                  inputs.nixvim.nixosModules.nixvim
              ];
          };
    /* nixpi = 
        let
            system = "aarch64-linux";
            pkgs = nixpkgs.legacyPackages.${system};
            pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
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
        }; */
    }; 

      #homeConfigurations = {
      #   osmo = home-manager.lib.homeManagerConfiguration {
      #     inherit pkgs;
      #     modules = [ ./home.nix ];
      #   };
      #};
    };
}
