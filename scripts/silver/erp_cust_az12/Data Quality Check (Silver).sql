-- Quality Checks
-- Check for unwanted spaces
-- Expectation: No Result
SELECT * FROM silver.erp_cust_az12
WHERE cid!=TRIM(cid) OR gen!=TRIM(gen)

--	Check for out of range dates
-- Expectation: No Result
SELECT bdate FROM silver.erp_cust_az12
WHERE bdate<'1926-01-01' OR bdate>'2011-01-01'

-- Data Standardization and Consistency
SELECT DISTINCT gen FROM
silver.erp_cust_az12

SELECT * FROM
silver.erp_cust_az12