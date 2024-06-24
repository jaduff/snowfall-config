{
  lib,
  config,
  namespace,
  ...
}: let
  cfg = config.${namespace}.services.syncthing;

  inherit
    (lib)
    types
    mkEnableOption
    mkIf
    mapAttrs
    optionalAttrs
    ;

  inherit
    (lib.${namespace})
    mkOpt
    mkBoolOpt
    ;

  bool-to-yes-no = value:
    if value
    then "yes"
    else "no";

  shares-submodule = with types;
    submodule ({name, ...}: {
      options = {
        path = mkOpt str null "The path to serve.";
        public = mkBoolOpt false "Whether the share is public.";
        browseable = mkBoolOpt true "Whether the share is browseable.";
        comment = mkOpt str name "An optional comment.";
        read-only = mkBoolOpt false "Whether the share should be read only.";
        only-owner-editable = mkBoolOpt false "Whether the share is only writable by the system owner (plusultra.user.name).";

        extra-config = mkOpt attrs {} "Extra configuration options for the share.";
      };
    });
in {
  options.${namespace}.services.syncthing = with types; {
    enable = mkEnableOption "Syncthing";
  };

  config = mkIf cfg.enable {
    networking.firewall = {
      allowedTCPPorts = [8384 22000];
      allowedUDPPorts = [22000 21027];
    };

  };
}
