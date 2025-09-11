#!/bin/sh
set -eu

BASE_URL="${BASE_URL:-http://app:8080}"

# Endpoints to hit (weights via repetition)
ENDPOINTS="
/hello
/latency?ms=5&jitterMs=2
/latency?ms=10&jitterMs=5
/latency?ms=25&jitterMs=10
/latency?ms=50&jitterMs=25
/latency?ms=200&jitterMs=100
/latency?ms=500&jitterMs=200
/error?rate=0.05
"

# Concurrency workers (lightweight)
WORKERS="${WORKERS:-6}"

pick_endpoint() {
  # shell-safe “random”: shuf may not exist; use awk on /dev/urandom
  echo "$ENDPOINTS" | awk 'NF' | awk -v seed="$(od -An -N2 -tu2 /dev/urandom 2>/dev/null | tr -d ' ')" '
    BEGIN{srand(seed)} {a[NR]=$0} END{print a[int(rand()*NR)+1]}'
}

worker() {
  while :; do
    ep="$(pick_endpoint)"
    # silent body, print status code for sanity
    code="$(curl -s -o /dev/null -w "%{http_code}" "$BASE_URL$ep" || echo 000)"
    echo "$(date +%H:%M:%S) $code $ep"
    # random think time
    sleep 5
  done
}

i=0
while [ "$i" -lt "$WORKERS" ]; do
  worker &
  i=$((i+1))
done

wait
