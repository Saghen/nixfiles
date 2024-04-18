{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "feather";
  version = "2024-04-18";

  src = ./feather;

  installPhase = ''
    install -D -m 444 $src/*.ttf -t $out/share/fonts/ttf
  '';

  meta = with lib; {
    description = "Simple beautiful open source icons";
    homepage = "https://feathericons.com/";
    platforms = platforms.all;
  };
}
