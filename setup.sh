#!/bin/bash

# Setup script for dotfiles
# Installs stow, stows dotfiles, and installs packages

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

error() {
    echo -e "${RED}[ERROR]${NC} $*" >&2
    exit 1
}

info() {
    echo -e "${GREEN}[INFO]${NC} $*"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $*"
}

# Check if running as root (we'll need sudo for package installation)
if [[ $EUID -eq 0 ]]; then
    error "This script should not be run as root. It will use sudo when needed."
fi

# Check for sudo
if ! command -v sudo >/dev/null 2>&1; then
    error "sudo is not installed. Please install sudo first."
fi

# Determine package manager
if command -v yay >/dev/null 2>&1; then
    PKGMGR="yay"
elif command -v pacman >/dev/null 2>&1; then
    PKGMGR="sudo pacman"
else
    error "Neither yay nor pacman found. This script is for Arch Linux only."
fi

info "Using package manager: $PKGMGR"

# Install stow if not installed
if ! command -v stow >/dev/null 2>&1; then
    info "Installing stow..."
    sudo pacman -S --needed --noconfirm stow || error "Failed to install stow"
else
    info "stow is already installed."
fi

# Determine dotfiles directory (where this script resides)
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

info "Dotfiles directory: $DOTFILES_DIR"

# Change to dotfiles directory
cd "$DOTFILES_DIR" || error "Failed to change to dotfiles directory"

# Stow dotfiles (only hidden files/directories except .git)
info "Stowing dotfiles..."
for item in .[!.]*; do
    # Skip .git and any other unwanted items
    if [[ "$item" == ".git" ]] || [[ "$item" == ".gitignore" ]]; then
        continue
    fi
    if [[ ! -e "$item" ]]; then
        continue
    fi

    if [[ -d "$item" ]]; then
        # For directories, use stow
        info "Stowing directory: $item..."
        # Capture stow output and exit status
        stow_output=$(stow --verbose --target="$HOME" "$item" 2>&1)
        stow_exit=$?
        while IFS= read -r line; do
            info "stow: $line"
        done <<< "$stow_output"
        if [[ $stow_exit -ne 0 ]]; then
            warn "stow encountered an error for $item (exit code: $stow_exit)"
        fi
    elif [[ -f "$item" ]]; then
        # For files, create symlink directly
        info "Creating symlink for file: $item..."
        target="$HOME/$item"
        source_abs="$(pwd)/$item"

        # Check if symlink already exists and points to the right place
        if [[ -L "$target" ]]; then
            current_target="$(readlink -f "$target")"
            if [[ "$current_target" == "$source_abs" ]]; then
                info "Symlink already exists and points to correct location: $target"
                continue
            else
                warn "Removing existing symlink $target (points to $current_target)"
                rm "$target"
            fi
        elif [[ -e "$target" ]]; then
            # Backup regular file/directory
            warn "Backing up existing $target to ${target}.bak"
            mv "$target" "${target}.bak"
        fi

        # Create symlink
        if ln -s "$source_abs" "$target"; then
            info "Created symlink: $target -> $source_abs"
        else
            error "Failed to create symlink for $item"
        fi
    fi
done

# Install packages from packages.packages
PACKAGES_FILE="packages.packages"
if [[ ! -f "$PACKAGES_FILE" ]]; then
    error "Packages file $PACKAGES_FILE not found."
fi

# Read packages into array, ignoring empty lines and comments
mapfile -t packages < <(grep -v '^#' "$PACKAGES_FILE" | grep -v '^$')

if [[ ${#packages[@]} -eq 0 ]]; then
    warn "No packages found in $PACKAGES_FILE."
    exit 0
fi

info "Installing ${#packages[@]} packages..."

# Install packages
for pkg in "${packages[@]}"; do
    info "Installing $pkg..."
    $PKGMGR -S --needed --noconfirm "$pkg" || warn "Failed to install $pkg"
done

info "Setup completed successfully!"
