const { Pool } = require('pg');
const config = require('../../shared/config');

const pool = new Pool(config.postgres);

const User = {
  /**
   * Find a user by email.
   */
  async findByEmail(email) {
    const { rows } = await pool.query(
      'SELECT * FROM users WHERE email = $1 LIMIT 1',
      [email],
    );
    return rows[0] || null;
  },

  /**
   * Find a user by ID.
   */
  async findById(id) {
    const { rows } = await pool.query(
      'SELECT id, email, created_at FROM users WHERE id = $1 LIMIT 1',
      [id],
    );
    return rows[0] || null;
  },

  /**
   * Create a new user with a hashed password.
   */
  async create(email, passwordHash) {
    const { rows } = await pool.query(
      'INSERT INTO users (email, password_hash) VALUES ($1, $2) RETURNING id, email, created_at',
      [email, passwordHash],
    );
    return rows[0];
  },

  /**
   * Store a refresh token for a user.
   */
  async saveRefreshToken(userId, token, expiresAt) {
    await pool.query(
      'INSERT INTO refresh_tokens (user_id, token, expires_at) VALUES ($1, $2, $3)',
      [userId, token, expiresAt],
    );
  },

  /**
   * Retrieve and validate a refresh token record.
   */
  async findRefreshToken(token) {
    const { rows } = await pool.query(
      'SELECT * FROM refresh_tokens WHERE token = $1 AND expires_at > NOW() LIMIT 1',
      [token],
    );
    return rows[0] || null;
  },

  /**
   * Delete a refresh token (logout / rotation).
   */
  async deleteRefreshToken(token) {
    await pool.query('DELETE FROM refresh_tokens WHERE token = $1', [token]);
  },

  /**
   * Delete all refresh tokens for a user (full logout).
   */
  async deleteAllRefreshTokens(userId) {
    await pool.query('DELETE FROM refresh_tokens WHERE user_id = $1', [userId]);
  },
};

module.exports = { User, pool };
