{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, utils }:
    utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit system; };
      in {
        devShell = with pkgs;
          mkShell {
            buildInputs = [
              (python3.withPackages (ppkgs:
                with ppkgs; [
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
              (vscode-with-extensions.override {
                vscodeExtensions = with vscode-extensions; [
                  ms-python.python
                  ms-toolsai-jupyter
                  mkhl.direnv
                ];
              })
            ];
          };
      });
}
