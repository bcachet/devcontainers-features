#!/usr/bin/env bash

set -e

source dev-container-features-test-lib

check "chezmoi is installed" chezmoi --version

reportResults
