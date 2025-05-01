#!/usr/bin/env bash

set -e

source ./library_scripts.sh

# nanolayer is a cli utility which keeps container layers as small as possible
# source code: https://github.com/devcontainers-extra/nanolayer
# `ensure_nanolayer` is a bash function that will find any existing nanolayer installations,
# and if missing - will download a temporary copy that automatically get deleted at the end
# of the script
ensure_nanolayer nanolayer_location "v0.5.6"

ARCH=$(lsb_release -cs)
curl -o puppet-tools.deb https://apt.puppet.com/puppet-tools-release-${ARCH}.deb
sudo dpkg -i puppet-tools.deb
sudo apt-get update
sudo apt-get install pdk

$nanolayer_location \
    install \
    devcontainer-feature \
    "ghcr.io/devcontainers-extra/features/apt-get-packages:1.0.7" \
    --option packages='rlwrap'

$nanolayer_location \
    install \
    devcontainer-feature \
    "ghcr.io/devcontainers-extra/features/gh-release:1.0.25" \
    --option repo='doy/rbw' \
    --option binaryNames='rbw,rbw-agent' \
    --option libName='etcd' \
    --option version="$VERSION"

echo 'Done!'
