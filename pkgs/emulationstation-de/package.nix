{
  lib,
  stdenv,
  fetchurl,
  buildFHSUserEnv,
  alsa-lib,
  udev,
  xorg,
  libGL,
  vulkan-loader,
  glib,
  dbus,
  nspr,
  nss,
  freetype,
  fontconfig,
  curl,
  libusb1,
  SDL2,
  ...
}:

let
  pname = "emulationstation-de";
  version = "3.5.0";

  src = fetchurl {
    url = "https://gitlab.com/es-de/emulationstation-de/-/releases/v${version}/downloads/EmulationStation-DE-${version}-x86_64.AppImage";
    hash = "sha256-1nP8C3r4e1N9ceq858G7KO2jmuAlt/mRIt3ZQhfr6Qk=";
  };

  appimageBin = stdenv.mkDerivation {
    inherit pname version src;
    dontUnpack = true;
    installPhase = ''
      install -Dm755 $src $out/bin/emulationstation-de-unwrapped
    '';
  };

  fhsEnv = buildFHSUserEnv {
    name = "emulationstation-de";
    targetPkgs = pkgs: with pkgs; [
      alsa-lib
      udev
      xorg.libX11
      xorg.libXext
      xorg.libXcursor
      xorg.libXrandr
      xorg.libXi
      xorg.libXxf86vm
      libGL
      vulkan-loader
      glib
      dbus
      nspr
      nss
      freetype
      fontconfig
      curl
      libusb1
      SDL2
    ];
    runScript = "${appimageBin}/bin/emulationstation-de-unwrapped";
  };
in

stdenv.mkDerivation {
  inherit pname version;
  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;
  installPhase = ''
    mkdir -p $out/bin
    ln -s ${fhsEnv}/bin/emulationstation-de $out/bin/emulationstation-de
  '';

  meta = {
    description = "EmulationStation Desktop Edition (FHS version)";
    homepage = "https://es-de.org/";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
  };
}
