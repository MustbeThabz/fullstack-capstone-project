const fs = require("node:fs");
const path = require("node:path");
const { ObjectId } = require("mongodb");

let cached = null;

function loadSampleGifts() {
  if (cached) return cached;
  const filePath = path.join(__dirname, "gifts.json");
  const raw = fs.readFileSync(filePath, "utf8");
  const parsed = JSON.parse(raw);
  cached = parsed.map((doc) => {
    const oid = doc?._id?.$oid;
    if (oid && ObjectId.isValid(oid)) return { ...doc, _id: new ObjectId(oid) };
    return doc;
  });
  return cached;
}

module.exports = { loadSampleGifts };

