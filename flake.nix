{

    description = "My all purpose flake";

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
	sops-nix = {
	  url = "github:mic92/sops-nix";
	  inputs.nixpkgs.follows = "nixpkgs";
	};
    	secrets = {
	  url = "git+ssh://git@codeberg.org/osmo1/.secrets.git?ref=main&shallow=1";
	  flake = false;
	};
    };


    outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, sops-nix, secrets, ... } @ inputs:
      let
	    inherit (self) outputs;
        inherit (nixpkgs) lib;
        configLib = import ./lib { inherit lib; };
        nixosModules = import ./modules/nixos;
      in {
      nixosConfigurations = {
        # Desktops
          /*none =
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
                ./hosts/none
                #inputs.disko.nixosModules.default
                #(import ./hosts/none/disko.nix)
                #inputs.impermanence.nixosModules.impermanence

                inputs.nur.nixosModules.nur
                inputs.nixvim.nixosModules.nixvim

                home-manager.nixosModules.home-manager{
                    home-manager.extraSpecialArgs = specialArgs;
                    home-manager.sharedModules = [ inputs.plasma-manager.homeManagerModules.plasma-manager ];
                }
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
                ./hosts/lixos
                #inputs.disko.nixosModules.default
                #(import ./hosts/lixos/disko.nix)
                #inputs.impermanence.nixosModules.impermanence

                inputs.nur.nixosModules.nur
                inputs.nixvim.nixosModules.nixvim

                home-manager.nixosModules.home-manager{
                    home-manager.extraSpecialArgs = specialArgs;
                    home-manager.sharedModules = [ inputs.plasma-manager.homeManagerModules.plasma-manager ];
                }

                inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t470s
                inputs.nixos-06cb-009a-fingerprint-sensor.nixosModules.open-fprintd
                inputs.nixos-06cb-009a-fingerprint-sensor.nixosModules.python-validity
              ];
          };
          # Servers
          serveri =
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
                ./hosts/serveri

                inputs.disko.nixosModules.default
                (import ./hosts/serveri/disko.nix)
                inputs.impermanence.nixosModules.impermanence


                inputs.nur.nixosModules.nur
                inputs.nixvim.nixosModules.nixvim
            ];
        };

	testeri =
          let
            system = "x86_64-linux";
            pkgs = nixpkgs.legacyPackages.${system};
	        pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
	        specialArgs = { inherit pkgs pkgs-unstable inputs outputs configLib secrets; };
          in
          lib.nixosSystem {
            inherit system;
	        inherit specialArgs;
            modules = [
                ./hosts/testeri

                inputs.disko.nixosModules.default 
		{
			disko.devices.disk.main.device = "/dev/vda";
			disko.devices.disk.secondary.device = "/dev/vdb";
		}
                (import ./hosts/testeri/disko.nix)
                inputs.impermanence.nixosModules.impermanence

                inputs.nur.nixosModules.nur
                inputs.nixvim.nixosModules.nixvim
            ];
        };

        };
    };
}
