--------------------------------------------------------------------------------------
-- Copyright (C) 2023 Crayon
-- BLACKBOX TEMPLATES (1)
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

DELETE FROM [dbo].[BlackBoxJobs] WHERE [JOBID] = 1
GO

DECLARE @JobNumber int
DECLARE @JobGUID [nvarchar](36)
DECLARE @FilePath [nvarchar](512)

SET @JobGUID = '11111111-1111-1111-1111-111111111111'
SET @FilePath = 'C:\ProgramData\Crayon\BlackBox\Data\uploads\11111111-1111-1111-1111-111111111111'

--SET @JobNumber = 0
INSERT INTO [dbo].[BlackBoxJobs] ([JOBID],[GUID],[Category],[Group],[Description],[UserID],[StatusID],[TimeStamp])
VALUES (1,@JobGUID,'Upload','Template','Templates ininitalisaton job',99,7,'2023-01-30 00:00:00.000')

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

DELETE FROM [dbo].[BlackBoxFiles] WHERE [JOBID] = 1
GO

DECLARE @JobGUID [nvarchar](36)
DECLARE @FilePath [nvarchar](512)

SET @JobGUID = '11111111-1111-1111-1111-111111111111'
SET @FilePath = 'C:\ProgramData\Crayon\BlackBox\Data\uploads\11111111-1111-1111-1111-111111111111'

--SET @FileNumber = 2, @JobNumber = 1
INSERT INTO [dbo].[BlackBoxFiles] ([FID],[JOBID],[GUID],[Name],[Location],[TypeID],[Group],[Description],[DataSource],[DataSourceInstanceID],[Datasets],[StatusID],[Locked],[TimeStamp])
VALUES (2,1,@JobGUID,'Template-Contacts-v1.0.xlsx',@FilePath+'\Template-Contacts-v1.0.xlsx',5,'Templates','Contacts template','Contacts',2,'Contacts',7,0,'2023-01-30 00:00:00.000')

GO

SET IDENTITY_INSERT [dbo].[BlackBoxFiles] OFF
GO


----
---- BLACKBOX DATA SOURCE TABLES
----

--------------------------------------------------------------------------------------------------------
-- dbo.BlackBoxDataSourceInstances: Add sample data source instances to the BlackBoxDataSourceInstances table

DELETE FROM [dbo].[BlackBoxDataSourceInstances] WHERE [JOBID] = 1
GO

SET IDENTITY_INSERT [dbo].[BlackBoxDataSourceInstances] ON
GO

DECLARE @JobGUID [nvarchar](36)
DECLARE @FilePath [nvarchar](512)

SET @JobGUID = '11111111-1111-1111-1111-111111111111'
SET @FilePath = 'C:\ProgramData\Crayon\BlackBox\Data\templates\Manager'

--SET @ID = 2, @FileNumber = 2, @JobNumber = 1
INSERT INTO [dbo].[BlackBoxDataSourceInstances] ([ID],[Name],[Group],[Comment],[TypeID],[ReferenceID],[Source],[Datasets],[Prefix],[JobID],[GUID],[StatusID],[Locked],[TimeStamp])
VALUES (2,'Contacts','Templates','BlackBox contact data',5,2,@FilePath+'\Template-Contacts-v1.0.xlsx','Contacts','sys',1,@JobGUID,7,0,'2023-01-30 00:00:00.000')

GO

SET IDENTITY_INSERT [dbo].[BlackBoxDataSourceInstances] OFF
GO

----
---- BLACKBOX DATASET TABLES
----

--------------------------------------------------------------------------------------------------------
-- dbo.BlackBoxDatasetUpdates: Add sample data set instances to the BlackBoxDatasetUpdates table

DELETE FROM [dbo].[BlackBoxDatasetUpdates] WHERE [JOBID] = 1
GO

SET IDENTITY_INSERT [dbo].[BlackBoxDatasetUpdates] ON
GO

DECLARE @JobGUID [nvarchar](36)
DECLARE @FilePath [nvarchar](512)

SET @JobGUID = '11111111-1111-1111-1111-111111111111'
SET @FilePath = 'C:\ProgramData\Crayon\BlackBox\Data\templates\Manager'

--SET @ID = 2, @FileNumber = 2, @JobNumber = 1
INSERT INTO [dbo].[BlackBoxDatasetUpdates] ([ID],[Name],[Group],[Flags],[Comment],[TableName],[DataSourceInstanceID],[DataSource],[JOBID],[GUID],[Rows],[StatusID],[TimeStamp])
VALUES (2,'Contacts','Templates','system','BlackBox contacts initialised','sysContacts',2,'Contacts',1,@JobGUID,6,7,'2023-01-30 00:00:00.000')

GO

SET IDENTITY_INSERT [dbo].[BlackBoxDatasetUpdates] OFF
GO


---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************

--PRINT 'Configuring BlackBox Contact Samples'

--DELETE FROM [dbo].[sysContacts]
--GO

--DBCC CHECKIDENT ('dbo.sysContacts', RESEED, 0)
--GO

--SET IDENTITY_INSERT [dbo].[sysContacts] ON
--GO

--SET @JobNumber = 1, @DataSourceInstanceID = 3
--INSERT INTO [dbo].[sysContacts] ([ID],[JobID],[DataSourceInstanceID],[LineNumber],[Exclude],[FlexeraID],[Cohort],[UID],[FullName],[FirstName],[LastName],[AddressBook],[Domain],[SAMAccountName],[Email],[PhotoFileName],[Country],[City],[Address],[Phone],[Birthday],[Site],[Business],[Job],[Memberships],[Guest],[Operator],[Manager],[Administrator],[Password],[Credits],[Status],[UpdatedBy],[Updated])
--VALUES (1,1,2,1,0,0,'system','00000000-0000-0000-0001-000000000000','Guest','Guest','','User','FLEXDEMO','Guest','guest@crayon.com','guest.jpg','Australia','Melbourne','44 Lakeview Drive Scoresby VIC 3179','',PARSE('01/01/2021' as date USING 'AR-LB'),'','','user','guest',1,0,0,0,'password',100,0,'system',CONVERT(datetime,'13/08/2021',103))

--INSERT INTO [dbo].[sysContacts] ([ID],[JobID],[DataSourceInstanceID],[LineNumber],[Exclude],[FlexeraID],[Cohort],[UID],[FullName],[FirstName],[LastName],[AddressBook],[Domain],[SAMAccountName],[Email],[PhotoFileName],[Country],[City],[Address],[Phone],[Birthday],[Site],[Business],[Job],[Memberships],[Guest],[Operator],[Manager],[Administrator],[Password],[Credits],[Status],[UpdatedBy],[Updated])
--VALUES (2,1,2,2,0,0,'system','00000000-0000-0000-0002-000000000000','Operator','Operator','','User','FLEXDEMO','Operator','user@crayon.com','supervisor.png','Australia','Melbourne','44 Lakeview Drive Scoresby VIC 3179','',PARSE('01/01/2021' as date USING 'AR-LB'),'','','Asset Manager','guest,asset',1,1,0,0,'password',100,0,'system',CONVERT(datetime,'13/08/2021',103))

--INSERT INTO [dbo].[sysContacts] ([ID],[JobID],[DataSourceInstanceID],[LineNumber],[Exclude],[FlexeraID],[Cohort],[UID],[FullName],[FirstName],[LastName],[AddressBook],[Domain],[SAMAccountName],[Email],[PhotoFileName],[Country],[City],[Address],[Phone],[Birthday],[Site],[Business],[Job],[Memberships],[Guest],[Operator],[Manager],[Administrator],[Password],[Credits],[Status],[UpdatedBy],[Updated])
--VALUES (3,1,2,3,0,0,'system','00000000-0000-0000-0003-000000000000','Manager','Manager','','User','FLEXDEMO','Manager','user@crayon.com','manager.png','Australia','Melbourne','44 Lakeview Drive Scoresby VIC 3179','',PARSE('01/01/2021' as date USING 'AR-LB'),'','','Storeman','guest,stores',1,1,1,0,'password',100,0,'system',CONVERT(datetime,'13/08/2021',103))

--INSERT INTO [dbo].[sysContacts] ([ID],[JobID],[DataSourceInstanceID],[LineNumber],[Exclude],[FlexeraID],[Cohort],[UID],[FullName],[FirstName],[LastName],[AddressBook],[Domain],[SAMAccountName],[Email],[PhotoFileName],[Country],[City],[Address],[Phone],[Birthday],[Site],[Business],[Job],[Memberships],[Guest],[Operator],[Manager],[Administrator],[Password],[Credits],[Status],[UpdatedBy],[Updated])
--VALUES (4,1,2,4,0,0,'system','00000000-0000-0000-0003-000000000000','Administrator','Administrator','','User','FLEXDEMO','Administrator','user@crayon.com','businessman.png','Australia','Melbourne','44 Lakeview Drive Scoresby VIC 3179','',PARSE('01/01/2021' as date USING 'AR-LB'),'','','Buyer','guest,purchase',1,1,1,1,'password',100,0,'system',CONVERT(datetime,'13/08/2021',103))

--SET @JobNumber = 1, @DataSourceInstanceID = 3
--INSERT INTO [dbo].[sysContacts] ([ID],[JobID],[DataSourceInstanceID],[LineNumber],[Exclude],[FlexeraID],[Cohort],[UID],[FullName],[FirstName],[LastName],[AddressBook],[Domain],[SAMAccountName],[Email],[PhotoFileName],[Country],[City],[Address],[Phone],[Birthday],[Site],[Business],[Job],[Memberships],[Guest],[Operator],[Manager],[Administrator],[Password],[Credits],[Status],[UpdatedBy],[Updated])
--VALUES (99,1,2,1,0,0,'system','00000000-0000-0000-0001-000000000000','System','System','','User','FLEXDEMO','System','system@crayon.com','superman.png','Australia','Melbourne','44 Lakeview Drive Scoresby VIC 3179','',PARSE('01/01/2021' as date USING 'AR-LB'),'','','system','system',1,1,1,1,'password',100,0,'system',CONVERT(datetime,'13/08/2021',103))

--GO

--SET IDENTITY_INSERT [dbo].[sysContacts] OFF
--GO

--UPDATE [dbo].[sysContacts] SET [JobID]=1, [DataSourceInstanceID]=2, [LineNumber]=[ID], [Exclude]=0, [FlexeraID]=0
--GO

--EXEC [dbo].[StageContacts] @DataSourceInstanceID=2, @KeepExisting=1
--GO

---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************
