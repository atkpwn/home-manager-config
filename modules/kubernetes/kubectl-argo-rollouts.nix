{ pkgs }:

pkgs.stdenv.mkDerivation rec {
  pname = "kubectl-argo-rollouts";
  version = "1.8.0";
  src = pkgs.fetchurl {
    url = "https://github.com/argoproj/argo-rollouts/releases/download/v${version}/${pname}-linux-amd64";
    # nix hash convert --hash-algo sha256 $(nix-prefetch-url https://github.com/argoproj/argo-rollouts/releases/download/v1.8.0/kubectl-argo-rollouts-linux-amd64)
    hash = "sha256-0n5TrWfwp0oJIp27u9flXDWYkTh9aJxnp7effhkdgE8=";
  };
  phases = [ "installPhase" ];
  installPhase = ''
    mkdir -p $out/bin
        cp $src $out/bin/kubectl-argo-rollouts
        chmod +x $out/bin/kubectl-argo-rollouts
  '';
  meta.platforms = pkgs.lib.platforms.linux;
}
