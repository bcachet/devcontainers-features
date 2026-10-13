#!/usr/bin/env bash

set -e

source dev-container-features-test-lib

check "mise is installed" mise version
check "can access /tmp" mkdir -p /tmp/X11

reportResults
