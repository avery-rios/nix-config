let
  base = { pkgs, ... }: {
    programs.vscode = {
      enable = true;
      package = pkgs.vscodium;
      userSettings = {
        "editor.fontFamily" = "'Cascadia Code', 'Droid Sans Mono', 'monospace', monospace";
        "editor.fontLigatures" = true;

        "editor.formatOnSave" = true;
        "editor.formatOnType" = true;

        "terminal.integrated.cursorStyle" = "line";

        "extensions.autoUpdate" = false;
      };
    };
  };

  editorconfig = { pkgs, ... }: {
    programs.vscode.extensions = [ pkgs.vscode-extensions.editorconfig.editorconfig ];
  };

  neovim = { pkgs, ... }: {
    programs.vscode = {
      extensions = [ pkgs.vscode-extensions.asvetliakov.vscode-neovim ];
      userSettings = {
        "vscode-neovim.neovimExecutablePaths.linux" = "${pkgs.neovim}/bin/nvim";
      };
    };
  };
in
{
  inherit base editorconfig neovim;

  default = { ... }: {
    imports = [
      base
      editorconfig
      neovim
    ];
  };
}
