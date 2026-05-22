const express = require("express");
const { ObjectId } = require("mongodb");
const { connectToDatabase } = require("./db");
const { loadSampleGifts } = require("./sampleData");

const router = express.Router();

router.get("/api/gifts", async (req, res) => {
  try {
    const { db } = await connectToDatabase();
    const gifts = await db.collection("gifts").find({}).toArray();
    res.json(gifts);
  } catch (err) {
    const gifts = loadSampleGifts();
    res.json(gifts);
  }
});

router.get("/api/gifts/:id", async (req, res) => {
  try {
    const { db } = await connectToDatabase();
    const { id } = req.params;

    if (!ObjectId.isValid(id)) {
      return res.status(400).json({ error: "Invalid id" });
    }

    const gift = await db.collection("gifts").findOne({ _id: new ObjectId(id) });
    if (!gift) return res.status(404).json({ error: "Gift not found" });

    res.json(gift);
  } catch (err) {
    const gifts = loadSampleGifts();
    const { id } = req.params;
    const gift = gifts.find((g) => String(g?._id) === String(id));
    if (!gift) return res.status(404).json({ error: "Gift not found" });
    res.json(gift);
  }
});

module.exports = router;
