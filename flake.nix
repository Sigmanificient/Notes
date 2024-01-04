{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    flake-utils.url = "github:numtide/flake-utils";

    nixdev = {
      url = "github:NixOS/nix.dev";
      flake = false;
    };
  };

  outputs = { self, nixdev, nixpkgs, flake-utils } @inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        gen-derivs = pkgs.stdenv.mkDerivation rec {
          src = nixdev;
          name = "generated-derivations";

          dontBuild = true;
          installPhase = ''
            mkdir -p $out
            cp ${src}/default.nix $out/default.nix
            cp ${src}/overlay.nix $out/overlay.nix

            patch -p1 $out/default.nix \
              < ${./generate_deviration_from_nixdev_nix.patch}
          '';
        };

        deriv-pkgs = (import "${gen-derivs}" {
          inherit inputs system;
          src = ./.;
        });
      in
      {
        formatter = pkgs.nixpkgs-fmt;
        devShell = pkgs.mkShell {
          packages = [ deriv-pkgs.devmode ];
        };

        packages = {
          inherit gen-derivs;
          notes = deriv-pkgs.notes;
        };
      });
}
