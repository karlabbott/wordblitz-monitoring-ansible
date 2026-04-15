#!/bin/bash
# Chaos script: Saturates PostgreSQL with CPU-heavy queries and connection-hogging transactions
# Stop: sudo -u postgres psql -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE query LIKE '%cross_chaos%';"

# Phase 1: 8 CPU-burner loops (cross joins)
for i in $(seq 1 8); do
  while true; do
    sudo -u postgres psql -d conference_bingo -c \
      "/* cross_chaos */ SELECT count(*) FROM bingo_squares a CROSS JOIN bingo_squares b CROSS JOIN bingo_squares c CROSS JOIN bingo_squares d CROSS JOIN bingo_squares e;" > /dev/null 2>&1
  done &
done

# Phase 2: 25 connection hogs that sleep in a transaction, starving the app's connection pool
# With max_connections=30, this leaves almost no room for the app
for i in $(seq 1 25); do
  while true; do
    sudo -u postgres psql -d conference_bingo -c \
      "/* cross_chaos */ SELECT pg_sleep(5);" > /dev/null 2>&1
  done &
done

echo "Chaos started: 8 cross-join loops + 25 connection hogs (max_connections=30)"
echo "App should become sluggish within seconds"
