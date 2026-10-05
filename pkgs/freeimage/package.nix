{ lib, stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  pname = "freeimage-legacy";
  version = "3.18.0";

  src = fetchurl {
    url = "mirror://sourceforge/freeimage/FreeImage${lib.replaceStrings ["."] [""] version}.zip";
    hash = "sha256-9BN5aC+a2pTqezT+hr+e4Ak1oxR75BtlaclgWlPkOP0=";
  };

  nativeBuildInputs = [ unzip ];

  NIX_CFLAGS_COMPILE = [ [ "-std=c++11" ]; ];

  patchPhase = ''
    sed -i 's/PowerPC/Generic/g' Source/FreeImage/PluginTIFF.cpp
    sed -i 's/CFLAGS =/CFLAGS = -std=c11 /' Makefile.gnu
    sed -i 's/CXXFLAGS =/CXXFLAGS = -std=c++11 /' Makefile.gnu
  '';

  preInstall = ''
    mkdir -p $out/include $out/lib
  '';

  meta = with lib; {
    description = "FOSS library for supporting various image types (iirc its a vulnerable package, however ES-DE needs it sooo)";
    homepage = "https://sourceforge.io";
    license = licenses.gpl2Only;
    platforms = platforms.linux;
  };
}
