let
  profile = {
    oneHalfDark = { lib, ... }: {
      xdg.dataFile."konsole/OneHalfDark.profile".text = lib.generators.toINI { } {
        Appearance = {
          ColorScheme = "One Half Dark";
          Font = "Cascadia Code PL,10,-1,5,50,0,0,0,0,0";
        };
        "Cursor Options".CursorShape = 1; # I-beam
        General = {
          Name = "One Half Dark";
          Parent = "FALLBACK/";
        };
        Scrolling.HistorySize = 5000;
      };

      xdg.dataFile."konsole/One Half Dark.colorscheme".text = lib.generators.toINI { } {
        Background.Color = "40,44,52";
        BackgroundFaint.Color = "40,44,52";
        BackgroundIntense.Color = "40,44,52";

        Color0.Color = "40,44,52";
        Color0Faint.Color = "40,44,52";
        Color0Intense.Color = "40,44,52";

        Color1.Color = "224,108,117";
        Color1Faint.Color = "224,108,117";
        Color1Intense.Color = "224,108,117";

        Color2.Color = "152,195,121";
        Color2Faint.Color = "152,195,121";
        Color2Intense.Color = "152,195,121";

        Color3.Color = "229,192,123";
        Color3Faint.Color = "229,192,123";
        Color3Intense.Color = "229,192,123";

        Color4.Color = "97,175,239";
        Color4Faint.Color = "97,175,239";
        Color4Intense.Color = "97,175,239";

        Color5.Color = "198,120,221";
        Color5Faint.Color = "198,120,221";
        Color5Intense.Color = "198,120,221";

        Color6.Color = "86,182,194";
        Color6Faint.Color = "86,182,194";
        Color6Intense.Color = "86,182,194";

        Color7.Color = "220,223,228";
        Color7Faint.Color = "220,223,228";
        Color7Intense.Color = "220,223,228";

        Foreground.Color = "171,178,191";
        ForegroundFaint.Color = "92,99,112";
        ForegroundIntense.Color = "130,137,151";

        General = {
          Description = "One Half Dark";
          Opacity = 0.7;
        };
      };
    };
  };
in
{
  inherit profile;

  default = { lib, ... }: {
    imports = [
      profile.oneHalfDark
    ];

    xdg.configFile."konsolerc".text = lib.generators.toINI { } ({
      "Desktop Entry".DefaultProfile = "OneHalfDark.profile";
    });
  };
}
