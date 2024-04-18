{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    pavucontrol # GUI Volume mixer and device settings
    helvum # GUI Audio routing: Control what apps get what audio
  ];

  services.pipewire = {
    enable = true;
    audio.enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true; # Wiki says to do it and I don't ask questions
  };
}
