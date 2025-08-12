#!/usr/bin/env bash

set -e

source dev-container-features-test-lib

check "restish is installed" restish --version

reportResults
