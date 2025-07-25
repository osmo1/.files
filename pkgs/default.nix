{
  pkgs ? import <nixpkgs> { },
}:
rec {
  zen-browser = pkgs.callPackage ./zen-browser { };
  daisy = pkgs.callPackage ./daisy { };
  sddm-tokyonight = pkgs.callPackage ./sddm-tokyonight { };
  tokyo-night-icons = pkgs.callPackage ./tokyo-night-icons { };
}
