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
      "eza"
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
    syntaxHighlighting.enable = true;
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
      ignoreAllDups  = true;
      ignorePatterns = [
        "eza"
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
    initExtra = ''
      source "${pkgs.fzf-git-sh}/share/fzf-git-sh/fzf-git.sh"
      complete -C aws_completer aws
    '';
    initExtraBeforeCompInit = ''
      autoload bashcompinit && bashcompinit # for aws_completer
    '';
    profileExtra = lib.optionalString isDarwin ''
      if [[ -f '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]]; then
        source '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
        export NIX_PATH="$HOME/.nix-defexpr"
      fi
    '';
    shellAliases = {
      clipboard = (if isDarwin then "pbcopy" else "xclip -sel clip");
      gdifft    = "GIT_EXTERNAL_DIFF=difft git diff";
      gls       = "git ls-files | xargs wc -l";
      grep      = "grep --color=auto";
      history   = "history 0";
      tree      = "eza --tree";
    };
  };

  alacritty = {
    enable = true;
    # see https://github.com/alacritty/alacritty/blob/master/extra/man/alacritty.5.scd
    settings = {
      env = {
        TERM = "xterm-256color";
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
      font = (if isDarwin then {
        size = 17;
        normal = {
          family = "JetBrainsMono Nerd Font";
          style  = "Regular";
        };
      } else {
        size = 7.5;
        normal = {
          family = "JetBrainsMono NF";
          style  = "Regular";
        };
      });
      scrolling.history = 100000;
    } //
    (if isDarwin then {
      # https://github.com/alacritty/alacritty/wiki/Keyboard-mappings#mac-os-4
      key_bindings = [
        { key = "F";     mods = "Command"; chars = "\\x1bf"; }
        { key = "B";     mods = "Command"; chars = "\\x1bb"; }
        { key = "Right"; mods = "Command"; chars = "\\x1bf"; }
        { key = "Left";  mods = "Command"; chars = "\\x1bb"; }
        { key = "Slash"; mods = "Control"; chars = "\\x1f"; }
      ];
    } else {
      shell.program = "${pkgs.zsh}/bin/zsh";
    });
  };

  awscli.enable = true;

  bat.enable = true;

  eza = {
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
      "--color 'header:italic:underline,label:blue'"
    ];
    fileWidgetOptions = [
      "--preview 'bat -n --color=always {}'"
      "--preview-window 'hidden'"
      "--bind 'ctrl-/:toggle-preview'"
      "--header 'Press CTRL-/ to toggle preview'"
    ];
  };

  git = {
    enable = true;
    userName  = "Attakorn Putwattana";
    userEmail = "atkpwn@gmail.com";
    aliases = {
      b     = "branch --color -v";
      c     = "checkout";
      cb    = "checkout -b";
      cm    = "checkout master";
      difft = "difftool --extcmd=difft";
      fixup = "commit --amend --no-edit";
      l     = "log --graph --pretty=format:'%Cred%h%Creset"
              + " -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'"
              + " --abbrev-commit --date=relative";
      hist  = "log --follow -p --";
      p     = "pull";
      su    = "submodule update --init --recursive";
      undo  = "reset --soft HEAD^";
    };
    delta = {
      enable = true;
      options = {
        # see https://dandavison.github.io/delta/full---help-output.html
        plus-style = "syntax bold '#1A3A1A'";
      };
    };
    extraConfig = {
      init.defaultBranch = "main";
      core = {
        editor     = "emacsclient";
        trustctime = false;
        whitespace = "trailing-space,space-before-tab";
      };
      "url \"git@github.com:\"".insteadOf = "https://github.com/";
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
    extraConfig = ''
      UseKeychain yes
      AddkeysToAgent yes
      IgnoreUnknown UseKeychain
      ConnectTimeout 5
    '';
    hashKnownHosts = true;
    matchBlocks = {
      bitbucket = {
        hostname       = "bitbucket.org";
        identitiesOnly = true;
        identityFile   = "~/.ssh/bigfoot";
      };
      github = {
        hostname       = "github.com";
        identitiesOnly = true;
        identityFile   = "~/.ssh/bigfoot";
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
    userKnownHostsFile  = "~/.ssh/known_hosts";
  };

  tmux = {
    enable           = true;
    aggressiveResize = true;
    baseIndex        = 1;
    clock24          = true;
    customPaneNavigationAndResize = true;
    escapeTime       = 0;
    extraConfig = (let conf = (builtins.readFile ./config/tmux.conf); in
      if isDarwin then
        (builtins.replaceStrings [ "xclip -selection clipboard" "xdg-open" ] [ "pbcopy" "open" ] conf)
      else
        conf);
    historyLimit     = 500000;
    keyMode          = "emacs";
    mouse            = true;
    prefix           = "C-z";
    shell            = "${pkgs.zsh}/bin/zsh";
    terminal         = "xterm-256color";
  };

  zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration  = true;
  };
}
