# This repository has been migrated to [Codeberg](https://codeberg.org/osmo1/.files). 
<div align="center">
  <img alt="Nix snowflake" src="assets/nix-snowflake-tokyo-night.svg" width="100px"/>
  <h1>.files</h1>
  <h3>My personal NixOS configuration for desktops and servers</h3>
</div>

## My all purpose NixOS flake
 - Single user
 - Multi DE / WM
 - Multi theme
 - Integrated sops-nix secrets
 - Custom easily configurable container services
 - Easily adaptable to different server and desktop uses
 - As modular as possible

## Installation
There is a provided installation script mostly copied from [EmergentMind's configuration](https://github.com/EmergentMind/nix-config).
```
Remotely installs NixOS on a target machine using these .files.
USAGE: -n <target_hostname> -d <target_destination> -k <ssh_key> [OPTIONS]
ARGS:
  -n <target_hostname>      specify target_hostname of the target host to deploy the nixos config on.
  -d <target_destination>   specify ip or url to the target host.
  -k <ssh_key>              specify the full path to the ssh_key you'll use for remote access to the
                            target during install process.
                            Example: -k /home/${target_user}/.ssh/my_ssh_key
OPTIONS:
  -u <target_user>          specify target_user with sudo access. .files will be cloned to their home.
                            Default='${target_user}'.
  --port <ssh_port>         specify the ssh port to use for remote access. Default=${ssh_port}.
  --impermanence            Use this flag if the target machine has impermanence enabled. WARNING: Assumes /persist path.
  --tpm                     Use this flag if the target machine has a tpm module and you want to use it.
  --nbde                    Use this flag if the target machine needs encryption over the network.
  --yubi                    Use this flag if the target machine needs encryption provided by yubikey.
  --debug                   Enable debug mode.
  -h | --help               Print this help.
```
This script is supposed to be run from a system already running this configuration, but should run on any system with nix installed with a little setup.
If you wish to use this script in your configuration, I would suggest checking out the original.

## Details and screenshots
### Desktop environments
#### Gnome
<img alt="Picture of a gnome desktop using a kanagawa colour scheme" src="assets/gnome_kangawa.png"/>
More coming soon

## Thanks
 - A lot of inspiration from [EmergentMind's config](https://github.com/EmergentMind/nix-config/)
 - [MyNixOS](https://mynixos.com/) for easy access to module definitions
 - Miscellaneous nixos discourses and github issues
