{ pkgs, ... }:

{
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
    timerConfig = {
      OnCalendar = "daily";
      Unit = "ludusavi.service";
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

  services = {
    # BTRFS snapshots to local storage
    btrbk.instances = {
      home = {
        onCalendar = "daily";
        settings = {
          snapshot_preserve = "14d";
          snapshot_preserve_min = "2d";
          volume."/" = {
            subvolume = "home";
            # directory to store snapshots
            # WARN: this directory must be created manually
            snapshot_dir = "/snapshots/home";
          };
        };
      };
    };

    # Backup home directory to remote
    restic.backups = {
      home = {
        timerConfig = { OnCalendar = "daily"; };
        repositoryFile = "/etc/restic/super-fish-repository";
        passwordFile = "/etc/restic/super-fish-password";
        user = "saghen";
        paths = [ "/home/saghen" ];
        exclude = [
          "/home/*/.cache"
          "/home/*/downloads"
          "/home/*/.local/share/Trash"

          "/home/*/games/lutris"
          "/home/*/games/steam"
          "/home/*/.steam"
          "/home/*/.local/share/Steam"

          "/home/*/code/**/node_modules"
          "/home/*/code/**/target"
        ];
      };
    };
  };
}
