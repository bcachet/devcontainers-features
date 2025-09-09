#!/usr/bin/env bash

set -e

source dev-container-features-test-lib

check "cue version is equal to 0.14.1" sh -c "cue version | grep '0.14.1'"

reportResults
