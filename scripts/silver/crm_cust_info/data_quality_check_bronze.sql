-- Quality Checks
-- Check for Nulls or Duplicates in Primary Key
-- Expectation: No Result
SELECT cst_id, COUNT(*)
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL

-- Check for unwanted spaces
-- Expectation: No Result
select cst_lastname
from bronze.crm_cust_info
where cst_lastname!=trim(cst_lastname)

-- Data Standardization and Consistency
SELECT DISTINCT cst_marital_status
FROM bronze.crm_cust_info
