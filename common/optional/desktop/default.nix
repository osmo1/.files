{ configLib, ... }:
{
  imports = (configLib.scanPaths ./.);
}