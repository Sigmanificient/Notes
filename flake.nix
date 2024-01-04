{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};


      in
      rec {
        formatter = pkgs.nixpkgs-fmt;

        devShell = pkgs.mkShell {
          inputsFrom = [ packages.notes ];
        };

        packages = {
          # Credits to nix.dev for the base derivation
          notes = pkgs.stdenv.mkDerivation {
            name = "notes";
            src = ./.;

            nativeBuildInputs = with pkgs.python310.pkgs; [
              linkify-it-py
              myst-parser
              sphinx
              furo
              sphinx-copybutton
              sphinx-design
              sphinx-notfound-page
              sphinx-sitemap
            ];

            buildPhase = ''
              make html
            '';

            installPhase = ''
              mkdir -p $out/
              cp -R .build/html/* $out/
            '';
          };
        };
      });
}
