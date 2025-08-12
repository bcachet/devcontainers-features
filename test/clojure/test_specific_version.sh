#!/usr/bin/env bash

set -e

source dev-container-features-test-lib

check "clojure version is equal to 1.12.1.1550" sh -c "clojure --version | grep '1.12.1.1550'"

reportResults
