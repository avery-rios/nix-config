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

  email = { ... }: {
    accounts.email.accounts = {
      outlook = {
        primary = true;
        address = "avery-dd70@outlook.com";
        realName = "Avery Rios";
        userName = "avery-dd70@outlook.com";
        flavor = "outlook.office365.com";
      };
    };
  };
}
