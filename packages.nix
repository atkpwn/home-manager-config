{ pkgs }:
with pkgs;

let
  isDarwin = stdenv.hostPlatform.isDarwin;

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
    difftastic
    hyperfine
    ripgrep
    tokei # Count your code, quickly

    dive
    docker
    docker-compose
    docker-credential-helpers
    docker-slim
    dockerfile-language-server-nodejs
    dockfmt
    lazydocker

    jq
    meld
    newman

    harlequin
  ] ++
  (if isDarwin then [
    colima
    rectangle
    unixtools.nettools
  ] else []);

  graphics = [
    darktable
    exiftool
    gimp
    gthumb
    inkscape
  ];

  internet = [
    brave
    dogdns
    dropbox
    google-chrome
    iftop
    qrencode
    rsync
  ];

  media = [
    audacity
    blanket
    spotify
  ];

  programming = [
    ccls
    clang
    cmake
    cmake-language-server
    gdb
    gnumake
  ]
  ++ [
    alejandra
    comma
    nh
    nix-output-monitor
    nixd
    # nixpkgs-fmt # current official
    nvd
  ]
  ++ [
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
  ]
  ++ [
    gradle
    jdk
    jdt-language-server
    kotlin
    kotlin-language-server
    spring-boot-cli
  ]
  ++ [
    cargo
    rust-analyzer
    rustc
    rustfmt
  ]
  ++ [
    go
    go-task
    gofumpt
    gopls
    gotest # `go test' with colors
    gotools
    ko
  ]
  ++ [
    deno
    nodejs
    nodePackages.typescript-language-server
  ]
  ++ [
    elan # lean version manager

    nodePackages.bash-language-server
    shellcheck
    shfmt
    texliveFull
  ];

  misc = [
    bat
    bottom
    btop
    calibre
    du-dust
    entr # https://eradman.com/entrproject/
    pv
    yq

    fastfetch
    gnome-disk-utility
    htop
    lsof
    pstree

    cmatrix
    figlet
    file-roller # archive manager

    isoimagewriter
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
