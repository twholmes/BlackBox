--------------------------------------------------------------------------------------
-- Copyright (C) 2023 Crayon
-- BLACKBOX CONFIGURATION
-- This file configures BlackBox for job recording and transactions 
--
--------------------------------------------------------------------------------------

USE $(DBName)
GO

---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************

----
---- BLACKBOX JOBS TABLES
----

--------------------------------------------------------------------------------------------------------
-- dbo.BlackBoxJobStatus: Reference table for job status

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BlackBoxJobStatus]') AND type in (N'U'))
DROP TABLE [dbo].[BlackBoxJobStatus]
GO

CREATE TABLE [dbo].[BlackBoxJobStatus]
(
  [StatusID] int NOT NULL PRIMARY KEY,
  [Status] [nvarchar](256)
)
GO

--------------------------------------------------------------------------------------------------------
-- Configure Jobs Status

-- included so these statements can be run independantly of a rebuild
DELETE FROM [dbo].[BlackBoxJobStatus]
GO

INSERT INTO [dbo].[BlackBoxJobStatus] ([StatusID],[Status])
VALUES (0, 'null')

INSERT INTO [dbo].[BlackBoxJobStatus] ([StatusID],[Status])
VALUES (1, 'ready')

INSERT INTO [dbo].[BlackBoxJobStatus] ([StatusID],[Status])
VALUES (2, 'blocked')

INSERT INTO [dbo].[BlackBoxJobStatus] ([StatusID],[Status])
VALUES (3, 'running')

INSERT INTO [dbo].[BlackBoxJobStatus] ([StatusID],[Status])
VALUES (4, 'paused')

INSERT INTO [dbo].[BlackBoxJobStatus] ([StatusID],[Status])
VALUES (5, 'completed')

INSERT INTO [dbo].[BlackBoxJobStatus] ([StatusID],[Status])
VALUES (6, 'archived')

INSERT INTO [dbo].[BlackBoxJobStatus] ([StatusID],[Status])
VALUES (7, 'other')

GO

--------------------------------------------------------------------------------------------------------
-- dbo.BlackBoxJobs: Records all jobs

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BlackBoxJobs]') AND type in (N'U'))
DROP TABLE [dbo].[BlackBoxJobs]
GO

CREATE TABLE [dbo].[BlackBoxJobs]
(
  [JOBID] int IDENTITY NOT NULL PRIMARY KEY,
  [GUID] [nvarchar](36),
  [Category] [nvarchar](64),
  [Group] [nvarchar](64),
  [Description] [nvarchar](2048),
  [StatusID] int,
  [UserID] int,  
  [TimeStamp] datetime
)

GO

DBCC CHECKIDENT ('dbo.BlackBoxJobs', RESEED, 1000)
GO

----
---- BLACKBOX JOB VIEWS
----

--------------------------------------------------------------------------------------------------------
-- dbo.vBlackBoxJobs: View definiton for vBlackBoxJobs

IF EXISTS (SELECT 1 FROM dbo.sysobjects WHERE id = object_id('dbo.vBlackBoxJobs') AND OBJECTPROPERTY(id, 'IsView') = 1)
  DROP VIEW [dbo].[vBlackBoxJobs]
GO

CREATE VIEW [dbo].[vBlackBoxJobs] AS
  SELECT
    j.[JOBID]
    ,j.[GUID]
    ,j.[Category]
    ,j.[Group]
    ,j.[Description]
    ,j.[StatusID]
    ,case
       when j.[StatusID] is null then 'null' 
       when j.[StatusID] = 0 then 'null'
       when j.[StatusID] = 1 then 'ready' 
       when j.[StatusID] = 2 then 'blocked'             
       when j.[StatusID] = 3 then 'running'
       when j.[StatusID] = 4 then 'paused'       
       when j.[StatusID] = 5 then 'completed'       
       when j.[StatusID] = 6 then 'archived'
       when j.[StatusID] > 7 then 'other'       
       when j.[StatusID] < 0 then 'error(' + convert(nvarchar(2),j.[StatusID]) + ')'
       else 'unknown'
     end AS [Status]
    ,j.[UserID]     
    ,j.[TimeStamp]
    ,DATEDIFF(day, j.[TimeStamp], GetDate()) AS [Age]
    ,ROW_NUMBER() OVER(PARTITION BY j.[GUID] ORDER BY j.[TimeStamp] desc) AS [Rank]    
  FROM [dbo].[BlackBoxJobs] AS j

GO

---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************
