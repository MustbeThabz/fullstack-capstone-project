const { MongoClient } = require("mongodb");

let cachedClient = null;
let cachedDb = null;
let cachedMongoError = null;

async function connectToDatabase() {
  if (cachedClient && cachedDb) return { client: cachedClient, db: cachedDb };
  if (cachedMongoError) throw cachedMongoError;

  const uri = process.env.MONGODB_URI || "mongodb://localhost:27017";
  const dbName = process.env.MONGODB_DB || "giftlink";

  const client = new MongoClient(uri);
  try {
    await client.connect();
  } catch (err) {
    cachedMongoError = err;
    throw err;
  }

  const db = client.db(dbName);

  cachedClient = client;
  cachedDb = db;

  return { client, db };
}

module.exports = { connectToDatabase };
