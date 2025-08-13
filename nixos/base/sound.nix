{ ... }:
{
  services.pipewire = {
    enable = true;
    wireplumber.enable = true; # Session / policy manager
    audio.enable = true; # Use as primary audio server
    pulse.enable = true; # PulseAudio compatibility
    alsa.enable = true; # ALSA compatibility
    alsa.support32Bit = true; # Wiki says to do it and I don't ask questions
  };
}
