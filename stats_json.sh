#!/bin/bash

DEST_DIR="/var/www/json"
OUTPUT_FILE="${DEST_DIR}/bunkerweb_stats.json"

TOTAL=$(curl -H "Host: bwapi" 127.0.0.1:5000/metrics/errors | jq '.msg | [.[]] | add')
BLOCKED=$(curl -H "Host: bwapi" 127.0.0.1:5000/metrics/requests | jq '.msg | .requests | length')
BANS=$(curl -H "Host: bwapi" 127.0.0.1:5000/bans | jq '.data | length')
COUNTRY=$(curl -H "Host: bwapi" 127.0.0.1:5000/metrics/requests | jq -r '.msg.requests? // [] | map(.country) | group_by(.) | map({country: .[0], count: length}) | max_by(.count) | "\(.country) (\(.count? // 0))"')
FLAG=$(echo -e $(printf '\\U%X\\U%X' $(($(printf '%d' "'${COUNTRY:0:1}") + 127397)) $(($(printf '%d' "'${COUNTRY:1}") + 127397))))

echo "{\"total\":${TOTAL},\"blocked\":${BLOCKED},\"bans\":${BANS},\"dom_origin\":\"${FLAG} ${COUNTRY}\"}" > "${OUTPUT_FILE_BWS}"
chown nginx:nginx "${OUTPUT_FILE_BWS}"
