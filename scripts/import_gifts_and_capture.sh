#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT_DIR}"

BIN_DIR=".mongodb/bin"
MONGOIMPORT="${BIN_DIR}/mongoimport"

if [ ! -x "${MONGOIMPORT}" ]; then
  echo "mongoimport not found. Run: ./scripts/install_mongo_local.sh" >&2
  exit 1
fi

URI="${MONGODB_URI:-mongodb://127.0.0.1:27017}"
DB="${MONGODB_DB:-giftlink}"
COLLECTION="${MONGODB_COLLECTION:-gifts}"

cmd="mongoimport --uri \"${URI}\" --db ${DB} --collection ${COLLECTION} --file gifts.json --jsonArray"

set +e
output="$(${MONGOIMPORT} --uri "${URI}" --db "${DB}" --collection "${COLLECTION}" --file gifts.json --jsonArray 2>&1)"
code="$?"
set -e

{
  echo "Task 3: MongoDB Import Output"
  echo
  echo "COMMAND:"
  echo "${cmd}"
  echo
  echo "OUTPUT:"
  echo "${output}"
  echo
  echo "EXIT_CODE:"
  echo "${code}"
} > inserted_items

if [ "${code}" -ne 0 ]; then
  echo "mongoimport failed (exit ${code}). See inserted_items for details." >&2
  exit "${code}"
fi

echo "Wrote inserted_items"

