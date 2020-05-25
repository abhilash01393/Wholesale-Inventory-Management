USE WholesaleInventory;
GO

IF (OBJECT_ID('spAddAdmin') IS NOT NULL)
  DROP PROCEDURE spAddAdmin
GO

CREATE PROC spAddAdmin
		@AdminName varchar(128),
		@TempPassword varchar(25) = 'Test@123'

AS

DECLARE @DynamicSQL varchar(256)
SET @DynamicSQL = 'CREATE LOGIN ' + @AdminName + ' ' +
                      'WITH PASSWORD = ''' + @TempPassword + ''', ' +
                      'DEFAULT_DATABASE = WholesaleInventory';


EXEC (@DynamicSQL);
SET @DynamicSQL = 'CREATE USER ' + @AdminName + ' ' +
                      'FOR LOGIN ' + @AdminName;
EXEC (@DynamicSQL);
SET @DynamicSQL = 'ALTER ROLE Admin ADD MEMBER ' +
                     @AdminName;
EXEC (@DynamicSQL);

BEGIN TRY
	DECLARE @Name VARCHAR(50)	
	SET @Name = 'Benjin'
	EXEC spAddViewRole @Name;
END TRY
BEGIN CATCH
	PRINT 'Error Number:  ' + CONVERT(varchar(100), ERROR_NUMBER());
	PRINT 'Error Message: ' + CONVERT(varchar(100), ERROR_MESSAGE());
END CATCH;
