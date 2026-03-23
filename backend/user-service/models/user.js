const { Pool } = require('pg');
const config = require('../../shared/config');

const pool = new Pool(config.postgres);

const UserModel = {
  async findById(id) {
    const { rows } = await pool.query(
      'SELECT id, email, display_name, created_at FROM users WHERE id = $1',
      [id],
    );
    return rows[0] || null;
  },

  async update(id, fields) {
    const allowed = ['display_name'];
    const updates = [];
    const values = [];
    let i = 1;

    for (const key of allowed) {
      if (fields[key] !== undefined) {
        updates.push(`${key} = $${i++}`);
        values.push(fields[key]);
      }
    }

    if (updates.length === 0) return this.findById(id);

    values.push(id);
    const { rows } = await pool.query(
      `UPDATE users SET ${updates.join(', ')}, updated_at = NOW() WHERE id = $${i} RETURNING id, email, display_name, created_at`,
      values,
    );
    return rows[0] || null;
  },

  async delete(id) {
    await pool.query('DELETE FROM users WHERE id = $1', [id]);
  },

  async getPreferences(userId) {
    const { rows } = await pool.query(
      'SELECT language, notifications_enabled, theme FROM user_preferences WHERE user_id = $1',
      [userId],
    );
    return rows[0] || { language: 'de', notifications_enabled: true, theme: 'system' };
  },

  async upsertPreferences(userId, prefs) {
    const { language, notifications_enabled, theme } = prefs;
    const { rows } = await pool.query(
      `INSERT INTO user_preferences (user_id, language, notifications_enabled, theme)
       VALUES ($1, $2, $3, $4)
       ON CONFLICT (user_id) DO UPDATE
         SET language = EXCLUDED.language,
             notifications_enabled = EXCLUDED.notifications_enabled,
             theme = EXCLUDED.theme
       RETURNING language, notifications_enabled, theme`,
      [userId, language || 'de', notifications_enabled !== undefined ? notifications_enabled : true, theme || 'system'],
    );
    return rows[0];
  },
};

module.exports = { UserModel, pool };
