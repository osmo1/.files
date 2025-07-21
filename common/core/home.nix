{
  inputs,
  outputs,
  lib,
  ...
}:
{
  home-manager.users.osmo = {
    home.stateVersion = "24.05";
    home.sessionVariables = {
      XDG_RUNTIME_DIR = "/run/user/$UID";
    };
  };

  home-manager.extraSpecialArgs = {
    inherit inputs outputs;
    plasma-manager = inputs.plasma-manager;
    lib = (lib.extend (_: _: inputs.home-manager.lib));
  };

  home-manager.backupFileExtension = "bk";
}
