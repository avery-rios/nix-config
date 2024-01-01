{
  base = { ... }: {
    users.users.avery = {
      uid = 1004;
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };
  };

  git = { ... }: {
    programs.git = {
      enable = true;
      userName = "Avery Rios";
      userEmail = "avery-dd70@outlook.com";
    };
  };
}
