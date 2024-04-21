{ pkgs, ... }:

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

    # devops
    terraform
    kubectl
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
