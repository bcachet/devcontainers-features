#!/usr/bin/env bash

set -e

source dev-container-features-test-lib

check "mise is installed" mise version
check "PATH contains /usr/local/share/mise/shims" grep "/usr/local/share/mise/shims" <<<"$PATH"

reportResults
