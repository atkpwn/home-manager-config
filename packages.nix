{ pkgs }: with pkgs;

let

  basic = [
    alacritty
    emacs
    emacs-all-the-icons-fonts
    exa
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
  ];

  internet = [
    brave
    google-chrome
  ];

  entertainment = [
    spotify
  ];

  programming = [
    ccls
    cmake
    gcc
    gdb
    gnumake
    lean
    python311
    rnix-lsp
  ];

  # TODO: latex
  # texlive.combined.scheme-full

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
