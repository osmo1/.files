{ lib
, qtbase
, qtsvg
, qtgraphicaleffects
, qtquickcontrols2
, wrapQtAppsHook
, stdenvNoCC
, fetchFromGitHub
}:
stdenvNoCC.mkDerivation
rec {
  pname = "tokyo-night-sddm";
  version = "1.0";
  dontBuild = true;
  src = fetchFromGitHub {
    owner = "rototrash";
    repo = "tokyo-night-sddm";
    rev = "ad5cb3d7bbffe530d9e63ee38601de3ccea6de20";
    sha256 = "sha256-JRVVzyefqR2L3UrEK2iWyhUKfPMUNUnfRZmwdz05wL0=";
  };
  nativeBuildInputs = [
    wrapQtAppsHook
  ];

  propagatedUserEnvPkgs = [
    qtbase
    qtsvg
    qtgraphicaleffects
    qtquickcontrols2
  ];


  installPhase = ''
    mkdir -p $out/share/sddm/themes
    cp -aR $src $out/share/sddm/themes/tokyo-night-sddm
  '';

}

