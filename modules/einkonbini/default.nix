{ config, pkgs, ... }:

let
  inherit (pkgs) lib;
  home = config.home.homeDirectory;
in {
  programs = {
    zsh.dirHashes = {
      konbini = "${home}/projects/einkonbini";
    };

    git = {
      settings = {
        "includeIf \"gitdir:~/projects/einkonbini/\"".path =
          "${config.xdg.configHome}/home-manager/modules/einkonbini/git.config";
      };
    };

    ssh = {
      extraConfig = lib.mkOrder 1200 ''
        Include ${config.xdg.configHome}/home-manager/modules/einkonbini/ssh.config
      '';
    };
  };
}
