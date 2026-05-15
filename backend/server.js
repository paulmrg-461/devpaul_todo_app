require('dotenv').config();

const express = require('express');
const cors = require('cors');
const rateLimit = require('express-rate-limit');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

const limiter = rateLimit({
  windowMs: 15 * 60 * 1000,
  max: 100,
  message: { error: 'Too many requests, please try again later.' },
});

app.use('/api/', limiter);

const DEEPSEEK_API_URL = process.env.DEEPSEEK_API_URL || 'https://api.deepseek.com/v1';
const DEEPSEEK_API_KEY = process.env.DEEPSEEK_API_KEY || '';

if (!DEEPSEEK_API_KEY) {
  console.error('ERROR: DEEPSEEK_API_KEY not set in environment.');
  process.exit(1);
}

app.post('/api/suggestions', async (req, res) => {
  try {
    const { task } = req.body;

    if (!task) {
      return res.status(400).json({ error: 'Task data is required' });
    }

    const response = await fetch(`${DEEPSEEK_API_URL}/chat/completions`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${DEEPSEEK_API_KEY}`,
      },
      body: JSON.stringify({
        model: 'deepseek-chat',
        messages: [
          {
            role: 'system',
            content: `
              Eres un asistente experto en gestión de tareas que proporciona sugerencias en español.
              Tus respuestas deben ser:
              1. Prácticas y específicas
              2. En español con acentos y caracteres especiales correctos
              3. Numeradas y bien estructuradas
              4. Concisas y directas
            `,
          },
          {
            role: 'user',
            content: `
              Tarea: ${task.name}
              Descripción: ${task.description}
              Prioridad: ${task.priority}
              Tipo: ${task.type}
              Fecha límite: ${task.dueDate}
              
              Por favor, proporciona 3 sugerencias prácticas y específicas para resolver esta tarea.
              Asegúrate de que las sugerencias estén numeradas y sean fáciles de entender y en formato MarkDown.
            `,
          },
        ],
        temperature: 0.7,
        max_tokens: 1300,
      }),
    });

    if (!response.ok) {
      const errorText = await response.text();
      console.error(`DeepSeek API error: ${response.status} - ${errorText}`);
      return res.status(response.status).json({
        error: `Error from AI service: ${response.status}`,
      });
    }

    const data = await response.json();
    const suggestion = data.choices[0].message.content;

    res.json({ suggestion });
  } catch (error) {
    console.error('Proxy error:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

app.get('/api/health', (_req, res) => {
  res.json({ status: 'ok', timestamp: new Date().toISOString() });
});

app.listen(PORT, () => {
  console.log(`Backend proxy running on http://localhost:${PORT}`);
  console.log(`DeepSeek API URL: ${DEEPSEEK_API_URL}`);
});
