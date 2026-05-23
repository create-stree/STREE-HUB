const express = require('express');
const fs = require('fs');
const path = require('path');
const cors = require('cors');

const app = express();
app.use(express.json());
app.use(cors());

const API_KEYS = (process.env.API_KEYS || 'demo-key-12345').split(',');
const SCRIPT_DIR = path.join(__dirname, 'scripts');

// Create scripts directory if doesn't exist
if (!fs.existsSync(SCRIPT_DIR)) {
    fs.mkdirSync(SCRIPT_DIR, { recursive: true });
}

// Serve HTML
app.get('/', (req, res) => {
    res.sendFile(path.join(__dirname, 'index.html'));
});

// Verify API Key middleware
const verifyApiKey = (req, res, next) => {
    const apiKey = req.headers['x-api-key'] || req.query.key;
    if (!apiKey || !API_KEYS.includes(apiKey.trim())) {
        return res.status(401).json({ error: 'Unauthorized' });
    }
    next();
};

// Health check
app.get('/api/health', (req, res) => {
    res.json({ status: 'online', service: 'STREE HUB' });
});

// List all scripts
app.get('/api/scripts', verifyApiKey, (req, res) => {
    try {
        const files = fs.readdirSync(SCRIPT_DIR)
            .filter(f => f.endsWith('.lua'))
            .map(f => ({ name: f, id: f.replace('.lua', '') }));
        res.json({ success: true, scripts: files, count: files.length });
    } catch (error) {
        res.status(500).json({ error: 'Failed to list scripts' });
    }
});

// Get specific script
app.get('/api/script/:id', verifyApiKey, (req, res) => {
    try {
        const scriptId = req.params.id;
        const scriptPath = path.join(SCRIPT_DIR, `${scriptId}.lua`);

        // Security: prevent path traversal
        if (!scriptPath.startsWith(SCRIPT_DIR)) {
            return res.status(403).json({ error: 'Access denied' });
        }

        // Check if file exists
        if (!fs.existsSync(scriptPath)) {
            return res.status(404).json({ error: 'Script not found' });
        }

        const script = fs.readFileSync(scriptPath, 'utf8');
        const encrypted = Buffer.from(script).toString('base64');

        res.json({
            success: true,
            id: scriptId,
            script: encrypted,
            encrypted: true,
            size: script.length,
            timestamp: new Date().toISOString()
        });
    } catch (error) {
        res.status(500).json({ error: 'Failed to load script' });
    }
});

// Create or update script
app.post('/api/script', verifyApiKey, (req, res) => {
    try {
        const { id, content } = req.body;

        if (!id || !content) {
            return res.status(400).json({ error: 'id and content required' });
        }

        const scriptPath = path.join(SCRIPT_DIR, `${id}.lua`);

        // Security: prevent path traversal
        if (!scriptPath.startsWith(SCRIPT_DIR)) {
            return res.status(403).json({ error: 'Access denied' });
        }

        fs.writeFileSync(scriptPath, content, 'utf8');

        res.json({
            success: true,
            message: `Script '${id}' created/updated successfully`,
            path: scriptPath
        });
    } catch (error) {
        res.status(500).json({ error: 'Failed to save script' });
    }
});

// Delete script
app.delete('/api/script/:id', verifyApiKey, (req, res) => {
    try {
        const scriptId = req.params.id;
        const scriptPath = path.join(SCRIPT_DIR, `${scriptId}.lua`);

        // Security: prevent path traversal
        if (!scriptPath.startsWith(SCRIPT_DIR)) {
            return res.status(403).json({ error: 'Access denied' });
        }

        // Check if file exists
        if (!fs.existsSync(scriptPath)) {
            return res.status(404).json({ error: 'Script not found' });
        }

        fs.unlinkSync(scriptPath);

        res.json({
            success: true,
            message: `Script '${scriptId}' deleted successfully`
        });
    } catch (error) {
        res.status(500).json({ error: 'Failed to delete script' });
    }
});

// 404 handler
app.use((req, res) => {
    res.status(404).json({ error: 'Endpoint not found' });
});

// Error handler
app.use((err, req, res, next) => {
    console.error(err);
    res.status(500).json({ error: 'Internal server error' });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`🔐 STREE HUB running on port ${PORT}`);
});

module.exports = app;