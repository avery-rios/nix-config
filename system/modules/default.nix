libs:
{
  persistence = import ./persistence.nix;
  tools = (import ./tools) libs;
  firefox = (import ./firefox.nix) libs;
}
