{ pkgs, ... }:

{
  programs = {
    fish = {
      enable = true;
      functions = {
        f = "thefuck";
        l = "eza";
        # disables greeting
        fish_greeting = "";
        # color for kubectl
        kubectl = "kubecolor $argv";
        # nix
        nr = "nix run nixpkgs#$argv[1] $argv[2..-1]";
        ns = "nix-shell --run fish $argv";
        nsp = "nix-shell --run fish -p $argv";
        nb = "nix build nixpkgs#$argv";
        nbp =
          "nix-build -E 'with import <nixpkgs> {}; callPackage ./default.nix {}' $argv";

        npr = "npm run --silent $argv";
        pnpr = "pnpm run --silent $argv";

        # customize transcient prompt
        starship_transient_prompt_func =
          "starship module directory && starship module character";
      };
      shellAbbrs = {
        cd = "z";
        n = "nvim";
        e = "exit";
        # kubectl plugin covers most except these ones
        kx = "kubectx";
        kn = "kubens";
        kg = "kubectl get";
        kd = "kubectl describe";
      };
      interactiveShellInit = ''
        # Use backward-kill-bigword to act like W in vim
        bind \b backward-kill-word
        bind \t complete-and-search

        # for krew
        # TODO: should be a better way?
        set -gx PATH $PATH $KREW_ROOT/bin

        fzf_configure_bindings
      '';
      plugins = with pkgs;
        with fishPlugins; [
          # package manager
          {
            name = "fisher";
            src = fetchFromGitHub {
              owner = "jorgebucaran";
              repo = "fisher";
              rev = "2efd33ccd0777ece3f58895a093f32932bd377b6";
              sha256 = "sha256-e8gIaVbuUzTwKtuMPNXBT5STeddYqQegduWBtURLT3M=";
            };
          }
          # guess
          {
            name = "autopair";
            src = autopair.src;
          }
          # adds support for fzf keybinds
          {
            name = "fzf.fish";
            src = fzf-fish.src;
          }
          # text expansions such as .., !! and others
          {
            name = "puffer";
            src = puffer.src;
          }
          # adds kubectl abbretions
          {
            name = "kubectl";
            src = fetchFromGitHub {
              owner = "blackjid";
              repo = "plugin-kubectl";
              rev = "f3cc9003077a3e2b5f45e3988817a78e959d4131";
              sha256 = "017nnk56j3llk39d48isyzs4mf7nbd00jywz00g9bprm6d5xa700";
            };
          }
        ];
    };

    # sqlite history
    atuin = {
      enable = true;
      flags = [ "--disable-up-arrow" ];
      settings = {
        sync_address = "https://atuin.super.fish";
        style = "compact";
        enter_accept = true;
      };
    };

    # prompt
    starship = {
      enable = true;
      enableTransience = true;
      settings = {
        # instead of this, we defined a function --on-event fish-prompt
        # that runs echo. this 
        add_newline = true;

        container = {
          format = "[$symbol]($style) ";
          style = "bold red";
        };

        # Replace the "❯" symbol in the prompt with "~>"
        character = {
          success_symbol = "[~>](green)";
          error_symbol = "[~>](blue)";
        };

        # Pure preset
        # https://starship.rs/presets/pure-preset
        # with my own customizations
        format =
          "$username$hostname$directory$git_branch$git_state$git_status$cmd_duration$c$cmake$cobot$crystal$dart$elixer$elm$fennel$golang$guix_shell$haskell$haxe$java$julia$kotlin$lua$meson$nim$nix_shell$nodejs$ocaml$perl$php$pijul_channel$python$rlang$ruby$rust$scala$swift$zig$line_break$character";
        directory.style = "blue";
        git_branch = {
          format = "[$branch]($style)";
          style = "bright-black";
        };
        git_status = {
          format =
            "[[(*$conflicted$untracked$modified$staged$renamed$deleted)](218) ($ahead_behind$stashed)]($style)";
          style = "cyan";
          conflicted = "";
          untracked = "";
          modified = "";
          staged = "";
          renamed = "";
          deleted = "";
        };
        git_state = {
          format = "([$state( $progress_current/$progress_total)]($style)) ";
          style = "bright-black";
        };
        cmd_duration = {
          format = "[$duration]($style) ";
          style = "yellow";
        };
        python = {
          format = "[$virtualenv]($style) ";
          style = "bright-black";
        };

        # Nerd Font symbols
        # https://starship.rs/presets/nerd-font
        aws = { symbol = "  "; };
        buf = { symbol = " "; };
        c = { symbol = " "; };
        conda = { symbol = " "; };
        crystal = { symbol = " "; };
        dart = { symbol = " "; };
        directory = { read_only = " 󰌾"; };
        docker_context = { symbol = " "; };
        elixir = { symbol = " "; };
        elm = { symbol = " "; };
        fennel = { symbol = " "; };
        fossil_branch = { symbol = " "; };
        git_branch = { symbol = " "; };
        golang = { symbol = " "; };
        guix_shell = { symbol = " "; };
        haskell = { symbol = " "; };
        haxe = { symbol = " "; };
        hg_branch = { symbol = " "; };
        hostname = { ssh_symbol = " "; };
        java = { symbol = " "; };
        julia = { symbol = " "; };
        kotlin = { symbol = " "; };
        lua = { symbol = " "; };
        memory_usage = { symbol = "󰍛 "; };
        meson = { symbol = "󰔷 "; };
        nim = { symbol = "󰆥 "; };
        nix_shell = { symbol = " "; };
        nodejs = { symbol = " "; };
        ocaml = { symbol = " "; };
        os = {
          symbols = {
            Alpaquita = " ";
            Alpine = " ";
            AlmaLinux = " ";
            Amazon = " ";
            Android = " ";
            Arch = " ";
            Artix = " ";
            CentOS = " ";
            Debian = " ";
            DragonFly = " ";
            Emscripten = " ";
            EndeavourOS = " ";
            Fedora = " ";
            FreeBSD = " ";
            Garuda = "󰛓 ";
            Gentoo = " ";
            HardenedBSD = "󰞌 ";
            Illumos = "󰈸 ";
            Kali = " ";
            Linux = " ";
            Mabox = " ";
            Macos = " ";
            Manjaro = " ";
            Mariner = " ";
            MidnightBSD = " ";
            Mint = " ";
            NetBSD = " ";
            NixOS = " ";
            OpenBSD = "󰈺 ";
            openSUSE = " ";
            OracleLinux = "󰌷 ";
            Pop = " ";
            Raspbian = " ";
            Redhat = " ";
            RedHatEnterprise = " ";
            RockyLinux = " ";
            Redox = "󰀘 ";
            Solus = "󰠳 ";
            SUSE = " ";
            Ubuntu = " ";
            Unknown = " ";
            Void = " ";
            Windows = "󰍲 ";
          };
        };
        package = { symbol = "󰏗 "; };
        perl = { symbol = " "; };
        php = { symbol = " "; };
        pijul_channel = { symbol = " "; };
        python = { symbol = " "; };
        rlang = { symbol = "󰟔 "; };
        ruby = { symbol = " "; };
        rust = { symbol = " "; };
        scala = { symbol = " "; };
        swift = { symbol = " "; };
        zig = { symbol = " "; };

        # No runtime versions preset
        # https://starship.rs/presets/no-runtimes
        # modified with no "via "
        bun = { format = "[$symbol]($style) "; };
        cmake = { format = "[$symbol]($style) "; };
        cobol = { format = "[$symbol]($style) "; };
        daml = { format = "[$symbol]($style) "; };
        deno = { format = "[$symbol]($style) "; };
        dotnet = { format = "[$symbol(🎯 $tfm )]($style) "; };
        elixir = { format = "[$symbol]($style) "; };
        elm = { format = " [$symbol]($style) "; };
        erlang = { format = "[$symbol]($style) "; };
        fennel = { format = "[$symbol]($style) "; };
        golang = { format = "[$symbol]($style) "; };
        gradle = { format = "[$symbol]($style) "; };
        haxe = { format = "[$symbol]($style) "; };
        helm = { format = "[$symbol]($style) "; };
        java = { format = "[$symbol]($style) "; };
        julia = { format = "[$symbol]($style) "; };
        kotlin = { format = "[$symbol]($style) "; };
        lua = { format = "[$symbol]($style) "; };
        meson = { format = "[$symbol]($style) "; };
        nim = { format = "[$symbol]($style) "; };
        nodejs = { format = "[$symbol]($style) "; };
        ocaml = {
          format = "[$symbol(($switch_indicator$switch_name) )]($style) ";
        };
        opa = { format = "[$symbol]($style) "; };
        perl = { format = "[$symbol]($style) "; };
        php = { format = "[$symbol]($style) "; };
        pulumi = { format = "[$symbol$stack]($style) "; };
        purescript = { format = "[$symbol]($style) "; };
        # python = { format = "[$symbol]($style) "; };
        quarto = { format = "[$symbol]($style) "; };
        raku = { format = "[$symbol]($style) "; };
        red = { format = "[$symbol]($style) "; };
        rlang = { format = "[$symbol]($style) "; };
        ruby = { format = "[$symbol]($style) "; };
        rust = { format = "[$symbol]($style) "; };
        solidity = { format = "[$symbol]($style) "; };
        typst = { format = "[$symbol]($style) "; };
        swift = { format = "[$symbol]($style) "; };
        vagrant = { format = "[$symbol]($style) "; };
        vlang = { format = "[$symbol]($style) "; };
        zig = { format = "[$symbol]($style) "; };
      };
    };
  };
}
