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
  cfg = config.${namespace}.suites.common-slim;
in {
  options.${namespace}.suites.common-slim = with types; {
    enable = mkBoolOpt false "Whether or not to enable common-slim configuration.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
    ];

    plusultra = {
      nix = enabled;

      # TODO: Enable this once Attic is configured again.
      # cache.public = enabled;

      cli-apps = {
        flake = enabled;
      };

      tools = {
        git = enabled;
        bottom = enabled;
        direnv = enabled;
	btop = enabled;
      };

      hardware = {
        storage = enabled;
        networking = enabled;
      };

      services = {
        openssh = enabled;
      };

      security = {
        doas = enabled;
      };

      system = {
        fonts = enabled;
        locale = enabled;
        time = enabled;
        xkb = enabled;
      };
    };
  };
}
