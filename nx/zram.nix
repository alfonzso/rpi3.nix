{ ... }: {
  zramSwap.enable = true;
  zramSwap.memoryPercent = 50;

  # 2. /tmp in RAM (no temp file writes)
  boot.tmpOnTmpfs = true;

  # 3. Reduce logging writes
  services.journald.extraConfig = ''
    Storage=volatile
    RuntimeMaxUse=30M
  '';

  # 4. No traditional swap file
  swapDevices = [ ];

  # 5. Mount with noatime (reduces metadata writes)
  fileSystems."/".options = [ "noatime" ];
}
