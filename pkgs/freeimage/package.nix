{ lib, stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  pname = "freeimage-legacy";
  version = "3.18.0";

  src = fetchurl {
    url = "mirror://sourceforge/freeimage/FreeImage${lib.replaceStrings ["."] [""] version}.zip";
    hash = "sha256-9BN5aC+a2pTqezT+hr+e4Ak1oxR75BtlaclgWlPkOP0=";
  };

  nativeBuildInputs = [ unzip ];

  NIX_CFLAGS_COMPILE = [ 
    "-std=c++11" 
    "-D_GNU_SOURCE"
    "-Wno-error=old-style-definition"
    "-Wno-error=implicit-function-declaration"
    "-Wno-error=incompatible-pointer-types"
  ]; 

  makeFlags = [
    "DESTDIR=$(out)"
    "INCDIR=/include"
    "INSTALLDIR=/lib"
  ];

  patchPhase = ''
    sed -i 's/PowerPC/Generic/g' Source/FreeImage/PluginTIFF.cpp
    sed -i 's/CFLAGS =/CFLAGS = -std=c11 /' Makefile.gnu
    sed -i 's/CXXFLAGS =/CXXFLAGS = -std=c++11 /' Makefile.gnu
    sed -i 's|/usr||g' Makefile.gnu
  '';

  preInstall = ''
    mkdir -p $out/include $out/lib
  '';

  meta = with lib; {
    description = "FOSS library for supporting various image types";
    homepage = "https://sourceforge.io";
    knownVulnerabilities = [
      "CVE-2021-33367"
      "CVE-2021-40262"
      "CVE-2021-40263"
      "CVE-2021-40264"
      "CVE-2021-40265"
      "CVE-2021-40266"

      "CVE-2023-47992"
      "CVE-2023-47993"
      "CVE-2023-47994"
      "CVE-2023-47995"
      "CVE-2023-47996"
    ];
    license = licenses.gpl2Only;
    platforms = platforms.linux;
  };
}
