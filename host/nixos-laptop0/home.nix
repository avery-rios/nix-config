{ pkgs, home, ... }: {
  imports = [
    home.kde.default
    home.kde.bluedevil
    home.firefox.default
    home.vscode.default
  ];

  browser.firefox = {
    nix.enable = true;

    profiles.default = {
      nix.enable = true;
    };
  };

  editor = {
    vscode = {
      nix.nix-ide.enable = true;
    };
  };

  programs.bash.enable = true;
}
