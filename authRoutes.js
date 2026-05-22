const express = require("express");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const { ObjectId } = require("mongodb");
const { connectToDatabase } = require("./db");

const router = express.Router();

const memoryUsersByEmail = new Map();
const memoryUsersById = new Map();

function requireAuth(req, res, next) {
  const header = req.headers.authorization || "";
  const [scheme, token] = header.split(" ");
  if (scheme !== "Bearer" || !token) return res.status(401).json({ error: "Missing token" });

  try {
    const payload = jwt.verify(token, process.env.JWT_SECRET || "dev_secret");
    req.user = payload;
    next();
  } catch (err) {
    res.status(401).json({ error: "Invalid token" });
  }
}

function signTokenForUser(user) {
  return jwt.sign(
    { sub: String(user._id), email: user.email },
    process.env.JWT_SECRET || "dev_secret",
    { expiresIn: "7d" }
  );
}

router.post("/api/auth/register", async (req, res) => {
  try {
    const { db } = await connectToDatabase();
    const { email, password, name } = req.body || {};

    if (!email || !password) {
      return res.status(400).json({ error: "email and password are required" });
    }

    const normalizedEmail = String(email).trim().toLowerCase();
    const existing = await db.collection("users").findOne({ email: normalizedEmail });
    if (existing) return res.status(409).json({ error: "User already exists" });

    const passwordHash = await bcrypt.hash(String(password), 10);
    const doc = {
      email: normalizedEmail,
      passwordHash,
      name: name ? String(name).trim() : "",
      createdAt: new Date()
    };

    const result = await db.collection("users").insertOne(doc);
    res.status(201).json({ _id: result.insertedId, email: doc.email, name: doc.name });
  } catch (err) {
    try {
      const { email, password, name } = req.body || {};
      if (!email || !password) return res.status(400).json({ error: "email and password are required" });

      const normalizedEmail = String(email).trim().toLowerCase();
      if (memoryUsersByEmail.has(normalizedEmail)) return res.status(409).json({ error: "User already exists" });

      const passwordHash = await bcrypt.hash(String(password), 10);
      const doc = {
        _id: new ObjectId(),
        email: normalizedEmail,
        passwordHash,
        name: name ? String(name).trim() : "",
        createdAt: new Date()
      };

      memoryUsersByEmail.set(doc.email, doc);
      memoryUsersById.set(String(doc._id), doc);
      res.status(201).json({ _id: doc._id, email: doc.email, name: doc.name });
    } catch (fallbackErr) {
      res.status(500).json({ error: "Registration failed", details: fallbackErr.message });
    }
  }
});

router.post("/api/auth/login", async (req, res) => {
  try {
    const { db } = await connectToDatabase();
    const { email, password } = req.body || {};

    if (!email || !password) {
      return res.status(400).json({ error: "email and password are required" });
    }

    const normalizedEmail = String(email).trim().toLowerCase();
    const user = await db.collection("users").findOne({ email: normalizedEmail });
    if (!user) return res.status(401).json({ error: "Invalid credentials" });

    const ok = await bcrypt.compare(String(password), user.passwordHash);
    if (!ok) return res.status(401).json({ error: "Invalid credentials" });

    const token = signTokenForUser(user);

    res.json({ token });
  } catch (err) {
    try {
      const { email, password } = req.body || {};
      if (!email || !password) return res.status(400).json({ error: "email and password are required" });

      const normalizedEmail = String(email).trim().toLowerCase();
      const user = memoryUsersByEmail.get(normalizedEmail);
      if (!user) return res.status(401).json({ error: "Invalid credentials" });

      const ok = await bcrypt.compare(String(password), user.passwordHash);
      if (!ok) return res.status(401).json({ error: "Invalid credentials" });

      const token = signTokenForUser(user);
      res.json({ token });
    } catch (fallbackErr) {
      res.status(500).json({ error: "Login failed", details: fallbackErr.message });
    }
  }
});

router.put("/api/auth/user", requireAuth, async (req, res) => {
  try {
    const { db } = await connectToDatabase();
    const userId = req.user?.sub;

    if (!userId || !ObjectId.isValid(userId)) {
      return res.status(400).json({ error: "Invalid user id" });
    }

    const { name } = req.body || {};
    const update = {};
    if (typeof name === "string") update.name = name.trim();

    const result = await db
      .collection("users")
      .findOneAndUpdate({ _id: new ObjectId(userId) }, { $set: update }, { returnDocument: "after" });

    if (!result.value) return res.status(404).json({ error: "User not found" });
    res.json({ _id: result.value._id, email: result.value.email, name: result.value.name });
  } catch (err) {
    try {
      const userId = req.user?.sub;
      const existing = memoryUsersById.get(String(userId));
      if (!existing) return res.status(404).json({ error: "User not found" });

      const { name } = req.body || {};
      if (typeof name === "string") existing.name = name.trim();

      memoryUsersByEmail.set(existing.email, existing);
      memoryUsersById.set(String(existing._id), existing);
      res.json({ _id: existing._id, email: existing.email, name: existing.name });
    } catch (fallbackErr) {
      res.status(500).json({ error: "Update failed", details: fallbackErr.message });
    }
  }
});

module.exports = router;
