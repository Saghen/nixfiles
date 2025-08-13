# systemd-boot, unencrypted /boot
# passwordless sudo with yubikey
#
# (for V2)
# systemd-cryptenroll - yubikey FIDO2 luks unlock: https://askubuntu.com/questions/1118814/yubikey-on-multiple-luks-drives
# secure boot via https://github.com/nix-community/lanzaboote
{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    yubikey-personalization
    yubikey-manager
    yubico-pam
  ];
  # needed for ykman
  services.pcscd.enable = true;

  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

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
    "saghen:2L3NN8wV0iB2yyPHiGL7OlWqKStZHGhNSC8Q1xhnucTRtgbScnXeGxGgyrT+6DQp3NUKajN10nazfVZ+LfIiSA==,3WyoccWHmErO8M2+dKF4NxGqfq71VIyNQcmBlgmImGCFjhkjbj4DNIS2GvSWzCf7ywQPRcDtsmycq16PRa1HtQ==,es256,+presence";

  # allow VIA to read keyboards
  services.udev.extraRules = ''
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
  '';
}
