/*
**************************************************************************************
Quality Checks
**************************************************************************************
Script Purpose:
    This script performs various quality checks like:
    -  Nulls or Duplicates in Primary Key
    -  Unwanted spaces
    -  Data Standardization and Consistency
    -  Null or negative values for cost
    -  Data Standardization and Consistency b/w related fields
    -  Invalid date ranges and orders

Usage Notes:
    -  Run these checks to find out data discrepancies and anomalies in bronze layer
    -  Use the findings to transform and clean the data
*/

/*
**************************************************************************************
Checking for bronze.crm_cust_info
**************************************************************************************
*/
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

/*
**************************************************************************************
Checking for bronze.crm_prd_info
**************************************************************************************
*/
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

/*
**************************************************************************************
Checking for bronze.crm_sales_details
**************************************************************************************
*/
-- Check for unwanted spaces
-- Expectation: No Result
select sls_prd_key
from bronze.crm_sales_details
where sls_prd_key!=trim(sls_prd_key)

-- Data Standardization and Consistency b/w Sales, Quantity and Price
-- >> Sales = Quantity * Price
-- >> Values must not be NULL, 0 or negative
-- >> Expectation: No Result
SELECT DISTINCT sls_sales AS old_sales,sls_quantity,
CASE
	WHEN sls_sales IS NULL OR sls_sales<=0 OR sls_sales!=sls_quantity*ABS(sls_price)
	THEN sls_quantity*ABS(sls_price)
	ELSE sls_sales
END AS sls_sales,
sls_price AS old_price,
CASE
	WHEN sls_price IS NULL OR sls_price<=0
	THEN sls_sales/NULLIF(sls_quantity,0)
	ELSE sls_price
END AS sls_price
FROM bronze.crm_sales_details
WHERE sls_sales!=sls_quantity*sls_price OR
sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL OR
sls_sales<=0 OR sls_quantity<=0 OR sls_price<=0
ORDER BY sls_sales,sls_quantity,sls_price

-- date anomalies
SELECT NULLIF(sls_order_dt,0) sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt<=0
OR LEN(sls_order_dt)!=8
OR sls_order_dt>20500101
OR sls_order_dt<19000101

SELECT NULLIF(sls_ship_dt,0) sls_ship_dt
FROM bronze.crm_sales_details
WHERE sls_ship_dt<=0
OR LEN(sls_ship_dt)!=8
OR sls_ship_dt>20500101
OR sls_ship_dt<19000101

SELECT NULLIF(sls_due_dt,0) sls_due_dt
FROM bronze.crm_sales_details
WHERE sls_due_dt<=0
OR LEN(sls_due_dt)!=8
OR sls_due_dt>20500101
OR sls_due_dt<19000101

-- check for invalid date orders
SELECT * FROM
bronze.crm_sales_details
WHERE sls_order_dt>sls_ship_dt OR sls_order_dt>sls_due_dt

/*
**************************************************************************************
Checking for bronze.erp_cust_az12
**************************************************************************************
*/
-- Check for unwanted spaces
-- Expectation: No Result
SELECT * FROM bronze.erp_cust_az12
WHERE cid!=TRIM(cid) OR gen!=TRIM(gen)

--	Check for out of range dates
-- Expectation: No Result
SELECT bdate FROM bronze.erp_cust_az12
WHERE bdate<'1926-01-01' OR bdate>'2011-01-01'

-- Data Standardization and Consistency
SELECT DISTINCT gen FROM
bronze.erp_cust_az12

/*
**************************************************************************************
Checking for bronze.erp_loc_a101
**************************************************************************************
*/
-- Check for unwanted spaces
-- Expectation: No Result
SELECT * FROM bronze.erp_loc_a101
WHERE cid!=TRIM(cid) OR cntry!=TRIM(cntry)

-- Data Standardization and Consistency
-- Expectation: No difference b/w old and new country
SELECT DISTINCT cntry AS old_cntry,
CASE WHEN TRIM(cntry)='DE' THEN 'Germany'
		 WHEN TRIM(cntry) IN ('US','USA') THEN 'United States'
		 WHEN TRIM(cntry)='' OR TRIM(cntry) IS NULL THEN 'n\a'
		 ELSE TRIM(cntry)
	END AS new_cntry
FROM bronze.erp_loc_a101
ORDER BY old_cntry

/*
**************************************************************************************
Checking for bronze.erp_px_cat_g1v2
**************************************************************************************
*/
-- Check for unwanted spaces
-- Expectation: No Result
SELECT * FROM bronze.erp_px_cat_g1v2
WHERE cat!=TRIM(cat) OR subcat!=TRIM(subcat) OR maintenance!=TRIM(maintenance)

-- Data Standardization and Consistency
SELECT DISTINCT maintenance
FROM bronze.erp_px_cat_g1v2

SELECT DISTINCT cat
FROM bronze.erp_px_cat_g1v2

SELECT DISTINCT subcat
FROM bronze.erp_px_cat_g1v2
