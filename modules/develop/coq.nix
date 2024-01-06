{ options, ... }:
{
  home = { config, pkgs, inputs, lib, info, ... }: {
    options = with lib; {
      develop.coq = {
        enable = mkEnableOption "Coq Support";

        env.enable = options.mkDisableOption "Coq build tools";

        editor = {
          vscode = {
            coq-lsp.enable = mkEnableOption "Coq lsp";
          };
        };
      };
    };

    config = let cfg = config.develop.coq; in lib.mkIf cfg.enable {
      home.packages = lib.mkIf cfg.env.enable [
        pkgs.coq
      ];

      programs.vscode =
        let
          cfgVsc = cfg.editor.vscode;
          open-vsx = inputs.nix-vscode-extensions.extensions.${info.system}.open-vsx;
        in
        lib.mkMerge [
          (lib.mkIf cfgVsc.coq-lsp.enable {
            extensions = [ open-vsx.ejgallego.coq-lsp ];
            userSettings = {
              "coq-lsp.path" = "${pkgs.coqPackages.coq-lsp}/bin/coq-lsp";
              "coq-lsp.updateIgnores" = false; # don't create .vscode dir
            };
          })
        ];
    };
  };
}
