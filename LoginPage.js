function toBasicAuth(email, password) {
  const token = Buffer.from(`${email}:${password}`).toString("base64");
  return `Basic ${token}`;
}

async function loginUser({ apiBaseUrl = "", email, password }) {
  const res = await fetch(`${apiBaseUrl}/api/auth/login`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "Authorization": toBasicAuth(email, password)
    },
    body: JSON.stringify({ email, password })
  });

  if (!res.ok) {
    const err = await res.json().catch(() => ({}));
    throw new Error(err.error || `Login failed (${res.status})`);
  }

  return res.json();
}

module.exports = { loginUser };

