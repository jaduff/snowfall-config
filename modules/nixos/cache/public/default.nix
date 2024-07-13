{
  config,
  lib,
  namespace,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.cache.public;
in
{
  options.${namespace}.cache.public = {
    enable = mkEnableOption "Plus Ultra public cache";
  };

  config = mkIf cfg.enable {
    plusultra.nix.extra-substituters = {
#      "https://attic.ruby.hamho.me/public".key = "public:QUkZTErD8fx9HQ64kuuEUZHO9tXNzws7chV8qy/KLUk=";
      "https://cache.nixos.org".key = "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";
      "https://nix-community.cachix.org".key = "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";
      "https://cache.lix.systems".key = "cache.lix.systems:aBnZUw8zA7H35Cz2RyKFVs3H4PlGTLawyY5KRbvJR8o=";

    };
  };
}
