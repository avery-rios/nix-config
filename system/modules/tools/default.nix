{ modules, ... }@libs:
{ ... }:
{
  imports = modules.importWithLibs libs [
    ./gpg.nix
    ./ssh.nix
  ];
}
