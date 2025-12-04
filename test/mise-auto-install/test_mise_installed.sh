#!/usr/bin/env bash

set -e

source dev-container-features-test-lib

check "mise is installed" mise version

reportResults
