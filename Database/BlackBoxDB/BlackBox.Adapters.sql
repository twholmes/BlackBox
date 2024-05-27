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
---- BLACKBOX ADAPTER TABLES
----

--------------------------------------------------------------------------------------------------------
-- dbo.BlackBoxAdapterTypes: Reference table for data source types

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BlackBoxAdapterTypes]') AND type in (N'U'))
DROP TABLE [dbo].[BlackBoxAdapterTypes]
GO

CREATE TABLE [dbo].[BlackBoxAdapterTypes]
(
  [TypeID] int NOT NULL PRIMARY KEY,
  [TypeName] [nvarchar](256),
  [TypeDescription] [nvarchar](2048),
)
GO

-- included so these statements can be run independantly of a rebuild
DELETE FROM [dbo].[BlackBoxAdapterTypes]
GO

INSERT INTO [dbo].[BlackBoxAdapterTypes] ([TypeID],[TypeName],[TypeDescription])
VALUES (0, '','null adapter')

INSERT INTO [dbo].[BlackBoxAdapterTypes] ([TypeID],[TypeName],[TypeDescription])
VALUES (1, 'business','Standard business adapter')

INSERT INTO [dbo].[BlackBoxAdapterTypes] ([TypeID],[TypeName],[TypeDescription])
VALUES (2, 'api','API script adapter')

INSERT INTO [dbo].[BlackBoxAdapterTypes] ([TypeID],[TypeName],[TypeDescription])
VALUES (3, 'script','Powershell script adapter')

INSERT INTO [dbo].[BlackBoxAdapterTypes] ([TypeID],[TypeName],[TypeDescription])
VALUES (9, 'fnms','FNMS legacy adapter')

GO

--------------------------------------------------------------------------------------------------------
-- dbo.BlackBoxAdapterStatus: Reference table for data source status

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BlackBoxAdapterStatus]') AND type in (N'U'))
DROP TABLE [dbo].[BlackBoxAdapterStatus]
GO

CREATE TABLE [dbo].[BlackBoxAdapterStatus]
(
  [StatusID] int NOT NULL PRIMARY KEY,
  [Status] [nvarchar](256)
)
GO

-- included so these statements can be run independantly of a rebuild
DELETE FROM [dbo].[BlackBoxAdapterStatus]
GO

INSERT INTO [dbo].[BlackBoxAdapterStatus] ([StatusID],[Status])
VALUES (0, 'null')

INSERT INTO [dbo].[BlackBoxAdapterStatus] ([StatusID],[Status])
VALUES (1, 'approved')

INSERT INTO [dbo].[BlackBoxAdapterStatus] ([StatusID],[Status])
VALUES (2, 'unapproved')

INSERT INTO [dbo].[BlackBoxAdapterStatus] ([StatusID],[Status])
VALUES (9, 'archived')

GO


--------------------------------------------------------------------------------------------------------
-- dbo.BlackBoxAdapters: Stores all the registered adapters

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BlackBoxAdapters]') AND type in (N'U'))
DROP TABLE [dbo].[BlackBoxAdapters]
GO

CREATE TABLE [dbo].[BlackBoxAdapters]
(
  [ImportName] [nvarchar](64) NOT NULL PRIMARY KEY,
  [Type] [nvarchar](64),  
  [Status] [nvarchar](64),
  [AdapterFullPath] [nvarchar](1024),  
  [DisplayName] [nvarchar](64),  
  [DisplayDescription] [nvarchar](2048),
  [UploadFileType] [nvarchar](8),
  [TemplateFileName] [nvarchar](256),  
  [ConfigFile] [nvarchar](256),
  [Group] [nvarchar](64),
  [DataSource] [nvarchar](64),
  [Dataset] [nvarchar](64),
  [TableName] [nvarchar](64),
  [TimeStamp] datetime
)

GO

---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************

----
---- BLACKBOX DATA SOURCE VIEWS
----

--------------------------------------------------------------------------------------------------------
-- dbo.vBlackBoxAdapters View definiton for vBlackBoxAdapters

IF EXISTS (SELECT 1 FROM dbo.sysobjects WHERE id = object_id('dbo.vBlackBoxAdapters') AND OBJECTPROPERTY(id, 'IsView') = 1)
  DROP VIEW [dbo].[vBlackBoxAdapters]
GO

CREATE VIEW [dbo].[vBlackBoxAdapters] AS
  SELECT
    ds.[ImportName]
    ,ds.[DisplayName]
    ,ds.[DisplayDescription]
    ,ds.[UploadFileType]   
    ,ds.[TemplateFileName]
    ,ds.[ConfigFile]
    ,ds.[Group]
    ,ds.[DataSource]
    ,ds.[Dataset]
    ,ds.[TableName]
    ,ds.[Status]
    ,case
       when ds.[Status] = '' then 0
       when ds.[Status] = 'approved' then 1
       when ds.[Status] = 'unapproved' then 2
       when ds.[Status] = 'archived' then 9       
       else 0
     end AS [StatusID]
    ,ds.[Type]     
    ,case
       when ds.[Type] = '' then 0
       when ds.[Type] = 'business' then 1
       when ds.[Type] = 'api' then 2
       when ds.[Type] = 'script' then 3
       when ds.[Type] = 'fnms' then 9
       else 0
     end AS [TypeID]
    ,case
       when ds.[ImportName] = 'System' then 'dashboards_servermode_svg_dark_32x32'
       when ds.[ImportName] = 'Contacts' then 'businessobjects_bo_contact_svg_dark_32x32'       
       when ds.[ImportName] = 'ValidationLists' then 'format_listbullets_svg_dark_32x32'
       when ds.[ImportName] = 'Assets' then 'businessobjects_bo_order_svg_dark_32x32'
       when ds.[ImportName] = 'Metrics' then 'iconbuilder_business_calculator_svg_dark_32x32'
       when ds.[ImportName] = 'Purchases' then 'businessobjects_bo_price_svg_dark_32x32'
       when ds.[ImportName] = 'AssetCriticality' then 'businessobjects_bo_opportunity_svg_dark_32x32'
       when ds.[ImportName] = 'SiteAssetApplications' then 'dashboards_editrules_svg_dark_32x32'
       else 'iconbuilder_shopping_box_svg_dark_32x32'
     end AS [Icon]     
    ,ds.[TimeStamp]
    ,DATEDIFF(day, ds.[TimeStamp], GetDate()) AS [Age]
  FROM [dbo].[BlackBoxAdapters] AS ds

GO


---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************

----
---- BLACKBOX DATA SOURCE TABLES
----

--------------------------------------------------------------------------------------------------------
-- dbo.BlackBoxAdapters: Add initial data sources to the BlackBoxAdapters table

PRINT 'Populate BlackBoxAdapters'

INSERT INTO [dbo].[BlackBoxAdapters] ([ImportName],[DisplayName],[DisplayDescription],[UploadFileType],[TemplateFileName],[ConfigFile],[Group],[DataSource],[Dataset],[TableName],[Status],[Type],[TimeStamp])
VALUES ('DataMappings','DataMappings','BlackBox data mappings data','xlsx','Template-System-v1.0.xslx','mgsbi.xml','System','System','DataMappings','sysDataMappings','business','approved','2022-03-06 21:40:58.867')

INSERT INTO [dbo].[BlackBoxAdapters] ([ImportName],[DisplayName],[DisplayDescription],[UploadFileType],[TemplateFileName],[ConfigFile],[Group],[DataSource],[Dataset],[TableName],[Type],[Status],[TimeStamp])
VALUES ('ValidationLists','ValidationLists','BlackBox validation data','xlsx','Template-System-v1.0.xslx','mgsbi.xml','System','System','ValidationLists','sysValidationLists','business','approved','2022-03-06 21:40:58.867')

INSERT INTO [dbo].[BlackBoxAdapters] ([ImportName],[DisplayName],[DisplayDescription],[UploadFileType],[TemplateFileName],[ConfigFile],[Group],[DataSource],[Dataset],[TableName],[Type],[Status],[TimeStamp])
VALUES ('Contacts','Contacts','BlackBox contact data','xlsx','Template-Contacts-v1.0.xlsx','mgsbi.xml','System','Contacts','Contracts','sysContracts','business','approved','2022-03-06 21:40:58.867')

GO

INSERT INTO [dbo].[BlackBoxAdapters] ([ImportName],[DisplayName],[DisplayDescription],[UploadFileType],[TemplateFileName],[ConfigFile],[Group],[DataSource],[Dataset],[TableName],[Type],[Status],[TimeStamp])
VALUES ('Purchases','Purchases','Purchases data','xlsx','Template-Purchases-v1.0.xlsx','mgsbi.xml','ITAM','Purchases','Purchases','itamPurchases','business','approved','2022-03-06 21:40:58.867')

INSERT INTO [dbo].[BlackBoxAdapters] ([ImportName],[DisplayName],[DisplayDescription],[UploadFileType],[TemplateFileName],[ConfigFile],[Group],[DataSource],[Dataset],[TableName],[Type],[Status],[TimeStamp])
VALUES ('Assets','Assets','Assets data','xlsx','Template-Assets-v1.0','mgsbi.xml','ITAM','Assets','Assets','itamAssets','business','approved','2022-02-22 20:00:00.123')

GO

INSERT INTO [dbo].[BlackBoxAdapters] ([ImportName],[DisplayName],[DisplayDescription],[UploadFileType],[TemplateFileName],[ConfigFile],[Group],[DataSource],[Dataset],[TableName],[Type],[Status],[TimeStamp])
VALUES ('Metrics','Metrics','Metrics data','xlsx','Template-Metrics-v1.0.xlsx','mgsbi.xml','Metrics','Metrics','Metrics','dataMetrics','business','approved','2022-03-06 22:11:30.700')

GO

---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************

----
---- BLACKBOX DATA SOURCE TABLES (not used at RIO)
----

--------------------------------------------------------------------------------------------------------
-- dbo.BlackBoxAdapters: Add initial data sources to the BlackBoxAdapters table

PRINT 'Populate Extra BlackBoxAdapters'


---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************
