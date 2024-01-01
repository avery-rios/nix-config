{ firefox, options, ... }:
{
  home = { config, pkgs, lib, inputs, info, ... }: {
    options = with lib; {
      develop.nix = {
        enable = mkEnableOption "Nix environment";

        editor = {
          vscode = {
            nix-ide.enable = mkEnableOption "Nix IDE";
          };
        };

        browser = {
          firefox = {
            enable = mkEnableOption "Nix doc";
            bookmarks = {
              nix.enable = options.mkDisableOption "Nix document";
              home-manager.enable = options.mkDisableOption "Home Manager doc";
            };
            profiles = firefox.profile.mkOption {
              enable = mkEnableOption "Nix firefox";
              search = {
                packages = options.mkDisableOption "Nix packages search";
                options = options.mkDisableOption "Nix options search";
              };
            };
          };
        };
      };
    };

    config = let cfg = config.develop.nix; in lib.mkIf cfg.enable {

      programs.firefox = let cfgFF = cfg.browser.firefox; in
        lib.mkIf cfgFF.enable {
          policies = {
            ManagedBookmarks = lib.mkMerge [
              (lib.mkIf cfgFF.bookmarks.nix.enable [{
                name = "Nix Reference Manual";
                url = "${pkgs.nix.doc}/share/doc/nix/manual/index.html";
              }])
              (lib.mkIf cfgFF.bookmarks.home-manager.enable [{
                name = "Home Manager Manual";
                url = "${inputs.home-manager.packages.${info.system}.docs-html}/share/doc/home-manager/index.xhtml";
              }])
            ];
          };
          profiles = firefox.profile.mkConfig
            (value: lib.mkIf value.enable {
              search.engines = {
                "NixOS packages" = lib.mkIf value.search.packages {
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
                "NixOS options" = lib.mkIf value.search.options {
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
            cfgFF.profiles;
        };

      programs.vscode = lib.mkIf cfg.editor.vscode.nix-ide.enable {
        extensions = [ pkgs.vscode-extensions.jnoortheen.nix-ide ];
        userSettings = {
          "nix.formatterPath" = "${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt";
        };
      };
    };
  };
}
