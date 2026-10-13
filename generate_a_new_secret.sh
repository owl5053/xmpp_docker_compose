#!/bin/bash

# 1. Generate a new secret (e.g.)
NEW_SECRET=$(openssl rand -base64 32 | tr -d /=+ | cut -c -32)
echo "New secret: $NEW_SECRET"
echo "=================================="
echo "Replace the secret in the following files:"
echo "turnserver.conf"
echo "prosody.cfg.lua"
