{
  description = "Minimal NixOS configuration for bootstrapping systems";

  inputs = {
    #nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/release-24.05";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    # Declarative partitioning and formatting
    disko.url = "github:nix-community/disko";
	sops-nix = {
	  url = "github:mic92/sops-nix";
	  inputs.nixpkgs.follows = "nixpkgs";
	};
    	secrets = {
	  url = "git+ssh://git@codeberg.org/osmo1/.secrets.git?ref=main&shallow=1";
	  flake = false;
	};
  };

  outputs =
    { self, nixpkgs, nixpkgs-unstable, sops-nix, secrets, ... }@inputs:
    let
      inherit (self) outputs;
      inherit (nixpkgs) lib;
      configVars = import ../mods/vars.nix { inherit inputs lib; };
      configLib = import ../mods/lib.nix { inherit lib; };
      minimalConfigVars = lib.recursiveUpdate configVars { isMinimal = true; };
      minimalSpecialArgs = {
        inherit inputs outputs configLib;
        configVars = minimalConfigVars;
      };

      # FIXME: Specify arch eventually probably
      # This mkHost is way better: https://github.com/linyinfeng/dotfiles/blob/8785bdb188504cfda3daae9c3f70a6935e35c4df/flake/hosts.nix#L358
      newConfig =
        hostname: disks: disk: tpm:
        (nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = minimalSpecialArgs;
          modules = [
            inputs.disko.nixosModules.disko	
	    inputs.sops-nix.nixosModules.sops
	    {
			disko.devices.disk.main.device = "${disk}";
		}
            (if disks == "custom" then configLib.relativeToRoot "hosts/${hostname}/disko.nix" else configLib.relativeToRoot "common/optional/disks/${disks}.nix")

            ./minimal-configuration.nix
	    { networking.hostName = hostname; }
            (configLib.relativeToRoot "hosts/${hostname}/hardware-configuration.nix")
	    (if tpm == true then configLib.relativeToRoot "common/optional/tpm.nix" else "")
          ];
        });
    in
    {
      nixosConfigurations = {
        # host = newConfig "hostname"
        # Swap size is in GiB
	lixos = newConfig "lixos" "1-luks-btrfs" "/dev/nvme0n1" true;
	cbt = newConfig "cbt" "1-luks-btrfs" "/dev/vda" true;
        serveri = newConfig "serveri";
        oraakeli = newConfig "oraakeli";
        testeri = newConfig "testeri";
        testeri2 = newConfig "testeri2";
	klusteri-0 = newConfig "klusteri-0" "1-luks-btrfs";
	klusteri-1 = newConfig "klusteri-1" "1-luks-btrfs";

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
