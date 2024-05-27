--------------------------------------------------------------------------------------
-- Copyright (C) 2024 Crayon
-- BLACKBOX CONFIGURATION
-- This file configures BlackBox for dataset recording and transactions 
--
--------------------------------------------------------------------------------------

USE $(DBName)
GO

---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************

----
---- BLACKBOX DATASET TABLES
----

--------------------------------------------------------------------------------------------------------
-- dbo.BlackBoxDatasetStatus: Reference table for data source status

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BlackBoxDatasetStatus]') AND type in (N'U'))
DROP TABLE [dbo].[BlackBoxDatasetStatus]
GO

CREATE TABLE [dbo].[BlackBoxDatasetStatus]
(
  [StatusID] int NOT NULL PRIMARY KEY,
  [Status] [nvarchar](256)
)
GO

DELETE FROM [dbo].[BlackBoxDatasetStatus]
GO

INSERT INTO [dbo].[BlackBoxDatasetStatus] ([StatusID],[Status])
VALUES (0, 'null')

INSERT INTO [dbo].[BlackBoxDatasetStatus] ([StatusID],[Status])
VALUES (1, 'filed')

INSERT INTO [dbo].[BlackBoxDatasetStatus] ([StatusID],[Status])
VALUES (2, 'pending')

INSERT INTO [dbo].[BlackBoxDatasetStatus] ([StatusID],[Status])
VALUES (3, 'loaded')

INSERT INTO [dbo].[BlackBoxDatasetStatus] ([StatusID],[Status])
VALUES (4, 'validated')

INSERT INTO [dbo].[BlackBoxDatasetStatus] ([StatusID],[Status])
VALUES (5, 'staged')

INSERT INTO [dbo].[BlackBoxDatasetStatus] ([StatusID],[Status])
VALUES (6, 'processed')

INSERT INTO [dbo].[BlackBoxDatasetStatus] ([StatusID],[Status])
VALUES (7, 'published')

INSERT INTO [dbo].[BlackBoxDatasetStatus] ([StatusID],[Status])
VALUES (8, 'locked')

INSERT INTO [dbo].[BlackBoxDatasetStatus] ([StatusID],[Status])
VALUES (9, 'withdrawn')

INSERT INTO [dbo].[BlackBoxDatasetStatus] ([StatusID],[Status])
VALUES (10, 'archived')

GO


--------------------------------------------------------------------------------------------------------
-- dbo.BlackBoxDatasetss: Stores all the registered data sources

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BlackBoxDatasets]') AND type in (N'U'))
DROP TABLE [dbo].[BlackBoxDatasets]
GO

CREATE TABLE [dbo].[BlackBoxDatasets]
(
  [Name] [nvarchar](64) NOT NULL PRIMARY KEY,
  [Group] [nvarchar](64),
  [Flags] [nvarchar](256),  
  [Description] [nvarchar](2048),
  [TableName] [nvarchar](64),
  [StagedInstanceID] [int] NULL,
  [StatusID] [int],
  [Locked] [bit],
  [TimeStamp] datetime
)

GO

--------------------------------------------------------------------------------------------------------
-- dbo.BlackBoxDatasetUpdates: Records updated to staged data history from data sources

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BlackBoxDatasetUpdates]') AND type in (N'U'))
DROP TABLE [dbo].[BlackBoxDatasetUpdates]
GO

CREATE TABLE [dbo].[BlackBoxDatasetUpdates]
(
  [ID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
  [Name] [nvarchar](64),  
  [Group] [nvarchar](64),
  [Flags] [nvarchar](256),
  [Comment] [nvarchar](2048),
  [TableName] [nvarchar](64),    
  [DataSourceInstanceID] [int] NULL,  
  [DataSource] [nvarchar](64) NULL,   
  [Sheet] [nvarchar](64),
  [JOBID] [int] NULL,
  [GUID] [nvarchar](36) NULL,
  [Rows] int,
  [StatusID] int,    
  [TimeStamp] datetime
)

GO

DBCC CHECKIDENT ('dbo.BlackBoxDatasetUpdates', RESEED, 1000)
GO

---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************

----
---- BLACKBOX DATASET VIEWS
----

--------------------------------------------------------------------------------------------------------
-- dbo.vBlackBoxDatasets: View definiton for vBlackBoxDatasets

IF EXISTS (SELECT 1 FROM dbo.sysobjects WHERE id = object_id('dbo.vBlackBoxDatasets') AND OBJECTPROPERTY(id, 'IsView') = 1)
  DROP VIEW [dbo].[vBlackBoxDatasets]
GO

CREATE VIEW [dbo].[vBlackBoxDatasets] AS
  SELECT
    ds.[Name]
    ,ds.[Group]
    ,ds.[Flags]
    ,ds.[Description]
    ,ds.[TableName]    
    ,ds.[StagedInstanceID]    
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
       when ds.[StatusID] = 10 then 'archived'
       when ds.[StatusID] < 0 then 'error(' + convert(nvarchar(2),ds.[StatusID]) + ')'
       else 'unknown'
     end AS [Status]
    ,ds.[Locked]         
    ,case
       when ds.[Name] = 'DataMappings' then 'page_documentmap_32x32gray'
       when ds.[Name] = 'Contacts' then 'businessobjects_bo_contact_svg_dark_32x32'
       when ds.[Name] = 'ValidationLists' then 'format_listbullets_svg_dark_32x32'       
       when ds.[Name] = 'Assets' then 'businessobjects_bo_order_svg_dark_32x32'
       when ds.[Name] = 'Metrics' then 'iconbuilder_business_calculator_svg_dark_32x32'
       when ds.[Name] = 'Purchases' then 'businessobjects_bo_price_svg_dark_32x32'
       else 'iconbuilder_shopping_box_svg_dark_32x32'
     end AS [Icon]
    ,ds.[TimeStamp]
    ,DATEDIFF(day, ds.[TimeStamp], GetDate()) AS [Age]
    ,ROW_NUMBER() OVER(PARTITION BY ds.[Name] ORDER BY ds.[TimeStamp] desc) AS [Rank]
  FROM [dbo].[BlackBoxDatasets] AS ds

GO

--------------------------------------------------------------------------------------------------------
-- dbo.vBlackBoxDatasetUpdates: View definiton for vBlackBoxDatasetUpdates

IF EXISTS (SELECT 1 FROM dbo.sysobjects WHERE id = object_id('dbo.vBlackBoxDatasetUpdates') AND OBJECTPROPERTY(id, 'IsView') = 1)
 DROP VIEW [dbo].[vBlackBoxDatasetUpdates]
GO

CREATE VIEW [dbo].[vBlackBoxDatasetUpdates] AS
  SELECT
    du.[ID]
    ,du.[Name]
    ,du.[Group]
    ,du.[Flags]    
    ,du.[Comment]
    ,du.[TableName]
    ,du.[DataSourceInstanceID]
    ,du.[DataSource]
    ,bbf.[FID]
    ,du.[Sheet]    
    ,du.[JOBID]
    ,du.[GUID]
    ,du.[Rows]    
    ,du.[StatusID]
    ,case
       when du.[StatusID] is null then ''       
       when du.[StatusID] = 0 then 'null'
       when du.[StatusID] = 1 then 'filed'
       when du.[StatusID] = 2 then 'staged'
       when du.[StatusID] = 3 then 'validated'
       when du.[StatusID] = 4 then 'submitted'
       when du.[StatusID] = 5 then 'approved'       
       when du.[StatusID] = 6 then 'processed'
       when du.[StatusID] = 7 then 'processed' 
       when du.[StatusID] = 8 then 'locked'             
       when du.[StatusID] = 9 then 'withdrawn'
       when du.[StatusID] = 10 then 'archived'
       when du.[StatusID] < 0 then 'error(' + convert(nvarchar(2),du.[StatusID]) + ')'
       else 'unknown'
     end AS [Status]
    ,case
       when du.[Name] = 'DataMappings' then 'page_documentmap_32x32gray'
       when du.[Name] = 'Contacts' then 'businessobjects_bo_contact_svg_dark_32x32'       
       when du.[Name] = 'ValidationLists' then 'format_listbullets_svg_dark_32x32'
       when du.[Name] = 'Assets' then 'businessobjects_bo_order_svg_dark_32x32'
       when du.[Name] = 'Metrics' then 'iconbuilder_business_calculator_svg_dark_32x32'
       when du.[Name] = 'Purchases' then 'businessobjects_bo_price_svg_dark_32x32'
       else 'iconbuilder_shopping_box_svg_dark_32x32'
     end AS [Icon]
    ,bbj.[UserID]
    ,bbc.[FullName]
    ,du.[TimeStamp]
    ,DATEDIFF(day, du.[TimeStamp], GetDate()) AS [Age]
    ,ROW_NUMBER() OVER(PARTITION BY du.[Group],du.[Name] ORDER BY du.[TimeStamp] desc) AS [Rank]    
  FROM [dbo].[BlackBoxDatasetUpdates] AS du
  JOIN [dbo].[BlackBoxDataSourceInstances] AS dsi ON du.[DataSourceInstanceID] = dsi.[ID]
  JOIN [dbo].[BlackBoxFiles] AS bbf ON du.[DataSourceInstanceID] = bbf.[DataSourceInstanceID]  
  JOIN [dbo].[BlackBoxJobs] as bbj ON du.JOBID = bbj.JOBID
  LEFT OUTER JOIN [dbo].[sysContacts] AS bbc ON bbj.[UserID] = bbc.[ID]

GO

---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************

----
---- BLACKBOX DATASET TABLES
----

--------------------------------------------------------------------------------------------------------
-- dbo.BlackBoxDatasets: Add initial data sources to the BlackBoxDatasets table

PRINT 'Populate BlackBoxDatasets'

INSERT INTO [dbo].[BlackBoxDatasets] ([Name],[Group],[Flags],[Description],[TableName],[StagedInstanceID],[StatusID],[Locked],[TimeStamp])
VALUES ('DataMappings','System','system,singleton','DataMappings settings','sysDataMappings',0,0,0,'2022-03-06 21:40:58.867')

INSERT INTO [dbo].[BlackBoxDatasets] ([Name],[Group],[Flags],[Description],[TableName],[StagedInstanceID],[StatusID],[Locked],[TimeStamp])
VALUES ('Contacts','System','system','BlackBox contact data','sysContacts',0,0,0,'2022-03-06 21:40:58.867')

INSERT INTO [dbo].[BlackBoxDatasets] ([Name],[Group],[Flags],[Description],[TableName],[StagedInstanceID],[StatusID],[Locked],[TimeStamp])
VALUES ('ValidationLists','System','system','BlackBox list data','sysValidationLists',0,0,0,'2023-01-31 21:40:58.867')

GO

INSERT INTO [dbo].[BlackBoxDatasets] ([Name],[Group],[Flags],[Description],[TableName],[StagedInstanceID],[StatusID],[Locked],[TimeStamp])
VALUES ('Purchases','ITAM','','Purchases data','itamPurchases',0,0,0,'2022-03-06 21:40:58.867')

INSERT INTO [dbo].[BlackBoxDatasets] ([Name],[Group],[Flags],[Description],[TableName],[StagedInstanceID],[StatusID],[Locked],[TimeStamp])
VALUES ('Assets','ITAM','','Assets data','itamAssets',0,0,0,'2022-03-06 21:40:58.867')

GO

INSERT INTO [dbo].[BlackBoxDatasets] ([Name],[Group],[Flags],[Description],[TableName],[StagedInstanceID],[StatusID],[Locked],[TimeStamp])
VALUES ('Metrics','Metrics','','Metrics data','dataMetrics',0,0,0,'2022-03-06 22:11:30.700')

GO

--------------------------------------------------------------------------------------------------------
-- dbo.BlackBoxDatasetUpdates: Add sample data set instances to the BlackBoxDatasetUpdates table

--SET IDENTITY_INSERT [dbo].[BlackBoxDatasetUpdates] ON
--GO

--DECLARE @JobGUID [nvarchar](36)
--SET @JobGUID = '00000000-0000-0000-0000-000000000000'

--SET @ID = 1, @FileNumber = 1, @JobNumber = 0
--INSERT INTO [dbo].[BlackBoxDatasetUpdates] ([ID],[Name],[Group],[Flags],[Comment],[TableName],[DataSourceInstanceID],[DataSource],[JOBID],[GUID],[Rows],[StatusID],[TimeStamp])
--VALUES (1,'System','System','system','System data initialised','sysDataMappings',1,'System',0,@JobGUID,52,2,'2023-01-30 21:40:58.867')

--SET @ID = 2, @FileNumber = 2, @JobNumber = 0
--INSERT INTO [dbo].[BlackBoxDatasetUpdates] ([ID],[Name],[Group],[Flags],[Comment],[TableName],[DataSourceInstanceID],[DataSource],[JOBID],[GUID],[Rows],[StatusID],[TimeStamp])
--VALUES (2,'Contacts','Manager','system','BlackBox contacts initialised','sysContacts',2,'Contacts',0,@JobGUID,6,2,'2023-01-30 21:40:58.867')

--SET @ID = 3, @FileNumber = 3, @JobNumber = 0
--INSERT INTO [dbo].[BlackBoxDatasetUpdates] ([ID],[Name],[Group],[Flags],[Comment],[TableName],[DataSourceInstanceID],[DataSource],[JOBID],[GUID],[Rows],[StatusID],[TimeStamp])
--VALUES (3,'ValidationLists','Manager','system','BlackBox lists initialised','sysValidationLists',3,'Lists',0,@JobGUID,1001,2,'2023-01-30 21:40:58.867')

--SET @JobGUID = '55555555-5555-5555-5555-555555555555'

--GO

--SET IDENTITY_INSERT [dbo].[BlackBoxDatasetUpdates] OFF
--GO

---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************

----
---- BLACKBOX DATASET TABLES (EXTRAS NOT USED AT RIO)
----

--------------------------------------------------------------------------------------------------------
-- dbo.BlackBoxDatasets: Add initial data sources to the BlackBoxDatasets table

--PRINT 'Populate Extra BlackBoxDatasets'

--INSERT INTO [dbo].[BlackBoxDatasets] ([Name],[Group],[Flags],[Description],[TableName],[Template],[Tab],[StatusID],[Locked],[TimeStamp])
--VALUES ('SplunkUsage','Inventory','','Splunk usage data','invSplunkUsage','','',0,0,'2022-03-06 21:40:58.867')

--INSERT INTO [dbo].[BlackBoxDatasets] ([Name],[Group],[Flags],[Description],[TableName],[Template],[Tab],[StatusID],[Locked],[TimeStamp])
--VALUES ('ControlMUsage','Inventory','','ControLM usage data','invControlMUsage','','',0,0,'2022-03-06 21:40:58.867')

--INSERT INTO [dbo].[BlackBoxDatasets] ([Name],[Group],[Flags],[Description],[TableName],[Template],[Tab],[StatusID],[Locked],[TimeStamp])
--VALUES ('LicenseCustomMetric','Metrics','','LicenseCustomMetric data','dataLicenseCustomMetric','','',0,0,'2022-03-06 22:47:41.123')

--GO

--INSERT INTO [dbo].[BlackBoxDatasets] ([Name],[Group],[Flags],[Description],[TableName],[Template],[Tab],[StatusID],[Locked],[TimeStamp])
--VALUES ('CPU','Inventory','','rvCPU inventory','rvCPU','','',0,0,'2022-03-06 22:11:30.700')

--INSERT INTO [dbo].[BlackBoxDatasets] ([Name],[Group],[Flags],[Description],[TableName],[Template],[Tab],[StatusID],[Locked],[TimeStamp])
--VALUES ('Host','Inventory','','rvHost inventory','rvHost','','',0,0,'2022-03-06 22:47:41.123')

--INSERT INTO [dbo].[BlackBoxDatasets] ([Name],[Group],[Flags],[Description],[TableName],[Template],[Tab],[StatusID],[Locked],[TimeStamp])
--VALUES ('Info','Inventory','','rvInfo inventory','rvInfo','','',0,0,'2022-02-22 20:00:00.123')

--INSERT INTO [dbo].[BlackBoxDatasets] ([Name],[Group],[Flags],[Description],[TableName],[Template],[Tab],[StatusID],[Locked],[TimeStamp])
--VALUES ('Cluster','Inventory','','rvCluster inventory','rvCluster','','',0,0,'2022-02-22 20:00:00.123')

--GO

---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************
