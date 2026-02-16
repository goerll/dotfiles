#!/bin/bash

# Setup script for dotfiles
# Uses GNU Stow to manage symlinks
# Can be run multiple times safely - only performs missing steps
#

set -euo pipefail

cat << 'EOF'
           __..--''``---....___   _..._    __
 /// //_.-'    .-/";  `        ``<._  ``.''_ `. / // /
///_.-' _..--.'_    \                    `( ) ) // //
/ (_..-' // (< _     ;_..__               ; `' / ///
 / // // //  `-._,_)' // / ``--...____..-' /// / //
EOF

# =============================================================================
# SECTION: Configuration and Utilities
# =============================================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

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

skip() {
    echo -e "${BLUE}[SKIP]${NC} $*"
}

# =============================================================================
# SECTION: Prerequisites Check
# =============================================================================

if [[ $EUID -eq 0 ]]; then
    error "This script should not be run as root. It will use sudo when needed."
fi

if ! command -v sudo >/dev/null 2>&1; then
    error "sudo is not installed. Please install sudo first."
fi

if command -v yay >/dev/null 2>&1; then
    PKGMGR="yay"
elif command -v pacman >/dev/null 2>&1; then
    PKGMGR="sudo pacman"
else
    error "Neither yay nor pacman found. This script is for Arch Linux only."
fi

info "Using package manager: $PKGMGR"

# =============================================================================
# SECTION: Enable Bluetooth
# =============================================================================

if systemctl list-unit-files bluetooth.service >/dev/null 2>&1; then
    if systemctl is-active --quiet bluetooth 2>/dev/null; then
        skip "Bluetooth service is already active."
    else
        info "Enabling bluetooth service..."
        if sudo systemctl enable --now bluetooth; then
            info "Bluetooth service enabled successfully."
        else
            warn "Failed to enable bluetooth service."
        fi
    fi
else
    skip "Bluetooth service not available on this system."
fi

# =============================================================================
# SECTION: Install Stow
# =============================================================================

if ! command -v stow >/dev/null 2>&1; then
    info "Installing stow..."
    sudo pacman -S --needed --noconfirm stow || error "Failed to install stow"
else
    skip "stow is already installed."
fi

# =============================================================================
# SECTION: Stow Dotfiles
# =============================================================================

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
info "Dotfiles directory: $DOTFILES_DIR"

cd "$DOTFILES_DIR" || error "Failed to change to dotfiles directory"

info "Checking for conflicting files..."

# Try stow in simulation mode to detect conflicts
if stow --no --verbose --target="$HOME" . 2>&1 | grep -q "existing target is"; then
    warn "Found conflicting files. Removing them..."
    
    # Get list of conflicts and remove them
    stow --no --verbose --target="$HOME" . 2>&1 | grep "existing target is" | sed 's/.*existing target is neither.* nor.*: //' | while read -r conflict; do
        conflict_path="$HOME/$conflict"
        if [[ -e "$conflict_path" ]]; then
            info "Removing conflicting file: $conflict_path"
            rm -rf "$conflict_path"
        fi
    done
fi

info "Stowing dotfiles..."
stow --verbose --target="$HOME" . || error "Failed to stow dotfiles"

info "Dotfiles stowed successfully!"

# =============================================================================
# SECTION: Install Packages
# =============================================================================

PACKAGES_FILE="packages.txt"
if [[ ! -f "$PACKAGES_FILE" ]]; then
    error "Packages file $PACKAGES_FILE not found."
fi

mapfile -t packages < <(
    grep -v '^#' "$PACKAGES_FILE" | 
    grep -v '^$' | 
    sed 's/#.*//' | 
    sed 's/^[[:space:]]*//;s/[[:space:]]*$//'
)

if [[ ${#packages[@]} -eq 0 ]]; then
    warn "No packages found in $PACKAGES_FILE."
else
    info "Installing ${#packages[@]} packages..."

    for pkg in "${packages[@]}"; do
        [[ -z "$pkg" ]] && continue
        
        if pacman -Qq "$pkg" >/dev/null 2>&1; then
            skip "Package already installed: $pkg"
        else
            info "Installing $pkg..."
            $PKGMGR -S --needed --noconfirm "$pkg" || warn "Failed to install $pkg"
        fi
    done
fi

# =============================================================================
# SECTION: Change Default Shell to Zsh
# =============================================================================

if ! command -v zsh >/dev/null 2>&1; then
    warn "Zsh is not installed. Skipping shell change."
else
    CURRENT_SHELL="$(getent passwd "$USER" | cut -d: -f7)"
    ZSH_PATH="$(command -v zsh)"

    if [[ "$CURRENT_SHELL" == "$ZSH_PATH" ]]; then
        skip "Default shell is already zsh."
    else
        info "Changing default shell to zsh..."
        if chsh -s "$ZSH_PATH"; then
            info "Default shell changed to zsh. Please log out and log back in for changes to take effect."
        else
            error "Failed to change default shell to zsh."
        fi
    fi
fi

# =============================================================================
# SECTION: Completion
# =============================================================================

info "Setup completed successfully!"
