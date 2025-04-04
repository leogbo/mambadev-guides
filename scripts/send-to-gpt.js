const axios = require('axios');
const { execSync } = require('child_process');
require('dotenv').config();

const comment = process.env.GITHUB_EVENT_PATH && require(process.env.GITHUB_EVENT_PATH).comment.body;
const mode = comment.includes('/mamba strict') ? 'Mamba Strict Mode' : 'Mamba Review Mode';

// Get PR diff
const prDiff = execSync('git fetch origin main && git diff origin/main...HEAD').toString();

// Send to GPT
axios.post('https://api.openai.com/v1/chat/completions', {
  model: 'gpt-4',
  messages: [
    { role: 'system', content: `You are Apex MambaDev in ${mode}. Review the following Apex PR diff using the Mamba Protocol.` },
    { role: 'user', content: prDiff }
  ]
}, {
  headers: {
    'Authorization': `Bearer ${process.env.OPENAI_API_KEY}`,
    'Content-Type': 'application/json'
  }
}).then(res => {
  const gptReply = res.data.choices[0].message.content;

  // Post reply as GitHub comment
  const issueNumber = require(process.env.GITHUB_EVENT_PATH).issue.number;
  return axios.post(`https://api.github.com/repos/${process.env.GITHUB_REPOSITORY}/issues/${issueNumber}/comments`, {
    body: `🧠 Mamba Review (${mode}):\n\n${gptReply}`
  }, {
    headers: {
      Authorization: `Bearer ${process.env.GITHUB_TOKEN}`
    }
  });
}).catch(err => {
  console.error('Mamba GPT error:', err.message);
  process.exit(1);
});
