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
  cfg = config.${namespace}.suites.common;
in {
  options.${namespace}.suites.common = with types; {
    enable = mkBoolOpt false "Whether or not to enable common configuration.";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
    ];

    plusultra = {
      nix = enabled;

      # TODO: Enable this once Attic is configured again.
       cache.public = enabled;

      cli-apps = {
        flake = enabled;
        vim = enabled;
      };

      tools = {
        git = enabled;
        misc = enabled;
        comma = enabled;
        bottom = enabled;
        btop = enabled;
        borgbackup = enabled;
	dig = enabled;
      };

      hardware = {
        audio = enabled;
        storage = enabled;
        networking = enabled;
      };

      services = {
        printing = enabled;
        openssh = enabled;
      };

      security = {
        gpg = enabled;
        keyring = enabled;
      };

      system = {
        boot = enabled;
        fonts = enabled;
        locale = enabled;
        time = enabled;
        xkb = enabled;
        sops-nix = enabled;
      };
    };
  };
}
