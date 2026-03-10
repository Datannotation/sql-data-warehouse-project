-- Quality Checks
-- Check for Nulls or Duplicates in Primary Key
-- Expectation: No Result
SELECT cst_id, COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL

-- Check for unwanted spaces
-- Expectation: No Result
select cst_firstname
from silver.crm_cust_info
where cst_firstname!=trim(cst_firstname)

-- Data Standardization and Consistency
SELECT DISTINCT cst_gndr
FROM silver.crm_cust_info

SELECT * FROM silver.crm_cust_info
