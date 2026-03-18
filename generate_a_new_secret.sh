#!/bin/bash

# 1. Сгенерируй новый пароль (например)
NEW_SECRET=$(openssl rand -base64 32 | tr -d /=+ | cut -c -32)
echo "Новый секрет: $NEW_SECRET"
echo "=================================="
echo "Замени пароль в файлах:"
echo "turnserver.conf"
echo "prosody.cfg.lua"

