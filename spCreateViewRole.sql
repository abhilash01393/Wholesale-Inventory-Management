--This stored procedure lets the sytem create a user
-- with only SELECT permission on all the 
--tables of the database and add the created user 
--as a member to db_datareader

USE WholesaleInventory;
GO

IF (OBJECT_ID('spCreateViewRole') IS NOT NULL)
  DROP PROCEDURE spCreateViewRole
GO

CREATE PROC spCreateViewRole
		@AdminName varchar(128)

AS

DECLARE @DynamicSQL varchar(256),
        @TableName varchar(128)
		

SET @DynamicSQL = 'CREATE ROLE ' + @AdminName + ' ;'
EXEC(@DynamicSQL);
DECLARE Table_Cursor CURSOR
DYNAMIC
FOR
  SELECT DISTINCT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME NOT IN ('sysdiagrams');

OPEN Table_Cursor;
FETCH NEXT FROM Table_Cursor
  INTO @TableName;
WHILE @@FETCH_STATUS = 0
  BEGIN
    
    SET @DynamicSQL = 'GRANT SELECT
  ON ' + @TableName + ' TO ' + @AdminName + ';'
  FETCH NEXT FROM Table_Cursor
      INTO @TableName;

	EXEC(@DynamicSQL);;
  END;
CLOSE Table_Cursor;

DEALLOCATE Table_Cursor;

SET @DynamicSQL = 'ALTER ROLE db_datareader ADD MEMBER ' + @AdminName + ' ;'
EXEC(@DynamicSQL)

BEGIN TRY
	DECLARE @Role VARCHAR(50)	
	SET @Role = 'Promo'
	EXEC spCreateViewRole @Role;
END TRY
BEGIN CATCH
	PRINT 'Error Number:  ' + CONVERT(varchar(100), ERROR_NUMBER());
	PRINT 'Error Message: ' + CONVERT(varchar(100), ERROR_MESSAGE());
END CATCH;