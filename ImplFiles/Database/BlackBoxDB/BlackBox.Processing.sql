--------------------------------------------------------------------------------------
-- Copyright (C) 2024 Crayon
-- BLACKBOX CONFIGURATION
-- This file configures BlackBox for dataset recording and transacrions 
--
--------------------------------------------------------------------------------------

USE $(DBName)
GO

---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************

----
---- BLACKBOX PROCESSING VIEWS
----

--------------------------------------------------------------------------------------------------------
-- dbo.vBlackBoxProcessingResults: View definiton for vBlackBoxProcessingResults

IF EXISTS (SELECT 1 FROM dbo.sysobjects WHERE id = object_id('dbo.vBlackBoxProcessingResults') AND OBJECTPROPERTY(id, 'IsView') = 1)
  DROP VIEW [dbo].[vBlackBoxProcessingResults]
GO

CREATE VIEW [dbo].[vBlackBoxProcessingResults] AS
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
      ,pdl.[Action]      
      ,pdl.[RecordNumber]
      ,pdl.[Item]
      ,pdl.[Result]
      ,pdl.[RecordKey]
      ,pdl.[RecordDescription]
      ,pdl.[Message]
  FROM [dbo].[BlackBoxProcessDetailLog] AS pdl
    JOIN [dbo].[BlackBoxProcessSummaryLog] AS pl ON pl.ProcessID = pdl.ProcessID
    JOIN [dbo].[BlackBoxProcessStepLog] AS psl ON psl.ProcessStepID = pdl.ProcessStepID
  WHERE pdl.[Action] in ('File','Load','Validate','Stage','Process','Publish','Build','Run')

GO


---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************

----
---- BLACKBOX PROCESSING PROCEDURES
----

/****** ClearProcessResults: [dbo].[ClearProcessResults] ******/
IF EXISTS(SELECT 1 FROM sys.procedures WHERE Name = 'ClearProcessResults')
  DROP PROCEDURE [dbo].[ClearProcessResults]
GO

CREATE PROCEDURE [dbo].[ClearProcessResults]
  @ProcessName [nvarchar](255),  
  @FileID int
AS
  PRINT 'Clear ' + @ProcessName + ' processing results for FileID=' + convert(nvarchar(5), @FileID)

  DECLARE @DataSourceInstanceID int  
  SELECT @DataSourceInstanceID = [DataSourceInstanceID] FROM [dbo].[BlackBoxFiles] WHERE [FID] = @FileID

  DELETE FROM [dbo].[BlackBoxProcessDetailLog]
  WHERE [ProcessDetailID] in
  (
    SELECT [ProcessDetailID]
    FROM [dbo].[BlackBoxProcessDetailLog] AS pdl
    JOIN [dbo].[BlackBoxProcessSummaryLog] AS pl ON pl.[ProcessID] = pdl.[ProcessID]
    WHERE pdl.[DataSourceInstanceID] = @DataSourceInstanceID AND pl.[ProcessName] = @ProcessName
  )

  DELETE FROM [dbo].[BlackBoxProcessStepLog] 
  WHERE [ProcessStepID] in
  (
    SELECT [ProcessStepID]
    FROM [dbo].[BlackBoxProcessStepLog] AS psl 
    JOIN [dbo].[BlackBoxProcessSummaryLog] AS pl ON pl.[ProcessID] = psl.[ProcessID]
    WHERE psl.[DataSourceInstanceID] = @DataSourceInstanceID AND pl.[ProcessName] = @ProcessName
  )

  DELETE FROM [dbo].[BlackBoxProcessSummaryLog] WHERE [DataSourceInstanceID] = @DataSourceInstanceID AND [ProcessName] = @ProcessName

GO

/****** ClearProcessStepResults: [dbo].[ClearProcessStepResults] ******/
IF EXISTS(SELECT 1 FROM sys.procedures WHERE Name = 'ClearProcessStepResults')
  DROP PROCEDURE [dbo].[ClearProcessStepResults]
GO

CREATE PROCEDURE [dbo].[ClearProcessStepResults]
  @ProcessName [nvarchar](255),  
  @ProcessStepName [nvarchar](255),    
  @FileID int
AS
  PRINT 'Clear ' + @ProcessName + '/' + @ProcessStepName + ' processing results for FileID=' + convert(nvarchar(5), @FileID)

  DECLARE @DataSourceInstanceID int  
  SELECT @DataSourceInstanceID = [DataSourceInstanceID] FROM [dbo].[BlackBoxFiles] WHERE [FID] = @FileID

  DECLARE @ProcessID int  
  SELECT @ProcessID = [ProcessID] FROM [dbo].[BlackBoxProcessSummaryLog] WHERE [DataSourceInstanceID] = @DataSourceInstanceID AND [ProcessName] = @ProcessName

  DELETE FROM [dbo].[BlackBoxProcessDetailLog]
  WHERE [ProcessDetailID] in
  (
    SELECT [ProcessDetailID]
    FROM [dbo].[BlackBoxProcessDetailLog] AS pdl
    JOIN [dbo].[BlackBoxProcessSummaryLog] AS pl ON pl.[ProcessID] = pdl.[ProcessID]
    WHERE pdl.[DataSourceInstanceID] = @DataSourceInstanceID AND pl.[ProcessID] = @ProcessID
  )

  DELETE FROM [dbo].[BlackBoxProcessStepLog] WHERE [DataSourceInstanceID] = @DataSourceInstanceID AND [ProcessID] = @ProcessID

GO


---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************

/****** PostProcessingResult: [dbo].[PostProcessingResult] ******/
IF EXISTS(SELECT 1 FROM sys.procedures WHERE Name = 'PostProcessingResult')
  DROP PROCEDURE [dbo].[PostProcessingResult]
GO

CREATE PROCEDURE [dbo].[PostProcessingResult]
  @JobID int,
  @FileID int,
  @ProcessName [nvarchar](255),
  @ProcessStepName [nvarchar](255),
  @Action [nvarchar](20),  
  @ProcessingMessage NVARCHAR(3000),
  @Level nvarchar(20) = 'info',
  @UserID [int] = 99
AS
  PRINT 'Post processing result for FileID=' + convert(nvarchar(5), @FileID)

  DECLARE @DatasetName nvarchar(64)
  DECLARE @DataSourceInstanceID int  
  DECLARE @FileName nvarchar(256)
  DECLARE @StatusNum nvarchar(5)  
  SELECT @FileName = [Name], @DatasetName = [DataSource], @DataSourceInstanceID = [DataSourceInstanceID], @StatusNum = CONVERT(nvarchar(5),[StatusID]) FROM [dbo].[BlackBoxFiles] WHERE [FID] = @FileID

  DECLARE @ProcessID int
  SELECT @ProcessID = [ProcessID] FROM [dbo].[BlackBoxProcessSummaryLog] WHERE [ProcessName] = @ProcessName AND [DataSourceInstanceID] = @DataSourceInstanceID
  IF @ProcessID IS NULL
  BEGIN
    INSERT INTO [dbo].[BlackBoxProcessSummaryLog] ([JobID],[ProcessName],[DatasetName],[DataSourceInstanceID],[Action],[StartDate],[EndDate],[Status],[Total],[Excluded],[Processed],[Result],[UserID])
    VALUES (@JobID, @ProcessName, @DatasetName, @DataSourceInstanceID, @Action, GetDate(), GetDate(), 0, 0, 0, 0, '', @UserID)
    SET @ProcessID = SCOPE_IDENTITY()
  END

  DECLARE @ProcessStepID int
  SELECT @ProcessStepID = [ProcessStepID] FROM [dbo].[BlackBoxProcessStepLog] WHERE [ProcessID] = @ProcessID AND [ProcessStepName] = @ProcessStepName
  IF @ProcessStepID IS NULL
  BEGIN    
    INSERT INTO BlackBoxProcessStepLog ([ProcessStepName],[ProcessID],[JobID],[DatasetName],[DataSourceInstanceID],[StartDate],[EndDate],[Status],[Total],[Excluded],[Processed],[Matched],[Errors],[Warnings],[Updated],[Created],[Deleted])
    VALUES (@ProcessStepName, @ProcessID, @JobID, @DatasetName, @DataSourceInstanceID, GETDATE(), GETDATE(), 1, 0, 0, 0, 0, 0, 0, 0, 0, 0)
    SET @ProcessStepID = SCOPE_IDENTITY()
  END

  DECLARE @RecordKey nvarchar(512)
  SET @RecordKey = ''

  DECLARE @Command NVARCHAR(MAX)
  SET @Command = '
    INSERT dbo.BlackBoxProcessDetailLog
    (
      ProcessID,
      ProcessStepID,        
      JobID,
      DatasetName,
      DataSourceInstanceID,
      Action,
      RecordNumber,
      Item,
      Result,
      RecordKey,
      RecordDescription,
      Message

    )
    SELECT
      lo.ProcessID, 
      lo.ProcessStepID,        
      lo.JobID,
      uf.[DataSource],
      CONVERT(nvarchar(5), uf.[DataSourceInstanceID]),
      ''' + @Action + ''',
      uf.[FID],
      ''Status=' + @StatusNum + ''',
      ''' + @Level + ''',
      LEFT(uf.[Name],50),
      uf.[Location],
      ''' + @ProcessingMessage + '''
    FROM dbo.[BlackBoxFiles] uf,
      dbo.BlackBoxProcessStepLog lo
    WHERE 
      lo.ProcessID = @ProcessID AND lo.ProcessStepID = @ProcessStepID
      AND uf.[FID] = ' + CONVERT(nvarchar(5), @FileID) + '

    SET @Result = 0
  '

  PRINT 'Executing SQL: ' + @Command
  BEGIN TRY
    DECLARE @Result BIT
    EXEC sp_executesql @Command
      , N'@ProcessID INT, @ProcessStepID INT, @ProcessingMessage NVARCHAR(3000), @Result INT OUTPUT'
      , @ProcessID = @ProcessID, @ProcessStepID = @ProcessStepID, @ProcessingMessage = @ProcessingMessage, @Result = @Result OUTPUT

  END TRY
  BEGIN CATCH
    DECLARE @m NVARCHAR(MAX)
    SET @m = 'Error executing processing post: ' + ERROR_MESSAGE() + ' Line ' + CAST(ERROR_LINE() AS NVARCHAR(5))
    PRINT @m
      ; THROW
  END CATCH

  /***
  **** DECLARE @Message [nvarchar](1024)
  **** SET @Message = 'DataSourceInstance status update: Action=' + @Action + ', DataSourceInstanceID=' + convert(nvarchar(5),@DataSourceInstanceID
  **** INSERT INTO [dbo].[BlackBoxHistory] ([Object],[RefID],[UserID],[Action],[Message],[TimeStamp]) VALUES('DataSourceInstance', @DataSourceInstanceID, @UserID, @Action, @Message, GetDate())
  ***/
GO


/****** PostFileUploadingResult: [dbo].[PostFileUploadingResult] ******/
IF EXISTS(SELECT 1 FROM sys.procedures WHERE Name = 'PostFileUploadingResult')
  DROP PROCEDURE [dbo].[PostFileUploadingResult]
GO

CREATE PROCEDURE [dbo].[PostFileUploadingResult]
  @JobID int,
  @FileID int,
  @Action [nvarchar](20),  
  @ProcessingMessage NVARCHAR(3000),
  @UserID [int] = 99
AS
  PRINT 'Post file uploading result for FileID=' + convert(nvarchar(5), @FileID)

  DECLARE @ProcessName [nvarchar](255)
  SET @ProcessName = 'Load'

  DECLARE @ProcessStepName [nvarchar](255)
  SET @ProcessStepName = 'Upload'

  EXEC [dbo].[PostProcessingResult]
    @JobID = @JobID,
    @FileID = @FileID,
    @ProcessName = @ProcessName,
    @ProcessStepName = @ProcessStepName,
    @Action = @Action,  
    @ProcessingMessage = @ProcessingMessage,
    @Level = 'info',
    @UserID = @UserID

GO

/****** PostFileStagingResult: [dbo].[PostFileStagingResult] ******/
IF EXISTS(SELECT 1 FROM sys.procedures WHERE Name = 'PostFileStagingResult')
  DROP PROCEDURE [dbo].[PostFileStagingResult]
GO

CREATE PROCEDURE [dbo].[PostFileStagingResult]
  @JobID int,
  @FileID int,
  @Action [nvarchar](20),  
  @ProcessingMessage NVARCHAR(3000),
  @UserID [int] = 99
AS
  PRINT 'Post file staging result for FileID=' + convert(nvarchar(5), @FileID)

  DECLARE @ProcessName [nvarchar](255)
  SET @ProcessName = 'Load'

  DECLARE @ProcessStepName [nvarchar](255)
  SET @ProcessStepName = 'Stage'

  EXEC [dbo].[PostProcessingResult]
    @JobID = @JobID,
    @FileID = @FileID,
    @ProcessName = @ProcessName,
    @ProcessStepName = @ProcessStepName,
    @Action = @Action,  
    @ProcessingMessage = @ProcessingMessage,
    @Level = 'info',
    @UserID = @UserID

GO

/****** PostFileStagingResult: [dbo].[PostFilePublishingResult] ******/
IF EXISTS(SELECT 1 FROM sys.procedures WHERE Name = 'PostFilePublishingResult')
  DROP PROCEDURE [dbo].[PostFilePublishingResult]
GO

CREATE PROCEDURE [dbo].[PostFilePublishingResult]
  @JobID int,
  @FileID int,
  @Action [nvarchar](20),  
  @ProcessingMessage NVARCHAR(3000),
  @UserID [int] = 99
AS
  PRINT 'Post file staging result for FileID=' + convert(nvarchar(5), @FileID)

  DECLARE @ProcessName [nvarchar](255)
  SET @ProcessName = 'Load'

  DECLARE @ProcessStepName [nvarchar](255)
  SET @ProcessStepName = 'Publish'

  EXEC [dbo].[PostProcessingResult]
    @JobID = @JobID,
    @FileID = @FileID,
    @ProcessName = @ProcessName,
    @ProcessStepName = @ProcessStepName,
    @Action = @Action,  
    @ProcessingMessage = @ProcessingMessage,
    @Level = 'info',
    @UserID = @UserID

GO

--- EXEC [dbo].[PostFileUploadingResult] @JobID=1000,  @FileID=1000, @Action='Load', @ProcessingMessage='test load'

/****** PostFileAdapterResult: [dbo].[PostFileAdapterResult] ******/
IF EXISTS(SELECT 1 FROM sys.procedures WHERE Name = 'PostFileAdapterResult')
  DROP PROCEDURE [dbo].[PostFileAdapterResult]
GO

CREATE PROCEDURE [dbo].[PostFileAdapterResult]
  @JobID int,
  @FileID int,
  @Action [nvarchar](20),  
  @ProcessingMessage NVARCHAR(3000),
  @Level nvarchar(20) = 'info',  
  @UserID [int] = 99
AS
  PRINT 'Post adapter result for FileID=' + convert(nvarchar(5), @FileID)

  DECLARE @ProcessName [nvarchar](255)
  SET @ProcessName = 'Processing'

  DECLARE @ProcessStepName [nvarchar](255)
  SET @ProcessStepName = 'Adapter'

  EXEC [dbo].[PostProcessingResult]
    @JobID = @JobID,
    @FileID = @FileID,
    @ProcessName = @ProcessName,
    @ProcessStepName = @ProcessStepName,
    @Action = @Action,  
    @ProcessingMessage = @ProcessingMessage,
    @Level = @Level,
    @UserID = @UserID

GO


---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************

----
---- BLACKBOX HISTORY PROCEDURES
----

/****** PostProcessingResult: [dbo].[PostHistory] ******/
IF EXISTS(SELECT 1 FROM sys.procedures WHERE Name = 'PostHistory')
  DROP PROCEDURE [dbo].[PostHistory]
GO

CREATE PROCEDURE [dbo].[PostHistory]
  @Object [nvarchar](64),
  @FID int,
  @DSIID int,  
  @Action [nvarchar](20),  
  @Msg [nvarchar](2048),
  @UserID [int] = 99
AS
  PRINT 'Post to history for FID=' + convert(nvarchar(5), @FID) + ' and DSIID=' + convert(nvarchar(5), @DSIID)

  IF @DSIID IS NULL OR @DSIID = 0
  BEGIN
    SELECT @DSIID = [DataSourceInstanceID] FROM [dbo].[BlackBoxFiles] WHERE [FID] = @FID
  END

  DECLARE @InsertedID int  
  IF @DSIID IS NOT NULL AND @DSIID > 0
  BEGIN 
    INSERT INTO [dbo].[BlackBoxHistory] ([Object],[RefID],[UserID],[Action],[Message],[TimeStamp]) OUTPUT Inserted.ID 
    VALUES(@Object,@DSIID,@UserID,@Action,@Msg,GetDate())
    SET @InsertedID = SCOPE_IDENTITY()
  END
  
  RETURN @InsertedID

GO


---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************

----
---- BLACKBOX PROCESSING BASE PROCEDURES
----

/****** PostBaseProcessingResult: [dbo].[PostBaseProcessingResult] ******/
IF EXISTS(SELECT 1 FROM sys.procedures WHERE Name = 'PostBaseProcessingResult')
  DROP PROCEDURE [dbo].[PostBaseProcessingResult]
GO

CREATE PROCEDURE [dbo].[PostBaseProcessingResult]
  @JobID int,
  @ProcessName [nvarchar](255),
  @ProcessStepName [nvarchar](255),  
  @Action [nvarchar](20),  
  @DatasetName nvarchar(64),
  @DataSourceInstanceID int,
  @SourceTableName nvarchar(256),  
  @ProcessingMessage NVARCHAR(3000),
  @RecordKey nvarchar(512),
  @TraceField nvarchar(256),
  @Level nvarchar(20) = 'info',
  @UserID [int] = 99
AS
  PRINT 'Post processing result (' + @DatasetName + ') for dsiid=' + convert(nvarchar(5), @DataSourceInstanceID)

  DECLARE @ProcessID int
  SELECT @ProcessID = [ProcessID] FROM [dbo].[BlackBoxProcessSummaryLog] WHERE [ProcessName] = @ProcessName AND [DataSourceInstanceID] = @DataSourceInstanceID
  IF @ProcessID IS NULL
  BEGIN
    INSERT INTO [dbo].[BlackBoxProcessSummaryLog] ([JobID],[ProcessName],[DatasetName],[DataSourceInstanceID],[Action],[StartDate],[EndDate],[Status],[Total],[Excluded],[Processed],[Result],[UserID])
    VALUES (@JobID, @ProcessName, @DatasetName, @DataSourceInstanceID, @Action, GetDate(), GetDate(), 0, 0, 0, 0, '', @UserID)
    SET @ProcessID = SCOPE_IDENTITY()
  END

  DECLARE @ProcessStepID int
  SELECT @ProcessStepID = [ProcessID] FROM [dbo].[BlackBoxProcessStepLog] WHERE [ProcessID] = @ProcessID AND [ProcessStepName] = @ProcessStepName
  IF @ProcessStepID IS NULL
  BEGIN    
    INSERT INTO BlackBoxProcessStepLog ([ProcessStepName],[ProcessID],[JobID],[DatasetName],[DataSourceInstanceID],[StartDate],[EndDate],[Status],[Total],[Excluded],[Processed],[Matched],[Errors],[Warnings],[Updated],[Created],[Deleted])
    VALUES (@ProcessStepName, @ProcessID, @JobID, @DatasetName, @DataSourceInstanceID, GETDATE(), GETDATE(), 1, 0, 0, 0, 0, 0, 0, 0, 0, 0)
    SET @ProcessStepID = SCOPE_IDENTITY()
  END

  DECLARE @Command NVARCHAR(MAX)
  SET @Command = '
    INSERT dbo.BlackBoxProcessDetailLog
    (
      ProcessID,
      ProcessStepID,        
      JobID,
      DatasetName,
      DataSourceInstanceID,
      Action,
      RecordNumber,
      Item,
      Result,
      RecordKey,
      RecordDescription,
      Message
    )
    SELECT
      lo.ProcessID, 
      lo.ProcessStepID,        
      lo.JobID,
      ''' + @DatasetName + ''',
      ' + CONVERT(nvarchar(5), @DataSourceInstanceID) + ',
      ''' + @Action + ''',
      0,
      ''item'',
      ''' + @Level + ''',
      LEFT(source.[' + @RecordKey + '],50),
      LEFT(' + @TraceField + ', 255),
      ''' + @ProcessingMessage + '''
    FROM [' + @SourceTableName + '] source,
      dbo.BlackBoxProcessStepLog lo
    WHERE 
      lo.ProcessID = @ProcessID AND lo.ProcessStepID = @ProcessStepID
      AND source.[DataSourceInstanceID] = ' + CONVERT(nvarchar(5), @DataSourceInstanceID) + '

    SET @Result = 0
  '

  PRINT 'Executing SQL: ' + @Command
  BEGIN TRY
    DECLARE @Result BIT
    EXEC sp_executesql @Command
      , N'@ProcessID INT, @ProcessStepID INT, @ProcessingMessage NVARCHAR(3000), @Result INT OUTPUT'
      , @ProcessID = @ProcessID, @ProcessStepID = @ProcessStepID, @ProcessingMessage = @ProcessingMessage, @Result = @Result OUTPUT

  END TRY
  BEGIN CATCH
    DECLARE @m NVARCHAR(MAX)
    SET @m = 'Error executing processing post: ' + ERROR_MESSAGE() + ' Line ' + CAST(ERROR_LINE() AS NVARCHAR(5))
    PRINT @m
      ; THROW
  END CATCH

GO


---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************

----
---- BLACKBOX STATUS PROCEDURES
----

/****** UpdateFileStatus: [dbo].[UpdateFileStatus] ******/
IF EXISTS(SELECT 1 FROM sys.procedures WHERE Name = 'UpdateFileStatus')
  DROP PROCEDURE [dbo].[UpdateFileStatus]
GO

CREATE PROCEDURE [dbo].[UpdateFileStatus]
  @FileID [int],
  @StatusID [int],
  @Action [nvarchar](20) = 'unknown',
  @UserID [int] = 99
AS
  PRINT 'Updating status (' + convert(nvarchar(2), @StatusID) + ') for fid=' + convert(nvarchar(5), @FileID)

  UPDATE [dbo].[BlackBoxFiles] SET [StatusID]=@StatusID, [TimeStamp]=GETDATE() WHERE [FID] = @FileID

  DECLARE @DataSourceInstanceID [int] = 0
  SELECT @DataSourceInstanceID = [DataSourceInstanceID] FROM [dbo].[BlackBoxFiles] WHERE [FID] = @FileID

  UPDATE [dbo].[BlackBoxDataSourceInstances] SET [StatusID]=@StatusID,[TimeStamp]=GETDATE() WHERE [ID] = @DataSourceInstanceID
  UPDATE [dbo].[BlackBoxDatasetUpdates] SET [StatusID]=@StatusID, [TimeStamp]=GETDATE() WHERE [DataSourceInstanceID] = @DataSourceInstanceID

  DECLARE @Message [nvarchar](1024)
  SET @Message = 'File status updated to sid=' + convert(nvarchar(2),@StatusID) + ' after action=' + @Action  

  INSERT INTO [dbo].[BlackBoxHistory] ([Object],[RefID],[UserID],[Action],[Message],[TimeStamp]) VALUES('File', @DataSourceInstanceID, @UserID, @Action, @Message, GetDate())

GO

/****** UpdateDataSourceStatus: [dbo].[UpdateDataSourceStatus] ******/
IF EXISTS(SELECT 1 FROM sys.procedures WHERE Name = 'UpdateDataSourceStatus')
  DROP PROCEDURE [dbo].[UpdateDataSourceStatus]
GO

CREATE PROCEDURE [dbo].[UpdateDataSourceStatus]
  @DataSourceInstanceID [int],
  @StatusID [int],
  @Action [nvarchar](20) = 'unknown',
  @UserID [int] = 99
AS
  PRINT 'Updating status (' + convert(nvarchar(2), @StatusID) + ') for dsiid=' + convert(nvarchar(5), @DataSourceInstanceID)

  UPDATE [dbo].[BlackBoxDataSourceInstances] SET [StatusID]=@StatusID,[TimeStamp]=GETDATE() WHERE [ID] = @DataSourceInstanceID 
  UPDATE [dbo].[BlackBoxFiles] SET [StatusID]=@StatusID, [TimeStamp]=GETDATE() WHERE [DataSourceInstanceID] = @DataSourceInstanceID
  UPDATE [dbo].[BlackBoxDatasetUpdates] SET [StatusID]=@StatusID, [TimeStamp]=GETDATE() WHERE [DataSourceInstanceID] = @DataSourceInstanceID  

  DECLARE @FileID [int] = 0
  SELECT @FileID = [FID] FROM [dbo].[BlackBoxFiles] WHERE [DataSourceInstanceID] = @DataSourceInstanceID

  DECLARE @Message [nvarchar](1024)
  SET @Message = 'DataSourceInstance status updated to sid=' + convert(nvarchar(2),@StatusID) + ' after action=' + @Action

  INSERT INTO [dbo].[BlackBoxHistory] ([Object],[RefID],[UserID],[Action],[Message],[TimeStamp]) VALUES('DataSource', @FileID, @UserID, @Action, @Message, GetDate())

GO


---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************

----
---- BLACKBOX STAGING PROCEDURES
----

/****** StoredProcedure: [dbo].[LoadGeneric] ******/
IF EXISTS(SELECT 1 FROM sys.procedures WHERE Name = 'LoadGeneric')
  DROP PROCEDURE [dbo].[LoadGeneric]
GO

CREATE PROCEDURE [dbo].[LoadGeneric]
  @DataSourceInstanceID int,
  @JobID int = 0,   
  @SourceDataset [nvarchar](100),
  @KeepExisting [bit] = 0
AS
  PRINT 'Finalise ' + @SourceDataset + ' loading'

  DECLARE @FID int  
  DECLARE @TableName [nvarchar](1024)  
  DECLARE @StagedCount int  

  SELECT @FID = [FID] FROM [dbo].[BlackBoxFiles] WHERE [DataSourceInstanceID] = @DataSourceInstanceID  

  SELECT @TableName = [TableName] FROM [dbo].[BlackBoxDatasets] WHERE [Name] = @SourceDataset
  
  DECLARE @query [nvarchar](1024)
  DECLARE @parm [nvarchar](500);

  IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(@TableName) AND type in (N'U'))  
  BEGIN
    SET @query = 'SELECT @StagedCount = COUNT(*) FROM [dbo].[' + @TableName + '] WHERE [DataSourceInstanceID] = ' + convert(nvarchar(10), @DataSourceInstanceID)
    SET @parm = N'@StagedCount int OUTPUT';
    EXECUTE sp_executesql @query, @parm, @StagedCount=@StagedCount OUTPUT 
  END
 
  RETURN @StagedCount

GO

/****** StoredProcedure: [dbo].[LoadAssets] ******/
IF EXISTS(SELECT 1 FROM sys.procedures WHERE Name = 'LoadAssets')
  DROP PROCEDURE [dbo].[LoadAssets]
GO

CREATE PROCEDURE [dbo].[LoadAssets]  
  @DataSourceInstanceID int,
  @JobID int = 0,   
  @SourceDataset [nvarchar](100) = '%',
  @KeepExisting [bit] = 0
AS
  PRINT 'Finalise Asset Loading'

  UPDATE [dbo].[itamAssets] 
  SET [Exclude] = ''
  WHERE [Exclude] IS NULL
  
  DECLARE @StagedCount int 
  IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[itamAssets]') AND type in (N'U'))  
  BEGIN
    SELECT @StagedCount = COUNT(*) FROM [dbo].[itamAssets] WHERE [DataSourceInstanceID] = @DataSourceInstanceID
  END
 
  RETURN @StagedCount

GO

/****** StoredProcedure: [dbo].[LoadPurchases] ******/
IF EXISTS(SELECT 1 FROM sys.procedures WHERE Name = 'LoadPurchases')
  DROP PROCEDURE [dbo].[LoadPurchases]
GO

CREATE PROCEDURE [dbo].[LoadPurchases]  
  @DataSourceInstanceID int,
  @JobID int = 0,   
  @SourceDataset [nvarchar](100) = '%',
  @KeepExisting [bit] = 0,
  @StagedCount int OUTPUT
AS
  PRINT 'Finalise Purchases Loading'

  DECLARE @query [nvarchar](1024)
  DECLARE @parm [nvarchar](500);

  UPDATE [dbo].[itamPurchases] 
  SET [Exclude] = ''
  WHERE [Exclude] IS NULL
  
  IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[itamPurchases]') AND type in (N'U'))  
  BEGIN
    SET @query = 'SELECT @StagedCount = COUNT(*) FROM [dbo].[itamPurchases] WHERE [DataSourceInstanceID] = ' + convert(nvarchar(10), @DataSourceInstanceID)
    SET @parm = N'@StagedCount int OUTPUT';
    EXECUTE sp_executesql @query, @parm, @StagedCount=@StagedCount OUTPUT 
  END

GO

/****** StoredProcedure: [dbo].[LoadValidationLists] ******/
IF EXISTS(SELECT 1 FROM sys.procedures WHERE Name = 'LoadValidationLists')
  DROP PROCEDURE [dbo].[LoadValidationLists]
GO

CREATE PROCEDURE [dbo].[LoadValidationLists]  
  @DataSourceInstanceID int,
  @JobID int = 0,   
  @SourceDataset [nvarchar](100) = '%',
  @KeepExisting [bit] = 0
AS
  PRINT 'Finalise ValidationLists Loading'

  UPDATE [dbo].[sysValidationLists] 
  SET [Exclude] = ''
  WHERE [Exclude] IS NULL
  
  DECLARE @StagedCount int 
  IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sysValidationLists]') AND type in (N'U'))  
  BEGIN
    SELECT @StagedCount = COUNT(*) FROM [dbo].[sysValidationLists] WHERE [DataSourceInstanceID] = @DataSourceInstanceID
  END

GO


---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************

----
---- BLACKBOX VALIDATIONS PROCEDURES
----

/****** RemoveValidationRecordsByDataSourceID: [dbo].[RemoveValidationRecordsByDataSourceID] ******/
IF EXISTS(SELECT 1 FROM sys.procedures WHERE Name = 'RemoveValidationRecordsByDataSourceID')
  DROP PROCEDURE [dbo].[RemoveValidationRecordsByDataSourceID]
GO

CREATE PROCEDURE [dbo].[RemoveValidationRecordsByDataSourceID]
  @DataSourceInstanceID [int]
AS
  PRINT 'Removing validation records for dsiid=' + convert(nvarchar(5), @DataSourceInstanceID)

  DELETE FROM [dbo].[BlackBoxProcessDetailLog]
  WHERE [ProcessDetailID] in
  (
    SELECT [ProcessDetailID]
    FROM [dbo].[BlackBoxProcessDetailLog] AS pdl
    JOIN [dbo].[BlackBoxProcessSummaryLog] AS pl ON pl.[ProcessID] = pdl.[ProcessID]
    WHERE pdl.[DataSourceInstanceID] = @DataSourceInstanceID AND pl.[Action] = 'Validate'
  )

  DELETE FROM [dbo].[BlackBoxProcessStepLog] 
  WHERE [ProcessStepID] in
  (
    SELECT [ProcessStepID]
    FROM [dbo].[BlackBoxProcessStepLog] AS psl 
    JOIN [dbo].[BlackBoxProcessSummaryLog] AS pl ON pl.[ProcessID] = psl.[ProcessID]
    WHERE psl.[DataSourceInstanceID] = @DataSourceInstanceID AND pl.[Action] = 'Validate'
  )

  DELETE FROM [dbo].[BlackBoxProcessSummaryLog] WHERE [DataSourceInstanceID] = @DataSourceInstanceID AND [Action] = 'Validate'

  UPDATE [dbo].[BlackBoxDataSourceInstances] SET [Validations]=NULL  WHERE [ID] = @DataSourceInstanceID

GO


---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************

----
---- BLACKBOX PUBLISHING PROCEDURES
----

/****** StoredProcedure: [dbo].[StageStagingTable] ******/
IF EXISTS(SELECT 1 FROM sys.procedures WHERE Name = 'StageStagingTable')
  DROP PROCEDURE [dbo].[StageStagingTable]
GO

CREATE PROCEDURE [dbo].[StageStagingTable]
  @DataSourceInstanceID [int] = 0,
  @JobID int = 0,  
  @SourceDataset [nvarchar](100),
  @SourceTableName [nvarchar](100),
  @KeepExisting [bit] = 0
AS
  PRINT 'Stage ' + @SourceDataset

  DECLARE @sql nvarchar(1024)
  SET @sql = 'IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N''[dbo].[staged' + @SourceDataset + ']'') AND type in (N''U'')) DROP TABLE [dbo].[staged' + @SourceDataset + ']'
  EXECUTE sp_executesql @sql

  SET @sql = 'SELECT * INTO [dbo].[staged' + @SourceDataset + '] FROM [dbo].[' + @SourceTableName + '] WHERE [Exclude] = 0'
  EXECUTE sp_executesql @sql
  
  SET @sql = 'ALTER TABLE [dbo].[staged' + @SourceDataset + '] DROP COLUMN [Exclude];'
  EXECUTE sp_executesql @sql  

GO

/****** StoredProcedure: [dbo].[StageDataMappings] ******/
/*
IF EXISTS(SELECT 1 FROM sys.procedures WHERE Name = 'StageDataMappings')
  DROP PROCEDURE [dbo].[StageDataMappings]
GO

CREATE PROCEDURE [dbo].[StageDataMappings]
  @DataSourceInstanceID [int] = 0,
  @JobID int = 0,  
  @SourceDataset [nvarchar](100),
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
*/

/****** StoredProcedure: [dbo].[StageContacts] ******/
IF EXISTS(SELECT 1 FROM sys.procedures WHERE Name = 'StageContacts')
  DROP PROCEDURE [dbo].[StageContacts]
GO

CREATE PROCEDURE [dbo].[StageContacts]
  @DataSourceInstanceID int = 0,
  @JobID int = 0,   
  @SourceDataset [nvarchar](100),
  @SourceTableName [nvarchar](100),
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

/****** StoredProcedure: [dbo].[StageValidationLists] ******/
IF EXISTS(SELECT 1 FROM sys.procedures WHERE Name = 'StageValidationLists')
  DROP PROCEDURE [dbo].[StageValidationLists]
GO

CREATE PROCEDURE [dbo].[StageValidationLists]
  @DataSourceInstanceID [int] = 0,
  @JobID int = 0,   
  @SourceDataset [nvarchar](100),
  @SourceTableName [nvarchar](100),
  @KeepExisting [bit] = 0
AS
  PRINT 'Stage ValidationLists'
  
  IF @KeepExisting = 0
  BEGIN
    DELETE FROM [dbo].[stagedValidationLists]
    WHERE [DataSource] like @SourceDataset AND [Status] = 0
  END
  
  INSERT INTO [dbo].[stagedValidationLists]
  SELECT  
    [ID],[JobID],[DataSourceInstanceID],[LineNumber],[FlexeraID]      
   ,[DataSource],[ListName],[Value],[Status]
  FROM [dbo].[sysValidationLists]
  WHERE [DataSource] like @SourceDataset AND [DataSourceInstanceID]=@DataSourceInstanceID AND ISNULL([Exclude], '') !='Yes'

GO

---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************

----
---- BLACKBOX ARCHIVE PROCEDURES
----

/****** RemoveRecordsByFileID: [dbo].[RemoveRecordsByFileID] ******/
IF EXISTS(SELECT 1 FROM sys.procedures WHERE Name = 'RemoveRecordsByFileID')
  DROP PROCEDURE [dbo].[RemoveRecordsByFileID]
GO

CREATE PROCEDURE [dbo].[RemoveRecordsByFileID]
  @FileID [int],
  @Action [nvarchar](20) = 'archive',  
  @UserID [int] = 99
AS
  PRINT 'Removing records for fid=' + convert(nvarchar(5), @FileID)

  DECLARE @DataSourceInstanceID [int] = 0
  SELECT @DataSourceInstanceID = [DataSourceInstanceID] FROM [dbo].[BlackBoxFiles] WHERE [FID] = @FileID

  DELETE FROM [dbo].[BlackBoxFiles] WHERE [FID] = @FileID
  DELETE FROM [dbo].[BlackBoxDataSourceInstances] WHERE [ID] = @DataSourceInstanceID
  DELETE FROM [dbo].[BlackBoxDatasetUpdates] WHERE [DataSourceInstanceID] = @DataSourceInstanceID

  DELETE FROM [dbo].[BlackBoxProcessDetailLog] WHERE [DataSourceInstanceID] = @DataSourceInstanceID
  DELETE FROM [dbo].[BlackBoxProcessSummaryLog] WHERE [DataSourceInstanceID] = @DataSourceInstanceID
  DELETE FROM [dbo].[BlackBoxProcessStepLog] WHERE [DataSourceInstanceID] = @DataSourceInstanceID

  DELETE FROM [dbo].[BlackBoxMetaData] WHERE [Object] = 'file' AND [RefID] = @FileID
  DELETE FROM [dbo].[BlackBoxMetaData] WHERE [Object] = 'job' AND [RefID] = @FileID  

  DECLARE @Message [nvarchar](1024)
  SET @Message = 'Removed records for File=' + convert(nvarchar(5),@FileID) + ' and DSIID=' + convert(nvarchar(5),@DataSourceInstanceID)

  INSERT INTO [dbo].[BlackBoxHistory] ([Object],[RefID],[UserID],[Action],[Message],[TimeStamp]) VALUES('File', @DataSourceInstanceID, @UserID, @Action, @Message, GetDate())

GO

/****** RemoveRecordsByDataSourceID: [dbo].[RemoveRecordsByDataSourceID] ******/
IF EXISTS(SELECT 1 FROM sys.procedures WHERE Name = 'RemoveRecordsByDataSourceID')
  DROP PROCEDURE [dbo].[RemoveRecordsByDataSourceID]
GO

CREATE PROCEDURE [dbo].[RemoveRecordsByDataSourceID]
  @DataSourceInstanceID [int],
  @Action [nvarchar](20) = 'archive',  
  @UserID [int] = 99
AS
  PRINT 'Removing records for dsiid=' + convert(nvarchar(5), @DataSourceInstanceID)

  DECLARE @FileID [int] = 0
  SELECT @FileID = [FID] FROM [dbo].[BlackBoxFiles] WHERE [DataSourceInstanceID] = @DataSourceInstanceID

  DELETE FROM [dbo].[BlackBoxFiles] WHERE [FID] = @FileID
  DELETE FROM [dbo].[BlackBoxDataSourceInstances] WHERE [ID] = @DataSourceInstanceID
  DELETE FROM [dbo].[BlackBoxDatasetUpdates] WHERE [DataSourceInstanceID] = @DataSourceInstanceID

  DELETE FROM [dbo].[BlackBoxProcessDetailLog] WHERE [DataSourceInstanceID] = @DataSourceInstanceID
  DELETE FROM [dbo].[BlackBoxProcessSummaryLog] WHERE [DataSourceInstanceID] = @DataSourceInstanceID
  DELETE FROM [dbo].[BlackBoxProcessStepLog] WHERE [DataSourceInstanceID] = @DataSourceInstanceID

  DELETE FROM [dbo].[BlackBoxMetaData] WHERE [Object] = 'file' AND [RefID] = @FileID
  DELETE FROM [dbo].[BlackBoxMetaData] WHERE [Object] = 'job' AND [RefID] = @FileID    

  DECLARE @Message [nvarchar](1024)
  SET @Message = 'Removed records for File=' + convert(nvarchar(5),@FileID) + ' and DSIID=' + convert(nvarchar(5),@DataSourceInstanceID)

  INSERT INTO [dbo].[BlackBoxHistory] ([Object],[RefID],[UserID],[Action],[Message],[TimeStamp]) VALUES('File', @DataSourceInstanceID, @UserID, @Action, @Message, GetDate())

GO


---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************
