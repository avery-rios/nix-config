{ pkgs, ... }: {
  programs.gpg = { enable = true; };
  services.gpg-agent = {
    enable = true;
    pinentryFlavor = "tty";
  };
  home.sessionVariables = { GPG_TTY = "$(tty)"; };
}
