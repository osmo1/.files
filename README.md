# My all purpose NixOS flake
 - Single user
 - Multi DE / WM
 - Multi theme
 - Integrated sops-nix secrets
 - Custom easily configurable container services
 - Easily adaptable to different server and desktop uses
 - As modular as possible

# Installation
As this flake has secrets, you will need to make your own secrets repo and configure your secrets if you want to use this flake as is.
### Local install
TODO
### Remote install
TODO

# TODO
### Global
 - [ ] Installation instructions
 - [ ] Theming
   - [ ] Global shell theming
   - [ ] Theme ~folders~ options for stylix
     - [x] Tokyo night
     - [x] Kanagawa wave
 - [ ] Template host
 - [x] Flake refactor 
    - [x] Format similar to the minimal flake (opted to go for format similar to EmergentMind's)
    - [x] ConfigVars and options such as DE and theme
    - [ ] Template host
 - [x] Backup using ~borgbackup~ restic
 - [ ] All required permanence declarations exist only when impermanence is enabled
    - [ ] And opposite
### Personal
 - [x] Masiina ready
 - [x] New host klusteri (not K3s)
 - [ ] ~Serveri~ and oraakeli working
   - [x] Import old containers

# Thanks
 - A lot of "inspiration" from [EmergentMinds](https://github.com/EmergentMind/nix-config) config
 - Miscellaneous nixos discourses and github issues
