#!/usr/bin/env bash
set -euo pipefail

# defaults (override with args)
SRC_DEFAULT="$HOME/dotfiles/nvim"
TARGET_DEFAULT="$HOME/.config/nvim"

SRC="${1:-$SRC_DEFAULT}"
TARGET="${2:-$TARGET_DEFAULT}"

timestamp() { date +"%Y%m%d%H%M%S"; }

# portable absolute path resolver (no here-docs)
abspath() {
  if command -v readlink >/dev/null 2>&1; then
    readlink -f "$1" && return
  fi
  if command -v realpath >/dev/null 2>&1; then
    realpath "$1" && return
  fi
  if command -v python3 >/dev/null 2>&1; then
    python3 -c 'import os,sys; print(os.path.realpath(sys.argv[1]))' "$1" && return
  fi
  if command -v python >/dev/null 2>&1; then
    python -c 'import os,sys; print(os.path.realpath(sys.argv[1]))' "$1" && return
  fi
  # fallback: print input
  echo "$1"
}

echo "Source: $SRC"
echo "Target: $TARGET"
echo

# check source exists
if [ ! -e "$SRC" ]; then
  echo "Error: source '$SRC' does not exist." >&2
  exit 1
fi

# ensure parent dir of target exists
mkdir -p "$(dirname "$TARGET")"

# create target directory if missing (we will place per-item symlinks inside)
if [ ! -e "$TARGET" ]; then
  echo "Creating target directory: $TARGET"
  mkdir -p "$TARGET"
fi

# if target is a symlink that points exactly to source (i.e. whole-dir symlink), nothing to do
if [ -L "$TARGET" ]; then
  src_real="$(abspath "$SRC")"
  target_real="$(readlink -f "$TARGET" 2>/dev/null || true)"
  if [ "$src_real" = "$target_real" ]; then
    echo "Target is already a symlink to the source. Nothing to do."
    exit 0
  else
    bak="$TARGET.bak.$(timestamp)"
    echo "Backing up existing target symlink: $TARGET -> $bak"
    mv "$TARGET" "$bak"
    mkdir -p "$TARGET"
  fi
fi

# iterate immediate children of SRC (including hidden entries except . and ..)
while IFS= read -r -d '' item; do
  name="$(basename "$item")"
  # skip '.' and '..' just in case
  if [ "$name" = "." ] || [ "$name" = ".." ]; then
    continue
  fi
  dest="$TARGET/$name"

  # If dest is a symlink that already points to the correct source, skip
  if [ -L "$dest" ]; then
    dest_target="$(readlink -f "$dest" 2>/dev/null || true)"
    src_real="$(abspath "$item" 2>/dev/null || true)"
    if [ -n "$dest_target" ] && [ -n "$src_real" ] && [ "$dest_target" = "$src_real" ]; then
      echo "Skipping (already linked): $dest -> $dest_target"
      continue
    fi
  fi

  # If something exists at dest and it's not the desired symlink, backup it
  if [ -e "$dest" ] || [ -L "$dest" ]; then
    bak="$dest.bak.$(timestamp)"
    echo "Backing up existing: $dest -> $bak"
    mv "$dest" "$bak"
  fi

  # create symlink
  ln -s "$item" "$dest"
  echo "Linked: $dest -> $item"

done < <(find "$SRC" -mindepth 1 -maxdepth 1 -print0)

echo
echo "Done."