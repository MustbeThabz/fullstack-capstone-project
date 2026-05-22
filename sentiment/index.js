const natural = require("natural");

function tokenize(text) {
  const tokenizer = new natural.WordTokenizer();
  return tokenizer.tokenize(String(text || ""));
}

module.exports = { tokenize };

