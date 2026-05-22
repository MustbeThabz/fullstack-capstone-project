# Final Project Submission Guide (Repo Checklist)

This repo is structured to match the 18 tasks in your submission rubric.

## Tasks 1–11 (code + template files)
- Task 1: `user-story.md`
- Task 4: `db.js` (includes `await client.connect()`)
- Task 5: `giftRoutes.js` (includes `connectToDatabase()`, `/api/gifts`, `/api/gifts/:id`)
- Task 6: `searchRoutes.js` (filters by `category`)
- Task 7: `app.js` (mounts `/api/search` via routes)
- Task 8: `index.js` (imports `natural`)
- Task 9: `RegisterPage.js` (includes `fetch()` + headers)
- Task 10: `LoginPage.js` (headers include `Content-Type` + `Authorization`)
- Task 11: `authRoutes.js` (register/login/update APIs)

## Task 2 (GitHub issues screenshot)
Create at least 8 issues and add labels (e.g., `new`, `icebox`, `technical debt`, `backlog`), then take a screenshot and save it as `userstories.png` in the repo root.

## Task 3 (MongoDB import)
Seed file: `gifts.json` (contains 16 documents).

Run:
`mongoimport --db giftlink --collection gifts --file gifts.json --jsonArray`

Copy/paste your terminal output into: `inserted_items`

## Task 12 (Deployment screenshot)
Deploy the app and take a screenshot of the landing page (must show URL, title, description/tagline, and a Get Started button) as `deployed_landingpage.png` in the repo root.

Landing page file served by the API:
`public/index.html`

## Tasks 13–17 (cURL output files)
Fill in these files by running the commands and pasting the JSON output:
- `mainpage`
- `register`
- `login`
- `item_detail`
- `search_item`

Optional helper (auto-generates Tasks 13–17 files):
`./scripts/generate_curl_outputs.sh`

## Task 18 (CI/CD proof)
This repo includes a GitHub Actions workflow:
`.github/workflows/ci.yml`

After it runs successfully, paste the successful output into: `CI/CD` (path: `CI/CD`)
