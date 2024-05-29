---------------------------------------------------------------------------
-- Copyright (C) 2024 Crayon
---------------------------------------------------------------------------

DECLARE @productVersion NVARCHAR(128)
SELECT @productVersion = CONVERT(NVARCHAR(128), SERVERPROPERTY('ProductVersion'))
PRINT N'SQL Server product version: ' + @productVersion

DECLARE @serverLevel TINYINT
SET @serverLevel = CONVERT(TINYINT, SUBSTRING(@productVersion, 0, CHARINDEX('.' , @productVersion))) * 10
PRINT N'SQL Server maximum compatibility level: ' + CONVERT(NVARCHAR, @serverLevel)

DECLARE @dbName NVARCHAR(128)
SET @dbName = 'BlackBox' --$(DBName) -- DB_NAME()

DECLARE @expectedLevel TINYINT
SET @expectedLevel = CASE WHEN @serverLevel > 120 THEN 120 ELSE @serverLevel END -- Current BlackBox release doesn't work with compatibility levels >120
PRINT N'Expected compatibility level for database: ' + CONVERT(NVARCHAR, @expectedLevel)

IF NOT EXISTS 
(
	SELECT * FROM master..sysdatabases WHERE name = '$(DBName)'
)
BEGIN
	PRINT '-----------------------------'
	PRINT 'Database ' + @dbName + ' not found'
	PRINT '-----------------------------'
END
ELSE
BEGIN
	PRINT '-----------------------------'
	PRINT 'Checking database ' + @dbName
	PRINT '-----------------------------'

  DECLARE @currentLevel TINYINT
  SELECT @currentLevel = compatibility_level FROM sys.databases WHERE name = @dbName

  IF @expectedLevel = @currentLevel
	  PRINT 'Database [' + @dbName + '] is currently configured with expected compatibility level ' + CONVERT(NVARCHAR, @currentLevel)
  ELSE
  BEGIN
  	PRINT 'Changing compatibility level of database [' + @dbName + '] from ' + CONVERT(NVARCHAR, @currentLevel) + ' to ' + CONVERT(NVARCHAR, @expectedLevel)
	  EXEC sp_dbcmptlevel @dbName, @expectedLevel
  END
END  
  
GO
