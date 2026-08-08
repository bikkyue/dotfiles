{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../common-configuration.nix
  ];

  hardware.asahi.enable = true;
  hardware.asahi.peripheralFirmwareDirectory = /firmware;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    input.General.UserspaceHID = false;
  };
  systemd.services.bluetooth.serviceConfig.CapabilityBoundingSet = [
    "CAP_NET_ADMIN"
    "CAP_NET_BIND_SERVICE"
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 5;
  boot.loader.efi.canTouchEfiVariables = false;
  boot.consoleLogLevel = 1;
  boot.kernelParams = [ "quiet" ];

  networking.hostName = "Atarayo";
  time.timeZone = "Asia/Tokyo";

  programs.niri.enable = true;

  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.tuigreet}/bin/tuigreet --time --remember --cmd niri-session";
      user = "greeter";
    };
  };

  security.polkit.enable = true;

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [ fcitx5-mozc ];
      settings = {
        inputMethod = {
          "Groups/0" = {
            Name = "Default";
            "Default Layout" = "us";
            DefaultIM = "mozc";
          };
          "Groups/0/Items/0" = {
            Name = "keyboard-us";
            Layout = "";
          };
          "Groups/0/Items/1" = {
            Name = "mozc";
            Layout = "";
          };
          "GroupOrder"."0" = "Default";
        };
      };
    };
  };

  environment.etc."niri/config.kdl".text = ''
    input {
        touchpad {
            tap
            natural-scroll
        }
    }

    layout {
        gaps 12
        default-column-width { proportion 0.5; }
        focus-ring { off; }
        border { off; }
    }

    window-rule {
        match app-id=r#"^Alacritty$"#
        opacity 0.85
    }

    spawn-at-startup "waybar"
    spawn-at-startup "fcitx5" "-d"
    spawn-at-startup "awww-daemon"
    hotkey-overlay { }
    screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"

    binds {
        Caps_Lock { spawn "fcitx5-remote" "-t"; }
        Mod+Shift+Slash { show-hotkey-overlay; }
        Mod+T { spawn "alacritty"; }
        Mod+D { spawn "fuzzel"; }
        Mod+Q { close-window; }
        Mod+O repeat=false { toggle-overview; }

        Mod+Left  { focus-column-left; }
        Mod+Down  { focus-window-down; }
        Mod+Up    { focus-window-up; }
        Mod+Right { focus-column-right; }
        Mod+Ctrl+Left  { move-column-left; }
        Mod+Ctrl+Down  { move-window-down; }
        Mod+Ctrl+Up    { move-window-up; }
        Mod+Ctrl+Right { move-column-right; }

        Mod+Page_Down { focus-workspace-down; }
        Mod+Page_Up   { focus-workspace-up; }
        Mod+Ctrl+Page_Down { move-column-to-workspace-down; }
        Mod+Ctrl+Page_Up   { move-column-to-workspace-up; }

        Mod+R { switch-preset-column-width; }
        Mod+F { maximize-column; }
        Mod+Shift+F { fullscreen-window; }
        Mod+V { toggle-window-floating; }

        Print { screenshot; }
        Ctrl+Print { screenshot-screen; }
        Alt+Print { screenshot-window; }

        Mod+Shift+E { quit; }
        Mod+Shift+P { power-off-monitors; }
    }
  '';

  home-manager.users.bikkyue.xdg.configFile."alacritty/alacritty.toml".text = ''
    [font]
    normal = { family = "NotoSansM Nerd Font Mono" }

  '';

  environment.systemPackages = with pkgs; [
    vim
    git
    fastfetch
    alacritty
    fuzzel
    waybar
    xwayland-satellite
    firefox
    awww
  ];

  zramSwap.enable = true;

  system.stateVersion = "26.11";
}
