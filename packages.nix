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
    zstd
    zoxide
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

  graphics = [
    exiftool
    gimp
    gthumb
    inkscape
    okular
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
++ emacsWithTools
++ fonts
++ graphics
++ internet
++ entertainment
++ programming
++ misc
