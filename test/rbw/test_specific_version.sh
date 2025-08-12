#!/usr/bin/env bash

set -e

source dev-container-features-test-lib

check "rbw version is equal to 1.13.2" sh -c "rbw --version | grep '1.13.2'"

reportResults
