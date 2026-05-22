#!/usr/bin/env bash
set -euo pipefail

OWNER="MustbeThabz"
REPO="fullstack-capstone-project"

token="${GITHUB_TOKEN:-}"
if [ -z "${token}" ]; then
  token="$(git remote get-url origin 2>/dev/null | sed -nE 's#https://([^@]+)@github.com/.*#\\1#p')"
fi

if [ -z "${token}" ]; then
  echo "Missing auth. Set GITHUB_TOKEN or add an authenticated origin URL." >&2
  exit 1
fi

api="https://api.github.com"
authHeader="Authorization: token ${token}"

create_label() {
  local name="$1"
  local color="$2"
  curl -sS -X POST "${api}/repos/${OWNER}/${REPO}/labels" \
    -H "${authHeader}" \
    -H "Accept: application/vnd.github+json" \
    -d "{\"name\":\"${name}\",\"color\":\"${color}\"}" >/dev/null || true
}

create_issue() {
  local title="$1"
  local body="$2"
  local labels_json="$3"
  curl -sS -X POST "${api}/repos/${OWNER}/${REPO}/issues" \
    -H "${authHeader}" \
    -H "Accept: application/vnd.github+json" \
    -d "{\"title\":\"${title}\",\"body\":\"${body}\",\"labels\":${labels_json}}" >/dev/null
}

create_label "new" "0e8a16"
create_label "icebox" "5319e7"
create_label "technical debt" "d93f0b"
create_label "backlog" "1d76db"

create_issue "User story: browse gifts list" "As a user, I want to browse a list of gifts so I can discover ideas." "[\"new\",\"backlog\"]"
create_issue "User story: view item detail" "As a user, I want to view gift details so I can decide if it fits." "[\"new\",\"backlog\"]"
create_issue "User story: search by category" "As a user, I want to filter gifts by category so I can narrow results." "[\"new\",\"backlog\"]"
create_issue "Auth: register endpoint" "Add/verify registration API and validation." "[\"new\",\"backlog\"]"
create_issue "Auth: login endpoint" "Add/verify login API and JWT issuance." "[\"new\",\"backlog\"]"
create_issue "Auth: update user endpoint" "Allow updating user information with auth." "[\"new\",\"backlog\"]"
create_issue "Tech debt: add request logging" "Add lightweight request logging (optional)." "[\"technical debt\",\"icebox\"]"
create_issue "Icebox: favorites feature" "Allow users to save favorite gifts for later." "[\"icebox\"]"

echo "Created labels + 8 issues in ${OWNER}/${REPO}"

