{ pkgs ? import <nixpkgs> { } }:

let
  shellDeps = with pkgs; [ bash gh pulseaudio bspwm lsof jq dunst xdg-utils ];
  pythonEnv =
    pkgs.python312.withPackages (ps: with ps; [ pulsectl-asyncio dbus-next ]);

  makeScript = name: body:
    "${
      pkgs.writeShellScriptBin name ''
        export PATH="${pkgs.lib.makeBinPath shellDeps}:$PATH"
        ${body} "$@"
      ''
    }/bin/${name}";
  makePythonScript = name: body:
    makeScript name "${pythonEnv}/bin/python ${body}";
  makeShellScript = name: body: makeScript name (builtins.readFile body);
in {
  twitch = makePythonScript "twitch" ./twitch.py;
  windows = makePythonScript "windows" ./windows.py;
  github = {
    notificationCount =
      makeShellScript "notification-count" ./github/notification-count.sh;
    openNotifications =
      makeShellScript "open-notifications" ./github/open-notifications.sh;
  };
  player = {
    nowPlaying = makePythonScript "now-playing" ./player/now-playing.py;
    setVolume = makePythonScript "set-volume" ./player/set-volume.py;
  };
  usage = {
    camera = makeShellScript "camera" ./usage/camera.sh;
    mic = makeShellScript "mic" ./usage/mic.sh;
  };
}
