#!/usr/bin/env bash

set -e

if [[ $# -lt 2 ]]; then
	echo "usage: $0 <key> <iv>"
	exit 1
fi

ENCRYPTED_KEY=${1}
ENCRYPTED_IV=${2}

openssl aes-256-cbc -K ${ENCRYPTED_KEY} -iv ${ENCRYPTED_IV} -in ./id_rsa.enc -out ~/.ssh/id_rsa -d 2>/dev/null
chmod 600 ~/.ssh/id_rsa
echo -e "Host github.com\n\tStrictHostKeyChecking no\n" >> ~/.ssh/config
git config --global user.email "technote.space@gmail.com"
git config --global user.name "Technote"
git config --global url."git@github.com:".insteadOf "https://github.com/"
