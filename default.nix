# { pkgs ? import <nixpkgs> {} }:
{ pkgs ? 
import (builtins.fetchTarball {
      name = "nixos-21.05";
      url = "https://codeload.github.com/NixOS/nixpkgs/tar.gz/21.05";
      sha256 = "1ckzhh24mgz6jd1xhfgx0i9mijk6xjqxwsshnvq789xsavrmsc36";
    }) {
      config.allowUnfree = true;
      # config.allowBroken = true;
      # config.allowUnsupportedSystem = true;
    }
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
    lldb
    gdb
    # vscode-extensions.vadimcn.vscode-lldb
    # vscode-extensions.ms-vscode.cpptools #not support on mac yet
    # vscode-with-extensions 
    # vscode-extensions.vscodevim.vim
  ];

  enableParallelBuilding = true;

  shellHook = ''
    export DYLD_LIBRARY_PATH="$PWD/deps/bgfx/.build/osx-x64/bin/:$DYLD_LIBRARY_PATH"
    echo "🚀 bgfx ready!"
  '';

}

