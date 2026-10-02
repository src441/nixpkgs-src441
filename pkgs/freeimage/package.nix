{ lib, stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  pname = "freeimage";
  version = "3.18.0";

  src = fetchurl {
    url = "mirror://sourceforge/freeimage/FreeImage${lib.replaceStrings ["."] [""] version}.zip";
    hash = "sha256-6beea6M/x+AatFsh2bZ0XU+QZorXm0S38u7v0w93608=";
  };

  nativeBuildInputs = [ unzip ];

  patchPhase = ''
    sed -i 's/PowerPC/Generic/g' Source/FreeImage/PluginTIFF.cpp
  '';

  makeFlags = [
    "DESTDIR=$(out)"
    "INCDIR=/include"
    "INSTALLDIR=/lib"
  ];

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
