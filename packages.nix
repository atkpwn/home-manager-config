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
    zoxide
    zstd
    zuki-themes
  ];

  fonts = with nerd-fonts; [
    fira-code
    inconsolata
    jetbrains-mono
    roboto-mono
  ];

  scripts = let
    fs = pkgs.lib.fileset;
    in
    fs.fileFilter (f: f.hasExt "nix") ./scripts
    |> fs.toList
    |> map (s: pkgs.callPackage s { });

  devTools = [
    comma
    difftastic
    hyperfine
    ripgrep
    tokei # Count your code, quickly

    dive
    docker
    docker-compose
    dockerfile-language-server-nodejs
    dockfmt
    lazydocker

    git
    jq
    meld
    newman
  ] ++
  [
    kubectl
    (callPackage ./packages/kubectl-argo-rollouts.nix {})

    k9s
    kustomize
    minikube
    skaffold
    stern
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
    deno
    nodePackages.typescript-language-server
    nodejs_20
  ]
  ++ [
    lean
    nodePackages.bash-language-server
    shfmt
    texliveFull
  ];

  misc = [
    bat
    bottom
    btop
    du-dust
    entr # https://eradman.com/entrproject/
    pv
    xsv
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
++ entertainment
++ misc
