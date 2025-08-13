#!/usr/bin/env bash

set -e

source dev-container-features-test-lib

check "pdk is installed" pdk --version
check "ruby is installed" ruby --version
check "puppet-languageserver is installed" puppet-languageserver --version

reportResults
