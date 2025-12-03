{ pkgs, ... }:
{
  users.users.osmo.packages = with pkgs.stable; [
    # rustc
    gcc14
    rust-bin.stable.latest.default
  ];
}
