require('dotenv').config();
const { Pool } = require('pg');

console.log('Attempting to connect to the database with the following settings:');
console.log(`User: ${process.env.DB_USER}`);
console.log(`Host: ${process.env.DB_HOST}`);
console.log(`Database: ${process.env.DB_DATABASE}`);
console.log(`Port: ${process.env.DB_PORT}`);
console.log('Password: [hidden]');

const pool = new Pool({
  user: process.env.DB_USER,
  host: process.env.DB_HOST,
  database: process.env.DB_DATABASE,
  password: process.env.DB_PASSWORD,
  port: process.env.DB_PORT,
  // Add a connection timeout to prevent hanging
  connectionTimeoutMillis: 5000,
});

async function testConnection() {
  try {
    const client = await pool.connect();
    console.log('\nDatabase connection successful!');
    client.release();
  } catch (error) {
    console.error('\nFailed to connect to the database.');
    console.error('Error details:', error.message);
    console.error('\nPlease double-check your .env file settings and ensure your PostgreSQL server is running correctly.');
  } finally {
    await pool.end();
  }
}

testConnection();