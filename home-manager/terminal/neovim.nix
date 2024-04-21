{ pkgs, ... }:

{
  home = {
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };

  programs.neovim = {
    enable = true;
    package = pkgs.neovim-nightly;

    defaultEditor = true;

    extraLuaConfig = ''
      -- bootstrap lazy.nvim, lazyvim and my plugins
      require('config.lazy')
    '';

    extraPackages = with pkgs; [
      tree-sitter
      ## LSPs, formatters, linters
      # kubernetes
      helm-ls
      yaml-language-server
      # lua
      lua-language-server
      stylua
      # misc
      nodePackages.bash-language-server
      # nix
      nil
      nixfmt-classic
      # python
      black
      nodePackages.pyright
      ruff-lsp
      # terraform
      terraform-ls
      tflint
      # web
      nodePackages.prettier
      nodePackages.eslint
      biome
      nodePackages.svelte-language-server
      nodePackages.typescript-language-server
      # todo: vtsls
    ];
  };
}

