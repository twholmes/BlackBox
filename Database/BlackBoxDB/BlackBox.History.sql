--------------------------------------------------------------------------------------
-- Copyright (C) 2023 Crayon
-- BLACKBOX CONFIGURATION
-- This file configures BlackBox for History 
--
--------------------------------------------------------------------------------------

--USE [BlackBox]
--GO

---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************

----
---- BLACKBOX HISTORY TABLES
----

--------------------------------------------------------------------------------------------------------
-- dbo.BlackBoxHistory: Records action history records

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BlackBoxHistory]') AND type in (N'U'))
DROP TABLE [dbo].[BlackBoxHistory]
GO

CREATE TABLE [dbo].[BlackBoxHistory]
(
  [ID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
  [Object] [nvarchar](64),
  [RefID] int NULL,
  [UserID] int,
  [ActorID] int,  
  [Action] [nvarchar](256),  
  [Message] [nvarchar](2048),  
  [TimeStamp] datetime
)

GO

DBCC CHECKIDENT ('dbo.BlackBoxHistory', RESEED, 1000)
GO

----
---- BLACKBOX HISTORY VIEWS
----

--------------------------------------------------------------------------------------------------------
-- dbo.vBlackBoxHistory: View definiton for vBlackBoxHistory

IF EXISTS (SELECT 1 FROM dbo.sysobjects WHERE id = object_id('dbo.vBlackBoxHistory') AND OBJECTPROPERTY(id, 'IsView') = 1)
  DROP VIEW [dbo].[vBlackBoxHistory]
GO

CREATE VIEW [dbo].[vBlackBoxHistory] AS
  SELECT
    h.[ID]
    ,h.[Object]
    ,h.[RefID]
    ,h.[UserID]
    ,h.[ActorID]    
    ,COALESCE(c.[FirstName],' ',c.[LastName]) AS [User]
    ,c.[SAMAccountName]
    ,h.[Action]
    ,h.[Message]
    ,h.[TimeStamp]
  FROM [dbo].[BlackBoxHistory] AS h
    LEFT OUTER JOIN [dbo].[sysContacts] AS c ON h.[UserID] = c.[ID]

GO

---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BlackBoxFNMSReportHistory]') AND type in (N'U'))
DROP TABLE [dbo].[BlackBoxFNMSReportHistory]
GO

CREATE TABLE [dbo].[BlackBoxFNMSReportHistory]
(
  [ID] int IDENTITY NOT NULL PRIMARY KEY,
  [ReportID] int,
  [ReportName] [nvarchar](256),
  [Rows] int,
  [Status] int,
  [TimeStamp] datetime
)

GO

---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************
