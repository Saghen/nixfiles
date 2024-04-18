# btrfs over 2 disks with RAID 0
# systemd-boot, unencrypted /boot
# systemd-cryptenroll - yubikey FIDO2 luks unlock: https://askubuntu.com/questions/1118814/yubikey-on-multiple-luks-drives
# passwordless sudo with yubikey

# (for V2) secure boot via https://github.com/nix-community/lanzaboote

{ pkgs, config, ... }:

{
  environment.systemPackages = with pkgs; [
    yubikey-personalization
    yubikey-manager
    yubico-pam
  ];

  security = {
    polkit.enable = true;

    # Enable PAM module for Yubikey for logging in
    pam = {
      services = {
        login.u2fAuth = true;
        sudo.u2fAuth = true;
      };
      u2f.authFile = "/etc/u2f-mappings";
    };
  };

  environment.etc."u2f-mappings".text = builtins.concatStringsSep "\n" ( 
    builtins.map (
      user: "${user}:uFCRmYevdOwCbnTg+AGbr8nCQSg1moNskkrwLaPkKnyJquwnhAwLahG0dYhWn4pniezXMbC0EKL8Pd46i51VZQ==,ksFBONzb15tfTzkK9MIzy6QWcFk27sj5/7Dwtjnuf2Meq0445QWnR9hk/+fv/dpjhPNawqU8ej/3pDkF/h+r+w==,es256,+presence:eEep3vG8EXQ5FjRM63/zjMghptZAGHhTRCIFgTQF2xAwqrdYpPKlZmrNpt+iQEHsKuHu9yjleLZNmOVIfIWYBA==,Nc+pNII4aXBtRfePZ+h1VgEV4DXmH0U599hpTF5IZfv4DnDnQN3aGdi/b6zuKoPxPraLHZM1C8D3S4UKA3ZABg==,es256,+presence"
    )
    ( builtins.attrNames config.users.users )
  );
}
