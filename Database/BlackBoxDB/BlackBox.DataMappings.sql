--------------------------------------------------------------------------------------
-- Copyright (C) 2024 Crayon
-- BLACKBOX CONFIGURATION
-- This file configures BlackBox for data mapping
--
--------------------------------------------------------------------------------------

USE $(DBName)
GO

---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************

----
---- BLACKBOX DATASET MAPPINGS TABLES
----

--------------------------------------------------------------------------------------------------------
PRINT '>>> dbo.sysDataMappings: Mappings for all BlackBox table fields'

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sysDataMappings]') AND type in (N'U'))
DROP TABLE [dbo].[sysDataMappings]
GO

CREATE TABLE [dbo].[sysDataMappings]
(
  [ID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
  [JobID] [int] NULL,
  [DataSourceInstanceID] [int] NULL,
  [LineNumber] [int] NULL,
  [Exclude] [nvarchar](4) NULL,
  [FlexeraID] [int] NULL,
  [DataSource] [nvarchar](128) NOT NULL,  
  [SourceDataset] [nvarchar](128) NOT NULL,    
  [Field] [nvarchar](128) NOT NULL,
  [TableName] [nvarchar](128) NOT NULL,
  [Column] [nvarchar](128) NOT NULL,
  [Mandatory] bit,  
  [Flags] [nvarchar](128) NULL,
  [Type] [nvarchar](32) NOT NULL, 
  [Size] [int],
  [Convert] [nvarchar](256),
  [DisplayWidth] [nvarchar](1024)
)

GO

DBCC CHECKIDENT ('dbo.sysDataMappings', RESEED, 1000)
GO

--------------------------------------------------------------------------------------------------------
PRINT '>>> dbo.stagedDataMappings: Mappings for all BlackBox table fields'

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stagedDataMappings]') AND type in (N'U'))
DROP TABLE [dbo].[stagedDataMappings]
GO

CREATE TABLE [dbo].[stagedDataMappings]
(
  [StagedID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
  [ID] [int] NULL,
  [JobID] [int] NULL,
  [DataSourceInstanceID] [int] NULL,
  [LineNumber] [int] NULL,
  [FlexeraID] [int] NULL,
  [DataSource] [nvarchar](128) NOT NULL,  
  [SourceDataset] [nvarchar](128) NOT NULL,    
  [Field] [nvarchar](128) NOT NULL,
  [TableName] [nvarchar](128) NOT NULL,
  [Column] [nvarchar](128) NOT NULL,
  [Mandatory] bit,  
  [Flags] [nvarchar](128) NULL,
  [Type] [nvarchar](32) NOT NULL, 
  [Size] [int],
  [Convert] [nvarchar](256),
  [DisplayWidth] [nvarchar](1024)
)

GO

DBCC CHECKIDENT ('dbo.stagedDataMappings', RESEED, 1000)
GO

---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************

--------------------------------------------------------------------------------------------------------
PRINT '>>> dbo.srcDataColumnMappings: Mappings for all BlackBox table fields'

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[srcDataColumnMappings]') AND type in (N'U'))
DROP TABLE [dbo].[srcDataColumnMappings]
GO

CREATE TABLE [dbo].[srcDataColumnMappings]
(
  [ID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
  [JobID] [int] NOT NULL,
  [DataSourceInstanceID] [int] NOT NULL,
  [SourceDataset] [nvarchar](128) NOT NULL,
  [Field] [nvarchar](128) NOT NULL,
  [DataType] [nvarchar](32) NOT NULL,
  [Rows] [int] NOT NULL
)
CREATE INDEX [IX_srcDataColumnMappings_JobID_DataSourceInstanceID_SourceDataset_Field] ON [dbo].[srcDataColumnMappings](JobID,DataSourceInstanceID,SourceDataset,[Field])

GO

DBCC CHECKIDENT ('dbo.srcDataColumnMappings', RESEED, 1000)
GO


---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************

--------------------------------------------------------------------------------------------------------
PRINT '>>> dbo.StageDataMappings: Create stored procedure'

IF EXISTS(SELECT 1 FROM sys.procedures WHERE Name = 'StageDataMappings')
  DROP PROCEDURE [dbo].[StageDataMappings]
GO

CREATE PROCEDURE [dbo].[StageDataMappings]
  @DataSourceInstanceID [int] = 0,
  @JobID int = 0,   
  @SourceDataset [nvarchar](100) = '%',
  @KeepExisting [bit] = 0
AS
  PRINT 'Stage DataMappings'
  
  IF @KeepExisting = 0
  BEGIN
    DELETE FROM [dbo].[stagedDataMappings] WHERE [SourceDataset] like @SourceDataset
  END
  
  INSERT INTO [dbo].[stagedDataMappings]
  SELECT  
    [ID],[JobID],[DataSourceInstanceID],[LineNumber],[FlexeraID]      
    ,[DataSource],[SourceDataset],[Field],[TableName],[Column],[Mandatory],[Flags],[Type],[Size],[Convert],[DisplayWidth]
  FROM [dbo].[sysDataMappings]
  WHERE [SourceDataset] like @SourceDataset AND [DataSourceInstanceID] = @DataSourceInstanceID AND LEFT(LOWER([Exclude]),1) != 'y'

GO

---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************

--------------------------------------------------------------------------------------------------------
PRINT '>>> dbo.sysDataMappings: Populate with required default data'

SET IDENTITY_INSERT [dbo].[sysDataMappings] ON
GO

--SET @JobNumber = 0, @DataSourceInstanceID = 0
INSERT INTO [dbo].[sysDataMappings] ([ID],[Exclude],[DataSource],[SourceDataset],[Field],[TableName],[Column],[Mandatory],[Flags],[Type],[Size],[Convert],[DisplayWidth]) 
VALUES (1,'n','DataMappings','DataMappings','DataSource','sysDataMappings','DataSource',0,'','nvarchar',128,'[{0}]','150px')

--SET @JobNumber = 0, @DataSourceInstanceID = 0
INSERT INTO [dbo].[sysDataMappings] ([ID],[Exclude],[DataSource],[SourceDataset],[Field],[TableName],[Column],[Mandatory],[Flags],[Type],[Size],[Convert],[DisplayWidth]) 
VALUES (2,'n','DataMappings','DataMappings','SourceDataset','sysDataMappings','SourceDataset',0,'','nvarchar',128,'[{0}]','150px')

--SET @JobNumber = 0, @DataSourceInstanceID = 0
INSERT INTO [dbo].[sysDataMappings] ([ID],[Exclude],[DataSource],[SourceDataset],[Field],[TableName],[Column],[Mandatory],[Flags],[Type],[Size],[Convert],[DisplayWidth]) 
VALUES (3,'n','DataMappings','DataMappings','Field','sysDataMappings','Field',0,'','nvarchar',128,'[{0}]','150px')

--SET @JobNumber = 0, @DataSourceInstanceID = 0
INSERT INTO [dbo].[sysDataMappings] ([ID],[Exclude],[DataSource],[SourceDataset],[Field],[TableName],[Column],[Mandatory],[Flags],[Type],[Size],[Convert],[DisplayWidth]) 
VALUES (4,'n','DataMappings','DataMappings','Dataset','sysDataMappings','Dataset',0,'','nvarchar',128,'[{0}]','150px')

--SET @JobNumber = 0, @DataSourceInstanceID = 0
INSERT INTO [dbo].[sysDataMappings] ([ID],[Exclude],[DataSource],[SourceDataset],[Field],[TableName],[Column],[Mandatory],[Flags],[Type],[Size],[Convert],[DisplayWidth]) 
VALUES (5,'n','DataMappings','DataMappings','Column','sysDataMappings','Column',0,'','nvarchar',128,'[{0}]','150px')

--SET @JobNumber = 0, @DataSourceInstanceID = 0
INSERT INTO [dbo].[sysDataMappings] ([ID],[Exclude],[DataSource],[SourceDataset],[Field],[TableName],[Column],[Mandatory],[Flags],[Type],[Size],[Convert],[DisplayWidth]) 
VALUES (6,'n','DataMappings','DataMappings','Flags','sysDataMappings','Flags',0,'','nvarchar',128,'[{0}]','150px')

--SET @JobNumber = 0, @DataSourceInstanceID = 0
INSERT INTO [dbo].[sysDataMappings] ([ID],[Exclude],[DataSource],[SourceDataset],[Field],[TableName],[Column],[Mandatory],[Flags],[Type],[Size],[Convert],[DisplayWidth]) 
VALUES (7,'n','DataMappings','DataMappings','Type','sysDataMappings','Type',0,'','nvarchar',32,'[{0}]','150px')

--SET @JobNumber = 0, @DataSourceInstanceID = 0
INSERT INTO [dbo].[sysDataMappings] ([ID],[Exclude],[DataSource],[SourceDataset],[Field],[TableName],[Column],[Mandatory],[Flags],[Type],[Size],[Convert],[DisplayWidth]) 
VALUES (8,'n','DataMappings','DataMappings','Size','sysDataMappings','Size',0,'','int',0,'convert(int,[{0}])','150px')

--SET @JobNumber = 0, @DataSourceInstanceID = 0
INSERT INTO [dbo].[sysDataMappings] ([ID],[Exclude],[DataSource],[SourceDataset],[Field],[TableName],[Column],[Mandatory],[Flags],[Type],[Size],[Convert],[DisplayWidth]) 
VALUES (9,'n','DataMappings','DataMappings','Convert','sysDataMappings','Convert',0,'','nvarchar',256,'[{0}]','150px')

--SET @JobNumber = 0, @DataSourceInstanceID = 0
INSERT INTO [dbo].[sysDataMappings] ([ID],[Exclude],[DataSource],[SourceDataset],[Field],[TableName],[Column],[Mandatory],[Flags],[Type],[Size],[Convert],[DisplayWidth]) 
VALUES (10,'n','DataMappings','DataMappings','Dummy','sysDataMappings','Dummy',0,'','nvarchar',1024,'[{0}]','150px')

GO

SET IDENTITY_INSERT [dbo].[sysDataMappings] OFF
GO

UPDATE [dbo].[sysDataMappings] SET [JobID]=0, [DataSourceInstanceID]=1, [LineNumber]=[ID], [Exclude]='n', [FlexeraID]=0
WHERE [SourceDataset] = 'DataMappings'
GO


--------------------------------------------------------------------------------------------------------
-- dbo.stagedDataMappings: Populate with required default data

SET IDENTITY_INSERT [dbo].[stagedDataMappings] ON
GO

--SET @JobNumber = 0, @DataSourceInstanceID = 0
INSERT INTO [dbo].[stagedDataMappings] ([StagedID],[ID],[DataSource],[SourceDataset],[Field],[TableName],[Column],[Mandatory],[Flags],[Type],[Size],[Convert],[DisplayWidth]) 
VALUES (1,1,'DataMappings','DataMappings','DataSource','sysDataMappings','DataSource',0,'','nvarchar',128,'[{0}]','150px')

--SET @JobNumber = 0, @DataSourceInstanceID = 0
INSERT INTO [dbo].[stagedDataMappings] ([StagedID],[ID],[DataSource],[SourceDataset],[Field],[TableName],[Column],[Mandatory],[Flags],[Type],[Size],[Convert],[DisplayWidth]) 
VALUES (2,2,'DataMappings','DataMappings','SourceDataset','sysDataMappings','SourceDataset',0,'','nvarchar',128,'[{0}]','150px')

--SET @JobNumber = 0, @DataSourceInstanceID = 0
INSERT INTO [dbo].[stagedDataMappings] ([StagedID],[ID],[DataSource],[SourceDataset],[Field],[TableName],[Column],[Mandatory],[Flags],[Type],[Size],[Convert],[DisplayWidth]) 
VALUES (3,3,'DataMappings','DataMappings','Field','sysDataMappings','Field',0,'','nvarchar',128,'[{0}]','150px')

--SET @JobNumber = 0, @DataSourceInstanceID = 0
INSERT INTO [dbo].[stagedDataMappings] ([StagedID],[ID],[DataSource],[SourceDataset],[Field],[TableName],[Column],[Mandatory],[Flags],[Type],[Size],[Convert],[DisplayWidth]) 
VALUES (4,4,'DataMappings','DataMappings','Dataset','sysDataMappings','Dataset',0,'','nvarchar',128,'[{0}]','150px')

--SET @JobNumber = 0, @DataSourceInstanceID = 0
INSERT INTO [dbo].[stagedDataMappings] ([StagedID],[ID],[DataSource],[SourceDataset],[Field],[TableName],[Column],[Mandatory],[Flags],[Type],[Size],[Convert],[DisplayWidth]) 
VALUES (5,5,'DataMappings','DataMappings','Column','sysDataMappings','Column',0,'','nvarchar',128,'[{0}]','150px')

--SET @JobNumber = 0, @DataSourceInstanceID = 0
INSERT INTO [dbo].[stagedDataMappings] ([StagedID],[ID],[DataSource],[SourceDataset],[Field],[TableName],[Column],[Mandatory],[Flags],[Type],[Size],[Convert],[DisplayWidth]) 
VALUES (6,6,'DataMappings','DataMappings','Flags','sysDataMappings','Flags',0,'','nvarchar',128,'[{0}]','150px')

--SET @JobNumber = 0, @DataSourceInstanceID = 0
INSERT INTO [dbo].[stagedDataMappings] ([StagedID],[ID],[DataSource],[SourceDataset],[Field],[TableName],[Column],[Mandatory],[Flags],[Type],[Size],[Convert],[DisplayWidth]) 
VALUES (7,7,'DataMappings','DataMappings','Type','sysDataMappings','Type',0,'','nvarchar',32,'[{0}]','150px')

--SET @JobNumber = 0, @DataSourceInstanceID = 0
INSERT INTO [dbo].[stagedDataMappings] ([StagedID],[ID],[DataSource],[SourceDataset],[Field],[TableName],[Column],[Mandatory],[Flags],[Type],[Size],[Convert],[DisplayWidth]) 
VALUES (8,8,'DataMappings','DataMappings','Size','sysDataMappings','Size',0,'','int',0,'convert(int,[{0}])','150px')

--SET @JobNumber = 0, @DataSourceInstanceID = 0
INSERT INTO [dbo].[stagedDataMappings] ([StagedID],[ID],[DataSource],[SourceDataset],[Field],[TableName],[Column],[Mandatory],[Flags],[Type],[Size],[Convert],[DisplayWidth]) 
VALUES (9,9,'DataMappings','DataMappings','Convert','sysDataMappings','Convert',0,'','nvarchar',256,'[{0}]','150px')

--SET @JobNumber = 0, @DataSourceInstanceID = 0
INSERT INTO [dbo].[stagedDataMappings] ([StagedID],[ID],[DataSource],[SourceDataset],[Field],[TableName],[Column],[Mandatory],[Flags],[Type],[Size],[Convert],[DisplayWidth]) 
VALUES (10,10,'DataMappings','DataMappings','Dummy','sysDataMappings','Dummy',0,'','nvarchar',1024,'[{0}]','150px')

GO

SET IDENTITY_INSERT [dbo].[stagedDataMappings] OFF
GO

UPDATE [dbo].[stagedDataMappings] SET [JobID]=0, [DataSourceInstanceID]=1, [LineNumber]=[ID], [FlexeraID]=0
WHERE [SourceDataset] = 'DataMappings'
GO

---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************
