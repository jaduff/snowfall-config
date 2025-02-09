{
  options,
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.security.sudo;
in
{
  options.${namespace}.security.sudo = {
    enable = mkBoolOpt false "Whether or not to enable sudo.";
  };

  config = mkIf cfg.enable {
    # enable sudo
    security.sudo.enable = true;


    # Add an alias to the shell for backward-compat and convenience.
    environment.shellAliases = {
      sudo = "sudo";
    };
  };
}
