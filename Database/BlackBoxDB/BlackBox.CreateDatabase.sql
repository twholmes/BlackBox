---------------------------------------------------------------------------
-- Copyright (C) 2024 Crayon Australia
---------------------------------------------------------------------------

IF EXISTS 
(
	SELECT * FROM master..sysdatabases WHERE name = '$(DBName)'
)
BEGIN
	PRINT '-----------------------------'
	PRINT 'Database $(DBName) exists'
	PRINT '-----------------------------'
END
ELSE
BEGIN
	PRINT '-----------------------------'
	PRINT 'Creating database $(DBName)'
	PRINT '-----------------------------'

	DECLARE @a NVARCHAR(256)
	SELECT @a = CONVERT(NVARCHAR(256),SERVERPROPERTY('collation')) 

	DECLARE	@collation NVARCHAR(256)

	SELECT	@collation = @a
	WHERE	@a LIKE '%CI_AS' -- the collation we want
		OR @a LIKE '%CI_AS_%' -- there are multiple options that can be on the end

	IF @collation IS NULL
		SET @collation = 'Latin1_General_CI_AS'

	EXECUTE ('CREATE DATABASE $(DBName) COLLATE '+ @collation)
END

GO

ALTER DATABASE $(DBName) SET RECOVERY SIMPLE
GO

