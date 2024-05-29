--------------------------------------------------------------------------------------
-- Copyright (C) 2024 Crayon
-- BLACKBOX SCHEMA
-- This file configures BlackBox for Contact transactions
-- and Datasets
--
--------------------------------------------------------------------------------------

USE $(DBName)
GO

---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************

----
---- BLACKBOX CONTACTS TABLES
----

--------------------------------------------------------------------------------------------------------
-- dbo.sysContacts: Table definiton for Contacts

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sysContacts]') AND type in (N'U'))
DROP TABLE [dbo].[sysContacts]
GO

CREATE TABLE [dbo].[sysContacts]
(
  [ID] [int] IDENTITY(1,1) NOT NULL,
  [JobID] [int] NULL,
  [DataSourceInstanceID] [int] NULL,
  [LineNumber] [int] NULL,
  [Exclude] [nvarchar](4) NULL,
  [FlexeraID] [int] NULL,
  [Cohort] [nvarchar](40) NULL, 
  [UID] [nvarchar](36) NOT NULL,
  [FullName] [nvarchar](40) NULL,  
  [FirstName] [nvarchar](40) NULL,
  [LastName] [nvarchar](40) NULL,
  [AddressBook] [nvarchar](20) NULL,
  [Domain] [nvarchar](40) NULL, 
  [SAMAccountName] [nvarchar](40) NULL,
  [Email] [nvarchar](80) NULL,
  [PhotoFileName] [nvarchar](80) NULL,
  [Country] [nvarchar](30) NULL,
  [City] [nvarchar](30) NULL,
  [Address] [nvarchar](120) NULL,
  [Phone] [nvarchar](30) NULL,
  [Birthday] [date] NULL,
  [Site] [nvarchar](120) NULL,  
  [Business] [nvarchar](200) NULL,  
  [Job] [nvarchar](120) NULL, 
  [Memberships] [nvarchar](400) NULL, 
  [Guest] [bit] NULL,  
  [Operator] [bit] NULL,
  [Manager] [bit] NULL,
  [Administrator] [bit] NULL,  
  [Password] [nvarchar](30) NULL, 
  [Credits] [int],  
  [Status] [int],
  [UpdatedBy] [varchar](20),
  [Updated] [datetime] NOT NULL
) ON [PRIMARY]

GO

DBCC CHECKIDENT ('dbo.sysContacts', RESEED, 1000)
GO

--------------------------------------------------------------------------------------------------------
-- dbo.stagedContacts: Table definiton for Contacts

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[stagedContacts]') AND type in (N'U'))
DROP TABLE [dbo].[stagedContacts]
GO

CREATE TABLE [dbo].[stagedContacts]
(
	[StagedID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
	[ID] [int] NULL,
  [DataSourceInstanceID] [int] NULL,
  [LineNumber] [int] NULL,
  [Exclude] [nvarchar](4) NULL,
  [FlexeraID] [int] NULL,
  [Cohort] [nvarchar](40) NULL, 
  [UID] [nvarchar](36) NOT NULL,
  [FullName] [nvarchar](40) NULL,  
  [FirstName] [nvarchar](40) NULL,
  [LastName] [nvarchar](40) NULL,
  [AddressBook] [nvarchar](20) NULL,
  [Domain] [nvarchar](40) NULL, 
  [SAMAccountName] [nvarchar](40) NULL,
  [Email] [nvarchar](80) NULL,
  [PhotoFileName] [nvarchar](80) NULL,
  [Country] [nvarchar](30) NULL,
  [City] [nvarchar](30) NULL,
  [Address] [nvarchar](120) NULL,
  [Phone] [nvarchar](30) NULL,
  [Birthday] [date] NULL,
  [Site] [nvarchar](120) NULL,  
  [Business] [nvarchar](200) NULL,  
  [Job] [nvarchar](120) NULL, 
  [Memberships] [nvarchar](400) NULL, 
  [Guest] [bit] NULL,  
  [Operator] [bit] NULL,
  [Manager] [bit] NULL,
  [Administrator] [bit] NULL,  
  [Password] [nvarchar](30) NULL, 
  [Credits] [int],  
  [Status] [int],
  [UpdatedBy] [varchar](20),
  [Updated] [datetime] NOT NULL
) ON [PRIMARY]

GO

DBCC CHECKIDENT ('dbo.stagedContacts', RESEED, 1000)
GO


/****** View: [dbo].[BlackBoxContacts] ******/
IF EXISTS (SELECT 1 FROM dbo.sysobjects WHERE id = object_id('dbo.BlackBoxContacts') AND OBJECTPROPERTY(id, 'IsView') = 1)
  DROP VIEW [dbo].[BlackBoxContacts]
GO

CREATE VIEW [dbo].[BlackboxContacts] AS
WITH Contacts AS
(
  SELECT
    staged.[ID]
    ,staged.[JobID]
    ,staged.[DataSourceInstanceID]
    ,staged.[LineNumber]    
    ,staged.[Exclude]
    ,staged.[FlexeraID]
    ,staged.[Cohort]
    ,staged.[UID]
    ,staged.[FullName]    
    ,staged.[FirstName]
    ,staged.[LastName]
    ,staged.[AddressBook]
    ,staged.[Domain]
    ,staged.[SAMAccountName]
    ,staged.[Email]
    ,staged.[PhotoFileName]
    ,staged.[Country]
    ,staged.[City]
    ,staged.[Address]
    ,staged.[Phone]
    ,staged.[Birthday]
    ,staged.[Site]
    ,staged.[Business]
    ,staged.[Job]
    ,staged.[Memberships]
    ,staged.[Guest]
    ,staged.[Operator]
    ,staged.[Manager]
    ,staged.[Administrator]
    ,staged.[Password]
    ,staged.[Credits]
    ,staged.[Status]
    ,staged.[UpdatedBy]
    ,staged.[Updated]
    ,ROW_NUMBER() OVER(PARTITION BY staged.[Domain], staged.[SAMAccountName] ORDER BY staged.[ID] desc) AS [Rank]
  FROM (
    SELECT bbvl.* FROM [dbo].[sysContacts] AS bbvl
    INNER JOIN [dbo].[BlackBoxFiles] AS bbf ON bbvl.DataSourceInstanceID = bbf.DataSourceInstanceID
    WHERE LEFT(LOWER(bbvl.[Exclude]),1) != 'y' AND (bbf.StatusID > 1 OR bbf.StatusID = 6 OR bbf.StatusID = 7)
  )  AS staged
)
SELECT
  c.[ID]
  ,c.[Cohort]
  ,c.[UID]
  ,c.[FullName]  
  ,c.[FirstName]
  ,c.[LastName]
  ,c.[AddressBook]
  ,c.[Domain]
  ,c.[SAMAccountName]
  ,c.[Email]
  ,c.[PhotoFileName]
  ,c.[Country]
  ,c.[City]
  ,c.[Address]
  ,c.[Phone]
  ,c.[Birthday]
  ,c.[Site]
  ,c.[Business]
  ,c.[Job]
  ,c.[Memberships]
  ,c.[Guest]
  ,c.[Operator]
  ,c.[Manager]
  ,c.[Administrator]
  ,c.[Password]
  ,c.[Credits]
  ,c.[Status]
  ,c.[UpdatedBy]
  ,c.[Updated]
FROM Contacts as c
WHERE c.Rank = 1;

GO

---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************

/****** StoredProcedure: [dbo].[StageContacts] ******/
IF EXISTS(SELECT 1 FROM sys.procedures WHERE Name = 'StageContacts')
  DROP PROCEDURE [dbo].[StageContacts]
GO

CREATE PROCEDURE [dbo].[StageContacts]
  @DataSourceInstanceID int = 0,
  @JobID int = 0,   
  @SourceDataset [nvarchar](100) = '%',
  @KeepExisting [bit] = 0
AS
  PRINT 'Stage Contacts'
  
  IF @KeepExisting = 0
  BEGIN
    DELETE FROM [dbo].[stagedContacts]
  END

  INSERT INTO [dbo].[stagedContacts]
  SELECT  
    [ID],[JobID],[DataSourceInstanceID],[LineNumber],[FlexeraID]
    ,[Cohort],[UID],[FullName],[FirstName],[LastName],[AddressBook],[Domain],[SAMAccountName],[Email],[PhotoFileName],[Country],[City],[Address]
    ,[Phone],[Birthday],[Site],[Business],[Job],[Memberships],[Guest],[Operator],[Manager],[Administrator],[Password],[Credits],[Status],[UpdatedBy],[Updated]
  FROM [dbo].[sysContacts] 
  WHERE [DataSourceInstanceID] = @DataSourceInstanceID AND LEFT(LOWER([Exclude]),1) != 'y'

GO

---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************

--------------------------------------------------------------------------------------------------------
-- dbo.sysDataMappings: Populate with required default data

DELETE FROM [dbo].[sysDataMappings] WHERE [DataSource] like 'Contacts' and [SourceDataset] like 'Contacts'
GO

SET IDENTITY_INSERT [dbo].[sysDataMappings] ON
GO
 
--SET @JobNumber = 0, @DataSourceInstanceID = 3
INSERT INTO [dbo].[sysDataMappings] ([ID],[Exclude],[DataSource],[SourceDataset],[Field],[TableName],[Column],[Mandatory],[Flags],[Type],[Size],[Convert],[DisplayWidth]) 
VALUES (200,'n','Contacts','Contacts','Cohort','sysContacts','Cohort',0,'','nvarchar',40,'[{0}]','150px')

INSERT INTO [dbo].[sysDataMappings] ([ID],[Exclude],[DataSource],[SourceDataset],[Field],[TableName],[Column],[Mandatory],[Flags],[Type],[Size],[Convert],[DisplayWidth]) 
VALUES (201,'n','Contacts','Contacts','UID','sysContacts','UID',0,'','nvarchar',36,'[{0}]','150px')

INSERT INTO [dbo].[sysDataMappings] ([ID],[Exclude],[DataSource],[SourceDataset],[Field],[TableName],[Column],[Mandatory],[Flags],[Type],[Size],[Convert],[DisplayWidth]) 
VALUES (202,'n','Contacts','Contacts','Name','sysContacts','Name',0,'','nvarchar',40,'[{0}]','150px')

INSERT INTO [dbo].[sysDataMappings] ([ID],[Exclude],[DataSource],[SourceDataset],[Field],[TableName],[Column],[Mandatory],[Flags],[Type],[Size],[Convert],[DisplayWidth]) 
VALUES (203,'n','Contacts','Contacts','FirstName','sysContacts','FirstName',0,'','nvarchar',40,'[{0}]','150px')

INSERT INTO [dbo].[sysDataMappings] ([ID],[Exclude],[DataSource],[SourceDataset],[Field],[TableName],[Column],[Mandatory],[Flags],[Type],[Size],[Convert],[DisplayWidth]) 
VALUES (204,'n','Contacts','Contacts','LastName','sysContacts','LastName',0,'','nvarchar',40,'[{0}]','150px')

INSERT INTO [dbo].[sysDataMappings] ([ID],[Exclude],[DataSource],[SourceDataset],[Field],[TableName],[Column],[Mandatory],[Flags],[Type],[Size],[Convert],[DisplayWidth]) 
VALUES (205,'n','Contacts','Contacts','AddressBook','sysContacts','AddressBook',0,'','nvarchar',20,'[{0}]','150px')

INSERT INTO [dbo].[sysDataMappings] ([ID],[Exclude],[DataSource],[SourceDataset],[Field],[TableName],[Column],[Mandatory],[Flags],[Type],[Size],[Convert],[DisplayWidth]) 
VALUES (206,'n','Contacts','Contacts','Domain','sysContacts','Domain',0,'','nvarchar',40,'[{0}]','150px')

INSERT INTO [dbo].[sysDataMappings] ([ID],[Exclude],[DataSource],[SourceDataset],[Field],[TableName],[Column],[Mandatory],[Flags],[Type],[Size],[Convert],[DisplayWidth]) 
VALUES (207,'n','Contacts','Contacts','SAMAccountName','sysContacts','SAMAccountName',0,'','nvarchar',40,'[{0}]','150px')

INSERT INTO [dbo].[sysDataMappings] ([ID],[Exclude],[DataSource],[SourceDataset],[Field],[TableName],[Column],[Mandatory],[Flags],[Type],[Size],[Convert],[DisplayWidth]) 
VALUES (208,'n','Contacts','Contacts','Email','sysContacts','Email',0,'','nvarchar',80,'[{0}]','150px')

INSERT INTO [dbo].[sysDataMappings] ([ID],[Exclude],[DataSource],[SourceDataset],[Field],[TableName],[Column],[Mandatory],[Flags],[Type],[Size],[Convert],[DisplayWidth]) 
VALUES (209,'n','Contacts','Contacts','PhotoFileName','sysContacts','PhotoFileName',0,'','nvarchar',80,'[{0}]','150px')

INSERT INTO [dbo].[sysDataMappings] ([ID],[Exclude],[DataSource],[SourceDataset],[Field],[TableName],[Column],[Mandatory],[Flags],[Type],[Size],[Convert],[DisplayWidth]) 
VALUES (210,'n','Contacts','Contacts','Country','sysContacts','Country',0,'','nvarchar',30,'[{0}]','150px')

INSERT INTO [dbo].[sysDataMappings] ([ID],[Exclude],[DataSource],[SourceDataset],[Field],[TableName],[Column],[Mandatory],[Flags],[Type],[Size],[Convert],[DisplayWidth]) 
VALUES (211,'n','Contacts','Contacts','City','sysContacts','City',0,'','nvarchar',30,'[{0}]','150px')

INSERT INTO [dbo].[sysDataMappings] ([ID],[Exclude],[DataSource],[SourceDataset],[Field],[TableName],[Column],[Mandatory],[Flags],[Type],[Size],[Convert],[DisplayWidth]) 
VALUES (212,'n','Contacts','Contacts','Address','sysContacts','Address',0,'','nvarchar',120,'[{0}]','150px')

INSERT INTO [dbo].[sysDataMappings] ([ID],[Exclude],[DataSource],[SourceDataset],[Field],[TableName],[Column],[Mandatory],[Flags],[Type],[Size],[Convert],[DisplayWidth]) 
VALUES (213,'n','Contacts','Contacts','Phone','sysContacts','Phone',0,'','nvarchar',30,'[{0}]','150px')

INSERT INTO [dbo].[sysDataMappings] ([ID],[Exclude],[DataSource],[SourceDataset],[Field],[TableName],[Column],[Mandatory],[Flags],[Type],[Size],[Convert],[DisplayWidth]) 
VALUES (214,'n','Contacts','Contacts','Birthday','sysContacts','Birthday',0,'','datetime',0,'try_convert(datetime,[{0}],103)','150px')

INSERT INTO [dbo].[sysDataMappings] ([ID],[Exclude],[DataSource],[SourceDataset],[Field],[TableName],[Column],[Mandatory],[Flags],[Type],[Size],[Convert],[DisplayWidth]) 
VALUES (215,'n','Contacts','Contacts','Site','sysContacts','Site',0,'','nvarchar',120,'[{0}]','150px')

INSERT INTO [dbo].[sysDataMappings] ([ID],[Exclude],[DataSource],[SourceDataset],[Field],[TableName],[Column],[Mandatory],[Flags],[Type],[Size],[Convert],[DisplayWidth]) 
VALUES (216,'n','Contacts','Contacts','Business','sysContacts','Business',0,'','nvarchar',200,'[{0}]','150px')

INSERT INTO [dbo].[sysDataMappings] ([ID],[Exclude],[DataSource],[SourceDataset],[Field],[TableName],[Column],[Mandatory],[Flags],[Type],[Size],[Convert],[DisplayWidth]) 
VALUES (217,'n','Contacts','Contacts','Job','sysContacts','Job',0,'','nvarchar',120,'[{0}]','150px')

INSERT INTO [dbo].[sysDataMappings] ([ID],[Exclude],[DataSource],[SourceDataset],[Field],[TableName],[Column],[Mandatory],[Flags],[Type],[Size],[Convert],[DisplayWidth]) 
VALUES (218,'n','Contacts','Contacts','Memberships','sysContacts','Memberships',0,'','nvarchar',400,'[{0}]','150px')

INSERT INTO [dbo].[sysDataMappings] ([ID],[Exclude],[DataSource],[SourceDataset],[Field],[TableName],[Column],[Mandatory],[Flags],[Type],[Size],[Convert],[DisplayWidth]) 
VALUES (219,'n','Contacts','Contacts','Guest','sysContacts','Guest',0,'','bit',400,'convert(bit,[{0}])','150px')

INSERT INTO [dbo].[sysDataMappings] ([ID],[Exclude],[DataSource],[SourceDataset],[Field],[TableName],[Column],[Mandatory],[Flags],[Type],[Size],[Convert],[DisplayWidth]) 
VALUES (220,'n','Contacts','Contacts','Operator','sysContacts','Operator',0,'','bit',400,'convert(bit,[{0}])','150px')

INSERT INTO [dbo].[sysDataMappings] ([ID],[Exclude],[DataSource],[SourceDataset],[Field],[TableName],[Column],[Mandatory],[Flags],[Type],[Size],[Convert],[DisplayWidth]) 
VALUES (221,'n','Contacts','Contacts','Manager','sysContacts','Manager',0,'','bit',400,'convert(bit,[{0}])','150px')

INSERT INTO [dbo].[sysDataMappings] ([ID],[Exclude],[DataSource],[SourceDataset],[Field],[TableName],[Column],[Mandatory],[Flags],[Type],[Size],[Convert],[DisplayWidth]) 
VALUES (222,'n','Contacts','Contacts','Auditor','sysContacts','Administrator',0,'','bit',400,'convert(bit,[{0}])','150px')

INSERT INTO [dbo].[sysDataMappings] ([ID],[Exclude],[DataSource],[SourceDataset],[Field],[TableName],[Column],[Mandatory],[Flags],[Type],[Size],[Convert],[DisplayWidth]) 
VALUES (223,'n','Contacts','Contacts','Password','sysContacts','Password',0,'','nvarchar',30,'[{0}]','150px')

INSERT INTO [dbo].[sysDataMappings] ([ID],[Exclude],[DataSource],[SourceDataset],[Field],[TableName],[Column],[Mandatory],[Flags],[Type],[Size],[Convert],[DisplayWidth]) 
VALUES (225,'n','Contacts','Contacts','Status','sysContacts','Status',0,'','int',0,'convert(int,[{0}])','150px')

INSERT INTO [dbo].[sysDataMappings] ([ID],[Exclude],[DataSource],[SourceDataset],[Field],[TableName],[Column],[Mandatory],[Flags],[Type],[Size],[Convert],[DisplayWidth]) 
VALUES (226,'n','Contacts','Contacts','UpdatedBy','sysContacts','UpdatedBy',0,'','nvarchar',20,'[{0}]','150px')

INSERT INTO [dbo].[sysDataMappings] ([ID],[Exclude],[DataSource],[SourceDataset],[Field],[TableName],[Column],[Mandatory],[Flags],[Type],[Size],[Convert],[DisplayWidth]) 
VALUES (227,'n','Contacts','Contacts','Updated','sysContacts','Updated',0,'','datetime',0,'ISNULL(TRY_CONVERT(datetime,[{0}],103), GETDATE())','150px')

GO

SET IDENTITY_INSERT [dbo].[sysDataMappings] OFF
GO

UPDATE [dbo].[sysDataMappings] SET [JobID]=1, [DataSourceInstanceID]=2, [LineNumber]=[ID], [Exclude]='n', [FlexeraID]=0
WHERE [SourceDataset] = 'Contacts'
GO

EXEC [dbo].[StageDataMappings] @DataSourceInstanceID=2, @JobID=0, @SourceDataset='Contacts', @KeepExisting=1
GO

---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************

--------------------------------------------------------------------------------------------------------
-- dbo.Contacts: Add sample data to the Contacts table

PRINT 'Configuring BlackBox Contact Samples'

--DELETE FROM [dbo].[sysContacts]

--SET IDENTITY_INSERT [dbo].[sysContacts] ON
--GO

--SET @JobNumber = 0, @DataSourceInstanceID = 3
--INSERT INTO [dbo].[sysContacts] ([ID],[JobID],[DataSourceInstanceID],[LineNumber],[Exclude],[FlexeraID],[Cohort],[UID],[FullName],[FirstName],[LastName],[AddressBook],[Domain],[SAMAccountName],[Email],[PhotoFileName],[Country],[City],[Address],[Phone],[Birthday],[Site],[Business],[Job],[Memberships],[Guest],[Operator],[Manager],[Administrator],[Password],[Credits],[Status])
--VALUES (1,0,2,1,0,0,'system','00000000-0000-0000-0001-000000000000','Guest','Guest','','User','FLEXDEMO','Guest','guest@crayon.com','guest.jpg','Australia','Melbourne','44 Lakeview Drive Scoresby VIC 3179','',PARSE('01/01/2021' as date USING 'AR-LB'),'','','user','guest',1,0,0,0,'password',100,0,'system',CONVERT(datetime,'13/08/2021',103))

--INSERT INTO [dbo].[sysContacts] ([ID],[JobID],[DataSourceInstanceID],[LineNumber],[Exclude],[FlexeraID],[Cohort],[UID],[FullName],[FirstName],[LastName],[AddressBook],[Domain],[SAMAccountName],[Email],[PhotoFileName],[Country],[City],[Address],[Phone],[Birthday],[Site],[Business],[Job],[Memberships],[Guest],[Operator],[Manager],[Administrator],[Password],[Credits],[Status])
--VALUES (2,0,2,2,0,0,'system','00000000-0000-0000-0002-000000000000','Operator','Operator','','User','FLEXDEMO','Operator','user@crayon.com','guest.jpg','Australia','Melbourne','44 Lakeview Drive Scoresby VIC 3179','',PARSE('01/01/2021' as date USING 'AR-LB'),'','','Asset Manager','guest,asset',1,1,0,0,'password',100,0,'system',CONVERT(datetime,'13/08/2021',103))

--INSERT INTO [dbo].[sysContacts] ([ID],[JobID],[DataSourceInstanceID],[LineNumber],[Exclude],[FlexeraID],[Cohort],[UID],[FullName],[FirstName],[LastName],[AddressBook],[Domain],[SAMAccountName],[Email],[PhotoFileName],[Country],[City],[Address],[Phone],[Birthday],[Site],[Business],[Job],[Memberships],[Guest],[Operator],[Manager],[Administrator],[Password],[Credits],[Status])
--VALUES (3,0,2,3,0,0,'system','00000000-0000-0000-0003-000000000000','Manager','Manager','','User','FLEXDEMO','Manager','user@crayon.com','guest.jpg','Australia','Melbourne','44 Lakeview Drive Scoresby VIC 3179','',PARSE('01/01/2021' as date USING 'AR-LB'),'','','Storeman','guest,stores',1,1,1,0,'password',100,0,'system',CONVERT(datetime,'13/08/2021',103))

--INSERT INTO [dbo].[sysContacts] ([ID],[JobID],[DataSourceInstanceID],[LineNumber],[Exclude],[FlexeraID],[Cohort],[UID],[FullName],[FirstName],[LastName],[AddressBook],[Domain],[SAMAccountName],[Email],[PhotoFileName],[Country],[City],[Address],[Phone],[Birthday],[Site],[Business],[Job],[Memberships],[Guest],[Operator],[Manager],[Administrator],[Password],[Credits],[Status])
--VALUES (4,0,2,4,0,0,'system','00000000-0000-0000-0003-000000000000','Administrator','Administrator','','User','FLEXDEMO','Administrator','user@crayon.com','guest.jpg','Australia','Melbourne','44 Lakeview Drive Scoresby VIC 3179','',PARSE('01/01/2021' as date USING 'AR-LB'),'','','Buyer','guest,purchase',1,1,1,1,'password',100,0,'system',CONVERT(datetime,'13/08/2021',103))

--SET @JobNumber = 0, @DataSourceInstanceID = 3
--INSERT INTO [dbo].[sysContacts] ([ID],[JobID],[DataSourceInstanceID],[LineNumber],[Exclude],[FlexeraID],[Cohort],[UID],[FullName],[FirstName],[LastName],[AddressBook],[Domain],[SAMAccountName],[Email],[PhotoFileName],[Country],[City],[Address],[Phone],[Birthday],[Site],[Business],[Job],[Memberships],[Guest],[Operator],[Manager],[Administrator],[Password],[Credits],[Status])
--VALUES (99,0,2,1,0,0,'system','00000000-0000-0000-0001-000000000000','System','System','','User','FLEXDEMO','System','system@crayon.com','guest.jpg','Australia','Melbourne','44 Lakeview Drive Scoresby VIC 3179','',PARSE('01/01/2021' as date USING 'AR-LB'),'','','system','system',1,1,1,1,'password',100,0,'system',CONVERT(datetime,'13/08/2021',103))

--GO

--SET IDENTITY_INSERT [dbo].[sysContacts] OFF
--GO

---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************

----
---- BLACKBOX SETTINGS TABLES
----

--------------------------------------------------------------------------------------------------------
-- dbo.BlackBoxSetttings: Table definiton for Settings

-- Contact Settings
DELETE FROM [dbo].[BlackBoxSettings] WHERE [Group] = 'Contacts'

INSERT INTO [dbo].[BlackBoxSettings] ([Group],[Name],[Type],[Value])
VALUES ('Contacts','Cohort','string','default')

INSERT INTO [dbo].[BlackBoxSettings] ([Group],[Name],[Type],[Value])
VALUES ('Contacts','LocalSyncEnabled','bool','false')

INSERT INTO [dbo].[BlackBoxSettings] ([Group],[Name],[Type],[Value])
VALUES ('Contacts','ADSyncEnabled','bool','true')

INSERT INTO [dbo].[BlackBoxSettings] ([Group],[Name],[Type],[Value])
VALUES ('Contacts','ADSyncMode','string','exclusive')

INSERT INTO [dbo].[BlackBoxSettings] ([Group],[Name],[Type],[Value])
VALUES ('Contacts','OperatorADGroup','string','APP-BlackBox-PRD-Operator')

INSERT INTO [dbo].[BlackBoxSettings] ([Group],[Name],[Type],[Value])
VALUES ('Contacts','ManagerADGroup','string','APP-BlackBox-PRD-Manager')

INSERT INTO [dbo].[BlackBoxSettings] ([Group],[Name],[Type],[Value])
VALUES ('Contacts','AdministratorADGroup','string','APP-BlackBox-PRD-Administrator')

INSERT INTO [dbo].[BlackBoxSettings] ([Group],[Name],[Type],[Value])
VALUES ('Contacts','Notes','string','this is the default cohort')

GO

---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************
