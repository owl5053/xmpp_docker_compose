#!/bin/bash

# default configuration
DEFAULT_TOUSER="admin@myserver.net"
BOT_NAME="bot:123456"
API_URL="https://myserver.net:5281/rest"

show_help() {
    cat << EOF
Using: sendxmpp [--to USER] [--help]
              echo "message" | sendxmpp [--to USER]

Sends the message via the XMPP REST API.

Options:
--to USER Send a message to the specified user
--help Show this help

If --to is not specified, the default user is used: $DEFAULT_TOUSER

EOF
}

TOUSER="$DEFAULT_TOUSER"
MESSAGE_ARG=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --to)
            TOUSER="$2"
            shift 2
            ;;
        --help)
            show_help
            exit 0
            ;;
        *)
            if [ -z "$MESSAGE_ARG" ]; then
                MESSAGE_ARG="$1"
            else
                MESSAGE_ARG="$MESSAGE_ARG $1"
            fi
            shift
            ;;
    esac
done

if [ -n "$MESSAGE_ARG" ]; then
    MESSAGE="$MESSAGE_ARG"
elif [ ! -t 0 ]; then
    MESSAGE=$(cat)
else
    echo "Error: There is no message to send" >&2
    echo "Please use: echo \"text\" | $0  or  $0 \"text\"" >&2
    exit 1
fi

MESSAGE_ESCAPED=$(echo "$MESSAGE" | sed 's/\\/\\\\/g' | sed 's/"/\\"/g' | awk '{printf "%s\\n", $0}' | sed 's/\\n$//')

if [[ "$TOUSER" == *"@conference."* ]]; then
    MSG_TYPE="groupchat"
else
    MSG_TYPE="chat"
fi

curl -s -X POST "$API_URL" \
    -u "$BOT_NAME" \
    -H "Content-Type: application/json" \
    -d "{\"to\": \"$TOUSER\", \"body\": \"$MESSAGE_ESCAPED\", \"type\": \"$MSG_TYPE\"}" \
    > /dev/null

if [ $? -eq 0 ]; then
    echo "The message was sent to the user $TOUSER"
else
    echo "Sending error" >&2
    exit 1
fi
