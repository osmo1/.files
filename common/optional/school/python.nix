{ pkgs, ... }:
{
  environment.systemPackages = with pkgs.stable; [
    python3
  ];
}
