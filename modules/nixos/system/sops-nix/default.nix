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
  cfg = config.${namespace}.apps.sops-nix;
  isEd25519 = k: k.type == "ed25519";
  getKeyPath = k: k.path;
  keys = builtins.filter isEd25519 config.services.openssh.hostKeys;
in {
  options.${namespace}.apps.sops-nix = with types; {
    enable = mkBoolOpt false "Whether or not to enable sops-nix.";
  };

  config = mkIf cfg.enable {
    imports = [inputs.sops-nix.nixosModules.sops];
    environment.systemPackages = with pkgs; [sops ssh-to-age];
    sops = {
      age.sshKeyPaths = map getKeyPath keys;
    sopsTest = config.sops.secrets.raspberrypi_syncthing_id
    };
  };

}
