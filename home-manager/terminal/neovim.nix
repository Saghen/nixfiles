# Requires cloning nvim config manually
# git clone https://github.com/saghen/nvim ~/.config/nvim

{ pkgs, config, ... }:

{
  home = {
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
  };

  programs.neovim = {
    enable = true;

    defaultEditor = true;

    extraLuaConfig = ''
      -- required for smart-open.nvim
      vim.g.sqlite_clib_path = "${pkgs.sqlite.out}/lib/libsqlite3.so"

      vim.g.colors = {
        crust = "${config.colors.crust}",
        mantle = "${config.colors.mantle}",
        base = "${config.colors.base}",
        core = "${config.colors.core}",

        surface_0 = "${config.colors.surface-0}",
        surface_1 = "${config.colors.surface-1}",
        surface_2 = "${config.colors.surface-2}",

        overlay_0 = "${config.colors.overlay-0}",
        overlay_1 = "${config.colors.overlay-1}",
        overlay_2 = "${config.colors.overlay-2}",

        subtext_0 = "${config.colors.subtext-0}",
        subtext_1 = "${config.colors.subtext-1}",
        subtext_2 = "${config.colors.subtext-2}",
        text = "${config.colors.text}",

        lavender = "${config.colors.lavender}",
        lavender_dark = "${config.colors.lavender-dark}",

        blue = "${config.colors.blue}",
        blue_dark = "${config.colors.blue-dark}",

        sapphire = "${config.colors.sapphire}",
        sapphire_dark = "${config.colors.sapphire-dark}",

        sky = "${config.colors.sky}",
        sky_dark = "${config.colors.sky-dark}",

        teal = "${config.colors.teal}",
        teal_dark = "${config.colors.teal-dark}",

        green = "${config.colors.green}",
        green_dark = "${config.colors.green-dark}",

        yellow = "${config.colors.yellow}",
        yellow_dark = "${config.colors.yellow-dark}",

        peach = "${config.colors.peach}",
        peach_dark = "${config.colors.peach-dark}",

        maroon = "${config.colors.maroon}",
        maroon_dark = "${config.colors.maroon-dark}",

        red = "${config.colors.red}",
        red_dark = "${config.colors.red-dark}",

        mauve = "${config.colors.mauve}",
        mauve_dark = "${config.colors.mauve-dark}",

        pink = "${config.colors.pink}",

        flamingo = "${config.colors.flamingo}",

        rosewater = "${config.colors.rosewater}",

        cyan = "${config.colors.cyan}",
      }

      -- bootstrap lazy.nvim, lazyvim and my plugins
      require('config.lazy')
    '';

    # for image.nvim
    # extraLuaPackages = ps: with ps; [ magick ];

    extraPackages = with pkgs; [
      tree-sitter

      # for image.nvim
      imagemagick

      ## LSPs, formatters, linters
      # fp
      nodePackages.purescript-language-server
      haskell-language-server
      # kubernetes
      helm-ls
      yaml-language-server
      # lua
      lua-language-server
      stylua
      # misc
      bash-language-server
      # nix
      nil
      nixfmt-classic
      # python
      black
      pyright
      ruff-lsp
      # rust
      # NOTE: rust-analyzer is managed by rustup via: rustup component add rust-analyzer
      graphviz # for crate graph visualization
      # terraform
      terraform-ls
      tflint
      # web
      prettierd
      vscode-langservers-extracted # eslint, css, html, markdown, json
      biome
      nodePackages.svelte-language-server
      nodePackages.typescript-language-server
      # todo: vtsls
    ];
  };
}

