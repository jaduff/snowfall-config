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
  cfg = config.${namespace}.system.sops-nix;
  isEd25519 = k: k.type == "ed25519";
  getKeyPath = k: k.path;
  keys = builtins.filter isEd25519 config.services.openssh.hostKeys;
in {
  options.${namespace}.system.sops-nix = with types; {
    enable = mkBoolOpt false "Whether or not to enable sops-nix.";
  };
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [sops ssh-to-age];
    sops = {
      defaultSopsFile = /home/jaduff/Source/snowfall-config/secrets/secrets.yaml;
      defaultSopsFormat = "yaml";
      age.sshKeyPaths = map getKeyPath keys;
    };
  };

}
