-- 2. DATA GENERATION
INSERT INTO locations VALUES (1, 'SoCal Central', 'Los Angeles'), (2, 'Beachside', 'Santa Monica'), (3, 'Desert Oasis', 'Palm Springs'), (4, 'Metro South', 'San Diego'), (5, 'Valley Scoop', 'Burbank');

INSERT INTO products VALUES (1, 'Vanilla Bean', 'Scoops', 4.5), (2, 'Dark Chocolate', 'Scoops', 4.5), (3, 'Strawberry', 'Scoops', 4.5), (4, 'Mint Chip', 'Scoops', 4.5), (5, 'Cookie Dough', 'Scoops', 5.0), (6, 'Rocky Road', 'Scoops', 5.0), (7, 'Pistachio', 'Scoops', 5.5), (8, 'Coffee Toffee', 'Scoops', 5.5), (9, 'Salted Caramel', 'Scoops', 5.0), (10, 'Mango Sorbet', 'Scoops', 4.5), (11, 'Hot Fudge Sundae', 'Sundaes', 8.0), (12, 'Banana Split', 'Sundaes', 9.5), (13, 'Root Beer Float', 'Drinks', 6.0), (14, 'Cold Brew Shake', 'Drinks', 7.0), (15, 'Ice Cream Sandwich', 'Sundaes', 6.5);

WITH RECURSIVE cnt(x) AS (SELECT 1 UNION ALL SELECT x+1 FROM cnt WHERE x < 1000)
INSERT INTO customers (name, email) SELECT 'Customer ' || x, 'user' || x || '@example.com' FROM cnt;

WITH RECURSIVE gen_orders(x) AS (SELECT 1 UNION ALL SELECT x+1 FROM gen_orders WHERE x < 50000)
INSERT INTO orders (customer_id, location_id, order_date, status)
SELECT 
    ABS(RANDOM() % 1000) + 1, 
    ABS(RANDOM() % 5) + 1,
    DATE('2023-01-01', '+' || ABS(RANDOM() % 1095) || ' days'),
    CASE ABS(RANDOM() % 10)
        WHEN 0 THEN 'cancelled'
        WHEN 1 THEN 'refunded'
        ELSE 'completed'
    END
FROM gen_orders;

INSERT INTO order_items (order_id, product_id, quantity, price_at_sale)
SELECT 
    order_id, 
    ABS(RANDOM() % 15) + 1, 
    ABS(RANDOM() % 3) + 1,
    (SELECT price FROM products WHERE product_id = (ABS(RANDOM() % 15) + 1))
FROM orders;
