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
      develop.haskell = {
        enable = mkEnableOption "Haskell environment";

        env = {
          cabal.enable = options.mkDisableOption "Cabal environment";
        };

        editor = {
          vscode.enable = mkEnableOption "VSCode haskell support";
          helix.enable = mkEnableOption "Helix haskell support";
        };

        browser = {
          firefox = {
            enable = mkEnableOption "Haskell doc";
            bookmarks.ghc.enable = options.mkDisableOption "GHC document";
          };
        };
      };
    };

    config = let cfg = config.develop.haskell; in lib.mkIf cfg.enable {
      home.packages = lib.mkIf cfg.env.cabal.enable (with pkgs; [
        ghc
        cabal-install
        haskell-language-server
      ]);

      programs.firefox.policies = lib.mkIf cfg.browser.firefox.enable {
        ManagedBookmarks = lib.mkIf cfg.browser.firefox.bookmarks.ghc.enable [
          {
            name = "GHC Documentation";
            url = "${pkgs.ghc.doc}/share/doc/ghc/html/index.html";
          }
        ];
      };

      programs.vscode = lib.mkIf cfg.editor.vscode.enable {
        extensions = with pkgs.vscode-extensions; [
          justusadam.language-haskell # syntax highlight
          haskell.haskell
        ];
        userSettings = {
          "haskell.serverExecutablePath" = "${pkgs.haskell-language-server}/bin/haskell-language-server-wrapper";
        };
      };

      programs.helix = lib.mkIf cfg.editor.helix.enable {
        languages.language-server.haskell-language-server-wrapper = {
          command = "${pkgs.haskell-language-server}/bin/haskell-language-server-wrapper";
        };
      };
    };
  };
}
