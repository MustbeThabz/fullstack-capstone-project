require("dotenv").config();

const natural = require("natural");
const app = require("./app");

const PORT = process.env.PORT || 5000;

app.use("/", require("express").static("public"));

app.get("/api/health", (req, res) => {
  const tokenizer = new natural.WordTokenizer();
  res.json({ ok: true, tokens: tokenizer.tokenize("GiftLink API up") });
});

app.listen(PORT, () => {
  // eslint-disable-next-line no-console
  console.log(`Server running on http://localhost:${PORT}`);
});

