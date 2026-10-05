{
  lib,
  stdenv,
  fetchsvn,
  libtiff,
  libpng,
  zlib,
  libwebp,
  libraw,
  openexr,
  openjpeg,
  libjpeg,
  jxrlib,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "freeimage";
  version = "unstable-2021-11-01";

  src = fetchsvn {
    url = "svn://svn.code.sf.net/p/freeimage/svn/";
    rev = "1900";
    hash = "sha256-rWoNlU/BWKZBPzRb1HqU6T0sT7aK6dpqKPe88+o/4sA=";
  };

  sourceRoot = "${finalAttrs.src.name}/FreeImage/trunk";

  # Ensure that the bundled libraries are not used at all
  prePatch = ''
    rm -rf Source/Lib* Source/OpenEXR Source/ZLib
  '';

  patches = [
    ./unbundle.diff
    ./libtiff-4.4.0.diff
  ];

  postPatch = ''
    # To support cross compilation, use the correct `pkg-config`.
    substituteInPlace Makefile.fip \
      --replace "pkg-config" "$PKG_CONFIG"
    substituteInPlace Makefile.gnu \
      --replace "pkg-config" "$PKG_CONFIG"
  '';

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libtiff
    libpng
    zlib
    libwebp
    libraw
    openexr
    openjpeg
    libjpeg
    jxrlib
  ];

  postBuild = ''
    make -f Makefile.fip
  '';

  env = {
    INCDIR = "${placeholder "out"}/include";
    INSTALLDIR = "${placeholder "out"}/lib";
  };

  preInstall = ''
    mkdir -p $INCDIR$INSTALLDIR
  '';

  postInstall = ''
    make -f Makefile.fip install
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Open Source library for accessing popular graphics image file formats";
    homepage = "http://freeimage.sourceforge.net/";
    license = lib.licenses.gpl1Plus;
    #knownVulnerabilities = [ stupid nix wont let me build when informing people :(
    #  "CVE-2021-33367"
    #  "CVE-2021-40262"
    #  "CVE-2021-40263"
    #  "CVE-2021-40264"
    #  "CVE-2021-40265"
    #  "CVE-2021-40266"

    #  "CVE-2023-47992"
    #  "CVE-2023-47993"
    #  "CVE-2023-47994"
    #  "CVE-2023-47995"
    #  "CVE-2023-47996"
    #];
    maintainers = with lib.maintainers; [ l-as ];
    platforms = lib.platforms.linux;
  };
})
