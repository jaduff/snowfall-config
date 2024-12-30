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
  cfg = config.${namespace}.apps.emacs;
in {
  options.${namespace}.apps.emacs = with types; {
    enable = mkBoolOpt false "Whether or not to enable Protontricks.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [emacs];
    environment.interactiveShellInit = ''
      alias doom='.config/emacs/bin/doom'
    '';

  };

}
