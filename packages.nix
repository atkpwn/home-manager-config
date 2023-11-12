{ pkgs }: with pkgs;

let

  basic = [
    alacritty
    myEmacsWithPackages
    eza
    p7zip
    pass
    starship
    tmux
    xclip
    zstd
    zoxide
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

  graphics = [
    exiftool
    gimp
    gthumb
    inkscape
    okular
    poppler_utils # pdfunite
  ];

  internet = [
    brave
    google-chrome
  ];

  entertainment = [
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
    gradle
    jdk
    jdt-language-server
  ]
  ++ [
    rust-analyzer
    rustfmt
  ]
  ++ [
    go
    gopls
  ]
  ++ [
    texlive.combined.scheme-full
    shfmt
    lean
    nixfmt
    python311
    rnix-lsp
  ];

  misc = [
    bat
    bottom
    difftastic
    dive
    du-dust
    fd
    fzf
    htop
    jq
    pet        # Simple command-line snippet manager, written in Go
    pv
    ripgrep
    tokei      # Count your code, quickly
  ];

in

basic
++ fonts
++ graphics
++ internet
++ entertainment
++ programming
++ misc
