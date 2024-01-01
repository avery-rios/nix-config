{ ... }:
{
  home = { config, pkgs, lib, ... }: {
    options = with lib;{
      editor = {
        vscode.toml.enable = mkEnableOption "Toml vscode support";
        helix.toml.enable = mkEnableOption "Helix toml support";
      };
    };

    config = {
      programs.vscode = lib.mkIf config.editor.vscode.toml.enable {
        extensions = [ pkgs.vscode-extensions.tamasfe.even-better-toml ];
      };

      programs.helix = lib.mkIf config.editor.helix.toml.enable {
        languages.language-server.taplo = {
          command = "${pkgs.taplo}/bin/taplo";
        };
      };
    };
  };
}
