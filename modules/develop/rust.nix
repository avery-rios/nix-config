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
      development.rust.enable = mkEnableOption "Rust environment";

      browser.firefox.rust = {
        enable = mkEnableOption "Rust firefox";
        bookmarks.enable = options.mkDisableOption "Rust Documentation";
      };

      editor = {
        vscode.rust.enable = mkEnableOption "Vscode Rust support";
        helix.rust.enable = mkEnableOption "Helix rust support";
      };
    };

    config = {
      home.packages = lib.mkIf config.development.rust.enable (with pkgs; [
        cargo
        rustc
        rustfmt
        clippy
        rust-bindgen
        rust-cbinggen
      ]);

      programs.firefox.policies = let cfg = config.browser.firefox.rust; in
        lib.mkIf cfg.enable {
          ManagedBookmarks = lib.mkIf cfg.bookmarks.enable [
            {
              name = "Rust Documentation";
              url = "${pkgs.rustc.doc}/share/doc/rust/html/index.html";
            }
          ];
        };

      programs.vscode = lib.mkIf config.editor.vscode.rust.enable {
        extensions = [ pkgs.vscode-extensions.matklad.rust-analyzer ];
        userSettings = {
          "rust-analyzer.server.path" = "${pkgs.rust-analyzer}/bin/rust-analyzer";
        };
      };

      programs.helix = lib.mkIf config.editor.helix.rust.enable {
        languages.language-server.rust-analyzer = {
          command = "${pkgs.rust-analyzer}/bin/rust-analyzer";
        };
      };
    };
  };
}
