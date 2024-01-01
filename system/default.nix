libs:
{
  nix = import ./nix.nix;
  tools = import ./tools;
  starship = import ./starship.nix;
  modules = (import ./modules) libs;
}
