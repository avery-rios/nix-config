{ persist, firefox, options, lib, ... }:
{
  system = persist.user.mkModule {
    name = "haskell";
    options = {
      cabal.enable = lib.mkEnableOption "Cabal for haskell";
    };
    config = { value, ... }: lib.mkIf value.cabal.enable {
      directories = [ ".cabal" ];
    };
  };

  home = { config, pkgs, lib, ... }: {
    options = with lib; {
      environment.persistence = persist.user.mkOption {
        haskell = {
          cabal.enable = mkEnableOption "Cabal for haskell";
        };
      };

      development.haskell = {
        cabal.enable = mkEnableOption "Haskell cabal environment";
      };

      browser = {
        firefox.haskell = {
          enable = mkEnableOption "Haskell firefox";
          bookmarks.enable = options.mkDisableOption "Haskell doc";
        };
      };

      editor = {
        vscode.haskell.enable = mkEnableOption "Vscode haskell support";
        helix.haskell.enable = mkEnableOption "Helix haskell support";
      };
    };

    config = {
      home.packages = lib.mkIf config.development.haskell.cabal.enable (with pkgs; [
        ghc
        cabal-install
        haskell-language-server
      ]);

      programs.firefox.policies = let cfg = config.browser.firefox.haskell; in
        lib.mkIf cfg.enable {
          ManagedBookmarks = lib.mkIf cfg.bookmarks.enable [
            {
              name = "GHC Documentation";
              url = "${pkgs.ghc.doc}/share/doc/ghc/html/index.html";
            }
          ];
        };

      programs.vscode = lib.mkIf config.editor.vscode.haskell.enable {
        extensions = with pkgs.vscode-extensions; [
          justusadam.language-haskell # syntax highlight
          haskell.haskell
        ];
        userSettings = {
          "haskell.serverExecutablePath" = "${pkgs.haskell-language-server}/bin/haskell-language-server-wrapper";
        };
      };

      programs.helix = lib.mkIf config.editor.helix.haskell.enable {
        languages.language-server.haskell-language-server-wrapper = {
          command = "${pkgs.haskell-language-server}/bin/haskell-language-server-wrapper";
        };
      };
    };
  };
}
