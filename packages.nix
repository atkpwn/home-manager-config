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

  browsers = [
    brave
    librewolf
    google-chrome
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
    hunk
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

    hyperfine
    iperf

    herdr
    opencode
    pi-coding-agent
  ];

  network = [
    dig
    iftop
    ipcalc
    nmap
    openssl
    qrencode
    rsync
  ];

  programming = [
    # c/c++
    # ccls
    # gcc
    cmakeCurses
    coreutils
    doxygen
    gdb
    gnumake
    lldb
    pkg-config

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
    (python314.withPackages (ps: with ps; [
      matplotlib
      numpy
      pandas
      scipy

      httpx
      jq
      loguru
      pytest
      rich
    ]))

    # java + jvm
    (gradle.override {
      java = javaPackages.compiler.openjdk25;
    })
    javaPackages.compiler.openjdk25
    kotlin

    # rust
    rustup

    # go
    go
    go-task
    gofumpt
    gotest # `go test' with colors
    ko

    protobuf
    protoc-gen-go
    protoc-gen-lint

    sqlc

    # javascript + typescript
    deno
    nodejs

    # lean version manager
    elan
    (vscode-with-extensions.override {
      vscodeExtensions = with vscode-extensions; [
        leanprover.lean4
        tamasfe.even-better-toml
        tuttieee.emacs-mcx
      ];
    })

    # others
    shellcheck
    shfmt
    texliveFull
  ];

  graphics = [
    darktable
    exiftool
    inkscape
  ];

  media = [
    # audacity
    spotify
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

    helix

    obsidian
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
++ browsers
++ scripts
++ devTools
++ network
++ programming
++ graphics
++ media
++ misc
++ (if pkgs.stdenv.hostPlatform.isDarwin then macOnly else linuxOnly)
