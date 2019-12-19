#!/bin/bash
echo `openssl rand -base64 32 | cut -c4-18 | tr -dc a-zA-Z0-9`
