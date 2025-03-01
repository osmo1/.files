{
    inputs, 
    outputs,
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
  };

  home-manager.backupFileExtension = "bk";
}
