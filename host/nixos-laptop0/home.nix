{ pkgs, home, modules, ... }: {
  imports = [
    home.kde.default
    home.kde.bluedevil
    home.firefox.default
    home.vscode.default

    modules.develop.home
  ];

  develop = {
    nix = {
      enable = true;
      editor = { vscode.nix-ide.enable = true; };
      browser.firefox = {
        enable = true;
        profiles.default.enable = true;
      };
    };
  };

  programs.bash.enable = true;
}
