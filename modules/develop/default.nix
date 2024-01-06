{ modules, ... }@libs:
let
  modules = libs.modules.importWithLibs libs [
    ./coq.nix
    ./cpp.nix
    ./haskell.nix
    ./latex.nix
    ./lua.nix
    ./nix.nix
    ./ocaml.nix
    ./rust.nix
    ./toml.nix
    ./typst.nix
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
