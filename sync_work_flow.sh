#!/bin/bash

USER="tigore21htl@gmail.com"
PASSWORD="LjFG@bgZ4HH3w6J"
B64_AUTH=$(echo -n "$USER:$PASSWORD" | base64)
N8N_URL="http://localhost:5678"

for file in ./templates/workflows/*.json; do
  echo "Importando $file..."
  curl -s -X POST "$N8N_URL/rest/workflows" \
    -H "Content-Type: application/json" \
    -H "Authorization: Basic $B64_AUTH" \
    -d @"$file"
done

echo "✅ Todos os templates foram importados via HTTP!"
