{ pkgs }:
with pkgs;

let
  basic = [
    alacritty
    git
    gnupg
    libreoffice
    p7zip
    pass
    starship
    tmux
    xclip
    zoxide
    zstd
    zuki-themes
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
    hyperfine
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
    newman
  ];

  perfTools = [
    iperf
  ];

  graphics = [
    darktable
    exiftool
    gimp
    gthumb
    inkscape
  ];

  internet = [
    brave
    dig
    dogdns
    dropbox
    google-chrome
    iftop
    ipcalc
    nmap
    qrencode
    rsync
  ];

  media = [
    audacity
    blanket
    calibre
    spotify
  ];

  programming = [
    # c/c++
    ccls
    # gcc
    clang
    cmake
    cmake-language-server
    gdb
    gnumake

    # nix
    alejandra
    comma
    lorri
    nh
    nix-output-monitor
    nixd
    # nixpkgs-fmt # current official
    nvd

    # python
    ruff # linter & formatter

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
    jdk24
    jdt-language-server
    kotlin
    kotlin-language-server
    spring-boot-cli

    # rust
    cargo
    rust-analyzer
    rustc
    rustfmt

    # go
    go
    go-task
    gofumpt
    gopls
    gotest # `go test' with colors
    gotools
    ko

    # javascript + typescript
    deno
    nodejs
    nodePackages.typescript-language-server

    # lean version manager
    elan

    # others
    nodePackages.bash-language-server
    shellcheck
    shfmt
    texliveFull
  ];

  misc = [
    bat
    bottom
    btop
    du-dust
    entr # https://eradman.com/entrproject/
    file-roller # archive manager
    gnome-disk-utility
    htop
    isoimagewriter
    procs
    pv
    yq

    fastfetch
    lsof
    pstree

    cmatrix
    figlet
  ];

in

basic
++ fonts
++ scripts
++ devTools
++ programming
++ graphics
++ internet
++ media
++ misc
