{
  description = "Minimal NixOS configuration for bootstrapping systems";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-25.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    disko.url = "github:nix-community/disko";
  };

  outputs =
    {
      self,
      nixpkgs,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      #inherit (nixpkgs) lib;
      lib = nixpkgs.lib.extend (
        self: super: { custom = import ../mods/lib.nix { inherit (nixpkgs) lib; }; }
      );
      configVars = import ../mods/vars.nix { inherit inputs lib; };
      minimalConfigVars = lib.recursiveUpdate configVars { isMinimal = true; };
      minimalSpecialArgs = {
        inherit inputs outputs lib;
        configVars = minimalConfigVars;
      };

      newConfig =
        hostname: disko: disks: tpm: nbde: grub: yubi:
        (nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = minimalSpecialArgs;
          modules =
            [
              inputs.disko.nixosModules.disko
              {
                disko.devices = disks;
              }

              (lib.custom.relativeToRoot "common/optional/disks/${disko}.nix")
              (
                if grub == true then
                  lib.custom.relativeToRoot "common/optional/grub.nix"
                else
                  lib.custom.relativeToRoot "common/optional/systemd-boot.nix"
              )

              ./minimal-configuration.nix
              (lib.custom.relativeToRoot "hosts/${hostname}/hardware-configuration.nix")
              { networking.hostName = hostname; }
            ]
            ++ (if tpm == true then [ (lib.custom.relativeToRoot "common/optional/tpm.nix") ] else [ ])
            ++ (if nbde == true then [ (lib.custom.relativeToRoot "common/optional/nbde.nix") ] else [ ])
            ++ (
              if yubi == true then [ (lib.custom.relativeToRoot "common/optional/yubikey-boot.nix") ] else [ ]
            );
        });
    in
    {
      nixosConfigurations = {
        # host     = newConfig "hostname"   "disko file name" "disks"                             tpm   nbde  grub yubi
        masiina = newConfig "masiina" "2-btrfs" [ "sda" "nvme0n1" ] false false true false;
        lixos = newConfig "lixos" "1-luks-btrfs" {
          disk.main.device = "/dev/nvme0n1";
        } false false true false;
        cbt = newConfig "cbt" "1-luks-btrfs" [ "vda" ] true false true false;
        serveri = newConfig "serveri" "4-luks-btrfs" {
          disk.main.device = "/dev/nvme0n1";
          disk.secondary.device = "/dev/sda";
          disk.aertiary.device = "/dev/sdb";
          disk.mini.device = "/dev/mmcblk0";
        } false true false false;
        klusteri-0 = newConfig "klusteri-0" "1-luks-btrfs" [ "nvme0n1" ] true false false false;
        klusteri-1 = newConfig "klusteri-1" "1-luks-btrfs" [ "nvme0n1" ] true false false false;
        klusteri-2 = newConfig "klusteri-2" "2-luks-btrfs" {
          disk.main.device = "/dev/nvme0n1";
          disk.secondary.device = "/dev/sda";
        } true false false false;
        oraakeli = newConfig "oraakeli" "1-luks-btrfs" false false false true false;

        # Custom ISO
        #
        # `just iso` - from nix-config directory to generate the iso standalone
        # 'just iso-install <drive>` - from nix-config directory to generate and copy directly to USB drive
        # `nix build ./nixos-installer#nixosConfigurations.iso.config.system.build.isoImage` - from nix-config directory to generate the iso manually
        #
        # Generated images will be output to the ~/nix-config/results directory unless drive is specified
        iso = nixpkgs.lib.nixosSystem {
          specialArgs = minimalSpecialArgs;
          modules = [
            "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
            "${nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
            ./iso
          ];
        };
      };
    };
}
