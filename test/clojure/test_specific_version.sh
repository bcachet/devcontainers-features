#!/usr/bin/env bash

set -e

source dev-container-features-test-lib

check "chezmoi version is equal to 1.12.0" sh -c "clojure --version | grep '1.12.0'"

reportResults
