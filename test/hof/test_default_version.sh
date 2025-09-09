#!/usr/bin/env bash

set -e

source dev-container-features-test-lib

check "hof is installed" hof version

reportResults
