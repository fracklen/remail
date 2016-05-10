#!/usr/bin/env bash

URL="http://127.0.0.1:8025"

TOTAL="$(curl $URL/api/v2/messages\?limit\=1 | jq -r '.total')"
BULK=5000

for offset in $(seq 0 $BULK $TOTAL); do
    echo "$offset / $TOTAL"
    curl -v "$URL/api/v2/messages?start=${offset}&limit=$BULK" | \
        jq -r '.items[].Content.Body' | \
        sed -n -e '/<img src/p' | \
        sed -e 's,.*="\(.*\)">,\1,' | \
        tr -d '\r' | \
        xargs -n 1 curl
done
