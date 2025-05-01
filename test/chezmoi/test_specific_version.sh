#!/usr/bin/env bash

set -e

source dev-container-features-test-lib

check "chezmoi version is equal to 2.62.2" sh -c "chezmoi --version | grep '2.62.2'"

reportResults
