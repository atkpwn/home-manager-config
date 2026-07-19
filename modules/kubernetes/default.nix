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
      kustomize
      minikube
      skaffold
      stern
    ]
    ++ lib.optionals pkgs.stdenv.hostPlatform.isDarwin [
      colima
    ];
  };
}
