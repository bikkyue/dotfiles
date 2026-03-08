# ============================================
# install.sh - Dotfiles セットアップスクリプト
# ============================================


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

# main

main() {
    echo "=== Dotfiles Setup ==="
    install_nix
    echo "=== Setup Complete ==="
}
