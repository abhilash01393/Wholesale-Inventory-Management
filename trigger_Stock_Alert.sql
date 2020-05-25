--This trigger is for low stock alert. 
--After the last sale for which the stock 
--count goes below 5, the alert will be 
--raised reminding to purchase the product.
USE WholesaleInventory;
GO
IF (OBJECT_ID('Stock_ALERT') IS NOT NULL)
	DROP TRIGGER Stock_ALERT

GO

CREATE TRIGGER Stock_ALERT 
 ON STOCK 
AFTER UPDATE
AS

BEGIN TRY
DECLARE @quantity INT;
DECLARE @product INT;


SELECT @quantity = STOCK_QUANTITY FROM inserted;
SELECT @product  = STOCK_ID FROM inserted;

IF @quantity < 5
THROW 50001, 'Stock is too low to buy. Need to purchase more product.', 1;

END TRY
BEGIN CATCH
IF @@TRANCOUNT>0
ROLLBACK;
THROW;
END CATCH;

EXEC sp_helptrigger 'STOCK';


SELECT [STOCK_ID],[STOCK_NAME],[STOCK_QUANTITY],[PER_ITEM_PRICE],[UPDATED_ON]
  FROM [WholesaleInventory].[dbo].[STOCK] where STOCK_ID = 12;

INSERT INTO ORDER_ITEMS (ORDER_ITEM_ID, ORDER_ID, STOCK_ID, PER_ITEM_PRICE, QUANTITY, TOTAL_PRICE, UPDATED_ON)
 VALUES (2,	500,	12,	90,	290,	90,	GETDATE());











DELETe FROM ORDER_ITEMS where ORDER_ID = 500 and ORDER_ITEM_ID = 2;

