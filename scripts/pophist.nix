{ pkgs }:

pkgs.writeShellScriptBin "pophist" ''
  HIST=~/.config/zsh/history
  ${pkgs.gnused}/bin/sed -i '$ d' ''${HIST}
''
