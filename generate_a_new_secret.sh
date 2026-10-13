#!/bin/bash

# 1. Generate a new secret (e.g.)
NEW_SECRET=$(openssl rand -base64 32 | tr -d /=+ | cut -c -32)
echo "New secret: $NEW_SECRET"
echo "=================================="
echo "Paste this into turnserver.conf:"
echo "static-auth-secret=$NEW_SECRET"
echo ""
echo "Paste this into prosody.cfg.lua (external_services):"
echo "secret = \"$NEW_SECRET\","
