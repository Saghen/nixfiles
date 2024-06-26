{ ... }:

{
  # Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  networking.networkmanager.enable = true; # Automatic networking confiugration

  # VPNs
  services.tailscale = {
    enable = true;
    openFirewall = true;
  };
  services.mullvad-vpn.enable = true;
}
