{ pkgs }:
with pkgs;

let
  basic = [
    alacritty
    git
    gnupg
    p7zip
    starship
    tmux
    xclip
    zoxide
    zstd
  ];

  fonts = with nerd-fonts; [
    fira-code
    inconsolata
    iosevka
    jetbrains-mono
    roboto-mono
    symbols-only
  ];

  scripts = let
    fs = pkgs.lib.fileset;
    in
    fs.fileFilter (f: f.hasExt "nix") ./scripts
    |> fs.toList
    |> map (s: pkgs.callPackage s { });

  devTools = [
    act
    difftastic
    ripgrep
    tokei # Count your code, quickly

    dive
    docker
    docker-compose
    docker-credential-helpers
    docker-slim
    dockerfile-language-server
    dockfmt
    lazydocker

    grype
    syft

    jq
    jqp
    meld

    nosql-workbench
  ];

  perfTools = [
    hyperfine
    iperf
  ];

  graphics = [
    darktable
    exiftool
    inkscape
  ];

  internet = [
    dig
    iftop
    ipcalc
    nmap
    openssl
    qrencode
    rsync
  ];

  browsers = [
    brave
    librewolf
    google-chrome
  ];

  media = [
    audacity
    spotify
  ];

  programming = [
    # c/c++
    ccls
    # gcc
    clang
    cmake
    gdb
    gnumake

    # nix
    alejandra
    comma
    nh
    nix-output-monitor
    # nixpkgs-fmt # current official
    nvd

    # python
    ruff # linter & formatter

    uv
    (python313.withPackages (ps: with ps; [
      matplotlib
      numpy
      pandas
      scipy

      httpx
      jq
      loguru
      pytest
      rich

      mypy # type checker
      pylsp-mypy
      python-lsp-ruff
      python-lsp-server
    ]))

    # java + jvm
    gradle
    javaPackages.compiler.openjdk25
    kotlin
    spring-boot-cli

    # rust
    cargo
    rustc
    rustfmt

    # go
    go
    go-task
    gofumpt
    gotest # `go test' with colors
    gotools
    ko

    protobuf
    protoc-gen-go
    protoc-gen-lint

    # javascript + typescript
    deno
    nodejs

    # lean version manager
    elan

    # others
    shellcheck
    shfmt
    texliveFull
  ];

  misc = [
    bat
    bottom
    btop
    dust
    entr # https://eradman.com/entrproject/
    htop
    procs
    pv
    yq

    fastfetch
    lsof
    pstree

    cmatrix
    figlet
    wthrr
  ];

  linuxOnly = [
    blanket
    bpftrace
    calibre
    dropbox
    file-roller # archive manager
    gimp
    gnome-disk-utility
    gthumb
    isoimagewriter
    libreoffice
    zuki-themes
  ];

  macOnly = [
    colima
    rectangle
    iproute2mac
  ];
in

basic
++ fonts
++ scripts
++ devTools
++ perfTools
++ programming
++ graphics
++ internet
++ browsers
++ media
++ misc
++ (if pkgs.stdenv.hostPlatform.isDarwin then macOnly else linuxOnly)
