{lib
, stdenv
, fetchurl
, nixosTests
}:

 stdenv.mkDerivation rec {
  pname = "example";
  version = "1.0";
  src = fetchurl {
    url = "nothing";
    sha512 = "nothing";
  };

  meta = {
   changelog = "for example nothing";
   description = "test";
   homepage = "kernel.org";
   maintainers = with lib.maintainers; [
    src441
   ];
   platforms = lib.platforms.unix;
   broken = stdenv.buildPlatform.is32bit;
   maxSilent = 7200;
   license = lib.licenses.mit;
   mainProgram = "example";
  };
  tests = {
   inherit (nixosTests) example;
  };
}
