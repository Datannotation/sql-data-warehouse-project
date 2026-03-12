-- Quality Checks
-- Check for unwanted spaces
-- Expectation: No Result
select sls_prd_key
from silver.crm_sales_details
where sls_prd_key!=trim(sls_prd_key)

-- Data Standardization and Consistency b/w Sales, Quantity and Price
-- >> Sales = Quantity * Price
-- >> Values must not be NULL, 0 or negative
-- >> Expectation: No Result
SELECT DISTINCT sls_sales,sls_quantity,sls_price
FROM silver.crm_sales_details
WHERE sls_sales!=sls_quantity*sls_price OR
sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL OR
sls_sales<=0 OR sls_quantity<=0 OR sls_price<=0
ORDER BY sls_sales,sls_quantity,sls_price

-- check for invalid date orders
SELECT * FROM
silver.crm_sales_details
WHERE sls_order_dt>sls_ship_dt OR sls_order_dt>sls_due_dt

SELECT * FROM silver.crm_sales_details