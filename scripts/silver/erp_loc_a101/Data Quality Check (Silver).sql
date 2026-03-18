-- Quality Checks
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