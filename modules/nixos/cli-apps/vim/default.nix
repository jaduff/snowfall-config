{
  options,
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
with lib;
with lib.${namespace}; let
  cfg = config.${namespace}.cli-apps.vim;
in {
  options.${namespace}.cli-apps.vim = with types; {
    enable = mkBoolOpt false "Whether or not to enable vim.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [vim];
  };
}
