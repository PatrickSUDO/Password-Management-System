#!/bin/bash

# Encrypt a data stream.
# $1 The master password
# $2 Plain data to encrypt
password="$1" plaintext="$2"
echo "$plaintext" | \
        openssl aes-256-ctr -e -base64 -pass "pass:$password" 


