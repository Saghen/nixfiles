{ pkgs, config, ... }:

{
  home.packages = with pkgs; [
    # tools
    procps # pkill watch top sysctl etc...
    fd # better find
    jq # transform json
    yq # jq for yaml
    fzf # fuzzy finder
    gh # github cli FIXME: stores credentials in plain text
    trash-cli # put items into the trash
    playerctl # interact with mpris players
    pulseaudio # utilities like pactl
    twitch-cli # login to twitch, used by some scripts
    # google cloud sdk with GKE auth support
    (pkgs.google-cloud-sdk.withExtraComponents
      (with pkgs.google-cloud-sdk.components; [ gke-gcloud-auth-plugin ]))

    # devops
    terraform # FIXME: stores credentials in plain text
    kubectl
    kustomize
    kubectx # fast namespace and context switching
    kubecolor # colorized kubectl output
    kubernetes-helm # k8s package manager

    # languages
    go
    python3
    poetry
    rustup
    bun
    deno
    nodejs_21
    nodePackages.pnpm
    gcc
    gnumake
  ];

  # Move a bunch of random dirs to XDG dirs
  home.sessionVariables = let
    home = "/home/${config.home.username}";
    cache = "${home}/.cache";
    cfg = "${home}/.config";
    data = "${home}/.local/share";
    # todo: find the UID of the user
    runtime = "/run/user/1000";
  in {
    CUDA_CACHE_PATH = "${cache}/nv";
    PNPM_HOME = "${data}/pnpm";
    NODE_REPL_HISTORY = "${data}/node_repl_history";
    NPM_CONFIG_PREFIX = "${data}/npm";
    NPM_CONFIG_CACHE = "${cache}/npm";
    NPM_CONFIG_TMP = "${runtime}/npm";
    CARGO_HOME = "${data}/cargo";
    RUSTUP_HOME = "${data}/rust";
    GOPATH = "${data}/go";
    W3M_DIR = "${data}/w3m";
    XCOMPOSECACHE = "${cache}/X11/xcompose";
    KUBECONFIG = "${cfg}/kube/config";
  };

  services.ssh-agent.enable = true;
  programs = {
    ssh = {
      enable = true;
      matchBlocks = {
        "github.com" = {
          hostname = "github.com";
          user = "git";
          identityFile = "~/.ssh/id_github";
          identitiesOnly = true;
        };
      };
    };

    # cat with syntax highlighting
    bat = {
      enable = true;
      config = { theme = "base16"; };
    };

    git = {
      enable = true;
      lfs.enable = true;
      userEmail = "liamcdyer@gmail.com";
      userName = "Liam Dyer";
      signing = {
        signByDefault = true;
        key = "A8F94F230A4470B1";
      };
      extraConfig = {
        core = { excludesfile = "~/.gitignore_global"; };
        url = {
          "ssh://git@github.com" = { insteadOf = "https://github.com"; };
        };
        init = { defaultBranch = "main"; };
      };
    };

    # better grep
    ripgrep = {
      enable = true;
      arguments = [ "--smart-case" "--colors" "match:fg:magenta" ];
    };

    # z for jumping between directories
    zoxide.enable = true;
  };
}
