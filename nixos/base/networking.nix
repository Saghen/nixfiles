{ ... }:

{
  networking.networkmanager.enable = true; # Automatic networking confiugration
  services.resolved.enable = true; # DNS caching

  # VPNs
  services.tailscale = {
    enable = true;
    openFirewall = true;
  };
  services.mullvad-vpn.enable = true;
}
