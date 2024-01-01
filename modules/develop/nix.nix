{ firefox, options, ... }:
{
  home = { config, pkgs, lib, ... }: {
    options = with lib; {
      browser.firefox = {
        nix = {
          enable = mkEnableOption "Nix firefox";
          bookmarks.enable = options.mkDisableOption "Nix documents";

        };
        profiles = firefox.profile.mkOption {
          nix = {
            enable = mkEnableOption "Nix firefox";
            search = {
              packages = options.mkDisableOption "Nix packages search";
              options = options.mkDisableOption "Nix options search";
            };
          };
        };
      };

      editor = {
        vscode.nix = {
          nix-ide.enable = mkEnableOption "Nix IDE";
        };
      };
    };

    config = {
      programs.firefox = let cfg = config.browser.firefox; in {
        policies = lib.mkIf cfg.nix.enable {
          ManagedBookmarks = lib.mkIf cfg.nix.bookmarks.enable [
            {
              name = "Nix Reference Manual";
              url = "${pkgs.nix.doc}/share/doc/nix/manual/index.html";
            }
          ];
        };
        profiles = firefox.profile.mkConfig
          (value: lib.mkIf value.nix.enable {
            search.engines = {
              "NixOS packages" = lib.mkIf value.nix.search.packages {
                description = "Search NixOS packages by name or description.";
                urls = [
                  {
                    template = "https://search.nixos.org/packages";
                    params = [{ name = "query"; value = "{searchTerms}"; }];
                  }
                ];
                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [ "@nixpkg" ];
              };
              "NixOS options" = lib.mkIf value.nix.search.options {
                description = "Search NixOS options by name or description.";
                urls = [
                  {
                    template = "https://search.nixos.org/options";
                    params = [{ name = "query"; value = "{searchTerms}"; }];
                  }
                ];
                icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
                definedAliases = [ "@nixopt" ];
              };
            };
          })
          cfg.profiles;
      };

      programs.vscode = lib.mkIf config.editor.vscode.nix.nix-ide.enable {
        extensions = [ pkgs.vscode-extensions.jnoortheen.nix-ide ];
        userSettings = {
          "nix.formatterPath" = "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt";
        };
      };
    };
  };
}
