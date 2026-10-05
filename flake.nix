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
          freeimage-legacy-pkg = pkgs.callPackage ./pkgs/freeimage/default.nix {};
        in {
          emulationstation-de = pkgs.callPackage ./pkgs/emulationstation-de/package.nix {
            freeimage-legacy = freeimage-legacy-pkg;
          };
          freeimage-legacy = freeimage-legacy-pkg;
        }
      );

      overlays.default = final: prev: {
        src441pkgs = let
          freeimage-legacy-pkg = final.callPackage ./pkgs/freeimage/default.nix {};
        in {
          emulationstation-de = final.callPackage ./pkgs/emulationstation-de/package.nix {
            freeimage-legacy = freeimage-legacy-pkg;
          };
          freeimage-legacy = freeimage-legacy-pkg;          
        };
      };
    };
}
