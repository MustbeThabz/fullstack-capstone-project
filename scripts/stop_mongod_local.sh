#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT_DIR}"

PID_FILE=".mongodb/mongod.pid"

if [ ! -f "${PID_FILE}" ]; then
  echo "mongod not running (no pid file)"
  exit 0
fi

pid="$(cat "${PID_FILE}")"
if kill -0 "${pid}" 2>/dev/null; then
  kill "${pid}"
  for _ in $(seq 1 40); do
    if kill -0 "${pid}" 2>/dev/null; then
      sleep 0.25
    else
      break
    fi
  done
fi

rm -f "${PID_FILE}"
echo "mongod stopped"

