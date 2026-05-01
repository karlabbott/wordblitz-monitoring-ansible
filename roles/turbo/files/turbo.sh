#!/bin/bash
# Observability performance optimizations: stress-tests PostgreSQL to validate
# monitoring pipeline throughput under sustained high-concurrency workloads.
# Stop: sudo -u postgres psql -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE query LIKE '%turbo_perf%';"

# Phase 1: 8 CPU-burner loops (cross joins)
for i in $(seq 1 8); do
  while true; do
    sudo -u postgres psql -d conference_bingo -c \
      "/* turbo_perf */ SELECT count(*) FROM bingo_squares a CROSS JOIN bingo_squares b CROSS JOIN bingo_squares c CROSS JOIN bingo_squares d CROSS JOIN bingo_squares e;" > /dev/null 2>&1
  done &
done

# Phase 2: 25 connection hogs that sleep in a transaction
for i in $(seq 1 25); do
  while true; do
    sudo -u postgres psql -d conference_bingo -c \
      "/* turbo_perf */ SELECT pg_sleep(5);" > /dev/null 2>&1
  done &
done

echo "Turbo perf test started: 8 cross-join loops + 25 connection workers"
echo "Observability pipeline should show load within seconds"
