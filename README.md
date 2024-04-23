# Supermarket Sales Data Analysis Using PostgreSQL

This portfolio project demonstrates the use of SQL to analyze supermarket sales data and gain insights into sales performance, profitability, sales trends, customer behavior, and pricing. The analysis covers a range of objectives, and SQL queries are provided to address each objective.

## Table of Contents

1. [Project Description](#project-description)
2. [Data Source](#data-source)
3. [Objectives](#objectives)
   - [Objective 1: Analyze Sales Performance](#objective-1-analyze-sales-performance)
   - [Objective 2: Investigate Profitability](#objective-2-investigate-profitability)
   - [Objective 3: Examine Sales Trends and Customer Behavior](#objective-3-examine-sales-trends-and-customer-behavior)
   - [Objective 4: Understand Pricing and Margins](#objective-4-understand-pricing-and-margins)
4. [Analysis Highlights](#analysis)
5. [Conclusion](#conclusion)
6. [Recommendation](#recommendations)

## Project Description

This project explores a supermarket sales dataset using PostgreSQL to extract insights related to sales trends, profitability, customer behavior, and pricing. The dataset includes information about purchases, item codes, wholesale prices, item names, category codes, quantities, selling prices, sales or returns, discounts, sales revenue, and loss rates.

## Data Source

The database used for this project has the following tables with the following columns:
### sales
- **Date:** The date of purchase
- **Item_Code:** Codes representing products sold
- **quantity_sold_kg:** The quantity sold in kilograms
- **unit_selling_price_kg:** The product's selling price per kilogram
- **sale_or_return:** Indicates whether the product was sold or returned
- **discount:** Indicates if there was a discount (Yes/No)
- **itemsales:** Calculated as Quantity multiplied by Selling price
### wholesale_price
- **Date:** The date of purchase
- **Item_Code:** Codes representing products sold
- **wholesale_price_kg:** The wholesale price of products per kilogram
### items
- **Item_Code:** Codes representing products sold
- **Item_Names:** The names of the products
- **Category_Codes:** The categories for the products
- **Category_name:** Product categories names
### loss_rate
- **Item_Code:** Codes representing products sold
- **Item_Names:** The names of the products
- **Loss_Rate:** The loss rate percent of each product
  
Download the dataset [here](https://www.kaggle.com/datasets/yapwh1208/supermarket-sales-data)

## Objectives

### Objective 1: Analyze Sales Performance

#### Total Sales by Category
```sql
SELECT ROUND(SUM(sales.itemsales), 0) AS Total_Sales, items.category_name AS Categories
FROM sales
JOIN items ON sales.item_code = items.item_code
GROUP BY Categories
ORDER BY Total_Sales DESC;
```

#### Best Performing Products by Sales
```sql
SELECT ROUND(SUM(sales.itemsales), 0) AS Total_Sales, items.item_name AS Products
FROM sales
JOIN items ON sales.item_code = items.item_code
GROUP BY Products
ORDER BY Total_Sales DESC
LIMIT 10;
```

#### Worst Performing Products by Sales
```sql
SELECT ROUND(SUM(sales.itemsales), 0) AS Total_Sales, items.item_name AS Products
FROM sales
JOIN items ON sales.item_code = items.item_code
GROUP BY Products
ORDER BY Total_Sales ASC
LIMIT 10;
```

#### Top Selling Products by Quantity
```sql
SELECT ROUND(SUM(sales.quantity_sold_kg), 0) AS Total_Sales, items.item_name AS Products
FROM sales
JOIN items ON sales.item_code = items.item_code
GROUP BY Products
ORDER BY Total_Sales DESC
LIMIT 10;
```

#### Effect of Discount on Sales
```sql
SELECT ROUND(SUM(sales.itemsales), 0) AS Total_Sales, items.item_name AS Products
FROM sales
JOIN items ON sales.item_code = items.item_code
WHERE discount = 'Yes'
GROUP BY Products
ORDER BY Total_Sales DESC
LIMIT 10;
```

### Objective 2: Investigate Profitability

#### Most Profitable Categories
```sql
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
```

#### Products with the Highest Loss Rates
```sql
SELECT items.item_name AS PRODUCTS, ROUND(SUM(loss_rate.loss_rate_percent), 2) AS PERCENT_LOSS
FROM items
JOIN loss_rate ON items.item_code = loss_rate.item_code
GROUP BY PRODUCTS
ORDER BY PERCENT_LOSS DESC
LIMIT 10;
```

### Objective 3: Examine Sales Trends and Customer Behavior

#### Seasonal Trends in Sales
```sql
SELECT
  date_part('year', date) AS year,
  date_part('month', date) AS month,
  date_trunc('month', date) AS month_start
FROM
  sales
LIMIT 10;
```

#### Aggregate Sales by Month
```sql
SELECT
  date_part('year', date) AS year,
  date_part('month', date) AS month,
  SUM(itemsales) AS total_sales
FROM
  sales
GROUP BY
  year, month
ORDER BY
  year, month;
```

#### Top 5 Months with the Highest Sales
```sql
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
```

### Objective 4: Understand Pricing and Margins

#### TOP 10 Most Expensive Products Based on Average Selling Price
```sql
SELECT ROUND(AVG(wholesale_price.wholesale_price_kg), 2) AS AVG_Wholesale_Price,
      ROUND(AVG(sales.unit_selling_price_kg), 2) AS AVG_Selling_Price,
      items.item_name AS Products
FROM 
  sales
JOIN 
  wholesale_price 
  ON sales.item_code = wholesale_price.item_code
JOIN 
  items 
  ON sales.item_code = items.item_code
GROUP BY 
  Products
ORDER BY 
  AVG_Selling_Price DESC
LIMIT 10;
```

#### Wholesale Prices Across Categories
```sql
SELECT ROUND(AVG(wholesale_price.wholesale_price_kg), 2) AS AVG_Wholesale_Price,
      items.category_name AS Category
FROM 
  wholesale_price
JOIN 
  items 
  ON wholesale_price.item_code = items.item_code
GROUP BY 
  Category
ORDER BY 
  AVG_Wholesale_Price DESC;
```
## Analysis

The analysis of supermarket sales data reveals the following key insights:

- **Top 3 Best-Selling Product Categories**: The leading product categories by sales volume are:
  - **Flower/Leaf Vegetables** with a total revenue of $1,079,070.
  - **Capsicum** with a total revenue of $754,133.
  - **Edible Mushroom** with a total revenue of $619,598.

- **Best-Selling Products**: The top-selling individual products include:
  - **Broccoli**, leading the list with $269,881 in sales.
  - **Net Lotus Root**, achieving sales of $211,652.
  - **Xixia Mushroom**, with a total revenue of $211,198.
  - **Wuhu Green Pepper**, generating $205,114 in sales.

- **Impact of Discounts**: Discounts play a significant role in sales. The following products showed notable sales boost due to discount promotions:
  - **Xixia Mushroom**
  - **Net Lotus Root**
  - **Broccoli**
  - **Yunnan Lettuce (Bag)**

- **Most Profitable Product Categories**: The most profitable product categories based on average profit margins are:
  - **Edible Mushrooms**
  - **Capsicum**
  - **Cabbage**

- **Least Profitable Product Category**: Despite being the best-selling category, **Flower/Leaf Vegetables** has the lowest profitability, likely due to high rates of product returns.

- **Product Returns and Loss**: The category with the highest number of product returns is **Flower/Leaf Vegetables**. This could be contributing to its lower profitability. The products with the highest percentage loss rates are:
  - **Chinese Cabbage**
  - **High Melon**
  - **Chuncai**

- **Seasonal Sales Trends**: The months with the highest sales activity are:
  - **January**
  - **February**
  - **August**
  - **October**

## Conclusion

The analysis of supermarket sales data using PostgreSQL reveals critical insights into sales performance, profitability, customer behavior, and seasonal trends. The key findings from this analysis indicate that Flower/Leaf Vegetables is the best-selling product category, while Edible Mushrooms and Capsicum are among the most profitable categories. However, high product returns and loss rates in certain categories, such as Flower/Leaf Vegetables, highlight potential issues with inventory management or quality control.

Discounts have proven to be effective in boosting sales for certain products like Xixia Mushroom, Net Lotus Root, and Broccoli. Moreover, the data shows distinct seasonal trends, with the peak sales occurring in January, February, August, and October and lows in April, May, and June. Identifying these trends provides opportunities for supermarkets to tailor their inventory and promotional strategies to maximize sales and profits.

## Recommendations

Based on the analysis results, the following recommendations are made:

1. **Optimize Inventory Management**: Given the high number of product returns in the Flower/Leaf Vegetables category, supermarkets should review their inventory and quality control processes. Implementing stricter quality checks and improving storage conditions could reduce the rate of returns and associated losses.

2. **Leverage Discount Strategies**: The significant impact of discounts on sales suggests that targeted discount promotions can be an effective tool to increase sales. Supermarkets should consider using data-driven insights to determine which products and time periods are best suited for discount campaigns.

3. **Focus on Profitable Categories**: Given the profitability of Edible Mushrooms and Capsicum, supermarkets should allocate resources and marketing efforts towards these categories to enhance overall profitability. This could include promoting these categories in store displays or offering bundled products.

4. **Address High Loss Rates**: The products with the highest loss rates, such as Chinese Cabbage and High Melon, require further investigation. Supermarkets should analyze why these products have high loss rates and take corrective actions, which may include changing suppliers, improving storage, or modifying pricing strategies.

5. **Plan for Seasonal Trends**: Since peak sales occur in specific months, supermarkets should plan inventory and staffing accordingly. Supermarkets can maximize their revenue by aligning marketing campaigns with these peak periods.

