#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT_DIR}"

BIN_DIR=".mongodb/bin"
MONGOD="${BIN_DIR}/mongod"

if [ ! -x "${MONGOD}" ]; then
  echo "mongod not found. Run: ./scripts/install_mongo_local.sh" >&2
  exit 1
fi

DATA_DIR="${ROOT_DIR}/.mongodb/data"
LOG_DIR="${ROOT_DIR}/.mongodb/log"
PID_FILE="${ROOT_DIR}/.mongodb/mongod.pid"
LOG_FILE="${LOG_DIR}/mongod.log"

mkdir -p "${DATA_DIR}" "${LOG_DIR}"

if [ -f "${PID_FILE}" ] && kill -0 "$(cat "${PID_FILE}")" 2>/dev/null; then
  echo "mongod already running (pid $(cat "${PID_FILE}"))"
  exit 0
fi

"${MONGOD}" \
  --dbpath "${DATA_DIR}" \
  --bind_ip 127.0.0.1 \
  --port 27017 \
  --logpath "${LOG_FILE}" \
  --pidfilepath "${PID_FILE}" \
  --fork

echo "mongod started (pid $(cat "${PID_FILE}"))"
