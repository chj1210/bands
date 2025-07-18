# Bakery ERP

A comprehensive information platform for a bakery to increase profits.

## Prerequisites

Before you begin, ensure you have the following installed:
- [Node.js](https://nodejs.org/) (v14 or later recommended)
- [PostgreSQL](https://www.postgresql.org/)

## Setup

Follow these steps to get your development environment set up.

### 1. Clone the Repository

```bash
git clone <repository-url>
cd bakery-erp
```

### 2. Install Dependencies

Install the project dependencies using npm:

```bash
npm install
```

### 3. Set Up the PostgreSQL Database

You need to have a PostgreSQL server running.

a. **Create a database user and a database.** You can use `psql` or a GUI tool like pgAdmin.

```sql
CREATE DATABASE bakery_db;
CREATE USER myuser WITH PASSWORD 'mypassword';
GRANT ALL PRIVILEGES ON DATABASE bakery_db TO myuser;
```
*Replace `myuser` and `mypassword` with your desired credentials.*

b. **Initialize the database schema.** Run the `setup.sql` script to create the necessary tables and seed initial data.

```bash
psql -U myuser -d bakery_db -f setup.sql
```
*You might be prompted for the password for `myuser`.*

### 4. Configure Environment Variables

Create a `.env` file in the root of the project by copying the example file:

```bash
cp .env.example .env
```

Now, edit the `.env` file with your PostgreSQL database connection details:

```
# PostgreSQL Database Connection Settings
DB_USER=myuser
DB_HOST=localhost
DB_DATABASE=bakery_db
DB_PASSWORD=mypassword
DB_PORT=5432
```

## Running the Application

You can run the server in development mode or for production.

### Development Mode

This will run the server with `nodemon`, which automatically restarts the server when file changes are detected.

```bash
npm run dev
```

### Production Mode

This starts the server using `node`.

```bash
npm start
```

## API Endpoint

Once the server is running, the GraphQL API is available at:

- **URL**: `http://localhost:4000/graphql`
- **Methods**: `GET`, `POST`

You can use a tool like Postman or Insomnia to interact with the GraphQL API.

A simple query to test the endpoint:
```graphql
query {
  hello
}
