{ pkgs, ... }:
let
  kubectlFlags = "--context $CONTEXT --namespace $NAMESPACE";
in {
  argo-rollouts-get = {
    shortCut = "g";
    confirm = false;
    description = "Get details";
    scopes = ["rollouts"];
    command = "bash";
    background = false;
    args = [
      "-c"
      "kubectl argo rollouts get rollout $NAME ${kubectlFlags} 2>&1 | less -R --header 15"
    ];
  };

  argo-rollouts-watch = {
    shortCut = "Shift-W";
    confirm = false;
    description = "Watch live updates";
    scopes = ["rollouts"];
    command = "bash";
    background = false;
    args = [
      "-c"
      "kubectl argo rollouts get rollout $NAME ${kubectlFlags} -w"
    ];
  };

  argo-rollouts-promote = {
    shortCut = "Shift-P";
    confirm = true;
    description = "Promote a rollout";
    scopes = ["rollouts"];
    command = "bash";
    background = false;
    args = [
      "-c"
      "kubectl argo rollouts promote $NAME ${kubectlFlags} 2>&1 | less -R"
    ];
  };

  argo-rollouts-promote-full = {
    shortCut = "Shift-F";
    confirm = true;
    description = "Promote full";
    scopes = ["rollouts"];
    command = "bash";
    background = false;
    args = [
      "-c"
      "kubectl argo rollouts promote $NAME --full ${kubectlFlags} 2>&1 | less -R"
    ];
  };

  argo-rollouts-restart = {
    shortCut = "r";
    confirm = true;
    description = "Restart";
    scopes = ["rollouts"];
    command = "bash";
    background = false;
    args = [
      "-c"
      "kubectl argo rollouts restart $NAME ${kubectlFlags} 2>&1 | less -R"
    ];
  };

  argo-rollouts-undo = {
    shortCut = "Shift-R";
    confirm = true;
    description = "Roll back";
    scopes = ["rollouts"];
    command = "bash";
    background = false;
    args = [
      "-c"
      "kubectl argo rollouts undo $NAME ${kubectlFlags} 2>&1 | less -R"
    ];
  };
}
//
(let
  helmFlags = "--kube-context $CONTEXT --namespace $NAMESPACE";
  release = "$(echo $NAME | cut -d':' -f1)";
  latestRevision = "$(helm ${helmFlags} history ${release} -o json | jq -r 'map(select(.status == \"deployed\")) | last | .revision')";
  # k9s pipes every substituted value through Go's strconv.ParseBool and, when it parses, rewrites
  # the value as "true"/"false" (internal/view/env.go in v0.51.0).  ParseBool accepts "1" and "0",
  # so revision 1 reaches the plugin as "true" and revision 0 as "false". Undo that. This is a
  # value: interpolate it wherever the revision is needed.
  selectedRevision = "$(printf '%s' \"$COL-REVISION\" | sed -e 's/^true$/1/' -e 's/^false$/0/')";
in {
  helm-diff-previous = {
    shortCut = "Shift-D";
    confirm = false;
    description = "Compare with the previous revision";
    scopes = ["helm"];
    command = "bash";
    background = false;
    args = [
      "-c"
      "rev=${selectedRevision}; helm ${helmFlags} diff revision $COL-NAME $(( rev )) $(( rev - 1 )) --color 2>&1 | less -R"
    ];
  };

  helm-diff-current = {
    shortCut = "Shift-D";
    confirm = false;
    description = "Compare with the latest revision";
    scopes = ["history"];
    command = "bash";
    background = false;
    args = [
      "-c"
      "helm ${helmFlags} diff revision ${release} ${latestRevision} ${selectedRevision} --color 2>&1 | less -R"
    ];
  };
})
//
(let
  clipboard = if pkgs.stdenv.hostPlatform.isDarwin then "pbcopy" else "${pkgs.xclip}/bin/xclip -sel clip";
in {
  secret-tls-crt-read = {
    shortCut = "Ctrl-X";
    confirm = false;
    description = "Read `tls.crt`";
    scopes = ["secrets"];
    command = "bash";
    background = false;
    args = [
      "-c"
      "kubectl ${kubectlFlags} get secret $NAME -o jsonpath='{.data.tls\\.crt}' | base64 -d | openssl x509 -noout -text | less -R"
    ];
  };

  secret-tls-crt-copy = {
    shortCut = "Ctrl-Y";
    confirm = false;
    description = "Copy `tls.crt` to clipboard";
    scopes = ["secrets"];
    command = "bash";
    background = false;
    args = [
      "-c"
      "kubectl ${kubectlFlags} get secret $NAME -o jsonpath='{.data.tls\\.crt}' | base64 -d | ${clipboard}"
    ];
  };

  secret-ca-crt-read = {
    shortCut = "Shift-X";
    confirm = false;
    description = "Read `ca.crt`";
    scopes = ["secrets"];
    command = "bash";
    background = false;
    args = [
      "-c"
      "kubectl ${kubectlFlags} get secret $NAME -o jsonpath='{.data.ca\\.crt}' | base64 -d | openssl x509 -noout -text | less -R"
    ];
  };

  secret-ca-crt-copy = {
    shortCut = "Shift-Y";
    confirm = false;
    description = "Copy `ca.crt` to clipboard";
    scopes = ["secrets"];
    command = "bash";
    background = false;
    args = [
      "-c"
      "kubectl ${kubectlFlags} get secret $NAME -o jsonpath='{.data.ca\\.crt}' | base64 -d | ${clipboard}"
    ];
  };
})
