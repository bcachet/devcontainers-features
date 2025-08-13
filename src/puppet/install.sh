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
dpkg -i puppet-tools.deb

$nanolayer_location \
    install \
    devcontainer-feature \
    "ghcr.io/devcontainers-extra/features/apt-get-packages:1" \
    --option packages='pdk,ruby,ruby-dev'

gem install specific_install
gem specific_install https://github.com/puppetlabs/puppet-editor-services.git

echo 'Done!'
