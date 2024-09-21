# My all purpose NixOS flake
 - Single user
 - Multi DE / WM
 - Multi theme
 - Integrated sops-nix secrets
 - Custom easily configurable container services
 - Easily adaptable to different server and desktop uses
 - As modular as possible
 - "Easy to install"

# Installation
As this flake has secrets, you will need to make your own secrets repo and configure your secrets if you want to use this flake as is.
## Local install
TODO
## Remote install
TODO

# TODO
## Global
 - [ ] Installation instructions
 - [ ] Disko configuration to common/optional/disks
 - [ ] Boot into common/core
 - [ ] Theming
   - [ ] Global shell theming
   - [ ] Theme folders
     - [ ] Tokyo night
     - [ ] Kanagawa wave
 - [ ] Template host
 - [ ] Flake refactor 
    - [ ] Format similar to the minimal flake
    - [ ] ConfigVars and options such as DE and theme
    - [ ] No need to touch hosts/${host} except for exceptions
    - [ ] Template host
 - [ ] Backup using borgbackup
## Personal
 - [ ] Masiina ready
 - [ ] New host klusteri (K3s)
 - [ ] Serveri and oraakeli working
   - [ ] Import old containers
