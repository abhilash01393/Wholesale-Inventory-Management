--This stored procedure lets the sytem create a user
-- with INSERT and UPDATE permissions on all the 
--tables of the database and add the created user 
--as a member to db_datareader

USE WholesaleInventory;
GO

IF (OBJECT_ID('spCreateAdmin') IS NOT NULL)
  DROP PROCEDURE spCreateAdmin
GO

CREATE PROC spCreateAdmin
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
    
    SET @DynamicSQL = 'GRANT INSERT, UPDATE
  ON ' + @TableName + ' TO ' + @AdminName + ';'
  FETCH NEXT FROM Table_Cursor
      INTO @TableName;

	EXEC(@DynamicSQL);

  END;
CLOSE Table_Cursor;

DEALLOCATE Table_Cursor;

SET @DynamicSQL = 'ALTER ROLE db_datareader ADD MEMBER ' + @AdminName + ' ;'
EXEC(@DynamicSQL)

BEGIN TRY
	DECLARE @Name VARCHAR(50)	
	SET @Name = 'Heads'
	EXEC spCreateAdmin @Name;
END TRY
BEGIN CATCH
	PRINT 'Error Number:  ' + CONVERT(varchar(100), ERROR_NUMBER());
	PRINT 'Error Message: ' + CONVERT(varchar(100), ERROR_MESSAGE());
END CATCH;