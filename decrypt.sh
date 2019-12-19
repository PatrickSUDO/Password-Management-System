#!/bin/bash

# Decrypt a data stream
# $1 The master password
# $2 Encrypted data to decrypt
password="$1" ciphertext="$2"
echo "$ciphertext" | \
    openssl aes-256-ctr -d -base64 -pass "pass:$password"
