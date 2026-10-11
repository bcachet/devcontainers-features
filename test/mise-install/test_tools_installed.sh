#!/usr/bin/env bash

set -e

source dev-container-features-test-lib

check "go is installed" go version

reportResults
