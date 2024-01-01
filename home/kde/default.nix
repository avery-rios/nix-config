let
  bluedevil = { lib, ... }: {
    xdg.configFile."bluedevilglobalrc".text = lib.generators.toINI { } {
      Global.launchState = "disable";
    };
  };
  baloo = { lib, ... }: {
    xdg.configFile."baloofilerc".text = lib.generators.toINI { } {
      "Basic Settings".Indexing-Enabled = false;
    };
  };
  mute = { lib, ... }: {
    xdg.configFile."plasmaparc".text = lib.generators.toINI { } {
      General.GlobalMute = true;
    };
  };
  konsole = import ./konsole.nix;
in
{
  inherit bluedevil baloo mute konsole;

  default = { ... }: {
    imports = [
      baloo
      mute
      konsole.default
    ];
  };
}
