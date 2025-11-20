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
  cfg = config.${namespace}.virtualisation.docker;
in
{
  options.${namespace}.virtualisation.docker = with types; {
    enable = mkBoolOpt false "Whether or not to enable docker.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ docker-compose ];

    plusultra.user.extraGroups = [ "docker" ];

    plusultra.home.extraOptions = {
    };

    # NixOS 22.05 moved NixOS Containers to a new state directory and the old
    # directory is taken over by OCI Containers (eg. docker). For systems with
    # system.stateVersion < 22.05, it is not possible to have both enabled.
    # This option disables NixOS Containers, leaving OCI Containers available.
    boot.enableContainers = false;

    virtualisation = {
      docker = {
        enable = cfg.enable;
      };
    };
  };
}
