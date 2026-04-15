#!/bin/bash
# Chaos script: Spawns endless expensive cross-join queries against the conference_bingo DB
# Stop: sudo -u postgres psql -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE query LIKE '%cross_chaos%';"

for i in $(seq 1 8); do
  while true; do
    sudo -u postgres psql -d conference_bingo -c \
      "/* cross_chaos */ SELECT count(*) FROM bingo_squares a CROSS JOIN bingo_squares b CROSS JOIN bingo_squares c CROSS JOIN bingo_squares d CROSS JOIN bingo_squares e;" > /dev/null 2>&1
  done &
done

echo "Chaos started: 8 endless cross-join loops running"
echo "Load average should spike to 8-10 within seconds"
