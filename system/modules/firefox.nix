{ persist, firefox, lib, ... }:
persist.user.mkModule {
  name = "firefox";
  options = {
    profiles = firefox.profile.mkOption {
      bookmarks.enable = lib.mkEnableOption "Persist bookmarks";
    };
  };
  config = { value, ... }: lib.mkMerge
    (builtins.attrValues
      (builtins.mapAttrs
        (name: value: lib.mkIf value.bookmarks.enable {
          directories = [ ".mozilla/firefox/${name}/bookmarkbackups" ];
          files = [ ".mozilla/firefox/${name}/places.sqlite" ];
        })
        value.profiles));
}
