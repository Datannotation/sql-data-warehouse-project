-- Quality Checks
-- Check for Nulls or Duplicates in Primary Key
-- Expectation: No Result
SELECT prd_id, COUNT(*)
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL

-- Check for unwanted spaces
-- Expectation: No Result
select prd_nm
from silver.crm_prd_info
where prd_nm!=trim(prd_nm)

-- Check for null or negative values for cost
-- Expectation: No Result
select prd_cost
from silver.crm_prd_info
where prd_cost<0 OR prd_cost IS NULL

-- Data Standardization and Consistency
SELECT DISTINCT prd_line
FROM silver.crm_prd_info

-- check for invalid date orders
SELECT * FROM silver.crm_prd_info
WHERE (prd_end_dt<prd_start_dt)
AND prd_nm LIKE 'Sport-100 Helmet-%'

SELECT * FROM silver.crm_prd_info
