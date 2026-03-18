-- Quality Checks
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