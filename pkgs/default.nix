{
  pkgs ? import <nixpkgs> { },
}:
rec {
  zen-browser = pkgs.callPackage ./zen-browser { };
  daisy = pkgs.callPackage ./daisy { };
}
