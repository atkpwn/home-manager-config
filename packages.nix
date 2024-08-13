{ pkgs }: with pkgs;

let

  basic = [
    alacritty
    eza
    gnupg
    p7zip
    pass
    starship
    tmux
    xclip
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

  dev = [
    comma
    delta
    difftastic
    dive
    docker
    docker-compose
    git
    meld
  ];

  graphics = [
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
    newman
    qrencode
    rsync
  ];

  entertainment = [
    audacity
    blanket
    spotify
  ];

  programming = [
    gdb
    gnumake
    ccls
    cmake
    gcc
  ]
  ++ [
    nil
    nixfmt-classic
  ]
  ++ [
    ruff # linter & formatter

    (python312.withPackages (ps: with ps; [
      matplotlib
      numpy

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
    gopls
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
    file-roller # archive manager
    gnome-disk-utility
    htop
    jq
    pv
    ripgrep
    tokei      # Count your code, quickly
  ];

in

basic
++ emacsWithTools
++ fonts
++ graphics
++ internet
++ entertainment
++ programming
++ misc
