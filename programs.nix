{ config, pkgs, ... }:

let
  inherit (pkgs) lib;
  inherit (pkgs.stdenv.hostPlatform) isDarwin;
  defaultFont = "JetBrainsMono Nerd Font";
  home = config.home.homeDirectory;
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
      "exit"
      "eza"
      "history"
      "ls"
      "pophist"
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
      dl = "${home}/Downloads";
    };
    dotDir = "${config.xdg.configHome}/zsh";
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
      path        = "${dotDir}/history";
      save        = 500000;
      share       = true;
      size        = 50000;
    };
    initContent = let
      zshConfigEarlyInit = lib.mkOrder 500 ''
        fpath=(${pkgs.zsh-completions}/share/zsh/site-functions $fpath)
        fpath=(${pkgs.deno}/share/zsh/site-functions $fpath)
        fpath=(${pkgs.gradle-completion}/share/zsh/site-functions $fpath)
        fpath=(${pkgs.pass}/share/zsh/site-functions $fpath)
      '';
      zshConfig = lib.mkOrder 1000 ''
        export LS_COLORS="$(${pkgs.vivid}/bin/vivid generate alabaster_dark)"

        source "${pkgs.fzf-git-sh}/share/fzf-git-sh/fzf-git.sh"

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
        # custom fzf flags
        # NOTE: fzf-tab does not follow FZF_DEFAULT_OPTS by default
        zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2 --bind=tab:accept
        # To make fzf-tab follow FZF_DEFAULT_OPTS.
        # NOTE: This may lead to unexpected behavior since some flags break this plugin. See Aloxaf/fzf-tab#455.
        zstyle ':fzf-tab:*' use-fzf-default-opts yes
        # switch group using `<` and `>`
        zstyle ':fzf-tab:*' switch-group '<' '>'

        [ -f "${home}/.ghcup/env" ] && source "$HOME/.ghcup/env"
        [ -f "${home}/.cargo/env" ] && source "$HOME/.cargo/env"

        function m() {
          emacsclient -ne "(man \"$1\")";
        }

        function magit() {
          PROJECT=$(git rev-parse --show-toplevel 2> /dev/null)
          emacsclient -ne "(progn
            (persp-switch \"''${1:-$(basename $PROJECT)}\")
            (find-file \"$PROJECT\")
            (magit-status))"
        }
      '';
    in lib.mkMerge [
      zshConfigEarlyInit
      zshConfig
    ];
    profileExtra = lib.optionalString isDarwin ''
      if [[ -f '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]]; then
        source '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
        export NIX_PATH="${home}/.nix-defexpr"
      fi
    '';
    shellAliases = {
      ".."      = "cd ..";
      "..."     = "cd .. && cd ..";
      clipboard = (if isDarwin then "pbcopy" else "xclip -sel clip");
      e         = "emacsclient";
      g         = "git";
      gm        = "git checkout main";
      gdifft    = "GIT_EXTERNAL_DIFF=${pkgs.difftastic}/bin/difft git diff";
      gl        = "git l -10";
      gls       = "git ls-files | xargs wc -l";
      gmp       = "git checkout main && git pull";
      gp        = "git pull";
      p         = "cd $(git rev-parse --show-toplevel)";
      grep      = "grep --color=auto";
      k         = "${pkgs.kubectl}/bin/kubectl";
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
      emacs = ''open "${home}/Applications/Home Manager Apps/Emacs.app"'';
      google-chrome = ''open "/Applications/Google Chrome.app"'';
    };
  };

  alacritty = {
    enable = true;
    # see https://github.com/alacritty/alacritty/blob/master/extra/man/alacritty.5.scd
    settings = {
      env = { TERM = "xterm-256color"; };
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
          family = defaultFont;
          inherit style;
        };
        in {
          size        = 16.0;
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
      terminal.shell = "${pkgs.zsh}/bin/zsh";
    });
  };

  ghostty = {
    enable = true;
    enableZshIntegration = true;
    package = if isDarwin then pkgs.ghostty-bin else pkgs.ghostty;
    settings = {
      title = "Ghostty";
      theme = "Arthur";
      font-family = defaultFont;
      font-size = 16;
      background-opacity = 0.9;
      gtk-titlebar = false;
      macos-option-as-alt = true;
      mouse-hide-while-typing = true;
      window-decoration = false;
      keybind = if isDarwin then [
        "cmd+f=esc:f"
        "cmd+b=esc:b"
      ] else [];
    };
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

  delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      # see https://dandavison.github.io/delta/full---help-output.html
      plus-style = "syntax bold '#1A3A1A'";
    };
  };

  direnv = {
    enable = true;
    enableZshIntegration = true;
  };

  eza = {
    enable = true;
    extraOptions = [
      "--group-directories-first"
      "--header"
    ];
    git   = true;
    icons = "auto";
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
        co  = "pr checkout";
        b   = "browse";
        pv  = "pr view";
        prs = "pr list -A atkpwn";
        create = "repo create --private --source=. --remote=origin";
      };
    };
  };

  gh-dash = {
    enable = true;
    settings = {
      prSections = [
        {
          title = "My Pull Requests";
          filters = "is:open author:@me";
        }
        {
          title = "Involed";
          filters = ''is:open involves:@me -author:@me updated>={{ nowModify "-2w" }}'';
        }
      ];
    };
  };

  git = {
    enable = true;
    settings = {
      user  = {
        name  = "Attakorn Putwattana";
        email = "atkpwn@gmail.com";
      };
      alias = {
        # some from https://github.com/nvie/git-toolbelt
        b     = "branch --color -v";
        c     = "checkout";
        cb    = "checkout -b";
        cm    = "checkout master";
        cp    = "cherry-pick";
        d     = "diff";
        difft = "difftool --extcmd=${pkgs.difftastic}/bin/difft";
        fixup = "commit --amend --no-edit";
        l     = "log"
              + " --graph"
              + " --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset"
              + " %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'"
              + " --abbrev-commit --date=relative";
        lol   = "log --graph --oneline --decorate --color --all";
        hist  = "log --follow -p --";
        p     = "pull";
        s     = "status";
        sign-after = "rebase -i --exec 'git commit --amend --no-edit --no-verify -S'";
        sub   = "submodule";
        subu  = "submodule update --init --recursive";
        undo  = "reset --soft HEAD^";
        w     = "worktree";
        wa    = "worktree add"; # ../directory branch
        wl    = "worktree list";
        wrc   = "worktree remove .";
      };
      init.defaultBranch = "main";
      core = {
        editor     = "emacsclient";
        trustctime = false;
        whitespace = "trailing-space,space-before-tab";
      };

      # https://youtu.be/aolI_Rz0ZqY at 17:23
      column = {
	      ui = "auto";
      };
      branch = {
	      sort = "-committerdate";
      };
      maintenance = {
	      auto = false;
	      strategy = "incremental";
      };

      submodule = {
        recurse = true;
      };

      "url \"git@github.com:\"".insteadOf = "https://github.com/";
    };
  };

  gpg = {
    enable = true;
    homedir = "${config.xdg.configHome}/gnupg";
  };

  password-store = {
    enable = true;
    package = pkgs.pass.withExtensions (exts: [
      exts.pass-otp
      exts.pass-genphrase
    ]);
    settings.PASSWORD_STORE_DIR = "${home}/.password-store";
  };

  starship = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration  = true;
    settings = {
      add_newline     = isDarwin;
      command_timeout = 2000;
      aws.format      = ''[($symbol$profile )(\[$duration\] )]($style)'';
      right_format = "$time";
      time = {
        disabled = false;
        format   = "[$time]($style)";
        style    = "fg:#646864";
      };
    };
  };

  ssh = {
    enable = true;
    enableDefaultConfig = false;
    extraConfig = ''
    '';
    matchBlocks = {
      bitbucket = {
        host           = "bitbucket.org";
        identitiesOnly = true;
        identityFile   = "${home}/.ssh/bigfoot";
      };
      github = {
        host           = "github.com";
        identitiesOnly = true;
        identityFile   = "${home}/.ssh/bigfoot";
      };
      "*" = {
        addKeysToAgent = "no";
        compression = false;
        controlMaster = "no";
        controlPath = "~/.ssh/master-%r@%n:%p";
        controlPersist = "no";
        forwardAgent   = false;
        # hashKnownHosts = true;
        serverAliveCountMax = 3;
        serverAliveInterval = 60;
        userKnownHostsFile  = "${home}/.ssh/known_hosts";
        extraOptions = {
          ConnectTimeout = "5";
          IgnoreUnknown  = "UseKeychain";
          UseKeychain    = "yes";
        };
      };
    };
  };

  tmux = {
    enable           = true;
    aggressiveResize = true;
    baseIndex        = 1;
    clock24          = true;
    customPaneNavigationAndResize = true;
    escapeTime       = 0;
    extraConfig = (let conf = (builtins.readFile ./config/tmux/tmux.conf); in
      if isDarwin then
        builtins.replaceStrings [ "xclip -selection clipboard" "xdg-open" ] [ "pbcopy" "open" ] conf
      else
        conf
    );
    historyLimit = 500000;
    keyMode      = "emacs";
    mouse        = true;
    plugins      = let
      catppuccin = {
        plugin = pkgs.tmuxPlugins.catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavor "mocha"
          set -g @catppuccin_window_status_style "rounded"
          set -g status-right-length 100
          set -g status-left-length 100
          set -g status-left ""

          set -g status-right "#{E:@catppuccin_status_application}"
          set -ag status-right "#{E:@catppuccin_status_session}"
          set -agF status-right "#{E:@catppuccin_status_battery}"

          set -g @catppuccin_window_current_text "#{?#{!=:#{window_name},}, #W,}"
          set -g @catppuccin_window_text "#{?#{!=:#{window_name},}, #W,}"
        '';
      };
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
          set -g @tokyo-night-tmux_show_datetime 0
        '';
      };
      yank = {
        plugin = pkgs.tmuxPlugins.yank;
        extraConfig = ''
          set -g @yank_action "copy-pipe"
        '';
      };
    in with pkgs.tmuxPlugins; [
      battery
      copycat
      # catppuccin
      # cpu
      resurrect
      tokyo-night
      yank
    ];
    prefix   = "C-z";
    shell    = "${pkgs.zsh}/bin/zsh";
    terminal = "xterm-256color";
  };

  zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration  = true;
    options = [
      # "--cmd cd"
    ];
  };
}
