#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
USERNAME="bikkyue"

install_nix() {
    if command -v nix &> /dev/null; then
        echo "[skip] Nix is already installed."
        return
    fi

    case "$(uname -s)" in
        Darwin)
            echo "[install] Installing Nix in daemon mode..."
            curl -L https://nixos.org/nix/install | sh -s -- --daemon
            # shellcheck source=/dev/null
            . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
            ;;
        *)
            echo "[install] Installing Nix in single-user mode..."
            curl -L https://nixos.org/nix/install | sh -s -- --no-daemon
            # shellcheck source=/dev/null
            . "$HOME/.nix-profile/etc/profile.d/nix.sh"
            ;;
    esac
}

enable_flakes() {
    local nix_conf="$HOME/.config/nix/nix.conf"

    if [ -f "$nix_conf" ] && grep -q "experimental-features" "$nix_conf"; then
        echo "[skip] Flakes are already enabled."
        return
    fi

    echo "[setup] Enabling Nix flakes..."
    mkdir -p "$(dirname "$nix_conf")"
    echo "experimental-features = nix-command flakes" >> "$nix_conf"
}

apply_nixos() {
    local target

    case "$(hostname)" in
        Shironere)
            target="Shironere"
            if ! sudo test -f /var/lib/cloudflared/token; then
                echo "[error] Restore /var/lib/cloudflared/token before rebuilding NixOS." >&2
                exit 1
            fi
            ;;
        Atarayo|atarayo|Geppaku)
            target="Atarayo"
            ;;
        *)
            echo "[error] No NixOS configuration is defined for $(hostname)." >&2
            exit 1
            ;;
    esac

    echo "[install] Applying the ${target} NixOS configuration..."
    sudo nixos-rebuild switch \
        --flake "path:${DOTFILES_DIR}#${target}" \
        --impure
}

apply_home_manager() {
    if [ "$(whoami)" != "$USERNAME" ]; then
        echo "[error] Home Manager is configured for ${USERNAME}." >&2
        exit 1
    fi

    case "$(uname -s)" in
        Darwin|Linux) ;;
        *)
            echo "[error] Unsupported operating system: $(uname -s)" >&2
            exit 1
            ;;
    esac

    echo "[install] Applying Home Manager configuration ${USERNAME}..."
    nix run home-manager/master -- switch \
        --flake "path:${DOTFILES_DIR}" \
        --impure \
        -b backup
}

main() {
    echo "=== Dotfiles Setup ==="

    if [ -e /etc/NIXOS ]; then
        apply_nixos
    else
        install_nix
        enable_flakes
        apply_home_manager
    fi

    echo "=== Setup Complete ==="

    if command -v zsh &> /dev/null; then
        exec zsh
    fi
}

main "$@"
