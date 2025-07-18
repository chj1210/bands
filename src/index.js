const express = require('express');
const { createHandler } = require('graphql-http/lib/use/express');
const { buildSchema } = require('graphql');

// GraphQL Schema
// We'll start with a simple schema and expand it later.
const schema = buildSchema(`
  type Query {
    hello: String
  }
`);

// Root resolver
const root = {
  hello: () => 'Hello, Bakery World!',
};

const app = express();
const port = 4000;

// Setup the GraphQL endpoint
app.all('/graphql', createHandler({
  schema: schema,
  rootValue: root,
}));

app.listen(port, () => {
  console.log(`Bakery ERP server running at http://localhost:${port}/graphql`);
});