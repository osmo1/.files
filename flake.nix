{
  description = "My all purpose flake";

  inputs = {
    # Nixpkgs and home-manager
    nixpkgs.url = "nixpkgs/nixos-24.05";
    nixpkgs-23-11.url = "nixpkgs/nixos-23.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    nur.url = "github:nix-community/NUR";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Common tools
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence = {
      url = "github:nix-community/impermanence";
    };

    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Personal repos
    secrets = {
      url = "git+ssh://git@codeberg.org/osmo1/.secrets.git?ref=main&shallow=1";
      flake = false;
    };
    wallpapers = {
      url = "git+ssh://git@github.com/osmo1/.wallpapers.git?ref=main&shallow=1";
      flake = false;
    };

    # Apps and modules
    nixvim = {
      url = "github:nix-community/nixvim/nixos-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    nix-gaming = {
        url = "github:fufexan/nix-gaming";
        inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
      ];
      inherit (nixpkgs) lib;
      configVars = import ./mods/vars.nix { inherit inputs lib; };
      configLib = import ./mods/lib.nix { inherit lib; };
      specialArgs = {
        inherit
          inputs
          outputs
          configVars
          configLib
          nixpkgs
          ;
      };
    in
    {
      # Custom modules to enable special functionality for nixos or home-manager oriented configs.
      #nixosModules = { inherit (import ./modules/nixos); };
      #homeManagerModules = { inherit (import ./modules/home-manager); };
      nixosModules = import ./modules/nixos;
      homeManagerModules = import ./modules/home-manager;
      containerModules = import ./modules/containers;

      # Custom modifications/overrides to upstream packages.
      overlays = import ./mods/overlays.nix { inherit inputs outputs; };

      # Custom packages to be shared or upstreamed.
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        import ./pkgs { inherit pkgs; }
      );

      checks = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        import ./mods/checks.nix { inherit inputs system pkgs; }
      );

      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-rfc-style);

      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          checks = self.checks.${system};
        in
        import ./shell.nix { inherit checks pkgs; }
      );

      nixosConfigurations = {
        # Main
        masiina = lib.nixosSystem {
          inherit specialArgs;
          modules = [
            home-manager.nixosModules.home-manager
            { home-manager.extraSpecialArgs = specialArgs; }
            inputs.disko.nixosModules.default
            (import ./common/optional/disks/2-btrfs.nix)
            {
              disko.devices.disk.main.device = "/dev/sda";
              disko.devices.disk.secondary.device = "/dev/nvme0n1";
            }
            ./hosts/masiina
          ];
        };
        lixos = lib.nixosSystem {
          inherit specialArgs;
          modules = [
            home-manager.nixosModules.home-manager
            { home-manager.extraSpecialArgs = specialArgs; }
            inputs.disko.nixosModules.default
            (import ./common/optional/disks/1-luks-btrfs.nix)
            { disko.devices.disk.main.device = "/dev/nvme0n1"; }
	    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-e495
	    inputs.impermanence.nixosModules.default
            ./hosts/lixos
          ];
        };

        cbt = lib.nixosSystem {
          inherit specialArgs;
          modules = [
            home-manager.nixosModules.home-manager
            { home-manager.extraSpecialArgs = specialArgs; }
            inputs.disko.nixosModules.default
            (import ./common/optional/disks/1-luks-btrfs.nix)
            { disko.devices.disk.main.device = "/dev/vda"; }
            ./hosts/cbt
          ];
        };
        nix-wsl = lib.nixosSystem {
          inherit specialArgs;
          modules = [
            home-manager.nixosModules.home-manager
            { home-manager.extraSpecialArgs = specialArgs; }
            inputs.nixos-wsl.nixosModules.default
            ./hosts/nix-wsl
          ];
        };
        testeri = lib.nixosSystem {
          inherit specialArgs;
          modules = [
            home-manager.nixosModules.home-manager
            { home-manager.extraSpecialArgs = specialArgs; }
            inputs.disko.nixosModules.default
            (import ./common/optional/disks/2-luks-btrfs.nix)
            {
              disko.devices.disk.main.device = "/dev/vda";
              disko.devices.disk.secondary.device = "/dev/vdb";
            }
            ./hosts/testeri
          ];
        };

        # Servers
        serveri = lib.nixosSystem {
          inherit specialArgs;
          modules = [
            home-manager.nixosModules.home-manager
            { home-manager.extraSpecialArgs = specialArgs; }
            inputs.disko.nixosModules.default
            (import ./common/optional/disks/2+1-luks-btrfs.nix)
            {
              disko.devices.disk.main.device = "/dev/sda";
              disko.devices.disk.secondary.device = "/dev/hda";
              disko.devices.disk.mini.device = "/dev/emmc";
            }
	    inputs.impermanence.nixosModules.default
            ./hosts/serveri
          ];
        };
        klusteri-0 = lib.nixosSystem {
          inherit specialArgs;
          modules = [
            home-manager.nixosModules.home-manager
            { home-manager.extraSpecialArgs = specialArgs; }
            inputs.disko.nixosModules.default
            (import ./common/optional/disks/1-luks-btrfs.nix)
            { disko.devices.disk.main.device = "/dev/nvme0n1"; }
	    inputs.impermanence.nixosModules.default
            ./hosts/klusteri-0
          ];
        };
        klusteri-1 = lib.nixosSystem {
          inherit specialArgs;
          modules = [
            home-manager.nixosModules.home-manager
            { home-manager.extraSpecialArgs = specialArgs; }
            inputs.disko.nixosModules.default
            (import ./common/optional/disks/1-luks-btrfs.nix)
            { disko.devices.disk.main.device = "/dev/nvme0n1"; }
	    inputs.impermanence.nixosModules.default
            ./hosts/klusteri-1
          ];
        };
      };
    };
}
