{
  stdenvNoCC,
  fetchFromGitHub,
  pkgs,
}:
stdenvNoCC.mkDerivation rec {
  pname = "tokyo-night-icons";
  version = "2.0";
  dontBuild = true;
  src = fetchFromGitHub {
    owner = "Fausto-Korpsvart";
    repo = "Tokyonight-GTK-Theme";
    rev = "006154c78dde52b5851347a7e91f924af62f1b8f";
    sha256 = "sha256-h5k9p++zjzxGFkTK/6o/ISl/Litgf6fzy8Jf6Ikt5V8=";
  };

  propagatedUserEnvPkgs = [
  ];
  nativeBuildInputs = [ pkgs.gtk3 ];

  # installPhase = ''
  #   mkdir -p $out/share/icons
  #   cp -aR $src $out/share/icons/tokyo-night
  # '';

  propagatedBuildInputs = [
    pkgs.gnome-icon-theme
    pkgs.hicolor-icon-theme
  ];

  installPhase = ''
    mkdir -p $out/share/icons/
    cp -aR $src/icons/Tokyonight-Dark $out/share/icons
    # gtk-update-icon-cache $out/share/icons/Tokyonight-Dark
  '';

  dontDropIconThemeCache = true;

}
