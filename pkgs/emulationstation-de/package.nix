{ lib
, stdenv
, fetchFromGitLab
, cmake
, pkg-config
, SDL2
, alsa-lib
, curl
, ffmpeg
, libgit2
, libunwind
, pugixml
, libpng
, libjpeg
}:

stdenv.mkDerivation rec {
  pname = "emulationstation-de";
  version = "3.5.0";

  src = fetchFromGitLab {
    owner = "es-de";
    repo = "emulationstation-de";
    rev = "v${version}";
    hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  nativeBuildInputs = [
    cmake
    make
    pkg-config
  ];

  buildInputs = [
    SDL2
    alsa-lib
    curl
    ffmpeg
    libgit2
    libunwind
    pugixml
    libpng
    libjpeg
  ];

  cmakeFlags = [
    "-DUSE_SYSTEM_PUGIXML=ON"
    "-DAPPLICATION_UPDATER=off"
  ];

  meta = with lib; {
    description = "Emulator frontend";
    homepage = "https://es-de.org";
    license = licenses.gpl3Only;
    maintainers = [ ];
    platforms = platforms.linux;
  };
}
