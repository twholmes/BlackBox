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
---- BLACKBOX VALIDATION TABLES
----

/****** Table: [dbo].[BlackBoxValidationRule] ******/
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BlackBoxValidationRule]') AND type in (N'U'))
  DROP TABLE [dbo].[BlackBoxValidationRule]
GO

CREATE TABLE [dbo].[BlackBoxValidationRule]
(
	[ProcessStepID] [int] NOT NULL,
	[IsGlobalRule] [bit] NOT NULL,
  [RuleType] [nvarchar](50) NULL,	
	[ValidationRule] [nvarchar](max) NOT NULL,
  [Level] [nvarchar](20) NULL,	
	[ErrorMessage] [nvarchar](3000) NOT NULL,
	[SourceColumn1Name] [nvarchar](256) NULL,
	[SourceColumn2Name] [nvarchar](256) NULL,
	[ValidationRuleID] [int] IDENTITY(1,1) NOT NULL
)

GO


----
---- BLACKBOX VALIDATION VIEWS
----

--------------------------------------------------------------------------------------------------------
-- dbo.vBlackBoxValidationResults: View definiton for vBlackBoxValidationResults

IF EXISTS (SELECT 1 FROM dbo.sysobjects WHERE id = object_id('dbo.vBlackBoxValidationResults') AND OBJECTPROPERTY(id, 'IsView') = 1)
  DROP VIEW [dbo].[vBlackBoxValidationResults]
GO

CREATE VIEW [dbo].[vBlackBoxValidationResults] AS
  SELECT 
      pdl.[ProcessDetailID]
      ,pdl.[ProcessID]
      ,pdl.[ProcessStepID]
	    ,pl.[ProcessName]
	    --,pl.[Action] AS [ProcessAction]
	    ,psl.[ProcessStepName]
      ,pdl.[JobID]
      ,pdl.[DatasetName]
      ,pdl.[DataSourceInstanceID]
      ,pdl.[RecordNumber]
      ,pdl.[Item]
      ,pdl.[Result]
      ,pdl.[RecordKey]
      ,pdl.[RecordDescription]
      ,pdl.[Message]
  FROM [dbo].[BlackBoxProcessDetailLog] AS pdl
    JOIN [dbo].[BlackBoxProcessSummaryLog] AS pl ON pl.ProcessID = pdl.ProcessID
    JOIN [dbo].[BlackBoxProcessStepLog] AS psl ON psl.ProcessStepID = pdl.ProcessStepID
  WHERE pl.[Action] = 'Validate'

GO

--------------------------------------------------------------------------------------------------------
-- dbo.vBlackBoxFilesWithValidation: View definiton for vBlackBoxFile

IF EXISTS (SELECT 1 FROM dbo.sysobjects WHERE id = object_id('dbo.vBlackBoxFilesWithValidation') AND OBJECTPROPERTY(id, 'IsView') = 1)
  DROP VIEW [dbo].[vBlackBoxFilesWithValidation]
GO

CREATE VIEW [dbo].[vBlackBoxFilesWithValidation] AS
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
    ,uf.[Datasets]    
    ,uf.[StatusID]
    ,case
       when uf.[StatusID] is null then ''       
       when uf.[StatusID] = 0 then 'null'
       when uf.[StatusID] = 1 then 'filed'
       when uf.[StatusID] = 2 then 'loaded'
       when uf.[StatusID] = 3 then 'pending'
       when uf.[StatusID] = 4 then 'validated'       
       when uf.[StatusID] = 5 then 'staged'       
       when uf.[StatusID] = 6 then 'processed'
       when uf.[StatusID] = 7 then 'published' 
       when uf.[StatusID] = 8 then 'locked'             
       when uf.[StatusID] = 9 then 'withdrawn'
       when uf.[StatusID] > 10 then 'archived'       
       when uf.[StatusID] < 0 then 'error(' + convert(nvarchar(2),uf.[StatusID]) + ')'
       else 'unknown'
     end AS [Status]
    ,dsi.[Validations]
    ,uf.[Locked]
    ,uj.[UserID]
    ,usr.[SAMAccountName]
    ,uf.[TimeStamp]
    ,DATEDIFF(day, uf.[TimeStamp], GetDate()) AS [Age]
    ,ROW_NUMBER() OVER(PARTITION BY uf.[GUID] ORDER BY uf.[TimeStamp] desc) AS [Rank]    
  FROM [dbo].[BlackBoxFiles] AS uf
  INNER JOIN [dbo].[BlackBoxJobs] AS uj ON uj.[JobID] = uf.[JobID]
  LEFT OUTER JOIN [dbo].[BlackBoxDataSourceInstances] AS dsi ON dsi.[ID] = uf.[DataSourceInstanceID]
  LEFT OUTER JOIN [dbo].[sysContacts] AS usr ON usr.[ID] = uj.[UserID]  

GO

---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************

