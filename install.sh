# ============================================
# install.sh - Dotfiles セットアップスクリプト
# ============================================

set -euo pipefail
DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

# Nix インストール
install_nix() {
    if command -v nix &> /dev/null; then
        echo "[skip] Nix is already installed."
        return
    fi

    echo "[install] Installing Nix (single-user mode)..."
    curl -L https://nixos.org/nix/install | sh -s -- --no-daemon

    # 現在のシェルにNixのパスを反映
    # shellcheck source=/dev/null
    . "$HOME/.nix-profile/etc/profile.d/nix.sh"

    echo "[done] Nix installed successfully."
}



# --------------------
# Nix Flakes 有効化
# --------------------
enable_flakes() {
    local nix_conf="$HOME/.config/nix/nix.conf"

    if [ -f "$nix_conf" ] && grep -q "experimental-features" "$nix_conf"; then
        echo "[skip] Flakes already enabled."
        return
    fi

    echo "[setup] Enabling Nix flakes..."
    mkdir -p "$(dirname "$nix_conf")"
    echo "experimental-features = nix-command flakes" >> "$nix_conf"
    echo "[done] Flakes enabled."
}

# --------------------
# Home Manager 適用
# --------------------
apply_home_manager() {
    local current_user
    current_user="$(whoami)"

    echo "[install] Applying Home Manager configuration for ${current_user}..."
    export PATH="$HOME/.nix-profile/bin:$HOME/.local/state/home-manager/gcroots/current-home/home-path/bin:$PATH"
    export USER="${current_user}"
    nix run home-manager/master -- switch --flake "${DOTFILES_DIR}#${current_user}" --impure
    echo "[done] Home Manager applied successfully."
}


# main

main() {
    echo "=== Dotfiles Setup ==="
    install_nix
    enable_flakes
    apply_home_manager
    echo "=== Setup Complete ==="
}

main "$@"

