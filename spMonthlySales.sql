--The stored procedure will produce monthly 
--logistics for Sale/Purchase between a set of dates.
-- The Sale/Purchase is optional parameter passed. The user can 
--have either Sale or Purchase statistics or even both.
USE WholesaleInventory;
GO

IF (OBJECT_ID('spMonthlySales') IS NOT NULL)
  DROP PROCEDURE spMonthlySales
GO

CREATE PROC spMonthlySales
       @DateMin varchar(50),
       @DateMax varchar(50),
	   @SaleOrPurchase INT = NULL
AS

IF @DateMin IS NULL OR @DateMax IS NULL
	THROW 50001, 'Missing Minimum and Maximum Date', 1;
IF NOT (ISDATE(@DateMin) = 1 AND ISDATE(@DateMax) = 1)
	THROW 50002, 'Invalid date format.', 1;
IF CAST(@DateMin AS datetime) > CAST(@DateMax AS datetime)
	THROW 50003, 'The minimum date should come before maximum date', 1;

IF @SaleOrPurchase IS NOT NULL

SELECT 
	CASE SALE_OR_PURCHASE
		WHEN 1 THEN 'SALE' 
		WHEN 2 THEN 'PURCHASE' 
		ELSE 'UNKNOWN VALUE' 
		END AS ORDERS,
	YEAR(ORDER_DATE) AS YEAR,
	CASE MONTH(ORDER_DATE)
		WHEN 1 THEN 'January'
		WHEN 2 THEN 'February'
		WHEN 3 THEN 'March'
		WHEN 4 THEN 'April'
		WHEN 5 THEN 'May'
		WHEN 6 THEN 'June'
		WHEN 7 THEN 'July'
		WHEN 8 THEN 'August'
		WHEN 9 THEN 'September'
		WHEN 10 THEN 'October'
		WHEN 11 THEN 'November'
		WHEN 12 THEN 'December'
		END AS MONTH,
	SUM(TOTAL_AMOUNT) AS TOTAL 
FROM ORDERS 
WHERE ORDER_DATE > @DateMin AND ORDER_DATE < @DateMax AND SALE_OR_PURCHASE = @SaleOrPurchase
GROUP BY SALE_OR_PURCHASE, YEAR(ORDER_DATE), MONTH(ORDER_DATE)
ORDER BY YEAR, MONTH(ORDER_DATE);

IF @SaleOrPurchase IS NULL

SELECT 
	CASE SALE_OR_PURCHASE
		WHEN 1 THEN 'SALE' 
		WHEN 2 THEN 'PURCHASE' 
		ELSE 'UNKNOWN VALUE' 
		END AS ORDERS,
	YEAR(ORDER_DATE) AS YEAR,
	CASE MONTH(ORDER_DATE)
		WHEN 1 THEN 'January'
		WHEN 2 THEN 'February'
		WHEN 3 THEN 'March'
		WHEN 4 THEN 'April'
		WHEN 5 THEN 'May'
		WHEN 6 THEN 'June'
		WHEN 7 THEN 'July'
		WHEN 8 THEN 'August'
		WHEN 9 THEN 'September'
		WHEN 10 THEN 'October'
		WHEN 11 THEN 'November'
		WHEN 12 THEN 'December'
		END AS MONTH,
	SUM(TOTAL_AMOUNT) AS TOTAL 
FROM ORDERS 
WHERE ORDER_DATE > @DateMin AND ORDER_DATE < @DateMax
GROUP BY SALE_OR_PURCHASE, YEAR(ORDER_DATE), MONTH(ORDER_DATE)
ORDER BY YEAR, MONTH(ORDER_DATE);

BEGIN TRY
	DECLARE @InitDate DATE
	DECLARE @FinalDate DATE
	SET @InitDate = '2013-12-10'
	SET @FinalDate = '2015-12-20'
	EXEC spMonthlySales @InitDate, @FinalDate;
END TRY
BEGIN CATCH
	PRINT 'Error Number:  ' + CONVERT(varchar(100), ERROR_NUMBER());
	PRINT 'Error Message: ' + CONVERT(varchar(100), ERROR_MESSAGE());
END CATCH;
