let
  base = { ... }: {
    programs.helix = {
      enable = true;
      settings = {
        editor = {
          cursor-shape = {
            insert = "bar";
          };
          rulers = [ 80 ];
        };
      };
    };
  };
in
{
  inherit base;

  default = base;
}
