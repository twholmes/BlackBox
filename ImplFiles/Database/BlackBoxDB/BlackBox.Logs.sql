--------------------------------------------------------------------------------------
-- Copyright (C) 2024 Crayon
-- BLACKBOX CONFIGURATION
-- This file configures BlackBox for logging 
--
--------------------------------------------------------------------------------------

USE $(DBName)
GO

---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************

----
---- BLACKBOX LOG TABLES
----

--------------------------------------------------------------------------------------------------------
-- dbo.BlackBoxLogEntryTypes: Reference table for uploaded file status

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BlackBoxLogEntryTypes]') AND type in (N'U'))
DROP TABLE [dbo].[BlackBoxLogEntryTypes]
GO

CREATE TABLE [dbo].[BlackBoxLogEntryTypes]
(
  [LogTypeID] int NOT NULL PRIMARY KEY,
  [LogType] [nvarchar](256)
)

GO

-- included so these statements can be run independantly of a rebuild
DELETE FROM [dbo].[BlackBoxLogEntryTypes]
GO

INSERT INTO [dbo].[BlackBoxLogEntryTypes] ([LogTypeID],[LogType])
VALUES (0, 'general')

INSERT INTO [dbo].[BlackBoxLogEntryTypes] ([LogTypeID],[LogType])
VALUES (1, 'action')

INSERT INTO [dbo].[BlackBoxLogEntryTypes] ([LogTypeID],[LogType])
VALUES (2, 'validation')

INSERT INTO [dbo].[BlackBoxLogEntryTypes] ([LogTypeID],[LogType])
VALUES (3, 'processing')

GO

--------------------------------------------------------------------------------------------------------
-- dbo.BlackBoxLogs: Records logging records

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BlackBoxLogs]') AND type in (N'U'))
DROP TABLE [dbo].[BlackBoxLogs]
GO

CREATE TABLE [dbo].[BlackBoxLogs]
(
  [ID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
  [LogTypeID] int,
  [Subject] [nvarchar](256),  
  [Message] [nvarchar](2048),  
  [JOBID] int NULL,
  [UserID] int,  
  [TimeStamp] datetime
)

GO

DBCC CHECKIDENT ('dbo.BlackBoxLogs', RESEED, 1000)
GO

----
---- BLACKBOX LOG VIEWS
----

--------------------------------------------------------------------------------------------------------
-- dbo.vBlackBoxLogs: View definiton for vBlackBoxLogs

IF EXISTS (SELECT 1 FROM dbo.sysobjects WHERE id = object_id('dbo.vBlackBoxLogs') AND OBJECTPROPERTY(id, 'IsView') = 1)
  DROP VIEW [dbo].[vBlackBoxLogs]
GO

CREATE VIEW [dbo].[vBlackBoxLogs] AS
  SELECT
    v.[ID]
    ,v.[LogTypeID]
    ,case
       when v.[LogTypeID] is null then 'null' 
       when v.[LogTypeID] = 0 then 'general'
       when v.[LogTypeID] = 1 then 'action' 
       when v.[LogTypeID] = 2 then 'validation'
       when v.[LogTypeID] = 3 then 'processing'       
       else 'unknown'
     end AS [LogType]    
    ,v.[Subject]
    ,v.[Message]
    ,v.[JOBID]
    ,v.[UserID]
    ,COALESCE(c.[FirstName],' ',c.[LastName]) AS [User]
    ,c.[SAMAccountName]    
    ,v.[TimeStamp]
  FROM [dbo].[BlackBoxLogs] AS v
    LEFT OUTER JOIN [dbo].[sysContacts] AS c ON v.[UserID] = c.[ID]


GO

---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************

--------------------------------------------------------------------------------------------------------
-- dbo.BlackBoxLogs: initial log entries

PRINT 'Initialise logging'

SET IDENTITY_INSERT [dbo].[BlackBoxLogs] ON
GO

INSERT INTO [dbo].[BlackBoxLogs] ([ID],[LogTypeID],[Subject],[Message],[JOBID],[UserID],[TimeStamp])
VALUES (1,0,'install','logging tables initialised',0,0,GETDATE())

GO

SET IDENTITY_INSERT [dbo].[BlackBoxLogs] OFF
GO


---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************

----
---- BLACKBOX PROCESSING LOG TABLES
----

/****** Table: [dbo].[BlackBoxProcessSummaryLog] ******/
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BlackBoxProcessSummaryLog]') AND type in (N'U'))
  DROP TABLE [dbo].[BlackBoxProcessSummaryLog]
GO

CREATE TABLE [dbo].[BlackBoxProcessSummaryLog]
(
  [ProcessID] [int] IDENTITY(1,1) NOT NULL,
  [ProcessName] [nvarchar](255) NOT NULL,
  [JobID] [int] NOT NULL,  
  [DatasetName] [nvarchar](64) NULL,
  [DataSourceInstanceID] [int] NULL,  
  [Action] [nvarchar](50) NULL,
  [StartDate] [datetime] NULL,
  [EndDate] [datetime] NULL,
  [Status] [int] NULL,
  [Total] [int] NULL,
  [Excluded] [int] NULL,     
  [Processed] [int] NULL,
  [Result] [nvarchar](2048),   
  [UserID] [int] NULL,
  CONSTRAINT [PK_BlackBoxProcessSummaryLog_ProcessID] PRIMARY KEY CLUSTERED 
  (
    [ProcessID] ASC
  )
)

GO

/****** Table: [dbo].[BlackBoxProcessStepLog] ******/
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BlackBoxProcessStepLog]') AND type in (N'U'))
  DROP TABLE [dbo].[BlackBoxProcessStepLog]
GO

CREATE TABLE [dbo].[BlackBoxProcessStepLog]
(
  [ProcessStepID] [int] IDENTITY(1,1) NOT NULL,
  [ProcessStepName] [nvarchar](255) NOT NULL,
  [ProcessID] [int] NOT NULL,    
  [JobID] [int] NOT NULL,  
  [DatasetName] [nvarchar](64) NULL,
  [DataSourceInstanceID] [int] NULL,    
  [StartDate] [datetime] NULL,
  [EndDate] [datetime] NULL,
  [Status] [int] NULL,  
  [Total] [int] NULL,
  [Excluded] [int] NULL,     
  [Processed] [int] NULL,  
  [Matched] [int] NULL,
  [Errors] [int] NULL,
  [Warnings] [int] NULL,  
  [Updated] [int] NULL,
  [Created] [int] NULL,
  [Deleted] [int] NULL,
  CONSTRAINT [PK_BlackBoxProcessStepLog_ProcessStepID] PRIMARY KEY CLUSTERED 
  (
    [ProcessStepID] ASC
  )
)

GO

/****** Table: [dbo].[BlackBoxProcessDetailLog] ******/
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BlackBoxProcessDetailLog]') AND type in (N'U'))
  DROP TABLE [dbo].[BlackBoxProcessDetailLog]
GO

CREATE TABLE [dbo].[BlackBoxProcessDetailLog]
(
  [ProcessDetailID] [int] IDENTITY(1,1) NOT NULL,
  [ProcessID] [int] NULL,      
  [ProcessStepID] [int] NULL,  
  [JobID] [int] NOT NULL,
  [DatasetName] [nvarchar](64) NULL,  
  [DataSourceInstanceID] [int] NULL,      
  [Action] [nvarchar](50) NULL,  
  [RecordNumber] [int] NULL,
  [Item] [nvarchar](100) NULL,
  [Result] [nvarchar](20) NULL,
  [RecordKey] [nvarchar](50) NULL,
  [RecordDescription] [nvarchar](255) NULL,
  [Message] [nvarchar](3000) NULL,
  CONSTRAINT [PK_BlackBoxProcessDetailLog_ProcessDetailID] PRIMARY KEY CLUSTERED 
  (
    [ProcessDetailID] ASC
  )
)

GO


---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************
