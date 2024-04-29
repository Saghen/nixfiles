{ ... }:

{
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

    # Backup local BTRFS snapshots to remote server
    restic.backups = {
      home = {
        timerConfig = { OnCalendar = "daily"; };
        repository = "rest:https://restic.super.fish/saghen/desktop/btrfs/home";
        initialize = true; # create the repository if it doesn't exist
        passwordFile = "/etc/restic/super-fish-password";
        paths = [ "/mnt/storage/backups/snapshots/home" ];
      };
    };
  };
}
