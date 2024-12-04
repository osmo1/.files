{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
}:
stdenvNoCC.mkDerivation rec {
  pname = "tokyo-night-icons";
  version = "2.0";
  dontBuild = true;
  src = fetchFromGitHub {
    owner = "ljmill";
    repo = "tokyo-night-icons";
    rev = "8bccfa14e3327acbc99b3ce5a7712b3a6c865f7b";
    sha256 = "sha256-yvVopLBSMd8RD6E1YiOJx8I4LdVxlQo28lzyPJ6PSJk=";
  };
  nativeBuildInputs =
    [
    ];

  propagatedUserEnvPkgs =
    [
    ];

  installPhase = ''
    mkdir -p $out/share/icons
    cp -aR $src $out/share/icons/tokyo-night
  '';

}
