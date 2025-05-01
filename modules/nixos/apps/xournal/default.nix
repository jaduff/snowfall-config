{
  options,
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.apps.xournalpp;
in
{
  options.${namespace}.apps.xournalpp = with types; {
    enable = mkBoolOpt false "Whether or not to enable Xournalpp.";
  };

  config = mkIf cfg.enable { environment.systemPackages = with pkgs; [
    xournalpp
    (texlive.combine {
      inherit (texlive) scheme-basic standalone
      varwidth scontents xcolor;
      })
  ]; };
}
