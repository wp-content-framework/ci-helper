#!/usr/bin/env bash

set -e

if [[ $# -lt 1 ]]; then
	echo "usage: $0 <TAG>"
	exit 1
fi

LAST_TAG=${1}
LAST_TAG=${LAST_TAG#v}

MAJOR=${LAST_TAG%%.*}
PATCH=${LAST_TAG##*.}
MINOR=${LAST_TAG%.*}
MINOR=${MINOR##*.}

PATCH=$((PATCH+1))

echo v${MAJOR}.${MINOR}.${PATCH}
