{
  lib,
  stdenvNoCC,
}:
stdenvNoCC.mkDerivation {
  pname = "feather";
  version = "2024-04-19";

  src = ./feather;

  installPhase = ''
    install -D -m 444 $src/*.ttf -t $out/share/fonts/truetype
  '';

  meta = with lib; {
    description = "Simple beautiful open source icons";
    homepage = "https://feathericons.com/";
    platforms = platforms.all;
  };
}
