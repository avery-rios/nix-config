{ persist, firefox, options, lib, ... }: {
  system = persist.user.mkModule {
    name = "haskell";
    options = { cabal.enable = lib.mkEnableOption "Cabal for haskell"; };
    config = { value, ... }:
      lib.mkIf value.cabal.enable { directories = [ ".cabal" ]; };
  };

  home = { config, pkgs, lib, ... }: {
    options = with lib; {
      develop.haskell = {
        enable = mkEnableOption "Haskell environment";

        env = { cabal.enable = options.mkDisableOption "Cabal environment"; };

        editor = {
          vscode.enable = mkEnableOption "VSCode haskell support";
          helix.enable = mkEnableOption "Helix haskell support";
          nixvim.enable = mkEnableOption "Neovim haskell support";
        };

        browser = {
          firefox = {
            enable = mkEnableOption "Haskell doc";
            bookmarks = {
              ghc.enable = options.mkDisableOption "GHC document";
              packages = mkOption {
                type = types.listOf types.package;
                default = [ ];
              };
            };
          };
        };
      };
    };

    config = let cfg = config.develop.haskell;
    in lib.mkIf cfg.enable {
      home.packages = lib.mkIf cfg.env.cabal.enable
        (with pkgs; [ ghc cabal-install haskell-language-server ]);

      programs.firefox.policies = let ffCfg = cfg.browser.firefox;
      in lib.mkIf ffCfg.enable {
        ManagedBookmarks = lib.mkMerge [
          (lib.mkIf ffCfg.bookmarks.ghc.enable [{
            name = "GHC Documentation";
            url = "${pkgs.ghc.doc}/share/doc/ghc/html/index.html";
          }])
          [{
            name = "Haskell packages";
            children = builtins.map (p: {
              inherit (p) name;
              url = "${p.doc}/share/doc/${p.name}/html/index.html";
            }) ffCfg.bookmarks.packages;
          }]
        ];
      };

      programs.vscode = lib.mkIf cfg.editor.vscode.enable {
        extensions = with pkgs.vscode-extensions; [
          justusadam.language-haskell # syntax highlight
          haskell.haskell
        ];
        userSettings = {
          "haskell.serverExecutablePath" =
            "${pkgs.haskell-language-server}/bin/haskell-language-server-wrapper";
        };
      };

      programs.helix = lib.mkIf cfg.editor.helix.enable {
        languages.language-server.haskell-language-server-wrapper = {
          command =
            "${pkgs.haskell-language-server}/bin/haskell-language-server-wrapper";
        };
      };

      programs.nixvim = lib.mkIf cfg.editor.nixvim.enable {
        plugins = {
          lsp.servers.hls = {
            enable = true;
            cmd = [ "haskell-language-server-wrapper" "--lsp" ];
          };
        };
      };
    };
  };
}
