{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.hostSpec = {
    # Data variables that don't dictate configuration settings
    username = lib.mkOption {
      type = lib.types.str;
      description = "The username of the host";
    };
    hostName = lib.mkOption {
      type = lib.types.str;
      description = "The hostname of the host";
    };
    email = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      description = "The email of the user";
    };
    work = lib.mkOption {
      default = { };
      type = lib.types.attrsOf lib.types.anything;
      description = "An attribute set of work-related information if isWork is true";
    };
    domain = lib.mkOption {
      type = lib.types.str;
      description = "The domain of the host";
    };
    userFullName = lib.mkOption {
      type = lib.types.str;
      description = "The full name of the user";
    };
    handle = lib.mkOption {
      type = lib.types.str;
      description = "The handle of the user (eg: github user)";
    };
    home = lib.mkOption {
      type = lib.types.str;
      description = "The home directory of the user";
      default =
        let
          user = config.hostSpec.username;
        in
        if pkgs.stdenv.isLinux then "/home/${user}" else "/Users/${user}";
    };
    persistFolder = lib.mkOption {
      type = lib.types.str;
      description = "The folder to persist data if impermenance is enabled";
      default = "";
    };
    sshKeys = lib.mkOption {
      type = lib.types.list;
      default = null;
      description = "What ssh keys the host should have in .ssh";
    };

    # Configuration Settings
    isMinimal = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Used to indicate a minimal host";
    };
    isLaptop = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Used to indicate a laptop host";
    };
    isServer = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Used to indicate a server host";
    };
    isWork = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Used to indicate a host that uses work resources";
    };

    /*
      useNeovimTerminal = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Used to indicate a host that uses neovim for terminals";
      };
    */
    style = lib.mkOption {
      type = lib.types.str;
      default = "Classic";
      description = "Used to indicate what theme a desktop uses";
    };
    theme = lib.mkOption {
      type = lib.types.enum [
        "Tokyo Night"
        "Kanagawa"
      ];
      default = "Tokyo Night";
      description = "Used to indicate what color theme a desktop uses";
    };
    wallpaper = lib.mkOption {
      type = lib.types.str;
      default = "stolen/nixos-tokyo.png";
      description = "Used to indicate what wallpaper a desktop uses";
    };
  };

  config = {
    assertions =
      let
        # We import these options to HM and NixOS, so need to not fail on HM
        isImpermanent =
          config ? "system" && config.system ? "impermanence" && config.system.impermanence.enable;
      in
      [
        {
          assertion =
            !config.hostSpec.isWork || (config.hostSpec.isWork && !builtins.isNull config.hostSpec.work);
          message = "isWork is true but no work attribute set is provided";
        }
        {
          assertion = !isImpermanent || (isImpermanent && !("${config.hostSpec.persistFolder}" == ""));
          message = "config.system.impermanence.enable is true but no persistFolder path is provided";
        }
        {
          assertion = !config.services.desktopManager.plasma6.enable || config.hostSpec.style == "Classic";
          message = "The classic theme is only available on Plasma and Gnome";
        }
      ];
  };
}
