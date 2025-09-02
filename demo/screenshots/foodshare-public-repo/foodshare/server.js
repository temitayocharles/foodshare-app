const express = require('express');
const { Client } = require('pg');
const cors = require('cors');

const app = express();
app.use(cors());
app.use(express.json());

const client = new Client({
    host: 'postgres',
    port: 5432,
    database: 'foodshare',
    user: 'foodadmin',
    password: 'FoodShare2025!'
});

client.connect();

app.get('/api/health', (req, res) => {
    res.json({ status: 'healthy', service: 'FoodShare Backend' });
});

app.get('/api/food', async (req, res) => {
    try {
        const result = await client.query('SELECT * FROM food_listings ORDER BY created_at DESC');
        res.json(result.rows);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

app.post('/api/food', async (req, res) => {
    try {
        const { restaurant, food_type, quantity, expiry_date, location, allergies } = req.body;
        const result = await client.query(
            'INSERT INTO food_listings (restaurant, food_type, quantity, expiry_date, location, allergies) VALUES ($1, $2, $3, $4, $5, $6) RETURNING *',
            [restaurant, food_type, quantity, expiry_date, location, allergies]
        );
        res.json(result.rows[0]);
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

app.listen(3000, () => {
    console.log('FoodShare Backend running on port 3000');
});
