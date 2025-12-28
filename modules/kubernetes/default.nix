{ pkgs, ... }:
{
  home.packages = with pkgs; [
    kubectl

    argo-rollouts
    helm
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
