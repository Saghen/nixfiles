# Built by using the private-build-plans.toml with the Iosevka repo by running:
# npm run build -- ttf::IosevkaCustom
# then patching with nerd fonts like so:
# docker run --rm -v $(pwd)/dist/IosevkaCustom:/in:Z -v $(pwd)/dist/IosevkaCustom500:/out:Z -e 'PN=16' nerdfonts/patcher --adjust-line-height --complete --xavgcharwidth 500
# TODO: Not sure that the xavgcharwidth did anything
# NOTE: Edit PN to adjust parallelization

{ lib, stdenvNoCC, fetchFromGitHub }:

stdenvNoCC.mkDerivation rec {
  pname = "iosevka-nerd";
  version = "2024-04-18";

  src = ./iosevka-nerd;

  installPhase = ''
    install -D -m 444 $src/*.ttf -t $out/share/fonts/ttf
  '';

  meta = with lib; {
    description = "Versatile typeface for code, from code.";
    homepage = "https://be5invis.github.io/Iosevka";
    platforms = platforms.all;
  };
}
