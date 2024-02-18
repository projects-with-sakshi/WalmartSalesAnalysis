CREATE DATABASE IF NOT EXISTS WalmartSalesData;

CREATE TABLE IF NOT EXISTS sales(
   invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
   branch VARCHAR(5) NOT NULL,
   city VARCHAR(30) NOT NULL,
   customer_type VARCHAR(30) NOT NULL,
   gender VARCHAR(10) NOT NULL,
   product_line VARCHAR(100) NOT NULL,
   unit_price DECIMAL(10,2) NOT NULL,
   quantity INT NOT NULL,sales
   VAT FLOAT(6,4) NOT NULL,
   total DECIMAL(12,4) NOT NULL,
   date DATETIME NOT NULL,
   time TIME NOT NULL,
   payment_method VARCHAR(15) NOT NULL,
   cogs DECIMAL(10,2) NOT NULL,
   gross_margin_pct FLOAT(11,9),
   gross_income DECIMAL(12,4)NOT NULL,
   rating FLOAT(2,1)
);



-- ----Feature Engineering----------
-- -----time_of_day

SELECT 
    time,
    (CASE 
        WHEN 'time' BETWEEN "00:00:00" AND "12:00:00" THEN "MORNING"
        WHEN 'time' BETWEEN "12:01:00" AND "16:00:00" THEN "AFTERNOON"
        ELSE "EVENEING"
	END 
    ) AS time_of_date  
FROM sales;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales
SET time_of_day=(
CASE
	WHEN 'time' BETWEEN "00:00:00" AND "12:00:00" THEN "MORNING"
	WHEN 'time' BETWEEN "12:01:00" AND "16:00:00" THEN "AFTERNOON"
	ELSE "EVENEING"
END
);


-- ---day_name
SELECT 
   date,
   DAYNAME(date) AS day_name
FROM SALES;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

UPDATE sales
SET day_name=DAYNAME(date);



-- month_name----
SELECT 
    date,
    MONTHNAME(date) AS month_name
FROM sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);

UPDATE sales
SET month_name=MONTHNAME(date);

-- ------------------------------------ EXPLORATORY DATA ANALYSIS ---------------------------------------------------

-- -----------------------------------------------------------------------------------------------------------------
-- ------------------------------------------ Generic --------------------------------------------------------------

-- Ques1.How many unique cities does the data have?
SELECT 
    DISTINCT city
FROM sales;

-- Ques2.In which city is each branch?
SELECT 
    DISTINCT branch
FROM sales;


SELECT 
   DISTINCT city,
   branch
FROM sales;

-- -----------------------------------------------------------------------------------------------------------------
-- ------------------------------------------ product --------------------------------------------------------------


-- Ques3.How many unique product lines does the data have?
SELECT 
     COUNT(DISTINCT product_line)
FROM sales;

-- Ques4.What is the most common payment method?
SELECT 
     payment_method,
     COUNT(payment_method) as cnt
FROM sales
GROUP BY payment_method
ORDER BY cnt DESC;

-- Ques5.What is the most selling product line?
SELECT 
     product_line,
     COUNT(product_line) AS cnt
FROM sales
GROUP BY product_line
ORDER BY cnt DESC;

-- Ques6.What is the total revenue by month?
SELECT 
     month_name AS month,
     SUM(total) AS total_revenue
FROM sales
GROUP BY month_name
ORDER BY total_revenue DESC;

-- Ques7.What month had the largest COGS(cost of good sold)?
SELECT 
	month_name AS month,
	SUM(cogs) AS cogs
FROM sales
GROUP BY month_name
ORDER BY cogs DESC;

-- Ques8.What product line had the largest revenue?
SELECT 
     product_line,
     SUM(total) AS total_revenue
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC;

-- Ques9.What is the city with the largest revenue?
SELECT 
     branch,
     city,
     SUM(total) AS total_revenue
FROM sales
GROUP BY city,branch
ORDER BY total_revenue DESC;

-- Ques10.What product line had the largest VAT?
SELECT 
     product_line,
     AVG(VAT) AS avg_tax
FROM sales
GROUP BY product_line
ORDER BY avg_tax DESC;

-- Ques11.Fetch each product line and add a column to those product line showing "Good", "Bad".Good if its greater than average sales
-- Ques12.Which branch sold more products than average product sold?
SELECT 
     branch,
     SUM(quantity) AS qty
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM sales);

-- Ques13.What is the most common product line by gender?
SELECT 
     gender,
     product_line,
     COUNT(gender) AS total_cnt
FROM sales
GROUP BY gender,product_line
ORDER BY total_cnt DESC;

-- Ques14.What is the avergae rating of each product line?
SELECT
    ROUND(AVG(rating),2) AS avg_rating,
    product_line
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;


-- -----------------------------------------------------------------------------------------------------------------
-- ------------------------------------------ Sales --------------------------------------------------------------

-- Ques15.NUmber of sales made in each time of the day per weekday?
SELECT 
     time_of_day,
     COUNT(*) AS total_sales
 FROM sales
 WHERE day_name='Monday'
 GROUP BY time_of_day
 ORDER BY total_sales DESC;

-- Ques16.Which of the customer types brings the most revenue?
SELECT 
     customer_type,
     SUM(total) AS total_rev
FROM sales
GROUP BY customer_type
ORDER BY total_rev DESC;

-- Ques17.Which city has the largest value added tax(VAT)?
SELECT
  city,
  AVG(VAT) AS VAT
FROM sales
GROUP BY city
ORDER BY VAT DESC;

-- Ques18.Which customer type pays the most in VAT?
SELECT
  customer_type,
  AVG(VAT) AS VAT
FROM sales
GROUP BY customer_type
ORDER BY VAT DESC;


-- -----------------------------------------------------------------------------------------------------------------
-- ------------------------------------------ Customer --------------------------------------------------------------

-- Ques19.How many unique customer types does the data have?
SELECT 
   DISTINCT customer_type
FROM sales;

-- Ques20.How many unique payment methods does the data have?
SELECT 
    DISTINCT payment_method
FROM sales;

-- Ques21.What is the most customer type?
SELECT 
    DISTINCT customer_type,
   COUNT(customer_type) AS cus_type
FROM sales
GROUP BY customer_type
ORDER BY cus_type DESC;

-- Ques22.Which customer type buys the most?
SELECT
    DISTINCT customer_type,
    COUNT(*) AS cstm_cnt
FROM sales
GROUP BY customer_type;

-- Ques23.What is the gender of most of the customer_type?
SELECT
     gender,
     COUNT(*) AS gen
FROM sales
GROUP BY gender
ORDER BY gender DESC;

-- Ques24.What is the gender distribution per branch?
SELECT
     gender,
     COUNT(*) AS gen
FROM sales
WHERE branch= "A"
GROUP BY gender
ORDER BY gen DESC;

-- Ques25.Whch time of the day do cutomer gives more ratings?
SELECT
    time_of_day,
    AVG(rating) AS avg_rating
FROM sales
GROUP BY time_of_day
ORDER BY avg_rating DESC;

-- Ques26.Which time of the day do cutomer give more rating per branch?
SELECT
    time_of_day,
    AVG(rating) AS avg_rating
FROM sales
WHERE branch="C"
GROUP BY time_of_day
ORDER BY avg_rating DESC;

-- Ques27.Which day of the week has best average rating?
SELECT 
     day_name,
     AVG(rating) AS avg_rating
FROM sales
GROUP BY day_name
ORDER BY avg_rating DESC;

-- Ques28.Which day of the week has the best average ratings per branch?
SELECT 
     day_name,
     AVG(rating) AS avg_rating
FROM sales
WHERE branch="A"
GROUP BY day_name
ORDER BY avg_rating DESC;




















