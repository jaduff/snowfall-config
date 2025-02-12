{
  options,
  config,
  pkgs,
  lib,
  namespace,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.system.power-management;
in
{
  options.${namespace}.system.power-management = with types; {
    enable = mkBoolOpt false "Whether or not to manage power-management settings.";
  };

  config = mkIf cfg.enable {
  services.power-profiles-daemon.enable = false;
  services.tlp = {
  enable = true;
  settings = {
    CPU_SCALING_GOVERNOR_ON_AC = "performance";
    CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

    CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
    CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

    CPU_MIN_PERF_ON_AC = 0;
    CPU_MAX_PERF_ON_AC = 100;
    CPU_MIN_PERF_ON_BAT = 0;
    CPU_MAX_PERF_ON_BAT = 50;

    CPU_BOOST_ON_AC=1;
    CPU_BOOST_ON_BAT=0;

    CPU_HWP_DYN_BOOST_ON_AC=1;
    CPU_HWP_DYN_BOOST_ON_BAT=0;

    # Optional helps save long term battery health
    START_CHARGE_THRESH_BAT0 = 40; # 40 and bellow it starts to charge
    STOP_CHARGE_THRESH_BAT0 = 80;  # 80 and above it stops charging

    WIFI_PWR_ON_BAT=1;
  };
  };
  services.auto-cpufreq.enable = true;
  services.auto-cpufreq.settings = {
  battery = {
    governor = "powersave";
    turbo = "never";
  };
  charger = {
    governor = "performance";
    turbo = "auto";
  };
};
  powerManagement.powertop.enable = true;


  };
}
