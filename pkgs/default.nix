{
  pkgs ? import <nixpkgs> { },
}:
rec {
  daisy = pkgs.callPackage ./daisy { };
  sddm-tokyonight = pkgs.callPackage ./sddm-tokyonight { };
  tokyo-night-icons = pkgs.callPackage ./tokyo-night-icons { };
}
