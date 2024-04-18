{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # tools
    fd # better find
    jq # transform json
    yq # jq for yaml
    fzf # fuzzy finder
    gh # github cli

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
  programs = {
    ssh.enable = true;

    # cat with syntax highlighting
    bat = {
      enable = true;
      config = { theme = "base16"; };
    };

    git = {
      enable = true;
      userEmail = "liamcdyer@gmail.com";
      userName = "Liam Dyer";
      signing = {
        signByDefault = true;
        key = "A8F94F230A4470B1";
      };
      extraConfig = {
        core = {
          excludesfile = "~/.gitignore_global";
        };
        url = {
          "ssh://git@github.com" = {
            insteadOf = "https://github.com";
          };
        };
        init = {
          defaultBranch = "main";
        };
      };
    };

    # better grep
    ripgrep = {
      enable = true;
      arguments = ["--smart-case" "--colors" "match:fg:magenta"];
    };

    # z for jumping between directories
    zoxide.enable = true;
  };
}
