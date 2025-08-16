{ inputs, ... }:
let
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs { pkgs = final; };

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://wiki.nixos.org/wiki/Overlays
  modifications = final: prev: {
    /*
      dwl = prev.dwl.override {
        #src = ../../dwl;
        configH = builtins.toPath ../common/optional/desktop/dwl/config.h;
        #conf = builtins.toPath ../common/optional/dwl/config.h;
        #patches = [ "${patches-path}/movestack.patch" ];
      };
    */
  };

  # Convenient access to stable or unstable nixpkgs regardless
  #
  # When applied, the nixpkgs-stable set (declared in the flake inputs) will
  # be accessible through 'pkgs.stable'. Likewise, the nixpkgs-unstable set
  # will be accessible through 'pkgs.unstable'
  stable-packages = final: _prev: {
    stable = import inputs.nixpkgs {
      system = final.system;
      config.allowUnfree = true;
      #overlays = modifications;
      overlays =
        let
          patches-path = builtins.toString inputs.dwl-patches;
        in
        [
          (prev: final: {
            dwl = (final.dwl.override { configH = ../common/optional/desktop/dwl/config.h; }).overrideAttrs {
              patches = [
                "${patches-path}/gaps.patch"
                "${patches-path}/cfact-v0.7-gaps.patch"
                "${patches-path}/pointer-gestures-unstable-v1.patch"
                "${patches-path}/gestures.patch"
                "${patches-path}/movestack.patch"
                "${patches-path}/shiftview.patch"
                "${patches-path}/smartborders.patch"
                "${patches-path}/swallow.patch"
                "${patches-path}/unclutter.patch"
                "${patches-path}/ipc.patch"
              ];
              postInstall =
                let
                  dwlSession = ''
                    [Desktop Entry]
                    Name=dwl
                    Comment=Dynamic Wayland compositor
                    Exec=dbus-dwl
                    Type=Application
                  '';
                in
                ''
                  mkdir -p $out/share/wayland-sessions
                  echo "${dwlSession}" > $out/share/wayland-sessions/dwl.desktop
                '';
              passthru.providedSessions = [ "dwl" ];
            };
            dwlb = (
              final.dwlb.override {
                configH = ../common/optional/desktop/dwl/dwlb.h;
              }
            );
            usbmuxd = (
              final.usbmuxd.overrideAttrs {
                src = final.fetchFromGitHub {
                  owner = "libimobiledevice";
                  repo = "usbmuxd";
                  rev = "523f7004dce885fe38b4f80e34a8f76dc8ea98b5";
                  hash = "sha256-U8SK1n1fLjYqlzAH2eU4MLBIM+QMAt35sEbY9EVGrfQ=";
                };

              }
            );
          })
        ];
    };
  };
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
in
{
  default =
    final: prev:

    (additions final prev)
    // (modifications final prev)
    // (stable-packages final prev)
    // (unstable-packages final prev);
}
