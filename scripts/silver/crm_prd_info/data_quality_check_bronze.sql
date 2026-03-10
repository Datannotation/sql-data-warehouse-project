-- Quality Checks
-- Check for Nulls or Duplicates in Primary Key
-- Expectation: No Result
SELECT prd_id, COUNT(*)
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL

-- Check for unwanted spaces
-- Expectation: No Result
select prd_nm
from bronze.crm_prd_info
where prd_nm!=trim(prd_nm)

-- Check for null or negative values for cost
-- Expectation: No Result
select prd_cost
from bronze.crm_prd_info
where prd_cost<0 OR prd_cost IS NULL

-- Data Standardization and Consistency
SELECT DISTINCT prd_line
FROM bronze.crm_prd_info

-- check for invalid date orders
SELECT * FROM bronze.crm_prd_info
WHERE (prd_end_dt<prd_start_dt OR prd_start_dt IS NULL OR prd_end_dt IS NULL)
AND prd_nm LIKE 'Sport-100 Helmet-%'

-- fix for the date anomalies
SELECT 
	prd_id,
	prd_key,
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt,
	LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)-1 AS prd_end_dt_test
FROM bronze.crm_prd_info
WHERE prd_key IN ('AC-HE-HL-U509-R','AC-HE-HL-U509','AC-HE-HL-U509-B')
