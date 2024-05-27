--------------------------------------------------------------------------------------
-- Copyright (C) 2024 Crayon
-- BLACKBOX CONFIGURATION
-- This file configures BlackBox for data source recording and transactions 
--
--------------------------------------------------------------------------------------

USE $(DBName)
GO

---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************

----
---- BLACKBOX DATA SOURCE TABLES
----

--------------------------------------------------------------------------------------------------------
-- dbo.BlackBoxDataSourceTypes: Reference table for data source types

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BlackBoxDataSourceTypes]') AND type in (N'U'))
DROP TABLE [dbo].[BlackBoxDataSourceTypes]
GO

CREATE TABLE [dbo].[BlackBoxDataSourceTypes]
(
  [TypeID] int NOT NULL PRIMARY KEY,
  [TypeName] [nvarchar](256),
  [TypeDescription] [nvarchar](2048),
)
GO

-- included so these statements can be run independantly of a rebuild
DELETE FROM [dbo].[BlackBoxDataSourceTypes]
GO

INSERT INTO [dbo].[BlackBoxDataSourceTypes] ([TypeID],[TypeName],[TypeDescription])
VALUES (0, '','Untyped data')

INSERT INTO [dbo].[BlackBoxDataSourceTypes] ([TypeID],[TypeName],[TypeDescription])
VALUES (1, 'sql','Data table returned by running a SQL script')

INSERT INTO [dbo].[BlackBoxDataSourceTypes] ([TypeID],[TypeName],[TypeDescription])
VALUES (2, 'ps1','Data table returned by running a PowerShell script')

INSERT INTO [dbo].[BlackBoxDataSourceTypes] ([TypeID],[TypeName],[TypeDescription])
VALUES (3, 'js','Data table returned by running a JavaScript script')

INSERT INTO [dbo].[BlackBoxDataSourceTypes] ([TypeID],[TypeName],[TypeDescription])
VALUES (4, 'csv','Data table loaded from CSV file')

INSERT INTO [dbo].[BlackBoxDataSourceTypes] ([TypeID],[TypeName],[TypeDescription])
VALUES (5, 'xlsx','Data table loaded from spreadsheet')

INSERT INTO [dbo].[BlackBoxDataSourceTypes] ([TypeID],[TypeName],[TypeDescription])
VALUES (6, 'xml','Data table loaded from XML file')

INSERT INTO [dbo].[BlackBoxDataSourceTypes] ([TypeID],[TypeName],[TypeDescription])
VALUES (7, 'blackbox','Data table returned by BlackBox WebServices API')

INSERT INTO [dbo].[BlackBoxDataSourceTypes] ([TypeID],[TypeName],[TypeDescription])
VALUES (8, 'fnms','Data table returned by FNMS WebServices API')

GO

--------------------------------------------------------------------------------------------------------
-- dbo.BlackBoxDataSourceStatus: Reference table for data source status

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BlackBoxDataSourceStatus]') AND type in (N'U'))
DROP TABLE [dbo].[BlackBoxDataSourceStatus]
GO

CREATE TABLE [dbo].[BlackBoxDataSourceStatus]
(
  [StatusID] int NOT NULL PRIMARY KEY,
  [Status] [nvarchar](256)
)
GO

-- included so these statements can be run independantly of a rebuild
DELETE FROM [dbo].[BlackBoxDataSourceStatus]
GO

INSERT INTO [dbo].[BlackBoxDataSourceStatus] ([StatusID],[Status])
VALUES (0, 'null')

INSERT INTO [dbo].[BlackBoxDataSourceStatus] ([StatusID],[Status])
VALUES (1, 'filed')

INSERT INTO [dbo].[BlackBoxDataSourceStatus] ([StatusID],[Status])
VALUES (2, 'pending')

INSERT INTO [dbo].[BlackBoxDataSourceStatus] ([StatusID],[Status])
VALUES (3, 'loaded')

INSERT INTO [dbo].[BlackBoxDataSourceStatus] ([StatusID],[Status])
VALUES (4, 'validated')

INSERT INTO [dbo].[BlackBoxDataSourceStatus] ([StatusID],[Status])
VALUES (5, 'staged')

INSERT INTO [dbo].[BlackBoxDataSourceStatus] ([StatusID],[Status])
VALUES (6, 'processed')

INSERT INTO [dbo].[BlackBoxDataSourceStatus] ([StatusID],[Status])
VALUES (7, 'published')

INSERT INTO [dbo].[BlackBoxDataSourceStatus] ([StatusID],[Status])
VALUES (8, 'locked')

INSERT INTO [dbo].[BlackBoxDataSourceStatus] ([StatusID],[Status])
VALUES (9, 'withdrawn')

INSERT INTO [dbo].[BlackBoxDataSourceStatus] ([StatusID],[Status])
VALUES (10, 'archived')

GO


--------------------------------------------------------------------------------------------------------
-- dbo.BlackBoxDataSource: Stores all the registered data sources

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BlackBoxDataSources]') AND type in (N'U'))
DROP TABLE [dbo].[BlackBoxDataSources]
GO

CREATE TABLE [dbo].[BlackBoxDataSources]
(
  [Name] [nvarchar](64) NOT NULL PRIMARY KEY,
  [Group] [nvarchar](64),  
  [Description] [nvarchar](2048),
  [TypeID] int,
  [Template] [nvarchar](2048),  
  [Datasets] [nvarchar](2048),
  [Prefix] [nvarchar](8),
  [StatusID] int,
  [Locked] bit,  
  [TimeStamp] datetime
)

GO

---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************

----
---- BLACKBOX DATA SOURCE INSTANCE TABLES
----

--------------------------------------------------------------------------------------------------------
-- dbo.BlackBoxDataSourceInstances: Stores all the registered data sources

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BlackBoxDataSourceInstances]') AND type in (N'U'))
DROP TABLE [dbo].[BlackBoxDataSourceInstances]
GO

CREATE TABLE [dbo].[BlackBoxDataSourceInstances]
(
  [ID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
  [Name] [nvarchar](64),
  [Group] [nvarchar](64),  
  [Comment] [nvarchar](2048),
  [TypeID] int,
  [ReferenceID] int,
  [Source] [nvarchar](MAX),
  [Datasets] [nvarchar](2048),
  [Prefix] [nvarchar](8),  
  [JOBID] int NULL,
  [GUID] [nvarchar](36) NULL,
  [StatusID] int,
  [Validations] [nvarchar](2048),
  [Locked] bit,    
  [TimeStamp] datetime
)

GO

DBCC CHECKIDENT ('dbo.BlackBoxDataSourceInstances', RESEED, 1000)
GO

---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************

----
---- BLACKBOX DATA SOURCE VIEWS
----

--------------------------------------------------------------------------------------------------------
-- dbo.vBlackBoxDataSources View definiton for vBlackBoxDataSources

IF EXISTS (SELECT 1 FROM dbo.sysobjects WHERE id = object_id('dbo.vBlackBoxDataSources') AND OBJECTPROPERTY(id, 'IsView') = 1)
  DROP VIEW [dbo].[vBlackBoxDataSources]
GO

CREATE VIEW [dbo].[vBlackBoxDataSources] AS
  SELECT
    ds.[Name]
    ,ds.[Group]
    ,ds.[Description]
    ,ds.[TypeID]   
    ,case
       when ds.[TypeID] is null then ''       
       when ds.[TypeID] = 0 then 'ready'
       when ds.[TypeID] = 1 then 'sql'
       when ds.[TypeID] = 2 then 'ps1'
       when ds.[TypeID] = 3 then 'js'
       when ds.[TypeID] = 4 then 'csv'
       when ds.[TypeID] = 5 then 'xlsx'
       when ds.[TypeID] = 6 then 'xml'
       when ds.[TypeID] = 7 then 'blackbox'
       when ds.[TypeID] = 8 then 'fnms'       
       when ds.[TypeID] > 8 then 'unknown'
       when ds.[TypeID] < 0 then 'error(' + convert(nvarchar(2),ds.[TypeID]) + ')'
       else 'unknown'
     end AS [Type]
    ,ds.[Template]
    ,ds.[Datasets]
    ,ds.[Prefix]    
    ,ds.[StatusID]
    ,case
       when ds.[StatusID] is null then ''       
       when ds.[StatusID] = 0 then 'null'
       when ds.[StatusID] = 1 then 'filed'
       when ds.[StatusID] = 2 then 'pending'       
       when ds.[StatusID] = 3 then 'loaded'
       when ds.[StatusID] = 4 then 'validated'       
       when ds.[StatusID] = 5 then 'staged'
       when ds.[StatusID] = 6 then 'processed'
       when ds.[StatusID] = 7 then 'published' 
       when ds.[StatusID] = 8 then 'locked'             
       when ds.[StatusID] = 9 then 'withdrawn'
       when ds.[StatusID] > 9 then 'archived'       
       when ds.[StatusID] < 0 then 'error(' + convert(nvarchar(2),ds.[StatusID]) + ')'
       else 'unknown'
     end AS [Status]
    ,ds.[Locked]     
    ,case
       when ds.[Name] = 'System' then 'dashboards_servermode_svg_dark_32x32'
       when ds.[Name] = 'Contacts' then 'businessobjects_bo_contact_svg_dark_32x32'       
       when ds.[Name] = 'ValidationLists' then 'format_listbullets_svg_dark_32x32'
       when ds.[Name] = 'Assets' then 'businessobjects_bo_order_svg_dark_32x32'
       when ds.[Name] = 'Metrics' then 'iconbuilder_business_calculator_svg_dark_32x32'
       when ds.[Name] = 'Purchases' then 'businessobjects_bo_price_svg_dark_32x32'
       when ds.[Name] = 'AssetCriticality' then 'businessobjects_bo_opportunity_svg_dark_32x32'
       when ds.[Name] = 'SiteAssetApplications' then 'dashboards_editrules_svg_dark_32x32'
       else 'iconbuilder_shopping_box_svg_dark_32x32'
     end AS [Icon]     
    ,ds.[TimeStamp]
    ,DATEDIFF(day, ds.[TimeStamp], GetDate()) AS [Age]
  FROM [dbo].[BlackBoxDataSources] AS ds

GO

----
---- BLACKBOX DATA SOURCE INSTANCE VIEWS
----

--------------------------------------------------------------------------------------------------------
-- dbo.vBlackBoxDataSourceInstances: View definiton for vBlackBoxDataSourceInstances

IF EXISTS (SELECT 1 FROM dbo.sysobjects WHERE id = object_id('dbo.vBlackBoxDataSourceInstances') AND OBJECTPROPERTY(id, 'IsView') = 1)
  DROP VIEW [dbo].[vBlackBoxDataSourceInstances]
GO

CREATE VIEW [dbo].[vBlackBoxDataSourceInstances] AS
  SELECT
    dsi.[ID]
    ,dsi.[Name]
    ,dsi.[Group]
    ,dsi.[Comment]
    ,dsi.[TypeID]
    ,case
       when dsi.[TypeID] is null then ''       
       when dsi.[TypeID] = 0 then 'ready'
       when dsi.[TypeID] = 1 then 'sql'
       when dsi.[TypeID] = 2 then 'ps1'
       when dsi.[TypeID] = 3 then 'js'
       when dsi.[TypeID] = 4 then 'csv'
       when dsi.[TypeID] = 5 then 'xlsx'
       when dsi.[TypeID] = 6 then 'xml'
       when dsi.[TypeID] = 7 then 'blackbox'
       when dsi.[TypeID] = 8 then 'fnms'       
       when dsi.[TypeID] > 8 then 'unknown'
       when dsi.[TypeID] < 0 then 'error(' + convert(nvarchar(2),dsi.[TypeID]) + ')'
       else 'unknown'
     end AS [Type]
    ,ds.[Template]
    ,ds.[Datasets] AS [AllowedDatasets]
    ,dsi.[ReferenceID]
    ,dsi.[Source]
    ,dsi.[Datasets]
    ,dsi.[Prefix]    
    ,dsi.[JOBID]
    ,dsi.[GUID]
    ,dsi.[StatusID]
    ,case
       when dsi.[StatusID] is null then ''       
       when dsi.[StatusID] = 0 then 'null'
       when dsi.[StatusID] = 1 then 'filed'
       when dsi.[StatusID] = 2 then 'pending'       
       when dsi.[StatusID] = 3 then 'staged'
       when dsi.[StatusID] = 4 then 'validated'       
       when dsi.[StatusID] = 5 then 'published'
       when dsi.[StatusID] = 6 then 'processed'
       when dsi.[StatusID] = 7 then 'processed' 
       when dsi.[StatusID] = 8 then 'locked'             
       when dsi.[StatusID] = 9 then 'withdrawn'
       when dsi.[StatusID] > 9 then 'archived'       
       when dsi.[StatusID] < 0 then 'error(' + convert(nvarchar(2),dsi.[StatusID]) + ')'
       else 'unknown'
     end AS [Status]
    ,dsi.[Validations]
    ,dsi.[Locked]     
    ,case
       when dsi.[Name] = 'System' then 'dashboards_servermode_svg_dark_32x32'
       when dsi.[Name] = 'Contacts' then 'businessobjects_bo_contact_svg_dark_32x32'
       when dsi.[Name] = 'ValidationLists' then 'format_listbullets_svg_dark_32x32'
       when dsi.[Name] = 'Assets' then 'businessobjects_bo_order_svg_dark_32x32'
       when dsi.[Name] = 'Metrics' then 'iconbuilder_business_calculator_svg_dark_32x32'
       when dsi.[Name] = 'Purchases' then 'businessobjects_bo_price_svg_dark_32x32'
       when dsi.[Name] = 'AssetCriticality' then 'businessobjects_bo_opportunity_svg_dark_32x32'
       when dsi.[Name] = 'SiteAssetApplications' then 'dashboards_editrules_svg_dark_32x32'
       else 'iconbuilder_shopping_box_svg_dark_32x32'
     end AS [Icon]     
    ,dsi.[TimeStamp]
    ,DATEDIFF(day, dsi.[TimeStamp], GetDate()) AS [Age]
    ,ROW_NUMBER() OVER(PARTITION BY dsi.[GUID] ORDER BY dsi.[TimeStamp] desc) AS [Rank]    
  FROM [dbo].[BlackBoxDataSourceInstances] AS dsi
    JOIN [dbo].[BlackBoxDataSources] AS ds ON ds.[Name] = dsi.[Name] 

GO

---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************

----
---- BLACKBOX DATA SOURCE TABLES
----

--------------------------------------------------------------------------------------------------------
-- dbo.BlackBoxDataSources: Add initial data sources to the BlackBoxDataSources table

PRINT 'Populate BlackBoxDataSources'

INSERT INTO [dbo].[BlackBoxDataSources] ([Name],[Group],[Description],[TypeID],[Template],[Datasets],[Prefix],[StatusID],[Locked],[TimeStamp])
VALUES ('System','System','BlackBox data',5,'Template-System-v1.0.xslx','DataMappings','sys',1,0,'2022-03-06 21:40:58.867')

INSERT INTO [dbo].[BlackBoxDataSources] ([Name],[Group],[Description],[TypeID],[Template],[Datasets],[Prefix],[StatusID],[Locked],[TimeStamp])
VALUES ('Contacts','System','BlackBox contact data',5,'Template-Contacts-v1.0.xlsx','Contacts','sys',1,0,'2022-03-06 21:40:58.867')

GO

INSERT INTO [dbo].[BlackBoxDataSources] ([Name],[Group],[Description],[TypeID],[Template],[Datasets],[Prefix],[StatusID],[Locked],[TimeStamp])
VALUES ('Purchases','ITAM','Purchases data',4,'Template-Purchases-v1.0.xlsx','Purchases','itam',1,0,'2022-03-06 21:40:58.867')

INSERT INTO [dbo].[BlackBoxDataSources] ([Name],[Group],[Description],[TypeID],[Template],[Datasets],[Prefix],[StatusID],[Locked],[TimeStamp])
VALUES ('Assets','ITAM','Assets data',5,'Template-Assets-v1.0','Assets','itam',1,0,'2022-02-22 20:00:00.123')

GO

INSERT INTO [dbo].[BlackBoxDataSources] ([Name],[Group],[Description],[TypeID],[Template],[Datasets],[Prefix],[StatusID],[Locked],[TimeStamp])
VALUES ('Metrics','Metrics','Metrics data',4,'Template-Metrics-v1.0.xlsx','Metrics','data',1,0,'2022-03-06 22:11:30.700')

GO

---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************

----
---- BLACKBOX DATA SOURCE TABLES (not used at RIO)
----

--------------------------------------------------------------------------------------------------------
-- dbo.BlackBoxDataSources: Add initial data sources to the BlackBoxDataSources table

PRINT 'Populate Extra BlackBoxDataSources'


---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************
