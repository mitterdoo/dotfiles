#!/bin/bash

updates=$(checkupdates; paru -Qum)
line_count=$(printf '%s' "$updates" | grep -c '^')

plural=""
if ((line_count > 1)); then
	plural="S"
fi


if ((line_count > 0)); then
	updates_json=$(printf '%s' "$updates" | jq -Rsa .)
	echo "{\"text\": \"<span color='#00FF00'>$line_count</span> UPDATE$plural\", \"tooltip\": $updates_json}"
else
	echo '{}'
fi

