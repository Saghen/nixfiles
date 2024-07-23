# btrfs over 2 disks with RAID 0
# systemd-boot, unencrypted /boot
# systemd-cryptenroll - yubikey FIDO2 luks unlock: https://askubuntu.com/questions/1118814/yubikey-on-multiple-luks-drives
# passwordless sudo with yubikey

# (for V2) secure boot via https://github.com/nix-community/lanzaboote

{ pkgs, ... }:

{
  # todo: are the yubikey/yubico ones needed?
  environment.systemPackages = with pkgs; [
    yubikey-personalization
    yubikey-manager
    yubico-pam
  ];

  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  # programs.gnupg.agent = {
  #   enable = true;
  #   pinentryPackage = pkgs.pinentry-tty;
  #   settings = { allow-loopback-pinentry = true; };
  # };
  hardware.gpgSmartcards.enable = true;

  security.polkit.enable = true;

  # Enable PAM module for Yubikey for login and sudo
  security.pam = {
    u2f = {
      enable = true;
      settings = {
        pinverification = 1;
        cue = true;
        authfile = "/etc/u2f-mappings";
      };
    };
    services = {
      login.u2fAuth = true;
      sudo.u2fAuth = true;
    };
  };
  # Public keys of Yubikeys. Generated via:
  # https://nixos.wiki/wiki/Yubikey#pam_u2f
  environment.etc."u2f-mappings".text =
    "saghen:DgBwRAkbzjUiiE6WikxyEadH/p1ze4p6w3/Wc0qQd7aI5qvQL9vn5joqOI/Gq1zPKf6P2Af3swf2cgG71WUriw==,DqEsqsA3Fnmc2EVm75neLy7PMLkN4bhgiFEp0OaqpNxqiEMMn7s4bWcrO4a6wsR7dVxK6cLDxNBzEJ+GvyHiVg==,es256,+presence:0mFOuATIQI9mpfkDuwQy1PEsYNFWgLzkDiZRxND4R1jWhq0AbkCtyoQN53oThRlvj/oChjrvrb3lQ6AJYvqDvA==,E2zkjzC0nd19Cix8uOeQ20zN1D9mJduG1c0JA04Dr/+OHw2TekZA4ZeNCjvkUY7Bj6oAy1ioNCIamXypxCQ4Aw==,es256,+presence";
}
