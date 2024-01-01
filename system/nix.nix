{ inputs, ... }: {
  nix = {
    settings = {
      sandbox = true;
      auto-optimise-store = true;
      experimental-features = "nix-command flakes ca-derivations";
    };

    registry = {
      nixpkgs.flake = inputs.nixpkgs;
    };
  };
}
