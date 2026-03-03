#!/bin/bash

set -e

echo "=== Linux Development Environment Setup ==="
echo ""

# Detect package manager
if command -v apt &> /dev/null; then
    PKG_MANAGER="apt"
    UPDATE_CMD="sudo apt update"
    INSTALL_CMD="sudo apt install -y"
elif command -v yum &> /dev/null; then
    PKG_MANAGER="yum"
    UPDATE_CMD="sudo yum update -y"
    INSTALL_CMD="sudo yum install -y"
elif command -v dnf &> /dev/null; then
    PKG_MANAGER="dnf"
    UPDATE_CMD="sudo dnf update -y"
    INSTALL_CMD="sudo dnf install -y"
elif command -v pacman &> /dev/null; then
    PKG_MANAGER="pacman"
    UPDATE_CMD="sudo pacman -Sy"
    INSTALL_CMD="sudo pacman -S --noconfirm"
else
    echo "Unsupported package manager. Exiting."
    exit 1
fi

echo "Detected package manager: $PKG_MANAGER"
echo ""

# Update package lists
echo "=== Updating package lists ==="
$UPDATE_CMD
echo ""

# Install curl and wget if not present (needed for other installations)
echo "=== Installing prerequisites (curl, wget, git) ==="
$INSTALL_CMD curl wget git
echo ""

# Install Node.js and npm
echo "=== Installing Node.js and npm ==="
if command -v node &> /dev/null; then
    echo "Node.js is already installed: $(node --version)"
else
    # Use NodeSource for latest LTS version
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    $INSTALL_CMD nodejs
    echo "Node.js installed: $(node --version)"
    echo "npm installed: $(npm --version)"
fi
echo ""

# Install tmux
echo "=== Installing tmux ==="
if command -v tmux &> /dev/null; then
    echo "tmux is already installed: $(tmux -V)"
else
    $INSTALL_CMD tmux
    echo "tmux installed: $(tmux -V)"
fi
echo ""

# Install uv
echo "=== Installing uv ==="
if command -v uv &> /dev/null; then
    echo "uv is already installed: $(uv --version)"
else
    curl -LsSf https://astral.sh/uv/install.sh | sh
    # Add to PATH for current session
    export PATH="$HOME/.local/bin:$PATH"
    echo "uv installed: $(uv --version)"
fi
echo ""

# Install opencode
echo "=== Installing opencode ==="
if command -v opencode &> /dev/null; then
    echo "opencode is already installed"
else
    # opencode is typically installed via npm
    npm install -g opencode
    echo "opencode installed"
fi
echo ""

# Install kilocode
echo "=== Installing kilocode ==="
if command -v kilo &> /dev/null || command -v kilocode &> /dev/null; then
    echo "kilocode is already installed"
else
    # Try to install via npm first, otherwise use the install script
    if npm install -g kilocode 2>/dev/null; then
        echo "kilocode installed via npm"
    else
        # Alternative: use the install script from kilo.ai
        curl -fsSL https://kilo.ai/install.sh | sh
        echo "kilocode installed"
    fi
fi
echo ""

echo "=== Installation Complete! ==="
echo ""
echo "Installed versions:"
echo "  Node.js: $(node --version 2>/dev/null || echo 'not found')"
echo "  npm: $(npm --version 2>/dev/null || echo 'not found')"
echo "  tmux: $(tmux -V 2>/dev/null || echo 'not found')"
echo "  uv: $(uv --version 2>/dev/null || echo 'not found')"
echo ""
echo "You may need to restart your terminal or run 'source ~/.bashrc' to use all tools."
