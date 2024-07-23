{ lib, ... }:

{
  # Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Internet
  networking.networkmanager.enable = true;
  # Causes long boots and hangs on update
  # https://github.com/NixOS/nixpkgs/issues/180175#issuecomment-1473408913
  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;
  systemd.services.systemd-networkd-wait-online.enable = lib.mkForce false;

  # VPNs
  services.tailscale = {
    enable = true;
    openFirewall = true;
  };
  services.mullvad-vpn.enable = true;
}
