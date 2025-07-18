-- Drop tables if they exist to ensure a clean setup
DROP TABLE IF EXISTS PAYMENTS, STOCK_MOVEMENTS, PRODUCT_INGREDIENTS, ORDER_ITEMS, ORDERS, PRODUCTS, INGREDIENTS, SUPPLIERS, MEMBERSHIPS, CUSTOMERS, USERS CASCADE;

-- USERS Table: Stores login information for staff and administrators
CREATE TABLE USERS (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    hashed_password VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL CHECK (role IN ('admin', 'staff')),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- CUSTOMERS Table: Stores customer information
CREATE TABLE CUSTOMERS (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) UNIQUE,
    email VARCHAR(100) UNIQUE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- MEMBERSHIPS Table: Manages customer loyalty program details
CREATE TABLE MEMBERSHIPS (
    membership_id SERIAL PRIMARY KEY,
    customer_id INT UNIQUE NOT NULL REFERENCES CUSTOMERS(customer_id),
    level VARCHAR(20) DEFAULT 'Standard' CHECK (level IN ('Standard', 'Gold', 'Silver')),
    points INT DEFAULT 0,
    expiry_date DATE
);

-- SUPPLIERS Table: Information about raw material suppliers
CREATE TABLE SUPPLIERS (
    supplier_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    contact_person VARCHAR(100),
    phone VARCHAR(20),
    address TEXT
);

-- INGREDIENTS Table: Manages raw materials for products
CREATE TABLE INGREDIENTS (
    ingredient_id SERIAL PRIMARY KEY,
    supplier_id INT REFERENCES SUPPLIERS(supplier_id),
    name VARCHAR(100) NOT NULL,
    cost_per_unit DECIMAL(10, 2) NOT NULL,
    current_stock REAL NOT NULL,
    safety_stock_level REAL,
    unit VARCHAR(20) NOT NULL, -- e.g., g, ml, piece
    expiry_date DATE
);

-- PRODUCTS Table: The items sold at the bakery
CREATE TABLE PRODUCTS (
    product_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    category VARCHAR(50),
    image_url VARCHAR(255),
    is_available BOOLEAN DEFAULT TRUE
);

-- PRODUCT_INGREDIENTS Table: Junction table for Products and Ingredients (Bill of Materials)
CREATE TABLE PRODUCT_INGREDIENTS (
    product_id INT NOT NULL REFERENCES PRODUCTS(product_id),
    ingredient_id INT NOT NULL REFERENCES INGREDIENTS(ingredient_id),
    quantity_used REAL NOT NULL,
    unit VARCHAR(20) NOT NULL,
    PRIMARY KEY (product_id, ingredient_id)
);

-- ORDERS Table: Records all sales transactions
CREATE TABLE ORDERS (
    order_id SERIAL PRIMARY KEY,
    user_id INT REFERENCES USERS(user_id), -- Staff who processed the order
    customer_id INT REFERENCES CUSTOMERS(customer_id), -- Can be NULL for non-member sales
    order_type VARCHAR(20) NOT NULL CHECK (order_type IN ('in-store', 'online', 'delivery')),
    status VARCHAR(20) NOT NULL CHECK (status IN ('pending', 'completed', 'cancelled')),
    total_amount DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- ORDER_ITEMS Table: Junction table for Orders and Products
CREATE TABLE ORDER_ITEMS (
    order_item_id SERIAL PRIMARY KEY,
    order_id INT NOT NULL REFERENCES ORDERS(order_id),
    product_id INT NOT NULL REFERENCES PRODUCTS(product_id),
    quantity INT NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    customization_details JSONB -- For options like 'less sugar'
);

-- STOCK_MOVEMENTS Table: Tracks all changes in ingredient inventory
CREATE TABLE STOCK_MOVEMENTS (
    movement_id SERIAL PRIMARY KEY,
    ingredient_id INT NOT NULL REFERENCES INGREDIENTS(ingredient_id),
    type VARCHAR(20) NOT NULL CHECK (type IN ('purchase', 'usage', 'waste', 'adjustment')),
    quantity REAL NOT NULL,
    timestamp TIMESTAMPTZ DEFAULT NOW()
);

-- PAYMENTS Table: Records payment details for each order
CREATE TABLE PAYMENTS (
    payment_id SERIAL PRIMARY KEY,
    order_id INT NOT NULL REFERENCES ORDERS(order_id),
    method VARCHAR(20) NOT NULL CHECK (method IN ('cash', 'credit_card', 'line_pay', 'google_pay', 'apple_pay')),
    amount DECIMAL(10, 2) NOT NULL,
    status VARCHAR(20) NOT NULL CHECK (status IN ('paid', 'refunded')),
    timestamp TIMESTAMPTZ DEFAULT NOW()
);

-- Add some sample data for testing
INSERT INTO USERS (username, hashed_password, role) VALUES ('admin', 'admin_pass', 'admin');
INSERT INTO PRODUCTS (name, price, category, is_available) VALUES ('Croissant', 3.50, 'Pastry', true);
INSERT INTO PRODUCTS (name, price, category, is_available) VALUES ('Chocolate Cake', 25.00, 'Cake', true);