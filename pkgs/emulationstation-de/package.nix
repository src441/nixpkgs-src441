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
    url = "https://gitlab.com/es-de/emulationstation-de/-/releases/v${version}/downloads/ES-DE-${version}_x64.AppImage";
    hash = lib.fakeHash;
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
