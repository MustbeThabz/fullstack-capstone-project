# GiftLink (Full-Stack Capstone)

GiftLink is a simple gift browser + search API with authentication endpoints, plus a static landing page in `public/index.html`.

## Quick start (local)
1. Install deps: `npm install`
2. Run API: `npm run dev`
3. Visit landing page: `http://localhost:5000/`

## Seed MongoDB (Task 3)
Seed file: `gifts.json` (16 documents).

Example:
`mongoimport --db giftlink --collection gifts --file gifts.json --jsonArray`

## API routes
- `GET /api/gifts` (list items)
- `GET /api/gifts/:id` (item details)
- `GET /api/search?category=tech` (filter by category)
- `POST /api/auth/register`
- `POST /api/auth/login`
- `PUT /api/auth/user` (Bearer token required)

## Submission checklist
See `FINAL_SUBMISSION_GUIDE.md`.

