CREATE DATABASE retail_capstone;
USE retail_capstone;

CREATE TABLE customer_data (
  customer_id VARCHAR(100) PRIMARY KEY,
  name VARCHAR(100),
  gender VARCHAR(10),
  age INT,
  region VARCHAR(10),
  sign_up_date DATE,
  loyalty_score INT
);

CREATE TABLE marketing_campaigns (
  campaign_id VARCHAR(100) PRIMARY KEY,
  channel VARCHAR(20),
  start_date DATE,
  end_date DATE,
  target_audience INT,
  conversions DECIMAL(5,2)
);
 
 CREATE TABLE product_catalog (
  product_id VARCHAR(100) PRIMARY KEY,
  product_name VARCHAR(100),
  category VARCHAR(50),
  price DECIMAL(10, 2),
  supplier_id VARCHAR(100)
);

CREATE TABLE sales_transactions (
  transaction_id VARCHAR(100) PRIMARY KEY,
  customer_id VARCHAR(100),
  product_id VARCHAR(100),
  quantity INT,
  discount_rate DECIMAL(5,2),
  total_price DECIMAL(10,2),
  transaction_date DATE
  );
  
SELECT customer_id
FROM sales_transactions
WHERE customer_id NOT IN (
  SELECT customer_id FROM customer_data
);

SELECT product_id
FROM sales_transactions
WHERE product_id NOT IN (
  SELECT product_id FROM product_catalog
);

ALTER TABLE sales_transactions
ADD CONSTRAINT fk_customer
FOREIGN KEY (customer_id)
REFERENCES customer_data(customer_id);

ALTER TABLE sales_transactions
ADD CONSTRAINT fk_product
FOREIGN KEY (product_id)
REFERENCES product_catalog(product_id);


SELECT customer_id, SUM(total_price) AS total_spent
FROM sales_transactions
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 10;

SELECT
  COUNT(DISTINCT CASE WHEN purchase_count > 1 THEN customer_id END) AS repeat_customers,
  COUNT(DISTINCT CASE WHEN purchase_count = 1 THEN customer_id END) AS one_time_customers
FROM (
  SELECT customer_id, COUNT(quantity) AS purchase_count
  FROM sales_transactions
  GROUP BY customer_id
) AS sub;

SELECT customer_id
FROM customer_data
WHERE customer_id NOT IN (
  SELECT DISTINCT customer_id FROM sales_transactions
);

SELECT
  DATE_FORMAT(transaction_date, '%Y-%m') AS month,
  SUM(total_price * (1 - (discount_rate))) AS monthly_revenue
FROM sales_transactions
WHERE transaction_date BETWEEN '2024-04-21' AND '2025-04-21'
GROUP BY DATE_FORMAT(transaction_date, '%Y-%m')
ORDER BY month;

SELECT
  customer_id,
  SUM(total_price * (1 - discount_rate)) AS lifetime_value
FROM sales_transactions
GROUP BY customer_id;






