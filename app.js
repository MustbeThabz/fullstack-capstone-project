const express = require("express");
const cors = require("cors");

const giftRoutes = require("./giftRoutes");
const searchRoutes = require("./searchRoutes");
const authRoutes = require("./authRoutes");

const app = express();

app.use(cors());
app.use(express.json());

app.use(giftRoutes);
// Search route: /api/search
app.use(searchRoutes);
app.use(authRoutes);

module.exports = app;
