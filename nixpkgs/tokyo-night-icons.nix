{ lib
, stdenvNoCC
, fetchFromGitHub
}:
stdenvNoCC.mkDerivation
rec {
  pname = "tokyo-night-icons";
  version = "1.0";
  dontBuild = true;
  src = fetchFromGitHub {
    owner = "ljmill";
    repo = "tokyo-night-icons";
    rev = "8bccfa14e3327acbc99b3ce5a7712b3a6c865f7b";
    sha256 = "sha256-JRVVzyefqR2L3UrEK2iWyhUKfPMUNUnfRZmwdz05wL0=";
  };
  nativeBuildInputs = [
  ];

  propagatedUserEnvPkgs = [
  ];


  installPhase = ''
    mkdir -p $out/share/icons
    cp -aR $src $out/share/icons/tokyo-night-sddm
  '';

}

