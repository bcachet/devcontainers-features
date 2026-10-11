#!/usr/bin/env bash

set -e

echo '---------------------------------------------------------------'
echo " Mise: Installing $TOOLS"
echo '---------------------------------------------------------------'

# tools installed here are shared by every user of the image
MISE_SYSTEM_DATA_DIR="${MISE_SYSTEM_DATA_DIR:-/usr/local/share/mise}"
MISE_SYSTEM_CONFIG_DIR="${MISE_SYSTEM_CONFIG_DIR:-/etc/mise}"
SYSTEM_CONFIG="$MISE_SYSTEM_CONFIG_DIR/config.toml"

# shims must be on PATH in every shell, $PATH must stay unexpanded in those files
echo "export PATH=$MISE_SYSTEM_DATA_DIR/shims:\$PATH" >/etc/profile.d/mise-shims.sh
for rc_file in /etc/bash.bashrc /etc/zsh/zshrc /etc/zsh/zshenv; do
  if [ -f "$rc_file" ]; then
    echo "export PATH=$MISE_SYSTEM_DATA_DIR/shims:\$PATH" >>"$rc_file"
  fi
done

FISH_CONF_DIR="/etc/fish/conf.d"
if command -v fish >/dev/null 2>&1; then
  mkdir -p "$FISH_CONF_DIR"
  echo "fish_add_path $MISE_SYSTEM_DATA_DIR/shims/" >"${FISH_CONF_DIR}/mise-data-dir.fish"
fi

mkdir -p "$MISE_SYSTEM_CONFIG_DIR"

for TOOL in ${TOOLS//,/ }; do
  if [ -n "$TOOL" ]; then
    # default to the latest version when no version is given
    case "$TOOL" in
      *@*) ;;
      *) TOOL="${TOOL}@latest" ;;
    esac
    echo "Installing $TOOL"
    mise install --yes --system "$TOOL"
    # pin the resolved version in the system config so every user's shim
    # resolves to the version already installed in $MISE_SYSTEM_DATA_DIR
    mise use --yes --pin --path "$SYSTEM_CONFIG" "$TOOL"
    chmod 644 "$SYSTEM_CONFIG"
  fi
done

echo 'Done!'
