const express = require("express");
const { connectToDatabase } = require("./db");
const { loadSampleGifts } = require("./sampleData");

const router = express.Router();

router.get("/api/search", async (req, res) => {
  try {
    const { db } = await connectToDatabase();
    const { category } = req.query;

    const filter = {};
    if (category && String(category).trim().length > 0) {
      filter.category = String(category).trim().toLowerCase();
    }

    const results = await db.collection("gifts").find(filter).toArray();
    res.json(results);
  } catch (err) {
    const { category } = req.query;
    const filterCategory = category && String(category).trim().length > 0 ? String(category).trim().toLowerCase() : null;
    const results = loadSampleGifts().filter((g) => (filterCategory ? g.category === filterCategory : true));
    res.json(results);
  }
});

module.exports = router;
