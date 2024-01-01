{ persist, lib, ... }:
{
  system = persist.user.mkModule {
    name = "ocaml";
    options = {
      enable = lib.mkEnableOption "OCaml";
    };
    config = { value, ... }: lib.mkIf value.enable {
      directories = [ ".opam" ];
    };
  };

  home = { config, pkgs, lib, ... }: {
    options = with lib; {
      development.ocaml.enable = mkEnableOption "OCaml environment";

      editor = {
        vscode.ocaml.enable = mkEnableOption "OCaml in vscode";
      };
    };

    config = {
      home.packages = lib.mkIf config.development.ocaml.enable (with pkgs; [
        ocaml
        opam
        dune_3
        dune-release
        ocamlformat
        ocamlPackages.ocaml-lsp
        ocamlPackages.merlin
        ocamlPackages.odoc
        ocamlPackages.utop
      ]);

      programs.vscode = lib.mkIf config.editor.vscode.ocaml.enable {
        extensions = [ pkgs.vscode-extensions.ocamllabs.ocaml-platform ];
      };
    };
  };
}
