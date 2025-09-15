#!/bin/sh
set -eu

KBN_URL="${KBN_URL:-http://kibana:5601}"
DATA_VIEW_TITLE="${DATA_VIEW_TITLE:-docker-logs-*}"
DATA_VIEW_NAME="${DATA_VIEW_NAME:-Docker logs}"
SPACE_ID="${SPACE_ID:-default}"

echo "Waiting for Kibana at $KBN_URL ..."
# Wait until status is greenish
for i in $(seq 1 60); do
  if curl -fsS "$KBN_URL/api/status" -H 'kbn-xsrf: true' >/dev/null; then
    break
  fi
  sleep 2
done

# 1) Ensure a data view exists
# If it already exists, this call will effectively no-op (we’ll try create; ignore 409)
create_payload=$(cat <<JSON
{
  "override": true,
  "data_view": {
    "title": "$DATA_VIEW_TITLE",
    "name": "$DATA_VIEW_NAME",
    "timeFieldName": "@timestamp"
  }
}
JSON
)
curl -fsS -o /dev/null -w "%{http_code}\n" \
  -X POST "$KBN_URL/api/data_views/data_view" \
  -H 'content-type: application/json' -H 'kbn-xsrf: true' \
  --data "$create_payload" || true

# 2) Optionally import saved objects (dashboards, visualizations, etc.)
if [ -f /kibana/export.ndjson ]; then
  echo "Importing saved objects from export.ndjson ..."
  curl -fsS -o /dev/null \
    -X POST "$KBN_URL/s/$SPACE_ID/api/saved_objects/_import?overwrite=true" \
    -H 'kbn-xsrf: true' \
    --form file=@/kibana/export.ndjson
fi

echo "Kibana setup done."
