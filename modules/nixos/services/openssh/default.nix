{
  options,
  config,
  pkgs,
  lib,
  host ? "",
  format ? "",
  inputs ? { },
  namespace,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.services.openssh;

  user = config.users.users.${config.${namespace}.user.name};
  user-id = builtins.toString user.uid;

  # TODO: This is a hold-over from an earlier Snowfall Lib version which used
  # the specialArg `name` to provide the host name.
  name = host;

  default-key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOvOCYx3WQIToff/c4WxRmZT/R89b1wJxcv36SNtWTYn";
  terminus-key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDGaeTTxW6kKkQJDvFd0+Jd6NeZM0wStafm8SzS0sjIJtjvfRzvkEGbAR2E1w4C37lpL6ll9VRdDpN5ZwF1ekVltrpr3NcCaAt6HOixJf/l7Quz52l9nl/8S1u8FmwU4+x50LStruvQrYErr5GEkd32ABQD8Vlh6Sslzw4kZ3LB/M3LrFXVrjO/Xf2n+hGngZmcT56f7GZVQY8+5pq99BOQVEjaeP52Twyp96meh0xbsdUyR7mgyDdg0VBbSq7D383qQFZ6TjB1T2p6aaka59Qm4EbzW5yenSOk9DSGf+1Xb773o//TPcSv4/3Rpj/s01BiIag8lnl0/5+5LpTxjzR1";

  other-hosts = lib.filterAttrs (
    key: host: key != name && (host.config.${namespace}.user.name or null) != null
  ) ((inputs.self.nixosConfigurations or { }) // (inputs.self.darwinConfigurations or { }));

  other-hosts-config = lib.concatMapStringsSep "\n" (
    name:
    let
      remote = other-hosts.${name};
      remote-user-name = remote.config.${namespace}.user.name;
      remote-user-id = builtins.toString remote.config.users.users.${remote-user-name}.uid;

      forward-gpg =
        optionalString (config.programs.gnupg.agent.enable && remote.config.programs.gnupg.agent.enable)
          ''
            RemoteForward /run/user/${remote-user-id}/gnupg/S.gpg-agent /run/user/${user-id}/gnupg/S.gpg-agent.extra
            RemoteForward /run/user/${remote-user-id}/gnupg/S.gpg-agent.ssh /run/user/${user-id}/gnupg/S.gpg-agent.ssh
          '';
    in
    ''
      Host ${name}
        User ${remote-user-name}
        ForwardAgent yes
        Port ${builtins.toString cfg.port}
        ${forward-gpg}
    ''
  ) (builtins.attrNames other-hosts);
in
{
  options.${namespace}.services.openssh = with types; {
    enable = mkBoolOpt false "Whether or not to configure OpenSSH support.";
    authorizedKeys = mkOpt (listOf str) [ default-key terminus-key ] "The public keys to apply.";
    port = mkOpt port 8888 "The port to listen on (in addition to 22).";
    manage-other-hosts =
      mkOpt bool true
        "Whether or not to add other host configurations to SSH config.";
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;

      settings = {
        PermitRootLogin = if format == "install-iso" then "yes" else "no";
        PasswordAuthentication = false;
      };

      extraConfig = ''
        StreamLocalBindUnlink yes
      '';

      ports = [
        22
        cfg.port
      ];
    };

    programs.ssh.extraConfig = ''
      Host *
        HostKeyAlgorithms +ssh-rsa

      ${optionalString cfg.manage-other-hosts other-hosts-config}
    '';

    plusultra.user.extraOptions.openssh.authorizedKeys.keys = cfg.authorizedKeys;

    plusultra.home.extraOptions = {
      programs.zsh.shellAliases = foldl (
        aliases: system: aliases // { "ssh-${system}" = "ssh ${system} -t tmux a"; }
      ) { } (builtins.attrNames other-hosts);
    };
  };
}
