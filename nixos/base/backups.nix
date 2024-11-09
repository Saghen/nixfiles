{ pkgs, config, ... }:

rec {
  # Backup game folders
  systemd.services.ludusavi = {
    description = "Backup game saves";
    serviceConfig = {
      Type = "oneshot";
      ExecStart =
        "${pkgs.ludusavi}/bin/ludusavi --config /etc/ludusavi backup --force";
    };
  };
  systemd.timers.ludusavi = {
    description = "Backup game saves";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      # Timer will run immediately if system was off when it would typically run
      Persistent = true;
    };
  };
  environment.etc.ludusavi = {
    target = "ludusavi/config.yaml";
    text = ''
      manifest:
        url: https://raw.githubusercontent.com/mtkennerly/ludusavi-manifest/master/data/manifest.yaml
      roots:
        - path: /home/saghen/.local/share/Steam
          store: steam
        - path: /home/saghen/games/steam
          store: steam
      backup:
        path: /home/saghen/games/saves
      restore:
        path: /home/saghen/games/saves-restore
    '';
  };

  # BTRFS snapshots to local storage
  system.activationScripts.mkBtrbkHome = "mkdir -p /snapshots/home";
  services.btrbk.instances = {
    # home = {
    #   onCalendar = "daily";
    #
    #   settings = {
    #     snapshot_preserve = "14d";
    #     snapshot_preserve_min = "2d";
    #     volume."/" = {
    #       subvolume = "home";
    #       snapshot_dir = "/snapshots/home";
    #     };
    #   };
    # };
  };

  # Backup home directory to remote
  sops.secrets."restic/super-fish/repository" = {
    sopsFile = ../../keys/sops/restic.yaml;
    mode = "0440";
    owner = "root";
    group = "root";
  };
  sops.secrets."restic/super-fish/password" =
    sops.secrets."restic/super-fish/repository";
  services.restic.backups = {
    home = {
      timerConfig = { OnCalendar = "daily"; };
      repositoryFile = config.sops.secrets."restic/super-fish/repository".path;
      passwordFile = config.sops.secrets."restic/super-fish/password".path;
      initialize = true;
      user = "root";
      paths = [ "/home/saghen" ];
      exclude = [
        "/home/*/.cache"
        "/home/*/.local"
        "/home/*/downloads"

        "/home/*/beets"
        "/home/*/Music"

        "/home/*/games/lutris"
        "/home/*/games/steam"
        "/home/*/games/mod-organizer-2"
        "/home/*/.steam"

        "/home/**/node_modules"
        "/home/**/.venv"
        "/home/*/code/**/target"
        "/home/*/code/huggingface/tokenizers"
        "/home/*/code/tmp"
        "/home/*/code/superfishial/readarr-dump"
      ];
    };
  };
}
