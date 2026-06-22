#!/bin/bash

# ============================================================
# sendxmppfile.sh — sending a file via XMPP (mod_rest + XEP-0363)
# Usage: ./sendxmppfile.sh <Recipient's JID> <path to file>
# Example: ./sendxmppfile.sh friend@myserver.net /tmp/photo.jpg
# ============================================================

# Default settings
CREDENTIALS="bot:123456"
REST_URL="https://myserver.net:5281/rest"
XMPP_DOMAIN="myserver.net"

TO_JID="$1"
FILE_PATH="$2"

if [ -z "$TO_JID" ] || [ -z "$FILE_PATH" ]; then
    echo "Error: Incorrect number of arguments!"
    echo "Usage: $0 <Recipient's JID> <path to file>"
    echo "Example: $0 friend@myserver.net /tmp/photo.jpg"
    exit 1
fi

if [ ! -f "$FILE_PATH" ]; then
    echo "Error: File '$FILE_PATH' not found!"
    exit 1
fi

FILE_SIZE=$(stat -c%s "$FILE_PATH")
FILE_NAME=$(basename "$FILE_PATH")

CONTENT_TYPE=$(file -b --mime-type "$FILE_PATH")
if [ -z "$CONTENT_TYPE" ]; then
    CONTENT_TYPE="application/octet-stream"
fi

echo "Recipient: $TO_JID"
echo "File: $FILE_NAME"
echo "Size:      $FILE_SIZE byte"
echo "Data type: $CONTENT_TYPE"
echo ""

REQUEST_URL="${REST_URL}/upload_request/${XMPP_DOMAIN}?filename=${FILE_NAME}&size=${FILE_SIZE}&content-type=${CONTENT_TYPE}"

RESPONSE_XML=$(curl -s -u "$CREDENTIALS" "$REQUEST_URL")

PUT_URL=$(echo "$RESPONSE_XML" | sed -n "s/.*<put url=['\"]\([^'\"]*\)['\"].*/\1/p")
GET_URL=$(echo "$RESPONSE_XML" | sed -n "s/.*<get url=['\"]\([^'\"]*\)['\"].*/\1/p")
BEARER_TOKEN=$(echo "$RESPONSE_XML" | sed -n "s/.*<header name=['\"]Authorization['\"]>Bearer \([^<]*\).*/\1/p")

if [ -z "$PUT_URL" ] || [ -z "$GET_URL" ] || [ -z "$BEARER_TOKEN" ]; then
    echo "Error: Couldn't get a slot from the server!"
    echo "Server response:"
    echo "$RESPONSE_XML"
    exit 1
fi

curl -s -o /dev/null -w "HTTP status: %{http_code}\n" -X PUT "$PUT_URL" \
    -H "Authorization: Bearer $BEARER_TOKEN" \
    --data-binary @"$FILE_PATH"
echo ""

curl -s -o /dev/null -w "HTTP status: %{http_code}\n" \
    -u "$CREDENTIALS" \
    -H "Content-Type: application/json" \
    -d "{
        \"kind\": \"message\",
        \"to\": \"$TO_JID\",
        \"oob_url\": \"$GET_URL\"
    }" \
    "$REST_URL"
echo "Done!"
echo ""
