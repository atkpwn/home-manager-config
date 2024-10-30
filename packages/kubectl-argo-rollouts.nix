{ pkgs }:

pkgs.stdenv.mkDerivation rec {
  pname = "kubectl-argo-rollouts";
  version = "1.7.2";
  src = pkgs.fetchurl {
    url = "https://github.com/argoproj/argo-rollouts/releases/download/v${version}/${pname}-linux-amd64";
    hash = "sha256-r36sZZO7ysTiGZYJleePaks7seaqR+FaSVvrGk0toXc=";
  };
  phases = [ "installPhase" ];
  installPhase = ''
    mkdir -p $out/bin
        cp $src $out/bin/kubectl-argo-rollouts
        chmod +x $out/bin/kubectl-argo-rollouts
  '';
  meta.platforms = pkgs.lib.platforms.linux;
}
