#!/usr/bin/env sh

STATUS=$(claude mcp list)

for server in notion linear-server mcp-gateway mcp-gateway-staging; do
  if echo "$STATUS" | grep -q "^${server}: .*Connected"; then
    echo "✔ ${server} already connected, skipping"
  else
    claude mcp login "$server"
  fi
done
