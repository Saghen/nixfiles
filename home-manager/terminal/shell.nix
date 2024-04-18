{ pkgs, ... }:

{
  programs = { 
    fish = {
      enable = true;
      functions = {
        # disables greeting
        fish_greeting = ""; 
        # use search menu when pressing tab for completion
        fish_user_key_bindings = "bind \t complete-and-search";
        # color for kubectl
        kubectl = "kubecolor $argv";
      };
      shellAbbrs = {
        cd = "z";
        # kubectl plugin covers most except these ones
        kx = "kubectx";
        kn = "kubens";
        kg = "kubectl get";
        kd = "kubectl describe";
      };
      # fzf all the things
      interactiveShellInit = "fzf_configure_bindings";
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
            name = "fzf";
            src = fzf.src;
          }
          # text expansions such as .., !! and others
          {
            name = "puffer";
            src = puffer.src;
          }
          # adds kubectl abbreviations
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
      flags = ["--disable-up-arrow"];
      settings = {
        sync_address = "https://atuin.super.fish";
        style = "compact";
        enter_accept = true;
      };
    };

    # prompt
    starship = {
      enable = true;
      settings = {
        # Inserts a blank line between shell prompts
        add_newline = false;

        format = ''
        $container\
        $kubernetes\
        $directory\
        $git_branch\
        $git_state\
        $docker_context\
        $conda\
        $jobs\
        $sudo\
        $character\
        '';

        container = { 
          format = "[$symbol]($style) ";
          style = "bold red"; 
        };

        # Replace the "❯" symbol in the prompt with "➜"
        character = { 
          success_symbol = "[~>](green)";
          error_symbol = "[~>](blue)"; 
        };
      };
    }; 
  };
}
