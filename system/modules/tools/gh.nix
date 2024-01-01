{ persist, lib, ... }:
persist.user.mkModule {
  name = "gh";
  options = {
    enable = lib.mkEnableOption "gh";
  };
  config = { value, ... }: {
    files = [ ".config/gh/hosts.yml" ];
  };
}
