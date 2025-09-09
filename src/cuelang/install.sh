#!/usr/bin/env bash

set -e

go install cuelang.org/go/cmd/cue@$VERSION

echo 'Done!'
