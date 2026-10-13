#!/usr/bin/env bash

set -e

echo '---------------------------------------------------------------'
echo " Mise: Installing $TOOLS"
echo '---------------------------------------------------------------'

REQUIRED_PACKAGES="curl sudo ca-certificates"

apt_get_update()
{
    if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
        echo "Running apt-get update..."
        apt-get update -y
    fi
}

check_packages() {
    if ! dpkg -s "$@" > /dev/null 2>&1; then
        apt_get_update
        apt-get -y install --no-install-recommends "$@"
    fi
}

export DEBIAN_FRONTEND=noninteractive

check_packages $REQUIRED_PACKAGES

install() {
    curl https://mise.run | MISE_INSTALL_PATH=/usr/local/bin/mise sh
    eval "$(mise activate bash)"
    mise doctor
}

echo "(*) Installing mise-en-place..."

install

# Clean up
rm -rf /var/lib/apt/lists/*

# tools installed here are shared by every user of the image
MISE_SYSTEM_DATA_DIR="${MISE_SYSTEM_DATA_DIR:-/usr/local/share/mise}"
MISE_SYSTEM_CONFIG_DIR="${MISE_SYSTEM_CONFIG_DIR:-/etc/mise}"
SYSTEM_CONFIG="$MISE_SYSTEM_CONFIG_DIR/config.toml"

# shims must be on PATH in every shell, $PATH must stay unexpanded in those files
echo "export PATH=$MISE_SYSTEM_DATA_DIR/shims:\$PATH" >/etc/profile.d/mise-shims.sh
if [ -f /etc/bash.bashrc ]; then
  echo 'eval "$(mise activate bash)"' >> /etc/bash.bashrc
fi
if [ -f /etc/zsh/zshrc ]; then
  echo 'eval "$(mise activate bash)"' >> /etc/zsh/zshrc
fi
if [ -f /etc/fish/config.fish ]; then
  echo 'mise activate fish | source' >> /etc/fish/config.fish
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

# Workaround for a BuildKit/podman issue: the devcontainer CLI removes
# /tmp/dev-container-features/<id> after this script runs. When that nested
# removal is the last change under /tmp, BuildKit omits the /tmp entry from
# the feature layer and podman recreates /tmp as 0755 on layer extraction,
# locking non-root users out of /tmp (e.g. VS Code cannot create
# /tmp/.X11-unix). Touching a file directly under /tmp forces BuildKit to
# emit the /tmp entry, preserving its 01777 mode.
tmp_marker="$(mktemp /tmp/.mise-install-tmp.XXXXXX)"
rm -f "$tmp_marker"

echo 'Done!'
