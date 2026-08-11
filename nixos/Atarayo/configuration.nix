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

  users.users.bikkyue.extraGroups = [ "uinput" ];

  programs.niri.enable = true;

  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };

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
        globalOptions = {
          "Hotkey/TriggerKeys" = {
            "0" = "Menu";
            "1" = "Zenkaku_Hankaku";
          };
          "Hotkey/AltTriggerKeys"."0" = "Shift+Shift_R";
        };
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
        keyboard {
            xkb {
                layout "us"
                options "terminate:ctrl_alt_bksp,caps:menu"
            }
        }

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

    workspace "desktop"

    window-rule {
        match app-id=r#"^Alacritty$"#
        opacity 0.85
    }

    spawn-at-startup "waybar"
    spawn-at-startup "awww-daemon"
    hotkey-overlay { }
    screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"

    binds {
        Mod+Shift+Slash { show-hotkey-overlay; }
        Mod+T { spawn "alacritty"; }
        Mod+E { spawn "cosmic-files"; }
        Mod+D { spawn "fuzzel"; }
        Ctrl+B { spawn "firefox"; }
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

  home-manager.users.bikkyue =
    let
      nvimMimeTypes = [
        "application/javascript"
        "application/json"
        "application/toml"
        "application/typescript"
        "application/x-shellscript"
        "text/javascript"
        "text/markdown"
        "text/plain"
        "text/typescript"
        "text/x-c"
        "text/x-c++src"
        "text/x-java"
        "text/x-lua"
        "text/x-nix"
        "text/x-python"
        "text/x-rust"
      ];
    in
    {
      xdg.configFile."alacritty/alacritty.toml".text = ''
        [font]
        normal = { family = "NotoSansM Nerd Font Mono" }

      '';

      xdg.configFile."fuzzel/fuzzel.ini".text = ''
        [main]
        font=NotoSansM Nerd Font Mono:size=18
        prompt=󰍉  
        placeholder=アプリを検索...
        lines=10
        width=50
        horizontal-pad=32
        vertical-pad=24
        inner-pad=12
        icon-theme=Adwaita
        layer=overlay

        [colors]
        background=14161ce6
        text=e6e9efff
        prompt=89b4faff
        placeholder=6c7086ff
        input=cdd6f4ff
        match=f9e2afff
        selection=89b4faff
        selection-text=111318ff
        selection-match=111318ff
        border=89b4faff

        [border]
        width=2
        radius=14
      '';

      xdg.configFile."waybar/config".text = builtins.toJSON {
        position = "bottom";
        layer = "top";
        height = 48;
        spacing = 6;
        margin-bottom = 6;
        margin-left = 6;
        margin-right = 6;
        modules-left = [
          "custom/launcher"
          "custom/home"
          "custom/firefox"
          "custom/files"
          "custom/terminal"
          "custom/separator-apps"
          "wlr/taskbar"
        ];
        modules-right = [
          "cpu"
          "memory"
          "disk"
          "custom/separator-workspaces"
          "niri/workspaces"
          "tray"
          "wireplumber"
          "clock"
        ];

        "custom/launcher" = {
          format = "󰍉";
          tooltip = "Applications";
          on-click = "fuzzel";
        };
        "custom/home" = {
          format = "";
          tooltip = "Show desktop (right-click: previous workspace)";
          on-click = "niri msg action focus-workspace desktop";
          on-click-right = "niri msg action focus-workspace-previous";
        };
        "custom/firefox" = {
          format = "";
          tooltip = "Firefox";
          on-click = "firefox";
        };
        "custom/files" = {
          format = "";
          tooltip = "Files";
          on-click = "cosmic-files";
        };
        "custom/terminal" = {
          format = "";
          tooltip = "Terminal";
          on-click = "alacritty";
        };
        "custom/separator-apps" = {
          format = "│";
          tooltip = false;
        };
        "custom/separator-workspaces" = {
          format = "│";
          tooltip = false;
        };
        cpu = {
          format = " {usage}%";
          tooltip = false;
          interval = 2;
        };
        memory = {
          format = " {percentage}%";
          tooltip = false;
          interval = 2;
        };
        disk = {
          format = " {percentage_used}%";
          tooltip = false;
          interval = 30;
          path = "/";
        };
        "wlr/taskbar" = {
          format = "{icon}";
          icon-size = 24;
          tooltip-format = "{title}";
          on-click = "activate";
          on-click-middle = "close";
        };
        "niri/workspaces" = {
          format = "{icon}";
          format-icons.desktop = "";
        };
        tray = {
          icon-size = 18;
          spacing = 8;
        };
        wireplumber = {
          format = "{icon} {volume}%";
          format-muted = "󰖁";
          format-icons = [
            ""
            ""
            ""
          ];
          on-click = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          on-scroll-up = "wpctl set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 5%+";
          on-scroll-down = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
        };
        clock = {
          format = "{:%H:%M}";
          tooltip-format = "{:%Y-%m-%d %A}";
        };
      };

      xdg.configFile."waybar/style.css".text = ''
        * {
          border: none;
          border-radius: 0;
          font-family: "NotoSansM Nerd Font Mono";
          font-size: 14px;
          min-height: 0;
        }

        window#waybar {
          background: rgba(20, 22, 28, 0.72);
          color: #e6e9ef;
          border-radius: 14px;
          opacity: 1;
        }

        .modules-left {
          padding-left: 8px;
        }

        #custom-launcher,
        #custom-home,
        #custom-firefox,
        #custom-files,
        #custom-terminal,
        #cpu,
        #memory,
        #disk,
        #taskbar button,
        #workspaces button,
        #tray,
        #wireplumber,
        #clock {
          padding: 0 12px;
          margin: 5px 0;
          border-radius: 10px;
        }

        #custom-separator-apps,
        #custom-separator-workspaces {
          padding: 0 3px;
          color: rgba(230, 233, 239, 0.45);
        }

        #custom-launcher:hover,
        #custom-home:hover,
        #custom-firefox:hover,
        #custom-files:hover,
        #custom-terminal:hover,
        #cpu:hover,
        #memory:hover,
        #disk:hover,
        #taskbar button:hover,
        #workspaces button:hover {
          background: rgba(255, 255, 255, 0.12);
        }

        #taskbar button.active,
        #workspaces button.active {
          background: #89b4fa;
          color: #111318;
        }

        #taskbar button.minimized {
          opacity: 0.55;
        }

        #clock {
          margin-right: 6px;
          font-weight: bold;
        }

        #wireplumber.muted {
          opacity: 0.55;
        }
      '';

      xdg.desktopEntries.nvim-terminal = {
        name = "Neovim (Alacritty)";
        genericName = "Text Editor";
        exec = "alacritty -e nvim %F";
        icon = "nvim";
        terminal = false;
        categories = [
          "Utility"
          "TextEditor"
        ];
        mimeType = nvimMimeTypes;
      };

      xdg.mimeApps = {
        enable = true;
        defaultApplications = builtins.listToAttrs (
          map (mimeType: {
            name = mimeType;
            value = [ "nvim-terminal.desktop" ];
          }) nvimMimeTypes
        );
      };
    };

  environment.systemPackages = with pkgs; [
    vim
    git
    adwaita-icon-theme
    fastfetch
    alacritty
    cosmic-files
    fuzzel
    waybar
    xwayland-satellite
    firefox
    awww
  ];

  zramSwap.enable = true;

  system.stateVersion = "26.11";
}
