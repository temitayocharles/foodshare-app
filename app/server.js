const express = require('express');
const { Pool } = require('pg');
const cors = require('cors');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const multer = require('multer');

const app = express();
app.use(cors());
app.use(express.json());

// Database connection
const pool = new Pool({
  host: process.env.DB_HOST || 'postgres',
  port: 5432,
  database: 'foodshare',
  user: 'fooduser',
  password: 'FoodShare2025!'
});

// Initialize database
async function initDB() {
  try {
    await pool.query(`
      CREATE TABLE IF NOT EXISTS users (
        id SERIAL PRIMARY KEY,
        name VARCHAR(255) NOT NULL,
        email VARCHAR(255) UNIQUE NOT NULL,
        password VARCHAR(255) NOT NULL,
        type VARCHAR(50) NOT NULL, -- donor or receiver
        location VARCHAR(255),
        allergies TEXT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );

      CREATE TABLE IF NOT EXISTS food_items (
        id SERIAL PRIMARY KEY,
        donor_id INTEGER REFERENCES users(id),
        title VARCHAR(255) NOT NULL,
        description TEXT,
        quantity INTEGER NOT NULL,
        location VARCHAR(255) NOT NULL,
        expiry_date DATE,
        allergens TEXT,
        status VARCHAR(50) DEFAULT 'available', -- available, claimed, expired
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );

      CREATE TABLE IF NOT EXISTS claims (
        id SERIAL PRIMARY KEY,
        food_item_id INTEGER REFERENCES food_items(id),
        receiver_id INTEGER REFERENCES users(id),
        claimed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        status VARCHAR(50) DEFAULT 'pending' -- pending, approved, rejected
      );
    `);
    console.log('Database initialized');
  } catch (err) {
    console.error('Database initialization error:', err);
  }
}

initDB();

// Middleware for authentication
const authenticateToken = (req, res, next) => {
  const token = req.header('Authorization')?.replace('Bearer ', '');
  if (!token) return res.status(401).json({ error: 'Access denied' });

  try {
    const verified = jwt.verify(token, 'your-secret-key');
    req.user = verified;
    next();
  } catch (err) {
    res.status(400).json({ error: 'Invalid token' });
  }
};

// Routes

// User registration
app.post('/api/auth/register', async (req, res) => {
  try {
    const { name, email, password, type, location, allergies } = req.body;
    const hashedPassword = await bcrypt.hash(password, 10);

    const result = await pool.query(
      'INSERT INTO users (name, email, password, type, location, allergies) VALUES ($1, $2, $3, $4, $5, $6) RETURNING id',
      [name, email, hashedPassword, type, location, allergies]
    );

    res.status(201).json({ message: 'User registered successfully', userId: result.rows[0].id });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// User login
app.post('/api/auth/login', async (req, res) => {
  try {
    const { email, password } = req.body;
    const result = await pool.query('SELECT * FROM users WHERE email = $1', [email]);

    if (result.rows.length === 0) return res.status(400).json({ error: 'User not found' });

    const user = result.rows[0];
    const validPassword = await bcrypt.compare(password, user.password);

    if (!validPassword) return res.status(400).json({ error: 'Invalid password' });

    const token = jwt.sign({ id: user.id, type: user.type }, 'your-secret-key');
    res.json({ token, user: { id: user.id, name: user.name, type: user.type } });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Get available food items
app.get('/api/food', async (req, res) => {
  try {
    const { location, allergies } = req.query;
    let query = 'SELECT * FROM food_items WHERE status = $1';
    let params = ['available'];

    if (location) {
      query += ' AND location ILIKE $' + (params.length + 1);
      params.push(`%${location}%`);
    }

    const result = await pool.query(query, params);
    res.json(result.rows);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Post new food item (donors only)
app.post('/api/food', authenticateToken, async (req, res) => {
  try {
    if (req.user.type !== 'donor') return res.status(403).json({ error: 'Only donors can post food' });

    const { title, description, quantity, location, expiry_date, allergens } = req.body;

    const result = await pool.query(
      'INSERT INTO food_items (donor_id, title, description, quantity, location, expiry_date, allergens) VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *',
      [req.user.id, title, description, quantity, location, expiry_date, allergens]
    );

    res.status(201).json(result.rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Claim food item (receivers only)
app.post('/api/food/:id/claim', authenticateToken, async (req, res) => {
  try {
    if (req.user.type !== 'receiver') return res.status(403).json({ error: 'Only receivers can claim food' });

    const foodId = req.params.id;

    // Check if food is available
    const foodResult = await pool.query('SELECT * FROM food_items WHERE id = $1 AND status = $2', [foodId, 'available']);
    if (foodResult.rows.length === 0) return res.status(404).json({ error: 'Food item not available' });

    // Create claim
    const claimResult = await pool.query(
      'INSERT INTO claims (food_item_id, receiver_id) VALUES ($1, $2) RETURNING *',
      [foodId, req.user.id]
    );

    // Update food status
    await pool.query('UPDATE food_items SET status = $1 WHERE id = $2', ['claimed', foodId]);

    res.status(201).json(claimResult.rows[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Get user's food items or claims
app.get('/api/my-food', authenticateToken, async (req, res) => {
  try {
    if (req.user.type === 'donor') {
      const result = await pool.query('SELECT * FROM food_items WHERE donor_id = $1', [req.user.id]);
      res.json(result.rows);
    } else {
      const result = await pool.query(`
        SELECT f.*, c.status as claim_status, c.claimed_at
        FROM food_items f
        JOIN claims c ON f.id = c.food_item_id
        WHERE c.receiver_id = $1
      `, [req.user.id]);
      res.json(result.rows);
    }
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

app.listen(3000, () => {
  console.log('Food Share API running on port 3000');
});
