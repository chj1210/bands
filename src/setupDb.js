const fs = require('fs');
const { Pool } = require('pg');
require('dotenv').config();

const setupSql = fs.readFileSync('setup.sql').toString();

// Connect to the default 'postgres' database to create our application's database
const pool = new Pool({
  user: process.env.DB_USER || 'postgres',
  host: process.env.DB_HOST || 'localhost',
  database: 'postgres', // Connect to the default db to run maintenance tasks
  password: process.env.DB_PASSWORD,
  port: process.env.DB_PORT || 5432,
});

const dbName = process.env.DB_DATABASE || 'bakery_db';

async function setupDatabase() {
  const client = await pool.connect();
  try {
    // Check if the database exists
    const res = await client.query(`SELECT 1 FROM pg_database WHERE datname = $1`, [dbName]);
    if (res.rowCount > 0) {
      console.log(`Database '${dbName}' already exists. Re-creating it...`);
      // Terminate all other connections to the database
      await client.query(`SELECT pg_terminate_backend(pg_stat_activity.pid) FROM pg_stat_activity WHERE pg_stat_activity.datname = '${dbName}' AND pid <> pg_backend_pid();`);
      await client.query(`DROP DATABASE IF EXISTS ${dbName}`);
    }
    
    console.log(`Creating database '${dbName}'...`);
    await client.query(`CREATE DATABASE ${dbName}`);
    console.log(`Database '${dbName}' created successfully.`);
    
    // Now, connect to the newly created database to create tables
    client.release(); // Release client from 'postgres' db pool
    
    const appDbPool = new Pool({
        user: process.env.DB_USER,
        host: process.env.DB_HOST,
        database: dbName,
        password: process.env.DB_PASSWORD,
        port: process.env.DB_PORT,
    });

    console.log('Connecting to the new database and setting up tables...');
    await appDbPool.query(setupSql);
    console.log('Tables created and sample data inserted successfully.');
    
    await appDbPool.end();
  } catch (error) {
    console.error('Error setting up the database:', error);
  }
}

setupDatabase();