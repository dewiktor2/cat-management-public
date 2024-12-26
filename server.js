const express = require('express');
const path = require('path');

const app = express();
const port = process.env.PORT || 4000; // Use environment variable or default to 4000

// Serve static files from the dist directory
app.use(express.static(path.join(__dirname, 'dist/frontend/browser')));


// Serve the index.html for all other routes (for SPA routing)
app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, 'dist/frontend/browser/index.html'));
});

app.listen(port, () => {
  console.log(`Server is running on port ${port}`);
});