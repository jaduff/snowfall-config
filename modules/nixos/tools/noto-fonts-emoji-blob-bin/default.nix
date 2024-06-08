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
  cfg = config.${namespace}.tools.noto-fonts-emoji-blob-bin;
in {
  options.${namespace}.tools.noto-fonts-emoji-blob-bin = with types; {
    enable = mkBoolOpt false "Whether or not to enable noto-fonts-emoji-blob-bin.";
  };

  config = mkIf cfg.enable {environment.systemPackages = with pkgs; [noto-fonts-emoji-blob-bin];};
}
