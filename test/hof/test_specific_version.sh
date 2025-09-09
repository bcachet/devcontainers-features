#!/usr/bin/env bash

set -e

source dev-container-features-test-lib

check "hof version is equal to 0.6.10" sh -c "hof version | grep '0.6.10'"

reportResults
