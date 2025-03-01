{
  description = "My all purpose flake";

  inputs = {
    # Nixpkgs and home-manager
    nixpkgs.url = "nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";

    nur.url = "github:nix-community/NUR";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
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
    dwl-patches = {
      url = "git+ssh://git@github.com/osmo1/dwl-patches.git?ref=main&shallow=1";
      flake = false;
    };

    # Apps and modules
    stylix = {
      url = "github:danth/stylix/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim/nixos-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixcord = {
      url = "github:kaylorben/nixcord";
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
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # This is for 5800x3d but as I undestood it, it should work for any am4 x3d chips
    ryzen-undervolt = {
      url = "github:svenlange2/Ryzen-5800x3d-linux-undervolting/0f05965f9939259c27a428065fda5a6c0cbb9225";
      flake = false;
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
          pkgs = inputs.nixpkgs.legacyPackages.${system};
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
        # TODO: I have great plans for this including themes but don't yet know how
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
            (import ./common/optional/disks/4-luks-btrfs.nix)
            {
              disko.devices.disk.main.device = "/dev/nvme0n1";
              disko.devices.disk.secondary.device = "/dev/sda";
              disko.devices.disk.aertiary.device = "/dev/sdb";
              disko.devices.disk.mini.device = "/dev/mmcblk0";
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
        klusteri-2 = lib.nixosSystem {
          inherit specialArgs;
          modules = [
            home-manager.nixosModules.home-manager
            { home-manager.extraSpecialArgs = specialArgs; }
            inputs.disko.nixosModules.default
            (import ./common/optional/disks/2-luks-btrfs.nix)
            {
              disko.devices.disk.main.device = "/dev/nvme0n1";
              disko.devices.disk.secondary.device = "/dev/sda1";
            }
            inputs.impermanence.nixosModules.default
            ./hosts/klusteri-2
          ];
        };
      };
    };
}
