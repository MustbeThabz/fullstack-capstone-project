async function registerUser({ apiBaseUrl = "", name, email, password }) {
  const res = await fetch(`${apiBaseUrl}/api/auth/register`, {
    method: "POST",
    headers: {
      "Content-Type": "application/json"
    },
    body: JSON.stringify({ name, email, password })
  });

  if (!res.ok) {
    const err = await res.json().catch(() => ({}));
    throw new Error(err.error || `Registration failed (${res.status})`);
  }

  return res.json();
}

module.exports = { registerUser };

