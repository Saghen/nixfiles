{ ... }:
{
  services.pipewire = {
    enable = true;
    wireplumber.enable = true; # Session / policy manager
    audio.enable = true; # Use as primary audio server
    pulse.enable = true; # PulseAudio compatibility
    alsa.enable = true; # ALSA compatibility
    alsa.support32Bit = true; # Wiki says to do it and I don't ask questions

    extraConfig.pipewire = {
      # Auto switches between sample rates based on current audio
      "10-clock-rate" = {
        "context.properties" = {
          "default.clock.rate" = "48000";
          "default.clock.allowed-rates" = [
            "44100"
            "48000"
          ];
        };
      };

      # Higher resampling quality makes 44.1khz -> 48khz audibly transparent
      "20-resample-quality" = {
        "stream.properties" = {
          "resample.quality" = "10";
        };
      };
    };
  };
}
