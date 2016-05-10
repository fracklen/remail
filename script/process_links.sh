#!/usr/bin/env bash

URL="http://127.0.0.1:8025"

TOTAL="$(curl $URL/api/v2/messages\?limit\=1 | jq -r '.total')"
BULK=1000

for offset in $(seq 0 $BULK $TOTAL); do
    echo "$offset / $TOTAL"
    sleep 1
    curl -v "$URL/api/v2/messages?start=${offset}&limit=$BULK" | \
        jq -r '.items[].Content.Body' | \
        sed -n -e '/<a href=/p' | \
        sed -e 's,.*="\(.*\)">.*,\1,' | \
        grep links | \
        tr -d '\r' | \
        xargs -n 1 -P 10 curl
done
