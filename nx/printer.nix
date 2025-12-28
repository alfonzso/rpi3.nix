{ pkgs, ... }:

let
  drivers = with pkgs; [
    cups-filters # PDF→PS and filter helpers
    cups-browsed # optional: auto-create queues for discovered printers
    splix # Optional—if your model also supports SPL
    ghostscript
  ];
in {
  services.printing = {
    enable = true;
    webInterface = true; # enable http://localhost:631/ (CUPS web UI)
    drivers = drivers;
    browsing = true; # enable cups-browsed discovery
    browsedConf = ''
      BrowseDNSSDSubTypes _ipp,_universal
      BrowseProtocols all
      CreateIPPPrinterQueues All
    '';

    allowFrom = [ "all" ];
    extraConf = ''
      DefaultEncryption Never
      ServerAlias *
    '';

    defaultShared = true; # share printers added here
    listenAddresses = [ "*:631" ]; # listen on IPP port
    openFirewall = true; # let the NixOS firewall allow printing
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true; # allow resolving *.local via Avahi (IPv4)
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
      userServices = true; # allow advertising user service files
    };
    openFirewall = true; # open UDP 5353 for mDNS
  };

  # (If you use NixOS firewall; optional if you used openFirewall above)
  networking.firewall.allowedTCPPorts = [ 631 ]; # IPP (CUPS)
  networking.firewall.allowedUDPPorts = [ 5353 ]; # mDNS (Avahi)
}
