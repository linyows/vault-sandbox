#!/bin/bash

: ${COMMON_NAME:='proxy.node.consul'}

ROOTDIR=$(git rev-parse --show-toplevel)
pushd $ROOTDIR/proxy/ssl

openssl req -sha256 -x509 -days 36500 -newkey rsa:4096 -nodes \
    -out $COMMON_NAME.crt \
    -keyout $COMMON_NAME.key \
    -subj "/C=/ST=/L=/O=/OU=/CN=$COMMON_NAME"

popd
