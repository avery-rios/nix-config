{ modules, ... }@libs:
let
  modules = libs.modules.importWithLibs libs [
    ./coq.nix
    ./haskell.nix
    ./nix.nix
    ./ocaml.nix
    ./rust.nix
    ./toml.nix
  ];
in
{
  system = { ... }: {
    imports = builtins.catAttrs "system" modules;
  };
  home = { ... }: {
    imports = builtins.catAttrs "home" modules;
  };
}
