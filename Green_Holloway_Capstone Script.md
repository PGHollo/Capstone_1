East Region Sales Analysis Presentation Script



For this project, I analyzed sales performance for the East region using SQL and Excel. My goal was to answer key business questions about revenue, monthly trends, product category performance, store rankings, and where the sales team should focus next quarter.



The main tables I used were:



* Store\_Sales for sales amounts, dates, and transactions
* Store\_Locations to connect sales to store locations and states
* Management to connect each state to the East region



The main idea was to connect the data step by step so each sale could be tied back to the correct region.



Question 1: Total Revenue and Date Range



For the first question, I wanted to find the total revenue for the East region and the time period the data covers.



I started with the Store\_Sales table because it has the sale amount and transaction date. Then I joined it to Store\_Locations and Management so I could filter the results to only the East region.



The query uses:



* SUM() to add up total revenue
* MIN() to find the first transaction date
* MAX() to find the last transaction date



This gives a quick summary of how much revenue the East region made and what dates are included in the dataset.



SELECT

&#x20;   m.Region,

&#x20;   ROUND(SUM(ss.Sale\_Amount), 2) AS total\_revenue,

&#x20;   MIN(ss.Transaction\_Date) AS start\_date,

&#x20;   MAX(ss.Transaction\_Date) AS end\_date

FROM Store\_Sales ss

JOIN Store\_Locations sl

&#x20;   ON ss.Store\_ID = sl.StoreId

JOIN Management m

&#x20;   ON sl.State = m.State

WHERE m.Region = 'EAST'

GROUP BY m.Region;



In simple terms, this query answers:

How much money did the East region make, and what time period does the data cover?



Question 2: Month-by-Month Revenue



For the second question, I looked at the monthly revenue breakdown for the East region.



This helps show whether revenue is increasing, decreasing, or staying steady over time.



The key part of this query is:



* DATE\_FORMAT(ss.Transaction\_Date, '%Y-%m')



That changes each transaction date into a month format, like 2022-01, so the sales can be grouped by month.



SELECT

&#x20;   DATE\_FORMAT(ss.Transaction\_Date, '%Y-%m') AS sales\_month,

&#x20;   ROUND(SUM(ss.Sale\_Amount), 2) AS monthly\_revenue

FROM Store\_Sales ss

JOIN Store\_Locations sl

&#x20;   ON ss.Store\_ID = sl.StoreId

JOIN Management m

&#x20;   ON sl.State = m.State

WHERE m.Region = 'EAST'

GROUP BY DATE\_FORMAT(ss.Transaction\_Date, '%Y-%m')

ORDER BY sales\_month;



In simple terms, this query answers:

How much revenue did the East region make each month?



Question 3: Revenue Comparison



For question three, I compared total revenue for the selected sales territory.



Since my selected territory is the East region, this query gives one total revenue number for that region.



SELECT

&#x20;   m.Region,

&#x20;   ROUND(SUM(ss.Sale\_Amount), 2) AS total\_revenue

FROM Store\_Sales ss

JOIN Store\_Locations sl

&#x20;   ON ss.Store\_ID = sl.StoreId

JOIN Management m

&#x20;   ON sl.State = m.State

WHERE m.Region = 'EAST'

GROUP BY m.Region;



This query keeps only East region sales, then adds them together.



In simple terms, this answers:

What is the total revenue for the East region compared to the region it belongs to?



Since the territory and region are both East in this case, the totals may match.



Question 4: Transactions and Average Sale by Product Category



For question four, I looked at the number of transactions per month and the average transaction size by product category.



This helps show which product categories are active and how much customers are spending on average.



The query uses:



* COUNT() to count transactions
* AVG() to find the average sale amount
* DATE\_FORMAT() to group the results by month



SELECT

&#x20;   DATE\_FORMAT(ss.Transaction\_Date, '%Y-%m') AS sales\_month,

&#x20;   ic.CategoryName AS product\_category,

&#x20;   COUNT(ss.Transaction\_ID) AS number\_of\_transactions,

&#x20;   ROUND(AVG(ss.Sale\_Amount), 2) AS average\_transaction\_size

FROM Store\_Sales ss

JOIN Store\_Locations sl

&#x20;   ON ss.Store\_ID = sl.StoreId

JOIN Management m

&#x20;   ON sl.State = m.State

JOIN Inventory\_Categories ic

&#x20;   ON ss.Product\_ID = ic.Product\_ID

WHERE m.Region = 'EAST'

GROUP BY

&#x20;   DATE\_FORMAT(ss.Transaction\_Date, '%Y-%m'),

&#x20;   ic.CategoryName

ORDER BY

&#x20;   sales\_month,

&#x20;   product\_category;



In simple terms, this query answers:

For each month, how many sales happened in each product category, and what was the average sale amount?



This is useful because a category may not always have the most transactions, but it could still have a high average sale amount.



Question 5: Store Sales Ranking



For question five, I ranked each store in the East region by total revenue.



This helps identify which stores are performing the best.



The query uses:



* SUM() to calculate revenue for each store
* COUNT() to count the number of transactions
* RANK() to rank stores from highest revenue to lowest revenue



SELECT

&#x20;   sl.StoreId,

&#x20;   sl.StoreLocation,

&#x20;   sl.State,

&#x20;   m.Region,

&#x20;   ROUND(SUM(ss.Sale\_Amount), 2) AS total\_revenue,

&#x20;   COUNT(\*) AS number\_of\_transactions,

&#x20;   RANK() OVER (

&#x20;       ORDER BY SUM(ss.Sale\_Amount) DESC

&#x20;   ) AS sales\_rank

FROM Store\_Sales ss

JOIN Store\_Locations sl

&#x20;   ON ss.Store\_ID = sl.StoreId

JOIN Management m

&#x20;   ON sl.State = m.State

WHERE m.Region = 'EAST'

GROUP BY

&#x20;   sl.StoreId,

&#x20;   sl.StoreLocation,

&#x20;   sl.State,

&#x20;   m.Region

ORDER BY sales\_rank;



In simple terms, this query answers:

Which East region stores are bringing in the most revenue?



Rank 1 is the strongest-performing store.



Question 6: Recommendation



Based on the East region analysis, my recommendation is to focus next quarter on the stores and product categories that are already generating the most revenue.



These areas show strong customer demand, so the company could support them with more inventory, promotions, and sales attention.



I would also review the lower-performing stores to see if they need better product selection, local marketing, or extra staff support.



So my recommendation is:



Build on what is already working, while improving the stores that are falling behind.



Excel PivotChart Portion



For the Excel part, I used PivotChart options to make the query results easier to understand visually.



Instead of showing every row of raw data, I rolled the data up in a cleaner way.



First, I created a Revenue by State chart. This gives a big-picture view of which East region states are producing the most revenue.



Then, I created a Top 10 Stores by Revenue chart. This zooms in and shows which individual stores are driving the strongest sales.



Together, the charts tell the story in two levels:



Revenue by State shows where sales are strongest overall.

Top 10 Stores shows which specific locations are creating that strength.



This design makes the analysis easier to explain because it starts broad, then gets more specific.



Closing Statement



Overall, SQL helped me pull and organize the East region sales data, while Excel helped me turn the results into visuals. The main takeaway is that the East region should focus on its strongest stores and product categories, while also using the data to improve lower-performing locations.



