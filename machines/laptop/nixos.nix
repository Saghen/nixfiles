{ inputs, ... }:

{
  # hardware-specific modules
  # TODO: use framework specific module
  imports = [
    inputs.hardware.nixosModules.common-pc-laptop
    inputs.hardware.nixosModules.common-pc-ssd
  ];

  config = {
    networking.hostName = "liam-laptop";
    networking.hostId = "x0c35pt6";

    # automatic firmware updates: fwupdmgr update
    services.fwupd.enable = true;

    # recommended over TLP by framework team
    services.power-profiles-daemon.enable = true;

    # enable fingerprint reader
    # register fingers via: fprintd-enroll -f finger
    services.fprintd.enable = true;

    # enable PAM fingerprint authentication
    security.pam.services = {
      login.fprintAuth = true;
      sudo.fprintAuth = true;
      polkit-1.fprintAuth = true;
    };
  };
}
