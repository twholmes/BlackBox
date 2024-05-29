--------------------------------------------------------------------------------------
-- Copyright (C) 2023 Crayon
-- BLACKBOX SCHEMA
-- This file configures BlackBox for Settings transactions
-- and Datasets
--
--------------------------------------------------------------------------------------

USE $(DBName)
GO

---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************

----
---- BLACKBOX SETTINGS TABLES
----

--------------------------------------------------------------------------------------------------------
-- dbo.sysSettings: BlackBox Settings table

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sysSettings]') AND type in (N'U'))
DROP TABLE [dbo].[sysSettings]
GO

CREATE TABLE [dbo].[sysSettings]
(
  [ID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
  [JobID] [int] NULL,
  [DataSourceInstanceID] [int] NULL,
  [LineNumber] [int] NULL,
  [Exclude] [nvarchar](4) NULL,
  [FlexeraID] [int] NULL,
	[Name] [nvarchar](40) NULL,
	[Group] [nvarchar](20) NULL,
	[Type] [nvarchar](20) NULL,
	[Value] [nvarchar](4000) NULL,
)

GO

DBCC CHECKIDENT ('dbo.sysSettings', RESEED, 1)
GO

--------------------------------------------------------------------------------------------------------
-- dbo.stagedSettings: BlackBox Settings table

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stagedSettings]') AND type in (N'U'))
DROP TABLE [dbo].[stagedSettings]
GO

CREATE TABLE [dbo].[stagedSettings]
(
  [StagedID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
  [ID] [int] NULL,
  [JobID] [int] NULL,
  [DataSourceInstanceID] [int] NULL,
  [LineNumber] [int] NULL,
  [Exclude] [nvarchar](4) NULL,
  [FlexeraID] [int] NULL,
	[Name] [nvarchar](40) NULL,
	[Group] [nvarchar](20) NULL,
	[Type] [nvarchar](20) NULL,
	[Value] [nvarchar](4000) NULL,
)

GO

DBCC CHECKIDENT ('dbo.stagedSettings', RESEED, 1)
GO


--------------------------------------------------------------------------------------------------------
-- dbo.BlackBoxSettings: View definiton for BlackBoxSettings

IF EXISTS (SELECT 1 FROM dbo.sysobjects WHERE id = object_id('dbo.BlackBoxSettings') AND OBJECTPROPERTY(id, 'IsView') = 1)
  DROP VIEW [dbo].[BlackBoxSettings]
GO

CREATE VIEW [dbo].[BlackBoxSettings] AS
  SELECT
   [Name]
   ,[Group]
   ,[Type]
   ,[Value]
  FROM [dbo].[stagedSettings]

GO


---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************

--------------------------------------------------------------------------------------------------------
-- dbo.BlackBoxSettings: Add sample data to the Settings table

-- General Settings:  
-- the delete included so these statements can be run independantly of a rebuild

DELETE FROM [dbo].[stagedSettings] WHERE [Group] = 'General'

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('General','Administrator','string','administrator')

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('General','AllowSelfRegistration','bool','true')

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('General','DefaultRole','string','Administrator')

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('General','ShowAdvanced','bool','false')

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('General','ShowSystem','bool','false')

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('General','ShowSupport','bool','false')

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('General','ShowManager','bool','false')

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('General','ShowAdministrator','bool','false')

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('General','VisibleGroups','string','ITAM')

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('General','AllGroups','string','ITAM,ANALYSIS')

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('General','VisibleTemplateDatasets','string','System,Contacts,Settings,DataMapping')

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('General','LeftChartFilter','string','Name = ''SiteAuditAssetList'' or Name = ''SIA''')

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('General','RightChartFilter','string','Name = ''SIDA''')

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('General','VisibleDataSources','string','System,Contacts,AssetCriticality,SiteAssetApplications')

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('General','AllDataSources','string','System,Contacts,Assets,Purchases,Metrics,AssetCriticality,SiteAssetApplications')

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('General','OleDbEnabled','bool','true')

GO

-- Dashboard Settings
INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('Dashboard','LeftChartTitle','string','AssetCriticality Record Counts')

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('Dashboard','LeftChartFilter','string','Name = ''SiteAuditAssetList'' or Name = ''SIA''')

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('Dashboard','RightChartTitle','string','SIDA Record Counts')

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('Dashboard','RightChartFilter','string','Name = ''SIDA''')

GO

-- Inspect Settings
DELETE FROM [dbo].[stagedSettings] WHERE [Group] = 'Inspect'

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('Inspect','ExcludeEnabled','bool','false')

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('Inspect','EditEnabled','bool','false')

GO

-- Worker Settings
DELETE FROM [dbo].[stagedSettings] WHERE [Group] = 'Worker'

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('Worker','WorkerPath','string','C:\\Program Files (x86)\\Crayon Australia\\BlackBoxWorker\\BlackBox.Worker.exe')

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('Worker','MGSBIPath','string','C:\\Program Files (x86)\\Flexera Software\\FlexNet Manager Platform\\DotNet\\bin\\mgsbi.exe')    

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('Worker','Simulate','bool','false')    

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('Worker','LocalSimulate','bool','false')    

GO

-- Adapter Settings
DELETE FROM [dbo].[stagedSettings] WHERE [Group] = 'Adapter'

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('Adapters','AssetsDir','string','C:\\ProgramData\\Crayon\\BlackBox\\Data\\adapters\\Assets')

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('Adapters','SiteAuditAssetListDir','string','C:\\ProgramData\\Crayon\\BlackBox\\Data\\adapters\\SiteAuditAssetList')

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('Adapters','AssetRiskAssessmentDir','string','C:\\ProgramData\\Crayon\\BlackBox\\Data\\adapters\\AssetRiskAssessment')

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('Adapters','SystemImpactAssessmentDir','string','C:\\ProgramData\\Crayon\\BlackBox\Data\\adapters\\SystemImpactAssessment')

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('Adapters','SIADir','string','C:\\ProgramData\\Crayon\\BlackBox\Data\\adapters\\SystemImpactAssessment')

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('Adapters','SystemImpactAssessmentAssetDir','string','C:\\ProgramData\Crayon\\BlackBox\\Data\\adapters\\SystemImpactAssessmentAssets')   

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('Adapters','SIDADir','string','C:\\ProgramData\Crayon\\BlackBox\\Data\\adapters\\SystemImpactAssessmentAssets')   

GO

-- ContactPage Settings
DELETE FROM [dbo].[stagedSettings] WHERE [Group] = 'ContactPage'

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('ContactsPage','AllowCardEdit','bool','true')

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('ContactsPage','CardsColumnCount','int','3')

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('ContactsPage','CardsRowsPerPage','int','2')

GO

-- Contact Settings
DELETE FROM [dbo].[stagedSettings] WHERE [Group] = 'Contacts'

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('Contacts','Cohort','string','default')

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('Contacts','LocalSyncEnabled','bool','false')

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('Contacts','ADSyncEnabled','bool','true')

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('Contacts','ADSyncMode','string','exclusive')

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('Contacts','SiteAuditorADGroup','string','APP-BlackBox-PRD-Operator')

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('Contacts','AssetManagerADGroup','string','APP-BlackBox-PRD-Manager')

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('Contacts','AdministratorADGroup','string','APP-BlackBox-PRD-Administrator')

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('Contacts','Notes','string','this is the default cohort')

GO

-- List Settings
DELETE FROM [dbo].[stagedSettings] WHERE [Group] = 'List'

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('Lists','AllowStaticListItems','bool','true')

GO

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('Lists','UsersDNSDomain','string','blackbox.com')

GO

-- Template Settings
DELETE FROM [dbo].[stagedSettings] WHERE [Group] = 'Template'

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('Templates','WorkBookName.System','string','Template-System.xlsx-v1.0')

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('Templates','WorkBookName.Contacts','string','Template-Contacts-v1.0.xlsx')

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('Templates','WorkBookVersion.Contacts','string','1.0')

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('Templates','SheetName.Contacts','string','Contacts')

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('Templates','SheetName.Lists','string','Lists')

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('Templates','SheetName.DataMapping','string','DataMapping')

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('Templates','SheetName.Assets','string','Assets')

GO

-- FileManager Settings
DELETE FROM [dbo].[stagedSettings] WHERE [Group] = 'FileManager'

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('FileManager','Notes','string','this is the default cohort')

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('FileManager','Local','string','enabled')

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('FileManager','LocalRoot','string','~/Data/uploads')

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('FileManager','InitialFolder','string','~/Data/uploads')

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('FileManager','Google','string','enabled')

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('FileManager','GoogleRoot','string','~/GoogleData')

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('FileManager','AllowMove','bool','true')

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('FileManager','AllowDelete','bool','true')

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('FileManager','AllowRename','bool','true')

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('FileManager','AllowCreate','bool','true')

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('FileManager','AllowCopy','bool','true')

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('FileManager','AllowDownload','bool','true')

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('FileManager','ShowPath','bool','true')

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('FileManager','ShowFilterBox','bool','true')

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('FileManager','ShowLockedFolderIcons','bool','true')

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('FileManager','EnableCallBacks','bool','true')

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('FileManager','FoldersVisible','bool','true')

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('FileManager','UploadEnabled','bool','true')

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('FileManager','FileListShowFolders','bool','true')

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('FileManager','FileListShowParentFolder','bool','true')

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('FileManager','BreadcrumbsVisible','bool','true')

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('FileManager','BreadcrumbsShowParentFolder','bool','true')

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('FileManager','BreadcrumbsPosition','string','Top')

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('FileManager','UseAdvancedUploadMode','bool','true')

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('FileManager','EnableUploadMultiSelect','bool','true')

GO

-- Spreadsheet Settings
DELETE FROM [dbo].[stagedSettings] WHERE [Group] = 'Spreadsheet'

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('Spreadsheet','AllowCommonActions','bool','false')

GO

-- WebServices Settings
DELETE FROM [dbo].[stagedSettings] WHERE [Group] = 'WebServices'

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('WebServices','Verbose','bool','false')

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('WebServices','WriteToSchema','bool','false')

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('WebServices','WriteToDatabase','bool','false')

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('WebServices','WriteToCSV','bool','false')

INSERT INTO [dbo].[stagedSettings] ([Group],[Name],[Type],[Value])
VALUES ('WebServices','CredentialTarget','string','FLEXDEMO\Administrator')

GO

UPDATE [dbo].[stagedSettings] SET [ID]=[StagedID], [JobID]=0, [DataSourceInstanceID]=1, [LineNumber]=[StagedID], [Exclude]='n', [FlexeraID]=0
GO

---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************
