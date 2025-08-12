#!/usr/bin/env bash

set -e

source dev-container-features-test-lib

check "rbw is installed" rbw --version

reportResults
