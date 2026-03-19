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
    -  Run these checks to find out data discrepancies and anomalies in silver layer and resolve them
*/

/*
**************************************************************************************
Checking for silver.crm_cust_info
**************************************************************************************
*/
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

/*
**************************************************************************************
Checking for silver.crm_prd_info
**************************************************************************************
*/  
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

/*
**************************************************************************************
Checking for silver.crm_sales_details
**************************************************************************************
*/  
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

/*
**************************************************************************************
Checking for silver.erp_cust_az12
**************************************************************************************
*/    
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

/*
**************************************************************************************
Checking for silver.erp_loc_a101
**************************************************************************************
*/    
-- Check for unwanted spaces
-- Expectation: No Result
SELECT * FROM silver.erp_loc_a101
WHERE cid!=TRIM(cid) OR cntry!=TRIM(cntry)

-- Data Standardization and Consistency
-- Expectation: No difference b/w old and new country
SELECT DISTINCT cntry AS old_cntry,
CASE WHEN TRIM(cntry)='DE' THEN 'Germany'
		 WHEN TRIM(cntry) IN ('US','USA') THEN 'United States'
		 WHEN TRIM(cntry)='' OR TRIM(cntry) IS NULL THEN 'n\a'
		 ELSE TRIM(cntry)
	END AS new_cntry
FROM silver.erp_loc_a101
ORDER BY old_cntry

SELECT * FROM
silver.erp_loc_a101

/*
**************************************************************************************
Checking for silver.erp_px_cat_g1v2
**************************************************************************************
*/    
-- Check for unwanted spaces
-- Expectation: No Result
SELECT * FROM silver.erp_px_cat_g1v2
WHERE cat!=TRIM(cat) OR subcat!=TRIM(subcat) OR maintenance!=TRIM(maintenance)

-- Data Standardization and Consistency
SELECT DISTINCT maintenance
FROM silver.erp_px_cat_g1v2

SELECT DISTINCT cat
FROM silver.erp_px_cat_g1v2

SELECT DISTINCT subcat
FROM silver.erp_px_cat_g1v2

SELECT *
FROM silver.erp_px_cat_g1v2
