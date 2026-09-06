{ config, pkgs, ... }: {
  home = {
    file = pkgs.lib.optionalAttrs pkgs.stdenv.hostPlatform.isDarwin {
      ".docker/run/docker.sock".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.colima/docker.sock";
    };

    packages = with pkgs; [
      # kubectl # use from minikube

      argo-rollouts
      k9s
      (wrapHelm kubernetes-helm { plugins = with kubernetes-helmPlugins; [
        helm-diff
      ]; })
      kustomize
      minikube
      skaffold
      stern
    ]
    ++ lib.optionals pkgs.stdenv.hostPlatform.isDarwin [
      colima
    ];
  };

  programs = {
    k9s = {
      enable = true;
      plugins = import ./k9s-plugins.nix { inherit pkgs; };
    };
  };
}
