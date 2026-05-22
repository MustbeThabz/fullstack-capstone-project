#!/usr/bin/env bash
set -euo pipefail

PORT="${PORT:-5000}"
API_BASE_URL="${API_BASE_URL:-http://localhost:${PORT}}"

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT_DIR}"

node index.js > /tmp/giftlink_server.log 2>&1 &
SERVER_PID="$!"

cleanup() {
  kill "${SERVER_PID}" >/dev/null 2>&1 || true
}
trap cleanup EXIT

for _ in $(seq 1 40); do
  if curl -fsS "${API_BASE_URL}/api/health" >/dev/null 2>&1; then
    break
  fi
  sleep 0.25
done

email="test+$(date +%s)@example.com"
password="Password123!"

write_file() {
  local file="$1"
  local cmd="$2"
  local output="$3"
  printf "%s\n\nCOMMAND:\n%s\n\nOUTPUT:\n%s\n" "${file}" "${cmd}" "${output}" > "${file}"
}

cmd_mainpage="curl ${API_BASE_URL}/api/gifts"
out_mainpage="$(curl -s "${API_BASE_URL}/api/gifts")"
write_file "mainpage" "curl ${API_BASE_URL}/api/gifts" "${out_mainpage}"

cmd_register="curl -X POST ${API_BASE_URL}/api/auth/register -H \"Content-Type: application/json\" -d '{\"name\":\"Test User\",\"email\":\"${email}\",\"password\":\"${password}\"}'"
out_register="$(curl -s -X POST "${API_BASE_URL}/api/auth/register" -H "Content-Type: application/json" -d "{\"name\":\"Test User\",\"email\":\"${email}\",\"password\":\"${password}\"}")"
write_file "register" "${cmd_register}" "${out_register}"

cmd_login="curl -X POST ${API_BASE_URL}/api/auth/login -H \"Content-Type: application/json\" -d '{\"email\":\"${email}\",\"password\":\"${password}\"}'"
out_login="$(curl -s -X POST "${API_BASE_URL}/api/auth/login" -H "Content-Type: application/json" -d "{\"email\":\"${email}\",\"password\":\"${password}\"}")"
write_file "login" "${cmd_login}" "${out_login}"

sample_id="000000000000000000000003"
cmd_item="curl ${API_BASE_URL}/api/gifts/${sample_id}"
out_item="$(curl -s "${API_BASE_URL}/api/gifts/${sample_id}")"
write_file "item_detail" "${cmd_item}" "${out_item}"

cmd_search="curl \"${API_BASE_URL}/api/search?category=tech\""
out_search="$(curl -s "${API_BASE_URL}/api/search?category=tech")"
write_file "search_item" "${cmd_search}" "${out_search}"

echo "Wrote: mainpage, register, login, item_detail, search_item"

