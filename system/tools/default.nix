let
  bat = { pkgs, ... }: {
    environment.systemPackages = [ pkgs.bat ];
    environment.etc."bat/config".text = ''
      --theme=TwoDark
    '';
  };
in
{
  min = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      coreutils
      moreutils
    ];
  };
  base = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      git
      neovim
      curl
      wget
      unzip
      lzip
    ];
  };

  admin = { pkgs, ... }: {
    imports = [
      bat
    ];
    environment.systemPackages = with pkgs; [
      eza
      fd
      ripgrep
      jq
      duf
      du-dust
      zellij
    ];
  };

  inherit bat;
}
