{ pkgs, config, lib, ... }:

let
  isDarwin = pkgs.stdenv.hostPlatform.isDarwin;
in {
  home-manager.enable = true;

  nix-index = {
    enable = true;
    enableZshIntegration = true;
  };

  bash = {
    enable = true;
    enableCompletion = true;
    historyControl = [
      "ignoredups"
      "ignorespace"
    ];
    historyFile = ".config/bash_history";
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
    autosuggestion.enable = true;
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
      ignoreSpace = true;
      path        = "$HOME/${dotDir}/zsh_history";
      save        = 500000;
      share       = true;
      size        = 50000;
    };
    initExtra = ''
      export LS_COLORS="$(${pkgs.vivid}/bin/vivid generate alabaster_dark)"

      source "${pkgs.fzf-git-sh}/share/fzf-git-sh/fzf-git.sh"
      complete -C ${pkgs.awscli2}/bin/aws_completer aws

      source "${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh"

      # from: https://github.com/Aloxaf/fzf-tab?tab=readme-ov-file#configure
      # disable sort when completing `git checkout`
      zstyle ':completion:*:git-checkout:*' sort false
      # set descriptions format to enable group support
      # NOTE: don't use escape sequences here, fzf-tab will ignore them
      zstyle ':completion:*:descriptions' format '[%d]'
      # set list-colors to enable filename colorizing
      zstyle ':completion:*' list-colors ''${(s.:.)LS_COLORS}
      # force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
      zstyle ':completion:*' menu no
      # preview directory's content with eza when completing cd
      zstyle ':fzf-tab:complete:cd:*' fzf-preview '${pkgs.eza}/bin/eza -1 --color=always $realpath'
      zstyle ':fzf-tab:complete:z:*' fzf-preview '${pkgs.eza}/bin/eza -1 --color=always $realpath'
      # switch group using `<` and `>`
      zstyle ':fzf-tab:*' switch-group '<' '>'

      [ -f "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env"
      [ -f "$HOME/.cargo/env" ] && source "$HOME/.cargo/env"

      function m() {
        emacsclient -ne "(man \"$1\")";
      }
    '';
    initExtraBeforeCompInit = ''
      fpath=(${pkgs.zsh-completions}/share/zsh/site-functions $fpath)
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
      e         = "emacsclient";
      gdifft    = "GIT_EXTERNAL_DIFF=${pkgs.difftastic}/bin/difft git diff";
      gls       = "git ls-files | xargs wc -l";
      grep      = "grep --color=auto";
      magit = ''
        (
          PROJECT=$(git rev-parse --show-toplevel) && \
          emacsclient -ne "(progn
            (persp-switch \"''${PROJECT##*/}\")
            (find-file \"$PROJECT\")
            (magit-status))"
        )
      '';
      dired = ''
        (
          DIR=''${''${PWD##*/}:-/}
          emacsclient -ne "(progn
            (persp-switch \"$DIR\")
            (find-file \"$PWD\"))"
        )
      '';
      tree = "${pkgs.eza}/bin/eza --tree";
    } // lib.optionalAttrs isDarwin {
      emacs = ''open "$HOME/Applications/Home Manager Apps/Emacs.app"'';
      google-chrome = ''open "/Applications/Google Chrome.app"'';
    };
  };

  alacritty = {
    enable = true;
    # see https://github.com/alacritty/alacritty/blob/master/extra/man/alacritty.5.scd
    settings = {
      env = { TERM = "xterm-256color"; };
      colors = with config.colorScheme.palette; {
        primary = {
          background = "#${base00}";
          foreground = "#${base07}";
        };
        normal = {
          black   = "#${base00}";
          red     = "#${base08}";
          green   = "#${base0B}";
          yellow  = "#${base0A}";
          blue    = "#${base0D}";
          magenta = "#${base0E}";
          cyan    = "#${base0C}";
          white   = "#${base07}";
        };
      };
      cursor = {
        style.blinking = "On";
        blink_interval = 500;
        blink_timeout = 0;
      };
      window = {
        dimensions = {
          columns = 80;
          lines = 40;
        };
        padding = {
          x = 2;
          y = 2;
        };
        decorations = (if isDarwin then "Buttonless" else "None");
        opacity = 0.95;
        title = "Terminal";
      };
      font = let
        jetbrainsMono = style: {
          family = if isDarwin then "JetBrainsMono Nerd Font" else "JetBrainsMono NF";
          inherit style;
        };
        in {
          size        = if isDarwin then 16.0 else 8.0;
          normal      = jetbrainsMono "Regular";
          bold        = jetbrainsMono "Bold";
          italic      = jetbrainsMono "Italic";
          bold_italic = jetbrainsMono "Bold Italic";
        };
      scrolling.history = 100000;
    } //
    (if isDarwin then {
      # https://github.com/alacritty/alacritty/wiki/Keyboard-mappings#mac-os-4
      key_bindings = [
        { key = "F";     mods = "Command"; chars = "\\u001bf"; }
        { key = "B";     mods = "Command"; chars = "\\u001bb"; }
        { key = "Right"; mods = "Command"; chars = "\\u001bf"; }
        { key = "Left";  mods = "Command"; chars = "\\u001bb"; }
        { key = "Slash"; mods = "Control"; chars = "\\u007f"; }
      ];
    } else {
      shell.program = "${pkgs.zsh}/bin/zsh";
    });
  };

  broot = {
    enable = true;
    enableZshIntegration = true;
    settings.verbs = [
      { key = "ctrl-n"; execution = ":line_down"; }
      { key = "ctrl-p"; execution = ":line_up"; }
      { key = "ctrl-v"; execution = ":page_down"; }
      { key = "alt-v"; execution = ":page_up"; }
    ];
  };

  eza = {
    enable = true;
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
      "--preview '${pkgs.bat}/bin/bat -n --color=always {}'"
      "--preview-window 'hidden'"
      "--bind 'ctrl-/:toggle-preview'"
      "--header 'Press CTRL-/ to toggle preview'"
    ];
  };

  gh = {
    enable = true;
    settings = {
      editor = "emacsclient";
      git_protocol = "ssh";
      aliases = {
        co = "pr checkout";
        pv = "pr view";
        prs = "pr list -A atkpwn";
      };
    };
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
      difft = "difftool --extcmd=${pkgs.difftastic}/bin/difft";
      fixup = "commit --amend --no-edit";
      l     = "log"
              + " --graph"
              + " --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset"
              + " %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'"
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
        builtins.replaceStrings [ "xclip -selection clipboard" "xdg-open" ] [ "pbcopy" "open" ] conf
      else
        conf
    );
    historyLimit = 500000;
    keyMode      = "emacs";
    mouse        = true;
    plugins      = let
      tokyo-night = pkgs.tmuxPlugins.mkTmuxPlugin rec {
        pluginName = "tokyo-night";
        version = "1.5.5";
        rtpFilePath = "tokyo-night.tmux";
        src = pkgs.fetchFromGitHub {
          owner = "janoamaral";
          repo = "tokyo-night-tmux";
          rev = "refs/tags/v${version}";
          hash = "sha256-ATaSfJSg/Hhsd4LwoUgHkAApcWZV3O3kLOn61r1Vbag=";
        };
        extraConfig = ''
        set -g @tokyo-night-tmux_window_id_style none
        set -g @tokyo-night-tmux_pane_id_style hide
        set -g @tokyo-night-tmux_zoom_id_style hide # dsquare
        set -g @tokyo-night-tmux_show_git 0
      '';
      };
      catppuccin = {
        plugin = catppuccin;
        extraConfig = "set -g @catppuccin_flavour 'mocha'";
      };
    in [
      pkgs.tmuxPlugins.resurrect
      tokyo-night
    ];
    prefix   = "C-z";
    shell    = "${pkgs.zsh}/bin/zsh";
    terminal = "xterm-256color";
  };

  zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration  = true;
  };
}
