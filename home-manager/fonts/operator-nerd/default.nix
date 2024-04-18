{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "operator-nerd";
  version = "2024-04-18";

  src = ./operator-nerd;

  installPhase = ''
    install -D -m 444 $src/*.otf -t $out/share/fonts/otf
  '';

  meta = with lib; {
    description = "A nice code font";
    homepage = "https://www.typography.com/fonts/operator/overview";
    platforms = platforms.all;
  };
}
