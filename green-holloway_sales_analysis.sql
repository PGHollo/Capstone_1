USE sample_sales;

/* What is total revenue overall for sales in the assigned territory, plus the start date and end date
that tell you what period the data covers?*/

SELECT
    m.Region,
    ROUND(SUM(ss.Sale_Amount), 2) AS total_revenue,
    MIN(ss.Transaction_Date) AS start_date,
    MAX(ss.Transaction_Date) AS end_date
FROM Store_Sales ss
JOIN Store_Locations sl
    ON ss.Store_ID = sl.StoreId
JOIN Management m
    ON sl.State = m.State
WHERE m.Region = 'East'
GROUP BY m.Region;

-- What is the month by month revenue breakdown for the sales territory?

SELECT
    DATE_FORMAT(ss.Transaction_Date, '%Y-%m') AS sales_month,
    ROUND(SUM(ss.Sale_Amount), 2) AS monthly_revenue
FROM Store_Sales ss
JOIN Store_Locations sl
    ON ss.Store_ID = sl.StoreId
JOIN Management m
    ON sl.State = m.State
WHERE m.Region = 'East'
GROUP BY DATE_FORMAT(ss.Transaction_Date, '%Y-%m')
ORDER BY sales_month;

-- Provide a comparison of total revenue for the specific sales territory and the region it belongs to.

SELECT
    m.Region AS sales_territory,
    ROUND(SUM(ss.Sale_Amount), 2) AS territory_revenue,
    ROUND((
        SELECT SUM(ss2.Sale_Amount)
        FROM Store_Sales ss2
        JOIN Store_Locations sl2
            ON ss2.Store_ID = sl2.StoreId
        JOIN Management m2
            ON sl2.State = m2.State
        WHERE m2.Region = 'East'
    ), 2) AS region_revenue
FROM Store_Sales ss
JOIN Store_Locations sl
    ON ss.Store_ID = sl.StoreId
JOIN Management m
    ON sl.State = m.State
WHERE m.Region = 'East'
GROUP BY m.Region;

-- What is the number of transactions per month and average transaction size by product category for the sales territory?

SELECT
    DATE_FORMAT(ss.Transaction_Date, '%Y-%m') AS sales_month,
    ic.Category AS product_category,
    COUNT(*) AS number_of_transactions,
    ROUND(AVG(ss.Sale_Amount), 2) AS average_transaction_size
FROM Store_Sales ss
JOIN Store_Locations sl
    ON ss.Store_ID = sl.StoreId
JOIN Management m
    ON sl.State = m.State
JOIN Products p
    ON ss.Prod_Num = p.ProdNum
JOIN Inventory_Categories ic
    ON p.Categoryid = ic.Categoryid
WHERE m.Region = 'East'
GROUP BY
    DATE_FORMAT(ss.Transaction_Date, '%Y-%m'),
    ic.Category
ORDER BY
    sales_month,
    product_category;
    
    -- provide a ranking of in-store sales performance by each store in the sales territory, or a ranking of online sales performance by state within an online sales territory?
    
  SELECT
    sl.StoreId,
    sl.StoreLocation,
    sl.State,
    m.Region,
    ROUND(SUM(ss.Sale_Amount), 2) AS total_revenue,
    COUNT(*) AS number_of_transactions,
    RANK() OVER (
        ORDER BY SUM(ss.Sale_Amount) DESC
    ) AS sales_rank
FROM Store_Sales ss
JOIN Store_Locations sl
    ON ss.Store_ID = sl.StoreId
JOIN Management m
    ON sl.State = m.State
WHERE m.Region = 'East'
GROUP BY
    sl.StoreId,
    sl.StoreLocation,
    sl.State,
    m.Region
ORDER BY sales_rank;

/* I recommend focusing next quarter on the Northeast stores that are already bringing in the most revenue. These stores are showing strong customer demand, so giving them more inventory, promotions, and sales support could help increase sales even more.
I would also review the lower-performing stores to see what they are missing, such as better product selection, local advertising, or staff support. 
This way, the sales team can grow what is already working while improving weaker areas.*/

    