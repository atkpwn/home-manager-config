{ pkgs }:

pkgs.writeShellApplication {
  name = "pophist";

  runtimeInputs = with pkgs; [ gnused ];

  text = ''
    sed -i '$d' "''${HOME}/.config/zsh/history"
  '';

  bashOptions = [
    "errexit"
    # "nounset" # allow unbound variable
    "pipefail"
  ];
}
