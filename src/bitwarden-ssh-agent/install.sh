#!/bin/sh
set -e

# Set SSH_AUTH_SOCK for the bitwarden SSH agent
SSH_AUTH_SOCK="/tmp/.bitwarden-ssh-agent.sock"

# Add to /etc/profile.d for system-wide configuration
echo "export SSH_AUTH_SOCK=\"${SSH_AUTH_SOCK}\"" > /etc/profile.d/bitwarden-ssh-agent.sh
chmod +x /etc/profile.d/bitwarden-ssh-agent.sh

# Also add to common shell rc files as a fallback
for rc_file in /etc/bash.bashrc /etc/zsh/zshrc; do
    if [ -f "$rc_file" ]; then
        echo "export SSH_AUTH_SOCK=\"${SSH_AUTH_SOCK}\"" >> "$rc_file"
    fi
done

# Add Fish shell support
FISH_CONF_DIR="/etc/fish/conf.d"
if [ -d "$FISH_CONF_DIR" ] || command -v fish >/dev/null 2>&1; then
    mkdir -p "$FISH_CONF_DIR"
    
    echo "set -gx SSH_AUTH_SOCK \"${SSH_AUTH_SOCK}\"" > "${FISH_CONF_DIR}/bitwarden-ssh-agent.fish"
fi

echo "Bitwarden SSH agent configuration complete"
