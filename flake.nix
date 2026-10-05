{
  description = "src441's custom repo";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" ]; # aarch64 could work but not tested
      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);
    in {

      packages = forAllSystems (system:
        let
          pkgs = import nixpkgs { inherit system; };
        in {
          emulationstation-de = pkgs.callPackage ./pkgs/emulationstation-de/package.nix {};
        }
      );

      overlays.default = final: prev: {
        emulationstation-de = final.callPackage ./pkgs/emulationstation-de/package.nix {};
        src441pkgs = {
          emulationstation-de = final.callPackage ./pkgs/emulationstation-de/package.nix {};
        };
      };
    };
}
