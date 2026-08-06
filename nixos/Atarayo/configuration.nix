{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../common-configuration.nix
  ];

  hardware.asahi.enable = true;
  hardware.asahi.peripheralFirmwareDirectory = /firmware;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = false;
  boot.consoleLogLevel = 1;
  boot.kernelParams = [ "quiet" ];

  networking.hostName = "Atarayo";
  time.timeZone = "Asia/Tokyo";

  services.openssh.openFirewall = true;

  environment.systemPackages = with pkgs; [
    vim
    git
    fastfetch
  ];

  zramSwap.enable = true;

  system.stateVersion = "26.11";
}
