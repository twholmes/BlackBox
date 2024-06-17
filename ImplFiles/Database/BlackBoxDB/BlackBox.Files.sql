--------------------------------------------------------------------------------------
-- Copyright (C) 2024 Crayon
-- BLACKBOX CONFIGURATION
-- This file configures BlackBox for data file recording and transactions 
--
--------------------------------------------------------------------------------------

USE $(DBName)
GO

---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************

----
---- BLACKBOX FILES TABLES
----

--------------------------------------------------------------------------------------------------------
-- dbo.BlackBoxFileStatus: Reference table for uploaded file status

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BlackBoxFileStatus]') AND type in (N'U'))
DROP TABLE [dbo].[BlackBoxFileStatus]
GO

CREATE TABLE [dbo].[BlackBoxFileStatus]
(
  [StatusID] int NOT NULL PRIMARY KEY,
  [Status] [nvarchar](256)
)

GO

-- included so these statements can be run independantly of a rebuild
DELETE FROM [dbo].[BlackBoxFileStatus]
GO

INSERT INTO [dbo].[BlackBoxFileStatus] ([StatusID],[Status])
VALUES (0, 'null')

INSERT INTO [dbo].[BlackBoxFileStatus] ([StatusID],[Status])
VALUES (1, 'filed')

INSERT INTO [dbo].[BlackBoxFileStatus] ([StatusID],[Status])
VALUES (2, 'pending')

INSERT INTO [dbo].[BlackBoxFileStatus] ([StatusID],[Status])
VALUES (3, 'loaded')

INSERT INTO [dbo].[BlackBoxFileStatus] ([StatusID],[Status])
VALUES (4, 'validated')

INSERT INTO [dbo].[BlackBoxFileStatus] ([StatusID],[Status])
VALUES (5, 'staged')

INSERT INTO [dbo].[BlackBoxFileStatus] ([StatusID],[Status])
VALUES (6, 'processed')

INSERT INTO [dbo].[BlackBoxFileStatus] ([StatusID],[Status])
VALUES (7, 'published')

INSERT INTO [dbo].[BlackBoxFileStatus] ([StatusID],[Status])
VALUES (8, 'locked')

INSERT INTO [dbo].[BlackBoxFileStatus] ([StatusID],[Status])
VALUES (9, 'withdrawn')

INSERT INTO [dbo].[BlackBoxFileStatus] ([StatusID],[Status])
VALUES (10, 'archived')

GO


--------------------------------------------------------------------------------------------------------
-- dbo.BlackBoxUploadedFiles: Records all file uploaded

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BlackBoxFiles]') AND type in (N'U'))
DROP TABLE [dbo].[BlackBoxFiles]
GO

CREATE TABLE [dbo].[BlackBoxFiles]
(
  [FID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
  [JOBID] int NOT NULL,  
  [GUID] [nvarchar](36) NOT NULL,  
  [Name] [nvarchar](128),
  [Location] [nvarchar](1024),
  [TypeID] int,
  [Group] [nvarchar](64),  
  [Description] [nvarchar](2048),
  [DataSource] [nvarchar](64),
  [DataSourceInstanceID] int NOT NULL,    
  [Datasets] [nvarchar](2048),  
  [StatusID] int, 
  [Locked] bit,       
  [TimeStamp] datetime
)

GO

DBCC CHECKIDENT ('dbo.BlackBoxFiles', RESEED, 1000)
GO

----
---- BLACKBOX UPLOADEDFILE VIEWS
----

--------------------------------------------------------------------------------------------------------
-- dbo.vBlackBoxFile: View definiton for vBlackBoxFile

IF EXISTS (SELECT 1 FROM dbo.sysobjects WHERE id = object_id('dbo.vBlackBoxFiles') AND OBJECTPROPERTY(id, 'IsView') = 1)
  DROP VIEW [dbo].[vBlackBoxFiles]
GO

CREATE VIEW [dbo].[vBlackBoxFiles] AS
  SELECT
    uf.[FID]
    ,uf.[JOBID]    
    ,uf.[GUID]
    ,uf.[Name]
    ,uf.[Location]
    ,uf.[TypeID]
    ,case
       when uf.[TypeID] is null then ''
       when uf.[TypeID] = 0 then 'ready'
       when uf.[TypeID] = 1 then 'sql'
       when uf.[TypeID] = 2 then 'ps1'
       when uf.[TypeID] = 3 then 'js'
       when uf.[TypeID] = 4 then 'csv'
       when uf.[TypeID] = 5 then 'xlsx'
       when uf.[TypeID] = 6 then 'xml'
       when uf.[TypeID] = 7 then 'blackbox'
       when uf.[TypeID] = 8 then 'fnms'
       when uf.[TypeID] > 8 then 'unknown'
       when uf.[TypeID] < 0 then 'error(' + convert(nvarchar(2),uf.[TypeID]) + ')'
       else 'unknown'
     end AS [Type]
    ,uf.[Group]
    ,uf.[Description]
    ,uf.[DataSource]
    ,uf.[DataSourceInstanceID]
    ,case
       when uf.[DataSource] = 'System' then 'dashboards_servermode_svg_dark_32x32'
       when uf.[DataSource] = 'Contacts' then 'businessobjects_bo_contact_svg_dark_32x32'
       when uf.[DataSource] = 'Lists' then 'format_listbullets_svg_dark_32x32'              
       when uf.[DataSource] = 'Assets' then 'businessobjects_bo_order_svg_dark_32x32'
       when uf.[DataSource] = 'Metrics' then 'iconbuilder_business_calculator_svg_dark_32x32'
       when uf.[DataSource] = 'Purchases' then 'businessobjects_bo_price_svg_dark_32x32'
       when uf.[DataSource] = 'AssetCriticality' then 'businessobjects_bo_opportunity_svg_dark_32x32'
       when uf.[DataSource] = 'SitAssetApplications' then 'dashboards_editrules_svg_dark_32x32'
       else 'iconbuilder_shopping_box_svg_dark_32x32'
     end AS [Icon]     
    ,uf.[Datasets]    
    ,uf.[StatusID]
    ,case
       when uf.[StatusID] is null then ''       
       when uf.[StatusID] = 0 then 'null'
       when uf.[StatusID] = 1 then 'filed'
       when uf.[StatusID] = 2 then 'pending'
       when uf.[StatusID] = 3 then 'loaded'       
       when uf.[StatusID] = 4 then 'validated'       
       when uf.[StatusID] = 5 then 'staged'
       when uf.[StatusID] = 6 then 'processing'
       when uf.[StatusID] = 7 then 'published' 
       when uf.[StatusID] = 8 then 'locked'             
       when uf.[StatusID] = 9 then 'withdrawn'
       when uf.[StatusID] = 10 then 'archived'       
       when uf.[StatusID] < 0 then 'error(' + convert(nvarchar(2),uf.[StatusID]) + ')'
       else 'unknown'
     end AS [Status]
    ,uf.[Locked]
    ,uj.[UserID]
    ,uf.[TimeStamp]
    ,DATEDIFF(day, uf.[TimeStamp], GetDate()) AS [Age]
    ,ROW_NUMBER() OVER(PARTITION BY uf.[GUID] ORDER BY uf.[TimeStamp] desc) AS [Rank]    
  FROM [dbo].[BlackBoxFiles] AS uf
  INNER JOIN [dbo].[BlackBoxJobs] AS uj ON uj.[JobID] = uf.[JobID]

GO


---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************
