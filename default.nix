# { pkgs ? import <nixpkgs> {} }:
{ pkgs ? 
import <nixpkgs> {}
# import (builtins.fetchTarball {
#       name = "nixos-20.09";
#       url = "https://codeload.github.com/NixOS/nixpkgs/tar.gz/20.09";
#       sha256 = "1wg61h4gndm3vcprdcg7rc4s1v3jkm5xd7lw8r2f67w502y94gcy";
#     }) {}
}:

let
  version = "0.1";
in pkgs.mkShell {
  name = "my-bgfx-example";

  nativeBuildInputs = with pkgs; [ 
    gnumake
    ninja
    ccls
    python38Packages.compiledb
  ];
  # phases: unpackPhase -> configurePhase -> buildPhase -> installPhase
  buildInputs = with pkgs; [ 
    glfw
    darwin.apple_sdk.frameworks.Foundation
    darwin.apple_sdk.frameworks.OpenGL
  ];

  enableParallelBuilding = true;

  shellHook = ''
    export DYLD_LIBRARY_PATH="$PWD/deps/bgfx/.build/osx-x64/bin/:$DYLD_LIBRARY_PATH"
    echo "🚀 bgfx ready!"
  '';

}

