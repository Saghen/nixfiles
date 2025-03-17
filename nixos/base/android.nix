{ ... }:

{
  programs.adb.enable = true;
  users.users.saghen.extraGroups = [ "adbusers" "kvm" ];
}
