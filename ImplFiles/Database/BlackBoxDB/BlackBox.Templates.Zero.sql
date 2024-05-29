--------------------------------------------------------------------------------------
-- Copyright (C) 2023 Crayon
-- BLACKBOX TEMPLATES (0)
-- This file configures BlackBox for a sample set of Jobs, Files, DataSources 
-- and Datasets
--
--------------------------------------------------------------------------------------

--USE [BlackBox]
--GO

---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************

----
---- BLACKBOX JOBS TABLES
----

--------------------------------------------------------------------------------------------------------
-- dbo.BlackBoxJob: Add sample jobs to BlackBoxJobs table

PRINT 'Configuring BlackBox Jobs Samples'

SET IDENTITY_INSERT [dbo].[BlackBoxJobs] ON
GO

DELETE FROM [dbo].[BlackBoxJobs] WHERE [JOBID] = 0
GO

DECLARE @JobNumber int
DECLARE @JobGUID [nvarchar](36)
DECLARE @FilePath [nvarchar](512)

SET @JobGUID = '00000000-0000-0000-0000-000000000000'
SET @FilePath = 'C:\ProgramData\Crayon\BlackBox\Data\uploads\00000000-0000-0000-0000-000000000000'

--SET @JobNumber = 0
INSERT INTO [dbo].[BlackBoxJobs] ([JOBID],[GUID],[Category],[Group],[Description],[UserID],[StatusID],[TimeStamp])
VALUES (0,@JobGUID,'Upload','Template','Templates ininitalisaton job',99,5,'2023-01-30 00:00:00.000')

GO

SET IDENTITY_INSERT [dbo].[BlackBoxJobs] OFF
GO
----
---- BLACKBOX FILES TABLES
----

--------------------------------------------------------------------------------------------------------
-- dbo.BlackBoxFiles: Add sample files to BlackBoxFiles table

PRINT 'Configuring BlackBox Files Samples'

SET IDENTITY_INSERT [dbo].[BlackBoxFiles] ON
GO

DELETE FROM [dbo].[BlackBoxFiles] WHERE [JOBID] = 0
GO

DECLARE @JobGUID [nvarchar](36)
DECLARE @FilePath [nvarchar](512)

SET @JobGUID = '00000000-0000-0000-0000-000000000000'
SET @FilePath = 'C:\ProgramData\Crayon\BlackBox\Data\uploads\00000000-0000-0000-0000-000000000000'

--SET @FileNumber = 1, @JobNumber = 1
INSERT INTO [dbo].[BlackBoxFiles] ([FID],[JOBID],[GUID],[Name],[Location],[TypeID],[Group],[Description],[DataSource],[DataSourceInstanceID],[Datasets],[StatusID],[Locked],[TimeStamp])
VALUES (1,0,@JobGUID,'Template-System-v1.0.xlsx',@FilePath+'\Template-System-v1.0.xlsx',5,'Templates','System template','System',1,'DataMappings',7,0,'2023-01-30 00:00:00.000')

GO

SET IDENTITY_INSERT [dbo].[BlackBoxFiles] OFF
GO


----
---- BLACKBOX DATA SOURCE TABLES
----

--------------------------------------------------------------------------------------------------------
-- dbo.BlackBoxDataSourceInstances: Add sample data source instances to the BlackBoxDataSourceInstances table

DELETE FROM [dbo].[BlackBoxDataSourceInstances] WHERE [JOBID] = 0
GO

SET IDENTITY_INSERT [dbo].[BlackBoxDataSourceInstances] ON
GO

DECLARE @JobGUID [nvarchar](36)
DECLARE @FilePath [nvarchar](512)

SET @JobGUID = '00000000-0000-0000-0000-000000000000'
SET @FilePath = 'C:\ProgramData\Crayon\BlackBox\Data\templates\System'

--SET @ID = 1, @FileNumber = 1, @JobNumber = 0
INSERT INTO [dbo].[BlackBoxDataSourceInstances] ([ID],[Name],[Group],[Comment],[TypeID],[ReferenceID],[Source],[Datasets],[Prefix],[JobID],[GUID],[StatusID],[Locked],[TimeStamp])
VALUES (1,'System','Templates','BlackBox system data',5,1,@FilePath+'\Template-System-v1.0.xlsx','DataMappings','sys',0,@JobGUID,7,0,'2023-01-30 00:00:00.000')

GO

SET IDENTITY_INSERT [dbo].[BlackBoxDataSourceInstances] OFF
GO

----
---- BLACKBOX DATASET TABLES
----

--------------------------------------------------------------------------------------------------------
-- dbo.BlackBoxDatasetUpdates: Add sample data set instances to the BlackBoxDatasetUpdates table

DELETE FROM [dbo].[BlackBoxDatasetUpdates] WHERE [JOBID] = 0
GO

SET IDENTITY_INSERT [dbo].[BlackBoxDatasetUpdates] ON
GO

DECLARE @JobGUID [nvarchar](36)
DECLARE @FilePath [nvarchar](512)

SET @JobGUID = '00000000-0000-0000-0000-000000000000'
SET @FilePath = 'C:\ProgramData\Crayon\BlackBox\Data\templates\System'

--SET @ID = 1, @FileNumber = 1, @JobNumber = 0
INSERT INTO [dbo].[BlackBoxDatasetUpdates] ([ID],[Name],[Group],[Flags],[Comment],[TableName],[DataSourceInstanceID],[DataSource],[JOBID],[GUID],[Rows],[StatusID],[TimeStamp])
VALUES (1,'System','Templates','system','System data initialised','sysDataMappings',1,'System',0,@JobGUID,52,7,'2023-01-30 00:00:00.000')

GO

SET IDENTITY_INSERT [dbo].[BlackBoxDatasetUpdates] OFF
GO

---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************
