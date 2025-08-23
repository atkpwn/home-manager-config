{ pkgs }:

pkgs.writeShellScriptBin "pophist" ''
  ${pkgs.gnused}/bin/sed -i '$d' ''${HISTFILE}
''
