{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # === Programming Languages & Runtimes ===
    # Python
    python313
    python313Packages.pip
    
    # Node.js & JavaScript
    nodejs
    nodePackages.pnpm
    yarn
    node2nix
    bun
    
    # Rust
    rustc
    cargo
    rustfmt
    clippy
    rust-analyzer
    cargo-deny
    cargo-edit
    cargo-watch
    
    # Go
    go
    gopls
    gotools
    go-tools
    
    # Java & JVM
    jdk
    maven
    gradle
    kotlin
    scala
    clojure
    leiningen
    
    # C/C++
    gcc
    clang
    cmake
    gnumake
    gdb
    lldb
    
    # C#
    dotnet-sdk
    
    # Ruby
    ruby
    
    # PHP
    php
    phpPackages.composer
    
    # Haskell
    ghc
    cabal-install
    stack
    haskell-language-server
    
    # OCaml
    ocaml
    dune_3
    opam
    
    # Elixir & Erlang
    elixir
    
    # Elm
    elmPackages.elm
    elmPackages.elm-format
    elmPackages.elm-language-server
    
    # Zig
    zig
    zls
    
    # Nim
    nim
    nimlangserver
    
    # Swift (Linux)
    # swift # Only if on supported platform
    
    # V
    vlang
    
    # Odin
    odin
    
    # Gleam
    gleam
    
    # Lean4
    lean4
    
    # R
    R
    rPackages.languageserver
    
    # === Config/Data Languages ===
    # Nix
    nil # Nix LSP
    nixd
    nixfmt-rfc-style
    
    # Dhall
    dhall
    dhall-lsp-server
    
    # Cue
    cue
    
    # Nickel
    nickel
    
    # Protobuf
    protobuf
    
    # === DevOps & Infrastructure ===
    # HashiCorp
    terraform
    packer
    vault
    consul
    nomad
    
    # Pulumi
    pulumi
    pulumictl
    
    # Open Policy Agent
    open-policy-agent
    
    # === Embedded & Hardware ===
    # PlatformIO
    platformio-core
    
    # === Documentation & Typesetting ===
    # LaTeX
    texliveFull
    
    # === Other Development Tools ===
    # Jupyter
    jupyter
    
    # Shell scripting
    shellcheck
    shfmt
    
    # PureScript
    purescript
    spago
    
    # SWI-Prolog
    swi-prolog
    
    # Haxe
    haxe
    
    # === Build Tools & Package Managers ===
    pkg-config
    openssl
    
    # === Version Control (if not already installed) ===
    # git # Usually already in core packages
  ];
  
  # Enable direnv for automatic dev-shell activation
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
