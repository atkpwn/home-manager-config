{ pkgs, ... }:
{
  home.packages = with pkgs; [
    kubectl

    argo-rollouts
    k9s
    kubernetes-helm
    kustomize
    minikube
    skaffold
    stern
  ] ++ (if pkgs.stdenv.hostPlatform.isDarwin
  then [
    colima
  ]
  else []
  );
}
