{
  inputs = {
    naersk.url = "github:nix-community/naersk/master";
    utils.url = "github:numtide/flake-utils";
    nixpkgs.url = "nixpkgs/nixos-unstable";

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, utils, naersk, fenix }:
    utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ fenix.overlays.default ];
        };
        toolchain = (pkgs.fenix.complete.withComponents [
          "cargo"
          "clippy"
          "rust-src"
          "rustc"
          "rustfmt"
        ]);
        naersk-lib = pkgs.callPackage naersk {
          cargo = toolchain;
          rustc = toolchain;
        };
      in {
        defaultPackage = naersk-lib.buildPackage { src = ./.; };
        devShell = pkgs.mkShell {
          # Make bevy see the shared libraries
          shellHook = ''
            export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${
              with pkgs;
              lib.makeLibraryPath [
                alsa-lib
                udev
                pkg-config
                vulkan-loader
                xorg.libX11
                xorg.libXcursor
                xorg.libXi
                xorg.libxcb
                xorg.libXrandr # To use the x11 feature
                libxkbcommon
                wayland # To use the wayland feature
              ]
            }"'';
          nativeBuildInputs = [ toolchain ];
          buildInputs = with pkgs; [ rust-analyzer-nightly ];
          RUST_SRC_PATH = pkgs.rustPlatform.rustLibSrc;
        };
      });
}
