{ pkgs }:

pkgs.writeShellApplication {
  name = "lombok2envrc";

  runtimeInputs = with pkgs; [
    fzf
  ];

  text = builtins.readFile ./lombok2envrc.sh;

  bashOptions = [
    "errexit"
    # "nounset" # this is set by default option
    "pipefail"
  ];
}
