#!/usr/bin/env bash

set -e

source dev-container-features-test-lib

check "SSH_AUTH_SOCK is installed" env | grep SSH_AUTH_SOCK | grep bitwarden

reportResults
