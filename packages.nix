{ pkgs }:
with pkgs;

let
  isDarwin = stdenv.hostPlatform.isDarwin;

  basic = [
    alacritty
    gnupg
    libreoffice
    p7zip
    pass
    starship
    tmux
    xclip
    xfce.thunar-archive-plugin
    zoxide
    zstd
    zuki-themes
  ];

  emacsWithTools = [
    myEmacsWithPackages

    # required by epackages.dirvish
    ffmpegthumbnailer
    mediainfo
    poppler_utils
    fd
    imagemagick
  ];

  fonts = [
    (nerdfonts.override {
      fonts = [
        "FiraCode"
        "Inconsolata"
        "JetBrainsMono"
        "RobotoMono"
      ];
    })
  ];

  devTools = [
    comma
    delta
    difftastic

    dive
    docker
    docker-compose
    dockerfile-language-server-nodejs
    dockfmt

    git
    jq
    meld
    newman
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
    okular
  ];

  internet = [
    brave
    dogdns
    google-chrome
    iftop
    qrencode
    rsync
  ];

  entertainment = [
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
    nixd
    nixfmt-rfc-style
    nixpkgs-fmt
  ]
  ++ [
    ruff # linter & formatter

    (python312.withPackages (ps: with ps; [
      matplotlib
      numpy
      pandas
      scipy

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
    bun
    nodePackages.typescript-language-server
    nodejs_20
  ]
  ++ [
    lean
    nodePackages.bash-language-server
    shfmt
    texlive.combined.scheme-full
  ];

  misc = [
    bat
    bottom
    btop
    du-dust
    entr # https://eradman.com/entrproject/
    xsv
    yq

    fastfetch
    gnome-disk-utility
    htop
    lsof
    ripgrep
    tokei # Count your code, quickly

    cmatrix
    figlet
    file-roller # archive manager
    pstree
    pv
  ];

in

basic
++ emacsWithTools
++ fonts
++ devTools
++ programming
++ graphics
++ internet
++ entertainment
++ misc
