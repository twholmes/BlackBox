--------------------------------------------------------------------------------------
-- Copyright (C) 2024 Crayon
-- BLACKBOX FNMS Data
-- This file configures BlackBox for a the base set of staged daat
-- and Datasets
--
--------------------------------------------------------------------------------------

USE $(DBName)
GO

---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************

----
---- FNMS TABLES
----

--------------------------------------------------------------------------------------------------------
-- dbo.[ComplianceSetting]: FNMS settings

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ComplianceSetting]') AND type in (N'U'))
DROP TABLE [dbo].[ComplianceSetting]
GO

CREATE TABLE [dbo].[ComplianceSetting]
(
  [ComplianceSettingID] [int] NOT NULL PRIMARY KEY,
  [SettingName] [nvarchar](128) NOT NULL,
  [SettingValue] [varchar](128) NOT NULL
)
GO

CREATE INDEX [IX_ComplianceSetting] ON [dbo].[ComplianceSetting]([SettingName])
GO


--------------------------------------------------------------------------------------------------------
-- dbo.[DatabaseConfiguration]: FNMS database configuration

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DatabaseConfiguration]') AND type in (N'U'))
DROP TABLE [dbo].[DatabaseConfiguration]
GO

CREATE TABLE [dbo].[DatabaseConfiguration]
(
  [Property] [varchar](32) NOT NULL,
  [Value] [varchar](256) NOT NULL,
  [Created] [datetime] NOT NULL,
  [LastDate] [datetime] NOT NULL
)
GO

CREATE INDEX [IX_DatabaseConfiguration] ON [dbo].[DatabaseConfiguration]([Property])
GO


---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************

----
---- BLACKBOX FNMS LOCATIONS
----

--------------------------------------------------------------------------------------------------------
-- dbo.[fnmsLocationsExport]: Sample staged dataset

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fnmsLocationsExport]') AND type in (N'U'))
DROP TABLE [dbo].[fnmsLocationsExport]
GO

CREATE TABLE [dbo].[fnmsLocationsExport]
(
  [GroupID] [int] NOT NULL PRIMARY KEY,
  [GroupCN] [nvarchar](256) NULL,
  [GroupExID] [varchar](128) NULL,
  [Path] [nvarchar](500) NULL,
  [TreeLevel] [int] NULL,
  [Level0] [nvarchar](256) NULL,  
  [Level1] [nvarchar](256) NULL,  
  [Level2] [nvarchar](256) NULL,  
  [Level3] [nvarchar](256) NULL,  
  [Level4] [nvarchar](256) NULL,  
  [Level5] [nvarchar](256) NULL,  
  [Level6] [nvarchar](256) NULL,  
  [Level7] [nvarchar](256) NULL,  
  [Level8] [nvarchar](256) NULL,  
  [Level9] [nvarchar](256) NULL
)
GO

CREATE INDEX [IX_fnmsLocationsExport] ON [dbo].[fnmsLocationsExport]([GroupCN])
GO

---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************

----
---- BLACKBOX FNMS CATEGORY EXPORT
----

--------------------------------------------------------------------------------------------------------
-- dbo.[fnmsCategoryExport]: Sample staged dataset

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fnmsCategoryExport]') AND type in (N'U'))
DROP TABLE [dbo].[fnmsCategoryExport]
GO

CREATE TABLE [dbo].[fnmsCategoryExport]
(
  [GroupID] [int] NOT NULL PRIMARY KEY,
  [GroupCN] [nvarchar](256) NULL,
  [GroupExID] [varchar](128) NULL,
  [Path] [nvarchar](500) NULL,
  [TreeLevel] [int] NULL,
  [Level0] [nvarchar](256) NULL,  
  [Level1] [nvarchar](256) NULL,  
  [Level2] [nvarchar](256) NULL,  
  [Level3] [nvarchar](256) NULL,  
  [Level4] [nvarchar](256) NULL,  
  [Level5] [nvarchar](256) NULL,  
  [Level6] [nvarchar](256) NULL,  
  [Level7] [nvarchar](256) NULL,  
  [Level8] [nvarchar](256) NULL,  
  [Level9] [nvarchar](256) NULL
)

GO

CREATE INDEX [IX_fnmsCategoryExport] ON [dbo].[fnmsCategoryExport]([GroupCN])
GO

---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************

----
---- BLACKBOX FNMS User EXPORT
----

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fnmsComplianceUserExport]') AND type in (N'U'))
	DROP TABLE [dbo].[fnmsComplianceUserExport]
GO

CREATE TABLE [dbo].[fnmsComplianceUserExport]
(
	[ComplianceUserID] [int] NOT NULL PRIMARY KEY,
	[SAMAccountName] [nvarchar] (64) NOT NULL
)
GO

CREATE INDEX [IX_fnmsComplianceUserExport] ON [dbo].[fnmsComplianceUserExport]([SAMAccountName])
GO

---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************

-- dbo.[Split]: Split function
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Split]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ))
DROP FUNCTION [dbo].[Split]
GO

CREATE FUNCTION [dbo].[Split] (@sep char(1), @s varchar(max))
RETURNS table
AS
RETURN 
(
  WITH Pieces(pn, start, stop) AS 
  (
    SELECT 1, 1, CHARINDEX(@sep, @s)
    UNION ALL
    SELECT cast(pn as int)+ 1, cast(stop as int) + 1, CHARINDEX(@sep, @s, stop + 1)
    FROM Pieces
    WHERE stop > 0
  )
  SELECT pn, SUBSTRING(@s, start, CASE WHEN stop > 0 THEN stop-start ELSE len(@s) END) AS s
  FROM Pieces
)

GO


---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************

----
---- BLACKBOX VALIDATION SCHEMA PROCEDURES
----

/****** StoredProcedure: [dbo].[AddCategoryColumns] ******/
IF EXISTS(SELECT 1 FROM sys.procedures WHERE Name = 'AddCategoryColumns')
  DROP PROCEDURE [dbo].[AddCategoryColumns]
GO

CREATE PROCEDURE [dbo].[AddCategoryColumns]
AS
  PRINT 'Populate the Categories table'
  
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
  SET DEADLOCK_PRIORITY LOW
  
  DECLARE @Command nvarchar(2048)
  SET @Command = ' 
  IF COL_LENGTH(''[dbo].[fnmsCategoryExport]'', ''Level1'') IS NULL
  BEGIN
    ALTER TABLE [dbo].[fnmsCategoryExport] ADD [Level1] nvarchar(100);
  END
  '
  EXEC sp_executesql @Command
  
  SET @Command = '  
  IF COL_LENGTH(''[dbo].[fnmsCategoryExport]'', ''Level2'') IS NULL
  BEGIN
    ALTER TABLE [dbo].[fnmsCategoryExport] ADD [Level2] nvarchar(100);
  END
  '
  EXEC sp_executesql @Command
  
  SET @Command = '  
  IF COL_LENGTH(''[dbo].[fnmsCategoryExport]'', ''Level3'') IS NULL
  BEGIN
    ALTER TABLE [dbo].[fnmsCategoryExport] ADD [Level3] nvarchar(100);
  END
  '
  EXEC sp_executesql @Command

  SET @Command = '
  IF COL_LENGTH(''[dbo].[fnmsCategoryExport]'', ''Level4'') IS NULL
  BEGIN
    ALTER TABLE [dbo].[fnmsCategoryExport] ADD [Level4] nvarchar(100);
  END
  '
  EXEC sp_executesql @Command
  
  SET @Command = ' 
  IF COL_LENGTH(''[dbo].[fnmsCategoryExport]'', ''Level5'') IS NULL
  BEGIN
    ALTER TABLE [dbo].[fnmsCategoryExport] ADD [Level5] nvarchar(100);
  END
  '
  EXEC sp_executesql @Command
  
  SET @Command = '  
  IF COL_LENGTH(''[dbo].[fnmsCategoryExport]'', ''Level6'') IS NULL
  BEGIN
    ALTER TABLE [dbo].[fnmsCategoryExport] ADD [Level6] nvarchar(100);
  END
  '
  EXEC sp_executesql @Command
  
  SET @Command = '
  IF COL_LENGTH(''[dbo].[fnmsCategoryExport]'', ''Level7'') IS NULL
  BEGIN
    ALTER TABLE [dbo].[fnmsCategoryExport] ADD [Level7] nvarchar(100);
  END
  '
  EXEC sp_executesql @Command  
;

GO

---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************

/****** StoredProcedure: [dbo].[PullCategoriesFromFNMS] ******/
IF EXISTS(SELECT 1 FROM sys.procedures WHERE Name = 'PullCategoriesFromFNMS')
  DROP PROCEDURE [dbo].[PullCategoriesFromFNMS]
GO

CREATE PROCEDURE [dbo].[PullCategoriesFromFNMS]
AS
BEGIN

  PRINT 'Pull category data from FNMS'

	DELETE FROM [dbo].[fnmsCategoryExport]

	; WITH cte AS (
		SELECT 
			c.[GroupID], 
			c.[GroupCN],
			c.[GroupExID], 
			c.[ParentGroupExID], 
			'Level' + CONVERT(NVARCHAR(10), c.[TreeLevel] - 2) AS LevelName
		FROM [FNMSCompliance].[dbo].[Category] c
		WHERE c.[BusinessView] = 0
			AND
			c.[TreeLevel] <= 12

		UNION ALL

		SELECT 
			cte.[GroupID], 
			cp.[GroupCN],
			cp.[GroupExID], 
			cp.[ParentGroupExID], 
			'Level' + CONVERT(NVARCHAR(10), cp.[TreeLevel] - 2) AS LevelName
		FROM [FNMSCompliance].[dbo].[Category] cp
			JOIN cte 
				ON cte.[ParentGroupExID] = cp.[GroupExID]
		WHERE cp.[TreeLevel] > 1
	)
	INSERT INTO [dbo].[fnmsCategoryExport] (
		[GroupID],
		[GroupCN],
		[GroupExID],
		[Path],
		[TreeLevel],
		[Level0], 
		[Level1], 
		[Level2], 
		[Level3], 
		[Level4], 
		[Level5], 
		[Level6], 
		[Level7], 
		[Level8], 
		[Level9] 
	)
	SELECT 
		c.[GroupID],
		c.[GroupCN],
		c.[GroupExID],
		c.[Path],
		c.[TreeLevel],
		lvl.[Level0], 
		lvl.[Level1], 
		lvl.[Level2], 
		lvl.[Level3], 
		lvl.[Level4], 
		lvl.[Level5], 
		lvl.[Level6], 
		lvl.[Level7], 
		lvl.[Level8], 
		lvl.[Level9]
	FROM [FNMSCompliance].[dbo].[Category] c
		JOIN (
			SELECT *
		FROM (
			SELECT 
				cte.[GroupID],
				cte.[LevelName],
				cte.[GroupCN]
			FROM cte
		) src
		PIVOT (
			MAX(src.[GroupCN])
			FOR src.[LevelName] IN ([Level0], [Level1], [Level2], [Level3], [Level4], [Level5], [Level6], [Level7], [Level8], [Level9])
		) AS pvt
	) lvl ON lvl.[GroupID] = c.[GroupID]
END
GO


/****** StoredProcedure: [dbo].[PullLocationsFromFNMS] ******/
IF EXISTS(SELECT 1 FROM sys.procedures WHERE Name = 'PullLocationsFromFNMS')
  DROP PROCEDURE [dbo].[PullLocationsFromFNMS]
GO

CREATE PROCEDURE [dbo].[PullLocationsFromFNMS]
AS
BEGIN

  PRINT 'Pull location data from FNMS'

	DELETE FROM [dbo].[fnmsLocationsExport]

	; WITH cte AS (
		SELECT 
			l.[GroupID], 
			l.[GroupCN],
			l.[GroupExID], 
			l.[ParentGroupExID], 
			'Level' + CONVERT(NVARCHAR(10), l.[TreeLevel] - 2) AS LevelName
		FROM [FNMSCompliance].[dbo].[Location] l
		WHERE l.[BusinessView] = 0
			AND
			l.[TreeLevel] <= 12

		UNION ALL

		SELECT 
			cte.[GroupID], 
			lp.[GroupCN],
			lp.[GroupExID], 
			lp.[ParentGroupExID], 
			'Level' + CONVERT(NVARCHAR(10), lp.[TreeLevel] - 2) AS LevelName
		FROM [FNMSCompliance].[dbo].[Location] lp
			JOIN cte 
				ON cte.[ParentGroupExID] = lp.[GroupExID]
		WHERE lp.[TreeLevel] > 1
	)
	INSERT INTO [dbo].[fnmsLocationsExport] (
		[GroupID],
		[GroupCN],
		[GroupExID],
		[Path],
		[TreeLevel],
		[Level0], 
		[Level1], 
		[Level2], 
		[Level3], 
		[Level4], 
		[Level5], 
		[Level6], 
		[Level7], 
		[Level8], 
		[Level9] 
	)
	SELECT 
		l.[GroupID],
		l.[GroupCN],
		l.[GroupExID],
		l.[Path],
		l.[TreeLevel],
		lvl.[Level0], 
		lvl.[Level1], 
		lvl.[Level2], 
		lvl.[Level3], 
		lvl.[Level4], 
		lvl.[Level5], 
		lvl.[Level6], 
		lvl.[Level7], 
		lvl.[Level8], 
		lvl.[Level9]
	FROM [FNMSCompliance].[dbo].[Location] l
		JOIN (
			SELECT *
		FROM (
			SELECT 
				cte.[GroupID],
				cte.[LevelName],
				cte.[GroupCN]
			FROM cte
		) src
		PIVOT (
			MAX(src.[GroupCN])
			FOR src.[LevelName] IN ([Level0], [Level1], [Level2], [Level3], [Level4], [Level5], [Level6], [Level7], [Level8], [Level9])
		) AS pvt
	) lvl ON lvl.[GroupID] = l.[GroupID]
END
GO




/****** StoredProcedure: [dbo].[PullComplianceUsersFromFNMS] ******/
IF EXISTS(SELECT 1 FROM sys.procedures WHERE Name = 'PullComplianceUsersFromFNMS')
  DROP PROCEDURE [dbo].[PullComplianceUsersFromFNMS]
GO

CREATE PROCEDURE [dbo].[PullComplianceUsersFromFNMS] (@UserDomainQualifiedName NVARCHAR(100))
AS
BEGIN

	PRINT 'Pull user data from FNMS'

	DELETE FROM [dbo].[fnmsComplianceUserExport]

	INSERT INTO [dbo].[fnmsComplianceUserExport] (
		[ComplianceUserID],
		[SAMAccountName]
	)
	SELECT TOP 1 WITH TIES
		cu.[ComplianceUserID],
		cu.[SAMAccountName]
	FROM [FNMSCompliance].[dbo].[ComplianceUser] cu
		JOIN [FNMSCompliance].[dbo].[ComplianceDomain] cd
			ON cd.[ComplianceDomainID] = cu.[ComplianceDomainID]
		JOIN [FNMSCompliance].[dbo].[ComplianceUserStatusI18N] cus
			ON cus.[ComplianceUserStatusID] = cu.[UserStatusID]
	WHERE cd.[QualifiedName] = @UserDomainQualifiedName
	ORDER BY ROW_NUMBER() OVER (PARTITION BY cu.[SAMAccountName] ORDER BY CASE WHEN cus.[DefaultValue] = 'Active' THEN 0 ELSE 1 END ASC, cu.[UpdatedDate] DESC)
END
GO


---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************

