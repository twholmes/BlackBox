--------------------------------------------------------------------------------------
-- Copyright (C) 2024 Crayon
-- BLACKBOX CONFIGURATION
-- This file configures BlackBox for data source validation
--
--------------------------------------------------------------------------------------

USE $(DBName)
GO

---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************

----
---- BLACKBOX LIST TABLES
----

/****** Table: [dbo].[sysValidationLists] ******/
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sysValidationLists]') AND type in (N'U'))
  DROP TABLE [dbo].[sysValidationLists]
GO

CREATE TABLE [dbo].[sysValidationLists]
(
	[ID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
  [JobID] [int] NULL,
  [DataSourceInstanceID] [int] NULL,
  [LineNumber] [int] NULL,
  [Exclude] [nvarchar](4) NULL,
  [FlexeraID] [int] NULL,
	[DataSource] [nvarchar](80) NOT NULL,	  
	[ListName] [nvarchar](80) NOT NULL,
  [Value] [nvarchar](500) NULL,
	[Status] [int] NULL  
)

GO

DBCC CHECKIDENT ('sysValidationLists', RESEED, 1000)
GO

/****** Table: [dbo].[stagedValidationLists] ******/
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stagedValidationLists]') AND type in (N'U'))
  DROP TABLE [dbo].[stagedValidationLists]
GO

CREATE TABLE [dbo].[stagedValidationLists]
(
	[StagedID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[ID] [int] NULL,
  [JobID] [int] NULL,
  [DataSourceInstanceID] [int] NULL,
  [LineNumber] [int] NULL,
  [FlexeraID] [int] NULL,
	[DataSource] [nvarchar](80) NOT NULL,	  
	[ListName] [nvarchar](80) NOT NULL,
  [Value] [nvarchar](500) NULL,
	[Status] [int] NULL  
)

GO

DBCC CHECKIDENT ('stagedValidationLists', RESEED, 1000)
GO


---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************

/****** View: [dbo].[combinedValidationLists] ******/
IF EXISTS (SELECT 1 FROM dbo.sysobjects WHERE id = object_id('dbo.combinedValidationLists') AND OBJECTPROPERTY(id, 'IsView') = 1)
  DROP VIEW [dbo].[combinedValidationLists]
GO

CREATE VIEW [dbo].[combinedValidationLists] AS
SELECT 
  [StagedID] AS [ID]
  ,[DataSource]
  ,[ListName]
  ,[Value]
  ,[Status]
FROM [dbo].[stagedValidationLists]

UNION

SELECT 
  [GroupID] AS [ID]
	,'AssetCriticality' AS [DataSource]
	,'Model_Category' AS [ListName]
  ,[GroupCN] AS [Value]
	,0 AS [Status]
FROM [dbo].[fnmsCategoryExport]
WHERE [TreeLevel] = 4
  
UNION

SELECT 
  [GroupID] AS [ID]
  ,'AssetCriticality' AS [DataSource]
	,'Sub_Model_Category' AS [ListName]
  ,[GroupCN] AS [Value]
	,0 AS [Status]
FROM [dbo].[fnmsCategoryExport]
WHERE [TreeLevel] = 5

UNION

SELECT 
  [GroupID] AS [ID]
	 ,'AssetCriticality' AS [DataSource]
	 ,'Site' AS [ListName]
   ,[GroupCN] AS [Value]
	 ,0 AS [Status]
FROM [dbo].[fnmsLocationsExport]
WHERE [TreeLevel] = 6

UNION

SELECT 
  [GroupID] AS [ID]
	 ,'AssetCriticality' AS [DataSource]
	 ,'Site_Name' AS [ListName]
   ,[GroupCN] AS [Value]
	 ,0 AS [Status]
FROM [dbo].[fnmsLocationsExport]
WHERE [TreeLevel] = 6

UNION

SELECT 
  [GroupID] AS [ID]
	 ,'AssetCriticality' AS [DataSource]
	 ,'Physical_Location' AS [ListName]
   ,'/'+[Level4]+'/'+[Level5]+'/'+[Level6]+'/'+[Level7]+'/'+[Level8]+'/'+[Level9] AS [Value]	 
	 ,0 AS [Status]
FROM [dbo].[fnmsLocationsExport]
WHERE [TreeLevel] = 11


UNION

SELECT 
  [ComplianceUserID] AS [ID]
	 ,'AssetCriticality' AS [DataSource]
	 ,'SAMAccountNames' AS [ListName]
   ,[SAMAccountName] AS [Value]
	 ,0 AS [Status]
FROM [dbo].[fnmsComplianceUserExport]

;

GO


---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************

--------------------------------------------------------------------------------------------------------
-- dbo.BlackBoxDataMappings: Populate with required default data

SET IDENTITY_INSERT [dbo].[sysDataMappings] ON
GO

DELETE FROM [dbo].[sysDataMappings] WHERE [DataSource] like 'AssetCriticality' and [SourceDataset] like 'ValidationLists'
GO

--SET @JobNumber = 5, @DataSourceInstanceID = 5
INSERT INTO [dbo].[sysDataMappings] ([ID],[Exclude],[DataSource],[SourceDataset],[Field],[TableName],[Column],[Mandatory],[Flags],[Type],[Size],[Convert],[DisplayWidth]) 
VALUES (110,'n','AssetCriticality','ValidationLists','DataSource','sysValidationLists','DataSource',0,'','nvarchar',80,'''AssetCriticality''','150px')

INSERT INTO [dbo].[sysDataMappings] ([ID],[Exclude],[DataSource],[SourceDataset],[Field],[TableName],[Column],[Mandatory],[Flags],[Type],[Size],[Convert],[DisplayWidth]) 
VALUES (111,'n','AssetCriticality','ValidationLists','List_Name','sysValidationLists','ListName',0,'','nvarchar',80,'[{0}]','150px')

INSERT INTO [dbo].[sysDataMappings] ([ID],[Exclude],[DataSource],[SourceDataset],[Field],[TableName],[Column],[Mandatory],[Flags],[Type],[Size],[Convert],[DisplayWidth]) 
VALUES (112,'n','AssetCriticality','ValidationLists','Value','sysValidationLists','Value',0,'','nvarchar',80,'[{0}]','150px')
GO

UPDATE [dbo].[sysDataMappings] SET [JobID]=5, [DataSourceInstanceID]=5, [LineNumber]=[ID], [Exclude]='n', [FlexeraID]=0
WHERE [DataSource] = 'AssetCriticality' AND [SourceDataset] = 'ValidationLists'
GO

EXEC [dbo].[StageDataMappings] @DataSourceInstanceID=5, @JobID=0, @SourceDataset='ValidationLists', @KeepExisting=1
GO


DELETE FROM [dbo].[sysDataMappings] WHERE [DataSource] like 'SiteAssetApplications' and [SourceDataset] like 'ValidationLists'
GO

--SET @JobNumber = 6, @DataSourceInstanceID = 6
INSERT INTO [dbo].[sysDataMappings] ([ID],[Exclude],[DataSource],[SourceDataset],[Field],[TableName],[Column],[Mandatory],[Flags],[Type],[Size],[Convert],[DisplayWidth]) 
VALUES (120,'n','SiteAssetApplications','ValidationLists','DataSource','sysValidationLists','DataSource',0,'','nvarchar',80,'''SiteAssetApplications''','150px')

INSERT INTO [dbo].[sysDataMappings] ([ID],[Exclude],[DataSource],[SourceDataset],[Field],[TableName],[Column],[Mandatory],[Flags],[Type],[Size],[Convert],[DisplayWidth]) 
VALUES (121,'n','SiteAssetApplications','ValidationLists','List_Name','sysValidationLists','ListName',0,'','nvarchar',80,'[{0}]','150px')

INSERT INTO [dbo].[sysDataMappings] ([ID],[Exclude],[DataSource],[SourceDataset],[Field],[TableName],[Column],[Mandatory],[Flags],[Type],[Size],[Convert],[DisplayWidth]) 
VALUES (122,'n','SiteAssetApplications','ValidationLists','Value','sysValidationLists','Value',0,'','nvarchar',80,'[{0}]','150px')
GO

UPDATE [dbo].[sysDataMappings] SET [JobID]=6, [DataSourceInstanceID]=6, [LineNumber]=[ID], [Exclude]='n', [FlexeraID]=0
WHERE [DataSource] = 'SiteAssetApplications' AND [SourceDataset] = 'ValidationLists'
GO

EXEC [dbo].[StageDataMappings] @DataSourceInstanceID=6, @JobID=0, @SourceDataset='ValidationLists', @KeepExisting=1
GO

SET IDENTITY_INSERT [dbo].[sysDataMappings] OFF
GO

---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************
