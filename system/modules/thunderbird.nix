{ persist, lib, ... }:
persist.user.mkModule {
  name = "thunderbird";
  options = with lib; {
    profiles = mkOption {
      type = types.attrsOf (types.submodule {
        options.mail.enable = mkEnableOption "Persist profile";
      });
    };
  };
  config = { value, ... }: lib.mkMerge (builtins.attrValues (builtins.mapAttrs
    (name: value: lib.mkIf value.mail.enable {
      directories = [
        ".thunderbird/${name}/ImapMail"
        ".thunderbird/${name}/Mail"
      ];
    })
    value.profiles));
}
