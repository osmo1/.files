{ inputs, ... }:
let
  patches-path = builtins.toString inputs.dwl-patches;
in
{
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs { pkgs = final; };

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://wiki.nixos.org/wiki/Overlays
  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: let ... in {
    # ...
    # });
    #    flameshot = prev.flameshot.overrideAttrs {
    #      cmakeFlags = [
    #        (prev.lib.cmakeBool "USE_WAYLAND_GRIM" true)
    #        (prev.lib.cmakeBool "USE_WAYLAND_CLIPBOARD" true)
    #      ];
    #    };
    dwl = prev.dwl.overrideAttrs {
      conf = ../common/optional/dwl/config.h;
      postInstall =
        let
          dwl-session = ''
            [Desktop Entry]
            Name=dwl
            Comment=Dwm but wayland
            Exec=dbus-dwl
            Type=Application
          '';
        in
        ''
          mkdir -p $out/share/wayland-sessions
          echo "${dwl-session}" > $out/share/wayland-sessions/dwl.desktop
        '';
      passthru.providedSessions = [ "dwl" ];
      patches = [ "${patches-path}/movestack.patch" ];
      #passthru.providedSessions = [ "dwl" "dbus-dwl" ];
    };
  };

  #
  # Convenient access to stable or unstable nixpkgs regardless
  #
  # When applied, the nixpkgs-stable set (declared in the flake inputs) will
  # be accessible through 'pkgs.stable'. Likewise, the nixpkgs-unstable set
  # will be accessible through 'pkgs.unstable'
  stable-packages = final: _prev: {
    stable = import inputs.nixpkgs {
      system = final.system;
      config.allowUnfree = true;
    };
  };
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
