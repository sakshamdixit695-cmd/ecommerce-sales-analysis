CREATE TABLE transactions (
    "Transaction_ID" TEXT,
    "User_Name" TEXT,
    "Age" INTEGER,
    "Country" TEXT,
    "Product_Category" TEXT,
    "Purchase_Amount" NUMERIC,
    "Payment_Method" TEXT,
    "Transaction_Date" DATE
);

select * from transactions;
##checking null values ###3
SELECT
    COUNT(*) FILTER (WHERE "Transaction_ID" IS NULL) AS missing_transaction_id,
    COUNT(*) FILTER (WHERE "User_Name" IS NULL) AS missing_user_name,
    COUNT(*) FILTER (WHERE "Purchase_Amount" IS NULL) AS missing_amount,
    COUNT(*) FILTER (WHERE "Transaction_Date" IS NULL) AS missing_date
FROM transactions;

## repeated occurrences###
SELECT "Transaction_ID", COUNT(*) AS occurrences
FROM transactions
GROUP BY "Transaction_ID"
HAVING COUNT(*) > 1;

SELECT
    COUNT(*) AS total_transactions,
    SUM("Purchase_Amount") AS total_revenue
FROM transactions;

##unique customers###
SELECT COUNT(DISTINCT "User_Name") AS unique_customers
FROM transactions;

select AVG("Purchase_Amount") as avg_order_value
from transactions;

SELECT
   "Country",
    COUNT(*) AS transactions,
    SUM("Purchase_Amount") AS revenue
FROM transactions
GROUP BY "Country"
ORDER BY revenue DESC;

SELECT
    purchase_count,
    COUNT(*) AS number_of_customers
FROM (
    SELECT
        "User_Name",
        COUNT(*) AS purchase_count
    FROM transactions
    GROUP BY "User_Name"
) t
GROUP BY purchase_count
ORDER BY purchase_count;

###percentage of repeated cutomer##
SELECT
    COUNT(*) FILTER (WHERE purchase_count > 1) * 100.0 / COUNT(*) AS repeat_customer_percentage
FROM (
    SELECT
        "User_Name",
        COUNT(*) AS purchase_count
    FROM transactions
    GROUP BY "User_Name"
) t;

SELECT
        "User_Name",
        COUNT(*) AS purchase_count
    FROM transactions
    GROUP BY "User_Name"
	order by purchase_count;

SELECT
    "User_Name",
    COUNT(*) AS total_orders_per_cust,
    SUM("Purchase_Amount") AS total_spent,
    AVG("Purchase_Amount") AS avg_order_value
FROM transactions
GROUP BY "User_Name"
ORDER BY total_spent DESC;
########Top 10 high-value customers###########

select "User_Name" , 
      SUM("Purchase_Amount") as total_spent
from transactions
group by "User_Name"
order by  total_spent  desc
limit 10 ;
##########pareto  ratio 80/20 ######

with revenue_cust as 
(select "User_Name", 
      SUM("Purchase_Amount") as total_spent
from transactions
group by "User_Name"
)
select * from 
(select *
, ntile(10) over (order by total_spent desc) as decile 
from revenue_cust
)

select "Transaction_Date" from transactions
ORDER BY "Transaction_Date" ;

SELECT
    DATE_TRUNC('month', "Transaction_Date") AS month
	from transactions;
SELECT
    DATE_TRUNC('month', "Transaction_Date") AS month,
    SUM("Purchase_Amount") AS total_revenue
FROM transactions
GROUP BY month
ORDER BY month;

SELECT
    DATE_TRUNC('month', "Transaction_Date") AS month,
    COUNT(*) AS total_transactions
FROM transactions
GROUP BY month
ORDER BY month;

SELECT
    DATE_TRUNC('month', "Transaction_Date") AS month,
    AVG("Purchase_Amount") AS avg_order_value
FROM transactions
GROUP BY month
ORDER BY month;


SELECT
    "Country",
    SUM("Purchase_Amount") AS total_revenue
FROM transactions
GROUP BY "Country"
ORDER BY total_revenue DESC;
## payemnt method used ###
SELECT
    "Payment_Method",
    COUNT(*) AS total_transactions
FROM transactions
GROUP BY "Payment_Method"
ORDER BY total_transactions DESC;

#### product category revenue distribution#####
SELECT
    "Product_Category",
    SUM("Purchase_Amount") AS total_revenue
FROM transactions
GROUP BY "Product_Category"
ORDER BY total_revenue DESC;

#####age wise spending ######
SELECT
    CASE
        WHEN "Age" BETWEEN 18 AND 25 THEN '18-25'
        WHEN "Age" BETWEEN 26 AND 35 THEN '26-35'
        WHEN "Age" BETWEEN 36 AND 45 THEN '36-45'
        WHEN "Age" BETWEEN 46 AND 55 THEN '46-55'
        ELSE '56+'
    END AS age_group,
    COUNT(*) AS total_transactions,
    SUM("Purchase_Amount") AS total_revenue
FROM transactions
GROUP BY age_group
ORDER BY total_revenue DESC;