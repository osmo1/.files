{ config, lib, pkgs, ... }: {
#imports = [] ++ (if config.hostSpec.isServer == false then lib.flatten [ ../../common/optional/desktop/${config.hostSpec.desktop} ] else []);
#imports = [] ++ (if config.hostSpec.isServer == false then lib.flatten [ ../../common/optional/school/packages.nix ] else []);
}
