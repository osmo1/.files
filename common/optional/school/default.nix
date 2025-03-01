{ configLib, ... }:
{
  #TODO: Wow! Isn't my school conf huge
  imports = (configLib.scanPaths ./.);
}
