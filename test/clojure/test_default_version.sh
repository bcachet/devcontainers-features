#!/usr/bin/env bash

set -e

source dev-container-features-test-lib

check "clojure is installed" clojure --version

reportResults
