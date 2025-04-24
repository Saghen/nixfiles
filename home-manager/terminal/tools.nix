{ pkgs, config, inputs, ... }:

{
  # rust packages
  home.sessionPath = [ "$HOME/.config/cargo/bin" ];

  home.packages = with pkgs; [
    # tools
    nh # nix helper
    procps # pkill watch top sysctl etc...
    tldr # cheatsheets
    # thefuck # ...
    eza # better ls
    fd # better find
    sd # better sed
    jq # transform json
    fx # interfactive view and transform json with actual js
    yq-go # jq for yaml
    fzf # fuzzy finder
    gh # github cli FIXME: stores credentials in plain text
    trash-cli # put items into the trash
    playerctl # interact with mpris players
    pulseaudio # utilities like pactl
    twitch-cli # login to twitch, used by some scripts
    xdo # send commands to X
    # google cloud sdk with GKE auth support
    (pkgs.google-cloud-sdk.withExtraComponents
      (with pkgs.google-cloud-sdk.components; [ gke-gcloud-auth-plugin ]))
    nix-index # provides nix-locate

    claude-code # AI coding

    # devops
    terraform # FIXME: stores credentials in plain text
    kubectl
    kustomize
    krew # package manager for kubectl
    kubectx # fast namespace and context switching
    kubecolor # colorized kubectl output
    kubernetes-helm # k8s package manager
    talosctl # Talos (k8s OS)
    omnictl # SaaS for Talos management

    # languages
    go
    python3
    bun
    deno
    nodejs_22
    corepack_22
    gcc
    gnumake
    lux-cli
    (fenix.complete.withComponents [
      "cargo"
      "clippy"
      "rust-src"
      "rustc"
      "rustfmt"
    ])
    cargo-wizard # subcommand for configuring projects for best performance
    rust-analyzer-nightly
    pkg-config
  ];

  # Move a bunch of random dirs to XDG dirs
  home.sessionVariables = let
    home = "/home/${config.home.username}";
    cache = "${home}/.cache";
    cfg = "${home}/.config";
    data = "${home}/.local/share";
    state = "${home}/.local/state";
    # todo: find the UID of the user
    runtime = "/run/user/1000";
  in {
    CUDA_CACHE_PATH = "${cache}/nv";
    PNPM_HOME = "${data}/pnpm";
    NODE_REPL_HISTORY = "${data}/node_repl_history";
    NPM_CONFIG_PREFIX = "${data}/npm";
    NPM_CONFIG_CACHE = "${cache}/npm";
    NPM_CONFIG_TMP = "${runtime}/npm";
    CARGO_HOME = "${cfg}/cargo";
    RUSTUP_HOME = "${data}/rust";
    GOPATH = "${data}/go";
    W3M_DIR = "${data}/w3m";
    XCOMPOSECACHE = "${cache}/X11/xcompose";
    KUBECONFIG = "${cfg}/kube/config";
    KREW_ROOT = "${data}/krew";
    DOCKER_CONFIG = "${cfg}/docker";
    PYTHON_HISTORY = "${state}/python/history";
    HISTFILE = "${state}/bash/history";
  };
  xdg.configFile = {
    cargo = {
      target = "cargo/config.toml";
      text = ''
        [net]
        git-fetch-with-cli = true
      '';
    };
  };

  services = {
    ssh-agent.enable = true;

    gpg-agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-tty;
      extraConfig = ''
        allow-loopback-pinentry
      '';
    };
  };

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
        "hf.co" = {
          hostname = "hf.co";
          user = "git";
          identityFile = "~/.ssh/id_github";
          identitiesOnly = true;
        };
        factorio = {
          hostname = "178.156.133.223";
          user = "root";
          identityFile = "/etc/ssh/ssh_host_ed25519_key";
          identitiesOnly = true;
        };
      };
    };

    gpg = {
      enable = true;
      settings = { pinentry-mode = "loopback"; };
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
          "ssh://git@hf.co" = { insteadOf = "https://huggingface.co"; };
        };
        init = { defaultBranch = "main"; };
        pull = { rebase = true; };
      };
    };

    # better grep
    ripgrep = {
      enable = true;
      arguments = [ "--smart-case" "--colors" "match:fg:magenta" ];
    };

    # z for jumping between directories
    zoxide.enable = true;

    # get dat metadata for music
    beets = {
      enable = false;
      settings = {
        plugins = [
          "lyrics"
          "replaygain"
          "scrub"
          "lastgenre"
          "fetchart"
          "duplicates"
          "chroma"
        ];
        replaygain.backend = "gstreamer";
        duplicates = {
          checksum = "fpcalc -plain {file}";
          # prefer files in full albums vs singles, but sometimes this doesn't work
          # and you need to reconcile manually
          tiebreak.items = [ "tracktotal" ];
        };
      };
    };
  };
}
