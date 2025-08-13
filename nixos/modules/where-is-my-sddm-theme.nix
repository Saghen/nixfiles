# Modified from nixpkgs to use the qt5 version
{
  lib,
  formats,
  stdenvNoCC,
  fetchFromGitHub,
  qtgraphicaleffects,
  themeConfig ? null,
}:
let
  user-cfg = (formats.ini { }).generate "theme.conf.user" themeConfig;
in
stdenvNoCC.mkDerivation rec {
  pname = "where-is-my-sddm-theme";
  version = "1.9.1-qt5";

  src = fetchFromGitHub {
    owner = "stepanzubkov";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-lxdtlNdMxBwCRL7c1Uw/TY6Yv9ycSdQz4BE1w19tzog=";
  };

  propagatedUserEnvPkgs = [ qtgraphicaleffects ];

  installPhase = ''
    mkdir -p $out/share/sddm/themes/
    cp -r where_is_my_sddm_theme_qt5/ $out/share/sddm/themes/where_is_my_sddm_theme
  ''
  + lib.optionalString (lib.isAttrs themeConfig) ''
    ln -sf ${user-cfg} $out/share/sddm/themes/where_is_my_sddm_theme/theme.conf.user
  '';

  meta = with lib; {
    description = "The most minimalistic SDDM theme among all themes";
    homepage = "https://github.com/stepanzubkov/where-is-my-sddm-theme";
    license = licenses.mit;
    maintainers = with maintainers; [ name-snrl ];
  };
}
