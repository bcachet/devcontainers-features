#!/usr/bin/env bash

set -e

source dev-container-features-test-lib

check "restish version is equal to 0.20.0" sh -c "restish --version | grep '0.20.0'"

reportResults
