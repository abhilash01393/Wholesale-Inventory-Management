USE WholesaleInventory;
GO

IF (OBJECT_ID('spAddViewRole') IS NOT NULL)
  DROP PROCEDURE spAddViewRole
GO

CREATE PROC spAddViewRole
		@ViewerName varchar(128),
		@TempPassword varchar(25) = 'Test@123'

AS

DECLARE @DynamicSQL varchar(256)
SET @DynamicSQL = 'CREATE LOGIN ' + @ViewerName + ' ' +
                      'WITH PASSWORD = ''' + @TempPassword + ''', ' +
                      'DEFAULT_DATABASE = WholesaleInventory';


EXEC (@DynamicSQL);
SET @DynamicSQL = 'CREATE USER ' + @ViewerName + ' ' +
                      'FOR LOGIN ' + @ViewerName;
EXEC (@DynamicSQL);
SET @DynamicSQL = 'ALTER ROLE Associates ADD MEMBER ' +
                     @ViewerName;
EXEC (@DynamicSQL);

BEGIN TRY
	DECLARE @Name VARCHAR(50)	
	SET @Name = 'Barbara'
	EXEC spAddViewRole @Name;
END TRY
BEGIN CATCH
	PRINT 'Error Number:  ' + CONVERT(varchar(100), ERROR_NUMBER());
	PRINT 'Error Message: ' + CONVERT(varchar(100), ERROR_MESSAGE());
END CATCH;