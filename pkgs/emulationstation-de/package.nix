{
  lib,
  stdenv,
  fetchurl,
  appimageTools,
  ...
}:

let
  pname = "emulationstation-de";
  version = "3.5.0";

  src = fetchurl {
    url = "https://gitlab.com/es-de/emulationstation-de/-/package_files/357717909/download"; # not effective, but if im updating ill just change the URL
    hash = "sha256-1nP8C3r4e1N9ceq858G7KO2jmuAlt/mRIt3ZQhfr6Qk=";
  };

  extracted = appimageTools.extract {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;
  extraPkgs = pkgs: with pkgs; [
    # testinggg
  ];

  meta = {
    description = "EmulationStation Desktop Edition (AppImage version)";
    homepage = "https://es-de.org/";
    license = lib.licenses.mit; 
    platforms = [ "x86_64-linux" ];
  };
}
