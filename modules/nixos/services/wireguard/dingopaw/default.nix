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
  cfg = config.${namespace}.services.wireguard.dingopaw;
in {
  options.${namespace}.services.wireguard.dingopaw= with types; {
    enable = mkBoolOpt false "Whether or not to enable wireguard-tools.";
  };

  config = mkIf cfg.enable {
    # configure sops for keyfiles
    sops.secrets.wg-ignorant-private = {
      sopsFile = ../secrets.yaml;
      owner = "jaduff";
      mode = "0400";
    };
    sops.secrets.wg-ignorant-public= {
      sopsFile = ../secrets.yaml;
      owner = "jaduff";
      mode = "0400";
    };
    sops.secrets.wg-dingopaw-public= {
      sopsFile = ../secrets.yaml;
      owner = "jaduff";
      mode = "0400";
    };
    sops.secrets.wg-dingopaw-private= {
      sopsFile = ../secrets.yaml;
      owner = "jaduff";
      mode = "0400";
    };
    sops.secrets.wg-jaduff-private = {
      sopsFile = ../secrets.yaml;
      owner = "jaduff";
      mode = "0400";
    };
    sops.secrets.wg-jaduff-public= {
      sopsFile = ../secrets.yaml;
      owner = "jaduff";
      mode = "0400";
    };
    sops.secrets.wg-psk = {
      sopsFile = ../secrets.yaml;
      owner = "jaduff";
      mode = "0400";
    };
     # enable NAT
  networking.nat.enable = true;
  networking.nat.externalInterface = "eth0";
  networking.nat.internalInterfaces = [ "wg0" ];
  networking.firewall = {
    allowedUDPPorts = [ 51820 ];
  };

  networking.wireguard.enable = true;
  networking.wireguard.interfaces = {
    # "wg0" is the network interface name. You can name the interface arbitrarily.
    wg0 = {
      # Determines the IP address and subnet of the server's end of the tunnel interface.
      ips = [ "10.100.0.1/24" ];

      # The port that WireGuard listens to. Must be accessible by the client.
      listenPort = 51820;

      # This allows the wireguard server to route your traffic to the internet and hence be like a VPN
      # For this to work you have to set the dnsserver IP of your router (or dnsserver of choice) in your clients
      postSetup = ''
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
      '';

      # This undoes the above command
      postShutdown = ''
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o eth0 -j MASQUERADE
      '';

      # Path to the private key file.
      #
      # Note: The private key can also be included inline via the privateKey option,
      # but this makes the private key world-readable; thus, using privateKeyFile is
      # recommended.
      privateKeyFile = config.sops.secrets.wg-dingopaw-private.path;

      peers = [
        # List of allowed peers.
        { # Feel free to give a meaningful name
          # Public key of the peer (not a file path).
	#ignorant
	publicKey = "xm4+XVgr8A6KgiqQbgRrJr4KJcSC//lUjcIkaif8aXE=";
          allowedIPs = [ "10.100.0.2/32" ]; }
	#jaduff
	{publicKey = "OAIZPW+WS0iCvkWxeDiMfgS3xFe9O8VKIFjaVzBS1SU=";
          allowedIPs = [ "10.100.0.2/32" ]; }
	#dingopaw
	{publicKey= "CSk5h/Ip1kR8hnkV/EXo5+EN2x0YMwwnxS6xmrPHBUE=";
         presharedKeyFile = config.sops.secrets.wg-psk.path;
          allowedIPs = [ "10.100.0.2/32" ]; }
          # List of IPs assigned to this peer within the tunnel subnet. Used to configure routing.
      ];
    };
  };
  };
}
