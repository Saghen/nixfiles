{ ... }:
{
  config = {
    machine = {
      scalingFactor = 1.5;
      monitors = [ "eDP-1" ];
      width = 2880;
      height = 1920;
      refreshRate = 120;
      optimizePower = true;

      disks = {
        boot = {
          diskUuid = "23A6-D8A5";
          type = "vfat";
          options = [
            "fmask=0077"
            "dmask=0077"
          ];
        };
        root = {
          luksUuid = "e4d85d5d-ecda-4719-9b98-e40942bfd1aa";
          diskUuid = "ad38535b-c13b-4535-b929-d9bb88eb10cc";
          type = "f2fs";
          options = [ "noatime" ];
        };
        swap = {
          luksUuid = "4508682f-fd52-487a-922c-2b01d93ee770";
          diskUuid = "3457863e-0f56-4a8c-b85e-85dfda36b940";
        };
      };
    };
  };
}
