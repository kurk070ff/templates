{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShell = with pkgs; mkShell {
          buildInputs = [ (python3.withPackages (ppkgs: with ppkgs; [
            pandas
            numpy
            matplotlib
            seaborn
            scikit-learn
            ipykernel
            pip
          ]))
          python3Packages.pip
          python3Packages.ipykernel
           ];
        };
      }
    );
}
