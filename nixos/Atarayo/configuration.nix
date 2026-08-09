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

    workspace "desktop"

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
        Mod+E { spawn "cosmic-files"; }
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
          "custom/separator-workspaces"
          "niri/workspaces"
          "tray"
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
        #taskbar button,
        #workspaces button,
        #tray,
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
