{ pkgs, ... }:
{
  home.packages = with pkgs; [
    kubectl
    (callPackage ./kubectl-argo-rollouts.nix {})

    k9s
    kustomize
    minikube
    skaffold
    stern
  ] ++ (
    if pkgs.stdenv.hostPlatform.isDarwin
    then [
      colima
    ]
    else []
  );
}
