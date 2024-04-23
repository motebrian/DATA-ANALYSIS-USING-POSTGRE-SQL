---Objective 1: Analyze Sales Performance
---Total Sales By Category
SELECT ROUND(sum(sales.itemsales),0) AS Total_Sales,items.category_name AS Categories
FROM sales
JOIN items
ON sales.item_code = items.item_code
GROUP BY Categories
ORDER BY Total_Sales DESC;
---Best performing products by sales
SELECT ROUND(sum(sales.itemsales),0) AS Total_Sales,items.item_name AS Products
FROM sales
JOIN items
ON sales.item_code = items.item_code
GROUP BY Products
ORDER BY Total_Sales DESC
LIMIT 10;
---Worst performing products by sales
SELECT ROUND(sum(sales.itemsales),0) AS Total_Sales,items.item_name AS Products
FROM sales
JOIN items
ON sales.item_code = items.item_code
GROUP BY Products
ORDER BY Total_Sales ASC
LIMIT 10;
---Top selling products by quantity
SELECT ROUND(sum(sales.quantity_sold_kg),0) AS Total_Sales,items.item_name AS Products
FROM sales
JOIN items
ON sales.item_code = items.item_code
GROUP BY Products
ORDER BY Total_Sales DESC
LIMIT 10;
---Effect of discount on sales
SELECT ROUND(sum(sales.itemsales),0) AS Total_Sales,items.item_name AS Products
FROM sales
JOIN items
ON sales.item_code = items.item_code
WHERE discount = 'Yes'
GROUP BY Products
ORDER BY Total_Sales DESC
LIMIT 10;---product sales with discount

SELECT ROUND(sum(sales.itemsales),0) AS Total_Sales,items.item_name AS Products
FROM sales
JOIN items
ON sales.item_code = items.item_code
WHERE discount = 'No'
GROUP BY Products
ORDER BY Total_Sales DESC
LIMIT 10;---product sales without discount

---Objective 2: Investigate Profitability
--- Most Profitable Categories
SELECT 
    items.category_name AS Category,
    AVG(ROUND(sales.unit_selling_price_kg - wholesale_price.wholesale_price_kg, 0)) AS AVG_PROFIT
FROM 
    sales
JOIN 
    items ON sales.item_code = items.item_code
JOIN 
    wholesale_price ON sales.item_code = wholesale_price.item_code
GROUP BY 
    items.category_name
ORDER BY 
    AVG_PROFIT DESC;
---Products with the highest loss rates
SELECT items.item_name AS PRODUCTS,ROUND(sum(loss_rate.loss_rate_percent),2) AS PERCENT_LOSS
FROM items
JOIN loss_rate
ON items.item_code = loss_rate.item_code
GROUP BY PRODUCTS
ORDER BY PERCENT_LOSS DESC
LIMIT 10;

---Objective 3: Examine Sales Trends and Customer Behavior
---Seasonal Trends in Sales
---Extract month and year from date
SELECT
  date_part('year', date) AS year,
  date_part('month', date) AS month,
  date_trunc('month', date) AS month_start
FROM
  sales
LIMIT 10;

---Agregate sales by month
SELECT
  date_part('year', date) AS year,
  date_part('month', date) AS month,
  sum(itemsales) AS total_sales
FROM
  sales
GROUP BY
  year, month
ORDER BY
  year, month;

-- Top 5 months  with the highest sales
SELECT
  year,
  month,
  total_sales
FROM (
  SELECT
    date_part('year', date) AS year,
    date_part('month', date) AS month,
    SUM(itemsales) AS total_sales
  FROM
    sales
  GROUP BY
    year, month
) AS monthly_sales
ORDER BY
  total_sales DESC
LIMIT 5;

-- Top 5 month with the lowest sales
SELECT
  year,
  month,
  total_sales
FROM (
  SELECT
    date_part('year', date) AS year,
    date_part('month', date) AS month,
    SUM(itemsales) AS total_sales
  FROM
    sales
  GROUP BY
    year, month
) AS monthly_sales
ORDER BY
  total_sales
LIMIT 5;
---Number of products returns by category
select COUNT(sales.sale_or_return) AS Number_Returns,items.category_name AS Category
from sales
JOIN items
ON sales.item_code = items.item_code
WHERE sale_or_return = 'return'
GROUP BY Category
ORDER BY Number_Returns DESC ;

---Objective 4: Understand Pricing and Margins
---TOP 10 Most expensive products based on average selling price across Products and their wholesale prices
SELECT ROUND(AVG(wholesale_price.wholesale_price_kg),2) AS AVG_Wholesale_price,ROUND(AVG(sales.unit_selling_price_kg),2)AS AVG_Selling_Price,items.item_name AS Products
FROM sales
JOIN wholesale_price
ON sales.item_code = wholesale_price.item_code
JOIN items
ON sales.item_code = items.item_code
GROUP BY Products
ORDER BY AVG_Selling_Price DESC
LIMIT 10;
---Wholesale prices across categories
SELECT ROUND(AVG(wholesale_price.wholesale_price_kg),2) AS AVG_Wholesale_Price,items.category_name AS Category
FROM wholesale_price
JOIN items
ON wholesale_price.item_code = items.item_code
GROUP BY Category
ORDER BY AVG_Wholesale_Price DESC;
---Average Selling price Across Categories
SELECT ROUND(AVG(sales.unit_selling_price_kg),2) AS AVG_Selling_Price,items.category_name AS Category
FROM sales
JOIN items
ON sales.item_code = items.item_code
GROUP BY Category
ORDER BY AVG_Selling_Price DESC;






