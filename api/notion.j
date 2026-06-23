export default async function handler(req, res) {
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'POST, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method === 'OPTIONS') return res.status(200).end();
  if (req.method !== 'POST') return res.status(405).json({ error: 'Method not allowed' });

  try {
    const { endpoint, method = 'GET', token, body } = req.body || {};
    if (!token) return res.status(400).json({ error: 'Missing token' });
    if (!endpoint) return res.status(400).json({ error: 'Missing endpoint' });

    const notionRes = await fetch(`https://api.notion.com/v1/${endpoint}`, {
      method,
      headers: {
        'Authorization': `Bearer ${token}`,
        'Notion-Version': '2022-06-28',
        'Content-Type': 'application/json',
      },
      ...(body ? { body: JSON.stringify(body) } : {}),
    });

    const data = await notionRes.json();
    return res.status(notionRes.status).json(data);
  } catch (e) {
    return res.status(500).json({ error: e.message });
  }
}
