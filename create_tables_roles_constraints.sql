
-- Create database psql -U postgres (in sh)

CREATE DATABASE restaurantdb;
--\c restaurantdb;

-- Create schema 
CREATE TABLE restaurants (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    restaurant_id INTEGER REFERENCES restaurants(id),
    name VARCHAR(100) NOT NULL
);

CREATE TABLE dishes (
    id SERIAL PRIMARY KEY,
    restaurant_id INTEGER REFERENCES restaurants(id),
    category_id INTEGER REFERENCES categories(id),
    name VARCHAR(200) NOT NULL,
    price MONEY NOT NULL,
    status TEXT NOT NULL
);

CREATE TABLE customers (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    gender VARCHAR(10),
    birthday DATE
);

CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(id),
    status TEXT NOT NULL
);

CREATE TABLE order_items (
    order_id INTEGER REFERENCES orders(id),
    dish_id INTEGER REFERENCES dishes(id),
    quantity INTEGER NOT NULL,
    PRIMARY KEY (order_id, dish_id)
);

-- Some data for the tables

INSERT INTO restaurants (name) VALUES 
('The Gourmet Kitchen'), 
('Pasta Palace'), 
('Sushi Central');

INSERT INTO categories (restaurant_id, name) VALUES 
(1, 'Appetizers'), 
(1, 'Main Course'), 
(2, 'Pasta'), 
(2, 'Desserts'), 
(3, 'Sushi'), 
(3, 'Sashimi');

INSERT INTO dishes (restaurant_id, category_id, name, price, status) VALUES 
(1, 1, 'Bruschetta', '5.99', 'available'), 
(1, 2, 'Grilled Chicken', '15.99', 'available'), 
(2, 3, 'Spaghetti Carbonara', '12.99', 'available'), 
(2, 4, 'Tiramisu', '6.99', 'available'), 
(3, 5, 'California Roll', '8.99', 'available'), 
(3, 6, 'Salmon Sashimi', '10.99', 'available');

INSERT INTO customers (full_name, email, gender, birthday) VALUES 
('John Doe', 'john@example.com', 'Male', '1985-05-15'), 
('Jane Smith', 'jane@example.com', 'Female', '1990-07-22');

INSERT INTO orders (customer_id, status) VALUES 
(1, 'pending'), 
(2, 'completed');

INSERT INTO order_items (order_id, dish_id, quantity) VALUES 
(1, 1, 2), 
(1, 3, 1), 
(2, 5, 3);



-- Adding constraints and roles

--- Adding NOT NULL constraints
ALTER TABLE categories ALTER COLUMN restaurant_id SET NOT NULL;
ALTER TABLE dishes ALTER COLUMN restaurant_id SET NOT NULL;
ALTER TABLE dishes ALTER COLUMN category_id SET NOT NULL;
ALTER TABLE order_items ALTER COLUMN order_id SET NOT NULL;
ALTER TABLE order_items ALTER COLUMN dish_id SET NOT NULL;

--- Add a role for read-only access
CREATE ROLE readonly;
GRANT CONNECT ON DATABASE restaurantdb TO readonly;
GRANT USAGE ON SCHEMA public TO readonly;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO readonly;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT SELECT ON TABLES TO readonly;


-- Opmtize performance with indexes


--- Adding indexes
CREATE INDEX idx_restaurants_name ON restaurants (name);
CREATE INDEX idx_categories_name ON categories (name);
CREATE INDEX idx_dishes_name ON dishes (name);
CREATE INDEX idx_customers_email ON customers (email);
CREATE INDEX idx_orders_status ON orders (status);
CREATE INDEX idx_order_items_order_id ON order_items (order_id);

--- Adding composite indexes for commonly queried columns
CREATE INDEX idx_dishes_restaurant_category ON dishes (restaurant_id, category_id);
CREATE INDEX idx_order_items_order_dish ON order_items (order_id, dish_id);


-- Verify constraints

--- Check constraints for the restaurants table
SELECT constraint_name, table_name, column_name
FROM information_schema.key_column_usage
WHERE table_name = 'restaurants';

--- Check constraints for the categories table
SELECT constraint_name, table_name, column_name
FROM information_schema.key_column_usage
WHERE table_name = 'categories';

--- Check constraints for the dishes table
SELECT constraint_name, table_name, column_name
FROM information_schema.key_column_usage
WHERE table_name = 'dishes';




