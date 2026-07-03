#!/bin/bash

# Settings
DOMAIN="your_server.ru"
CONTAINER="prosody"
# Path to accounts on host (with dot encoding %2e)
ACCOUNTS_PATH="./data/prosody/your_server%2ru/accounts/"

case "$1" in
    -a)
        read -p "Enter new username: " UNAME
        sudo docker compose exec $CONTAINER prosodyctl adduser $UNAME@$DOMAIN
        ;;
    -p)
        if [ -z "$2" ]; then echo "Usage: $0 -p <username>"; exit 1; fi
        sudo docker compose exec $CONTAINER prosodyctl passwd $2@$DOMAIN
        ;;
    -d)
        if [ -z "$2" ]; then echo "Usage: $0 -d <username>"; exit 1; fi
        sudo docker compose exec $CONTAINER prosodyctl deluser $2@$DOMAIN
        ;;
    -l)
        if [ -d "$ACCOUNTS_PATH" ]; then
            echo "User list for domain $DOMAIN:"
            echo "-----------------------------------"
            sudo ls -1 "$ACCOUNTS_PATH" | sed 's/\.dat$//'
            echo "-----------------------------------"
        else
            echo "Error: accounts folder not found. Check path or create your first user."
        fi
        ;;
    *)
        echo "Usage:"
        echo "  $0 -a           - Create a new user"
        echo "  $0 -p <user>    - Change user password"
        echo "  $0 -d <user>    - Delete a user"
        echo "  $0 -l           - List all users"
        exit 1
        ;;
esac

