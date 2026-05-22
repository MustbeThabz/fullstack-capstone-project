const express = require("express");
const cors = require("cors");
const path = require("node:path");

const giftRoutes = require("./giftRoutes");
const searchRoutes = require("./searchRoutes");
const authRoutes = require("./authRoutes");

const app = express();

app.use(cors());
app.use(express.json());

// Landing page (Task 12 screenshot)
const publicDir = path.join(__dirname, "public");
app.use(express.static(publicDir));
app.get("/", (req, res) => {
  res.sendFile(path.join(publicDir, "index.html"));
});

app.use(giftRoutes);
// Search route: /api/search
app.use(searchRoutes);
app.use(authRoutes);

module.exports = app;
