{ lib, ... }:
with lib; {
  # Declare what settings a user of this "hello.nix" module CAN SET.
  # options.rpi3-config = {
  options.rpi = {
    # enable = mkEnableOption "hello service";
    user = mkOption {
      type = types.str;
      default = "nxadmin";
    };
    user_password = mkOption {
      type = types.str;
      default = "foobar";
    };
    hostname = mkOption {
      type = types.str;
      default = "world";
    };
    wifi = mkOption {
      type = lib.types.submodule {
        options = {
          ssid = mkOption {
            type = types.str;
            default = "mywifi";
          };
          ssid_password = mkOption {
            type = types.str;
            default = "mywifipwd";
          };
          interface = mkOption {
            type = types.str;
            default = "wlan0";
          };
        };
      };
      default = { };
    };
  };

}

# user = getEnvOrFail "USER";
# user_password = getEnvOrFail "USER_PASS";
# ssid = getenv "WIFI";
# ssid_password = getEnvOrFail "WIFI_PASS";
# interface = getEnvOrFail "INTERFACE";
# hostname = getEnvOrFail "HOSTNAME";
