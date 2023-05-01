{ pkgs, lib }:

let
  isDarwin   = pkgs.stdenv.targetPlatform.isDarwin;
in {
  home-manager.enable = true;

  bash = {
    enable = true;
    enableCompletion = true;
    historyControl = [
      "ignoredups"
      "ignorespace"
    ];
    historyFile     = ".config/bash_history";
    historyFileSize = 500000;
    historyIgnore = [
      "exa"
      "exit"
      "history"
      "ls"
      "tmux"
    ];
    historySize = 50000;
  };

  zsh = rec {
    enable = true;
    enableCompletion = true;
    enableSyntaxHighlighting = true;
    enableAutosuggestions = true;
    defaultKeymap = "emacs";
    dirHashes = {
      dl = "$HOME/Downloads";
    };
    dotDir = ".config/zsh";
    envExtra = lib.optionalString isDarwin ''
      [[ -o login ]] && export PATH='/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin'
    '';
    history = {
      extended       = true;
      ignoreDups     = true;
      ignorePatterns = [
        "exa"
        "exit"
        "history *"
        "ls"
        "tmux"
        "z"
      ];
      ignoreSpace    = true;
      path           = "$HOME/${dotDir}/zsh_history";
      save           = 500000;
      share          = true;
      size           = 50000;
    };
    profileExtra = lib.optionalString isDarwin ''
      if [[ -f '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]]; then
        source '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
        export NIX_PATH="$HOME/.nix-defexpr"
      fi
    '';
    shellAliases = {
      clipboard = (if isDarwin then "pbcopy" else "xclip -sel clip");
      gls       = "git ls-files | xargs wc -l";
      grep      = "grep --color=auto";
      history   = "history 0";
      tree      = "exa --tree";
    };
  };

  alacritty = {
    enable = true;
    # see https://github.com/alacritty/alacritty/blob/master/extra/man/alacritty.5.scd
    settings = {
      env = {
        "TERM" = "xterm-256color";
      };
      cursor = {
        style.blinking = "On";
        blink_interval = 500;
        blink_timeout  = 0;
      };
      window = {
        dimensions = {
          columns = 80;
          lines   = 40;
        };
        padding = {
          x = 2;
          y = 2;
        };
        decorations = (if isDarwin then "Buttonless" else "None");
        opacity     = 0.95;
        title       = "Terminal";
      };
      font = {
        size = 7.5;
        normal = {
          family = "JetBrainsMono NF";
          style = "Regular";
        };
      };
      scrolling.history = 100000;
      shell.program     = "${pkgs.zsh}/bin/zsh";
    };
  };

  bat.enable = true;

  exa = {
    enable = true;
    enableAliases = true;
    extraOptions = [
      "--group-directories-first"
      "--header"
      "--classify"
    ];
    git   = true;
    icons = true;
  };

  fzf = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    defaultOptions = [
      "--height 40%"
      "--layout=reverse"
      "--info=inline"
      "--border"
    ];
  };

  git = {
    enable = true;
    userName = "Attakorn Putwattana";
    userEmail = "atkpwn@gmail.com";
    aliases = {
      b    = "branch --color -v";
      l    = "log --graph --pretty=format:'%Cred%h%Creset"
             + " -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'"
             + " --abbrev-commit --date=relative";
      su   = "submodule update --init --recursive";
      undo = "reset --soft HEAD^";
    };
    extraConfig = {
      init.defaultBranch = "main";
      core = {
        editor     = "emacsclient";
        trustctime = false;
        whitespace = "trailing-space,space-before-tab";
      };
    };
  };

  starship = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration  = true;
    settings = {
      add_newline     = isDarwin;
      command_timeout = 2000;
      aws.format      = ''[($symbol$profile )(\[$duration\] )]($style)'';
    };
  };

  ssh = {
    enable = true;
    hashKnownHosts = true;
    matchBlocks = {
      bitbucket = {
        hostname = "bitbucket.org";
        identitiesOnly = true;
        identityFile = "~/.ssh/bigfoot";
      };
      github = {
        hostname = "github.com";
        identitiesOnly = true;
        identityFile = "~/.ssh/bigfoot";
      };
      keychain = {
        host = "*";
        extraOptions = {
          UseKeychain    = "yes";
          AddKeysToAgent = "yes";
          IgnoreUnknown  = "UseKeychain";
        };
      };
    };
    serverAliveInterval = 60;
    userKnownHostsFile = "~/.ssh/known_hosts";
  };

  tmux = {
    enable           = true;
    aggressiveResize = true;
    baseIndex        = 1;
    clock24          = true;
    customPaneNavigationAndResize = true;
    escapeTime       = 0;
    extraConfig      = (builtins.readFile ./config/tmux.conf);
    historyLimit     = 500000;
    keyMode          = "emacs";
    mouse            = true;
    prefix           = "C-z";
    shell            = "${pkgs.zsh}/bin/zsh";
    terminal         = "screen-256color";
  };

  zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration  = true;
  };
}
