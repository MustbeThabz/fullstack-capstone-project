#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT_DIR}"

MONGO_DIR=".mongodb"
BIN_DIR="${MONGO_DIR}/bin"

mkdir -p "${MONGO_DIR}"

# Versions known to have Ubuntu 24.04 builds in MongoDB download archives.
MONGODB_SERVER_VERSION="${MONGODB_SERVER_VERSION:-8.2.7}"
MONGODB_TOOLS_VERSION="${MONGODB_TOOLS_VERSION:-100.17.0}"

server_tgz="mongodb-linux-x86_64-ubuntu2404-${MONGODB_SERVER_VERSION}.tgz"
tools_tgz="mongodb-database-tools-ubuntu2404-x86_64-${MONGODB_TOOLS_VERSION}.tgz"

server_url="https://fastdl.mongodb.org/linux/${server_tgz}"
tools_url="https://fastdl.mongodb.org/tools/db/${tools_tgz}"

download_and_extract() {
  local url="$1"
  local tgz="$2"
  local dest="$3"

  if [ -d "${dest}" ]; then
    return 0
  fi

  echo "Downloading ${tgz}..."
  curl -fL --retry 3 --retry-delay 2 -o "/tmp/${tgz}" "${url}"

  echo "Extracting ${tgz}..."
  tar -xzf "/tmp/${tgz}" -C "${MONGO_DIR}"
}

download_and_extract "${server_url}" "${server_tgz}" "${MONGO_DIR}/mongodb-linux-x86_64-ubuntu2404-${MONGODB_SERVER_VERSION}"
download_and_extract "${tools_url}" "${tools_tgz}" "${MONGO_DIR}/mongodb-database-tools-ubuntu2404-x86_64-${MONGODB_TOOLS_VERSION}"

rm -rf "${BIN_DIR}"
mkdir -p "${BIN_DIR}"

ln -s "../mongodb-linux-x86_64-ubuntu2404-${MONGODB_SERVER_VERSION}/bin/mongod" "${BIN_DIR}/mongod"
ln -s "../mongodb-linux-x86_64-ubuntu2404-${MONGODB_SERVER_VERSION}/bin/mongosh" "${BIN_DIR}/mongosh" 2>/dev/null || true
ln -s "../mongodb-linux-x86_64-ubuntu2404-${MONGODB_SERVER_VERSION}/bin/mongo" "${BIN_DIR}/mongo" 2>/dev/null || true

for tool in mongoimport mongodump mongorestore mongoexport; do
  if [ -f "${MONGO_DIR}/mongodb-database-tools-ubuntu2404-x86_64-${MONGODB_TOOLS_VERSION}/bin/${tool}" ]; then
    ln -s "../mongodb-database-tools-ubuntu2404-x86_64-${MONGODB_TOOLS_VERSION}/bin/${tool}" "${BIN_DIR}/${tool}"
  fi
done

echo "Installed local MongoDB binaries into ${BIN_DIR}"
echo "Next:"
echo "  ./scripts/start_mongod_local.sh"
echo "  ./scripts/import_gifts_and_capture.sh"

