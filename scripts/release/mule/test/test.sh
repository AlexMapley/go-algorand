#!/usr/bin/env bash

set -ex

export WORKDIR="$6"

if [ -z "$WORKDIR" ]
then
    echo "WORKDIR must be defined."
    exit 1
fi

export OS_TYPE="$1"
export ARCH_TYPE="$2"
export ARCH_BIT="$3"
export VERSION=${VERSION:-$4}
export PKG_TYPE="$5"
BRANCH=${BRANCH:-$(git rev-parse --abbrev-ref HEAD)}
export BRANCH
CHANNEL=${CHANNEL:-$("$WORKDIR/scripts/compute_branch_channel.sh" "$BRANCH")}
export CHANNEL
SHA=${SHA:-$(git rev-parse HEAD)}
export SHA

if ! $USE_CACHE
then
    mule -f package-test.yaml "package-test-setup-$PKG_TYPE"
fi

"$WORKDIR/scripts/release/mule/test/util/test_package.sh"

