{ persist, firefox, options, lib, ... }:
{
  system = persist.user.mkModule {
    name = "rust";
    options = {
      enable = lib.mkEnableOption "Rust";
    };
    config = { value, ... }: lib.mkIf value.enable {
      directories = [ ".cargo" ];
    };
  };

  home = { config, lib, pkgs, ... }: {
    options = with lib; {
      develop.rust = {
        enable = mkEnableOption "Rust environment";

        env.enable = options.mkDisableOption "Rust build tools";

        editor = {
          vscode.enable = mkEnableOption "VSCode rust support";
          helix.enable = mkEnableOption "Helix rust support";
          nixvim.enable = mkEnableOption "Neovim rust support";
        };

        browser = {
          firefox = {
            enable = mkEnableOption "Rust doc";
            bookmarks = {
              rustc.enable = options.mkDisableOption "Rust Documentation";
            };
          };
        };
      };
    };

    config = let cfg = config.develop.rust; in lib.mkIf cfg.enable {
      home.packages = lib.mkIf cfg.env.enable (with pkgs; [
        cargo
        rustc
        rustfmt
        clippy
        rust-bindgen
        rust-cbindgen
      ]);

      programs.firefox.policies = let cfgFF = cfg.browser.firefox; in
        lib.mkIf cfgFF.enable {
          ManagedBookmarks = lib.mkIf cfgFF.bookmarks.rustc.enable [
            {
              name = "Rust Documentation";
              url = "${pkgs.rustc.doc}/share/doc/rust/html/index.html";
            }
          ];
        };

      programs.vscode = lib.mkIf cfg.editor.vscode.enable {
        extensions = [ pkgs.vscode-extensions.matklad.rust-analyzer ];
        userSettings = {
          "rust-analyzer.server.path" = "${pkgs.rust-analyzer}/bin/rust-analyzer";
        };
      };

      programs.helix = lib.mkIf cfg.editor.helix.enable {
        languages.language-server.rust-analyzer = {
          command = "${pkgs.rust-analyzer}/bin/rust-analyzer";
        };
      };

      programs.nixvim = lib.mkIf cfg.editor.nixvim.enable {
        plugins = {
          lsp.servers.rust-analyzer = {
            enable = true;
            installCargo = false;
            installRustc = false;
          };

          # TODO: use https://github.com/mrcjkb/rustaceanvim
          # rust-tools = {
          #   enable = true;
          # };
        };
      };
    };
  };
}
