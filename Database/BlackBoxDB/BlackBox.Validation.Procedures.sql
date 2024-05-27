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
---- BLACKBOX VALIDATION SCHEMA PROCEDURES
----

/****** StoredProcedure: [dbo].[CreateBlackBoxProcessSummaryLog] ******/
IF EXISTS(SELECT 1 FROM sys.procedures WHERE Name = 'CreateBlackBoxProcessSummaryLog')
  DROP PROCEDURE [dbo].[CreateBlackBoxProcessSummaryLog]
GO

CREATE PROCEDURE [dbo].[CreateBlackBoxProcessSummaryLog]
  @Result int OUTPUT
AS
  PRINT 'Create Table BlackBoxProcessSummaryLog'

  IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BlackBoxProcessSummaryLog]') AND type in (N'U'))
  BEGIN
    DROP TABLE [dbo].[BlackBoxProcessSummaryLog]
  END

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
  SET @Result = @@Error

  RETURN @Result
;

GO

/****** StoredProcedure: [dbo].[CreateBlackBoxProcessStepLog] ******/
IF EXISTS(SELECT 1 FROM sys.procedures WHERE Name = 'CreateBlackBoxProcessStepLog')
  DROP PROCEDURE [dbo].[CreateBlackBoxProcessStepLog]
GO

CREATE PROCEDURE [dbo].[CreateBlackBoxProcessStepLog]
  @Result int OUTPUT
AS
  PRINT 'Create Table BlackBoxProcessStepLog'

  IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BlackBoxProcessStepLog]') AND type in (N'U'))
  BEGIN
    DROP TABLE [dbo].[BlackBoxProcessStepLog]
  END

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
  SET @Result = @@Error

  RETURN @Result
;

GO

/****** StoredProcedure: [dbo].[CreateBlackBoxProcessDetailLog] ******/
IF EXISTS(SELECT 1 FROM sys.procedures WHERE Name = 'CreateBlackBoxProcessDetailLog')
  DROP PROCEDURE [dbo].[CreateBlackBoxProcessDetailLog]
GO

CREATE PROCEDURE [dbo].[CreateBlackBoxProcessDetailLog]
  @Result int OUTPUT
AS
  PRINT 'Create Table BlackBoxProcessDetailLog'

  IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BlackBoxProcessDetailLog]') AND type in (N'U'))
  BEGIN
    DROP TABLE [dbo].[BlackBoxProcessDetailLog]
  END

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
  SET @Result = @@Error

  RETURN @Result
;

GO


---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************

----
---- BLACKBOX VALIDATION PROCESSING PROCEDURES
----

/****** StoredProcedure: [dbo].[StartValidationProcess] ******/
IF EXISTS(SELECT 1 FROM sys.procedures WHERE Name = 'StartValidationProcess')
  DROP PROCEDURE [dbo].[StartValidationProcess]
GO

CREATE PROCEDURE [dbo].[StartValidationProcess]
  @JobID int,
  @DatasetName nvarchar(64),
  @DataSourceInstanceID int,
  @UserID int,
  @Clear bit = 0
AS
  PRINT 'Starting validation process'

  IF (@Clear = 1)
  BEGIN
    DELETE FROM [dbo].[BlackBoxProcessDetailLog] WHERE [JobID] = @JobID
    DELETE FROM [dbo].[BlackBoxProcessStepLog] WHERE [JobID] = @JobID  
    DELETE FROM [dbo].[BlackBoxProcessSummaryLog] WHERE [JobID] = @JobID
  END

  INSERT INTO [dbo].[BlackBoxProcessSummaryLog] ([JobID],[ProcessName],[DatasetName],[DataSourceInstanceID],[Action],[StartDate],[EndDate],[Status],[Total],[Excluded],[Processed],[Result],[UserID])
  VALUES (@JobID, 'Validation', @DatasetName, @DataSourceInstanceID, 'Validate', GetDate(), GetDate(), 0, 0, 0, 0, '', @UserID)
  
  DECLARE @ProcessID int
  SET @ProcessID = SCOPE_IDENTITY()
  
  RETURN @ProcessID
;

GO

/****** StoredProcedure: [dbo].[EndValidationProcess] ******/
IF EXISTS(SELECT 1 FROM sys.procedures WHERE Name = 'EndValidationProcess')
  DROP PROCEDURE [dbo].[EndValidationProcess]
GO

CREATE PROCEDURE [dbo].[EndValidationProcess]
  @ProcessID int,
  @JobID int,
  @DatasetName nvarchar(64),
  @SourceTableName nvarchar(256),
  @Status int = 2
AS
  PRINT 'Ending validation process'

  UPDATE BlackBoxProcessSummaryLog
  SET Status = @Status /* 2 = Ended */, EndDate = GETDATE()
  WHERE ProcessID = @ProcessID
;
  
GO

/****** StoredProcedure: [dbo].[StartValidationSteps] ******/
IF EXISTS(SELECT 1 FROM sys.procedures WHERE Name = 'StartValidationSteps')
  DROP PROCEDURE [dbo].[StartValidationSteps]
GO

CREATE PROCEDURE [dbo].[StartValidationSteps]
  @ProcessID int,
  @JobID int,
  @DatasetName nvarchar(64),
  @DataSourceInstanceID int,  
  @SourceTableName nvarchar(256)
AS
  PRINT 'Starting validation steps'

  DELETE FROM [dbo].[BlackBoxProcessStepLog] WHERE [ProcessID] = @ProcessID

  INSERT INTO BlackBoxProcessStepLog ([ProcessStepName],[ProcessID],[JobID],[DatasetName],[DataSourceInstanceID],[StartDate],[EndDate],[Status],[Total],[Excluded],[Processed],[Matched],[Errors],[Warnings],[Updated],[Created],[Deleted])
  VALUES ('Initialise', @ProcessID, @JobID, @DatasetName, @DataSourceInstanceID, GETDATE(), GETDATE(), 1, 0, 0, 0, 0, 0, 0, 0, 0, 0)

  DECLARE @ProcessStepID int
  SET @ProcessStepID = SCOPE_IDENTITY()
  
  DECLARE @Command nvarchar(2048)
  SET @Command = '
    UPDATE dbo.BlackBoxProcessSummaryLog
    SET Total = (SELECT COUNT(*) FROM [' + @SourceTableName + '])
      , Processed = (SELECT COUNT(*) FROM [' + @SourceTableName + '])    
      , Excluded = (SELECT COUNT(*) FROM [' + @SourceTableName + '] WHERE ISNULL([Exclude],'''') = ''Yes'')      
    WHERE ProcessID = @ProcessID
  '

  PRINT 'Executing SQL: ' + @Command
  EXEC sp_executesql @Command, N'@ProcessID INT', @ProcessID = @ProcessID
  
  SET @Command = '
    UPDATE dbo.BlackBoxProcessStepLog
    SET Total = (SELECT COUNT(*) FROM [' + @SourceTableName + '])
      , Processed = (SELECT COUNT(*) FROM [' + @SourceTableName + '])    
      , Excluded = (SELECT COUNT(*) FROM [' + @SourceTableName + '] WHERE ISNULL([Exclude],'''') = ''Yes'')      
      , Matched = (SELECT COUNT(*) FROM [' + @SourceTableName + '] WHERE [JobID] = @JobID AND ISNULL([Exclude],'''') != ''Yes'')
      , Created = 0
      , Updated = 0
      , Deleted = 0
      , Warnings = 0
      , Errors = 0
      , EndDate = GetDate()
    WHERE ProcessID = @ProcessID and ProcessStepID = @ProcessStepID
  '

  PRINT 'Executing SQL: ' + @Command
  EXEC sp_executesql @Command, N'@ProcessID INT, @ProcessStepID INT, @JobID INT', @ProcessID = @ProcessID, @ProcessStepID = @ProcessStepID, @JobID = @JobID

  DELETE FROM [dbo].[BlackBoxProcessDetailLog] WHERE [ProcessID] = @ProcessID
 
  PRINT 'Create ##ValidationExpression' 
  IF OBJECT_ID('tempdb..##ValidationExpression') IS NULL
  BEGIN
    CREATE TABLE ##ValidationExpression 
    (
      SPID INT,
      SourceColumnName NVARCHAR(64) COLLATE database_default,
      ValidationExpression NVARCHAR(MAX) COLLATE database_default,
      ErrorMessage NVARCHAR(256) COLLATE database_default
    )
  END
  ELSE
  BEGIN
    DELETE FROM ##ValidationExpression WHERE SPID = @@SPID
  END
;

GO

/****** StoredProcedure: [dbo].[EndValidationSteps] ******/
IF EXISTS(SELECT 1 FROM sys.procedures WHERE Name = 'EndValidationSteps')
  DROP PROCEDURE [dbo].[EndValidationSteps]
GO

CREATE PROCEDURE [dbo].[EndValidationSteps]
  @ProcessID INT,
  @ProcessStepID INT
AS
  PRINT 'Ending validation steps'
  
  DECLARE @Result nvarchar(2048)  
  DECLARE @Steps int  
  DECLARE @Warnings int    
  DECLARE @Errors int    
  
  SET @Steps = (SELECT COUNT(*) FROM [dbo].[BlackBoxProcessStepLog] WHERE [ProcessID] = @ProcessID)
  SET @Warnings = (SELECT SUM([Warnings]) FROM [dbo].[BlackBoxProcessStepLog] WHERE [ProcessID] = @ProcessID)
  SET @Errors = (SELECT SUM([Errors]) FROM [dbo].[BlackBoxProcessStepLog] WHERE [ProcessID] = @ProcessID)
  
  SET @Result = 'Completed validation checks: ' + CONVERT(nvarchar(8),@Steps) + ' Steps, ' + CONVERT(nvarchar(8),@Errors) + ' Errors, ' + CONVERT(nvarchar(8),@Warnings) + ' Warnings '
  
  DECLARE @Command nvarchar(2048)
  SET @Command = '
    UPDATE dbo.BlackBoxProcessSummaryLog
    SET [Result] = @Result
      , EndDate = GetDate()
    WHERE ProcessID = @ProcessID
  '

  PRINT 'Executing SQL: ' + @Command
  EXEC sp_executesql @Command, N'@ProcessID INT, @Result nvarchar(2048)', @ProcessID = @ProcessID, @Result = @Result

;

GO

/****** StoredProcedure: [dbo].[StartValidationStep] ******/
IF EXISTS(SELECT 1 FROM sys.procedures WHERE Name = 'StartValidationStep')
  DROP PROCEDURE [dbo].[StartValidationStep]
GO

CREATE PROCEDURE [dbo].[StartValidationStep]
  @ProcessID int,
  @ProcessStepName nvarchar(255),
  @JobID int,
  @DatasetName nvarchar(64),
  @DataSourceInstanceID int,  
  @SourceTableName nvarchar(256)
AS
  PRINT 'Starting ' + @ProcessStepName + ' step'

  INSERT INTO BlackBoxProcessStepLog (ProcessStepName, ProcessID, JobID, DatasetName, DataSourceInstanceID, StartDate, Status)
  VALUES (@ProcessStepName, @ProcessID, @JobID, @DatasetName, @DataSourceInstanceID, GETDATE(), 0)    

  DECLARE @ProcessStepID INT
  SET @ProcessStepID = SCOPE_IDENTITY()
  
  DECLARE @Command NVARCHAR(MAX)
  SET @Command = '
    UPDATE dbo.BlackBoxProcessStepLog
    SET Total = (SELECT COUNT(*) FROM [' + @SourceTableName + '])
      , Processed = (SELECT COUNT(*) FROM [' + @SourceTableName + '])    
      , Excluded = (SELECT COUNT(*) FROM [' + @SourceTableName + '] WHERE ISNULL([Exclude],'''') = ''Yes'')      
      , Matched = (SELECT COUNT(*) FROM [' + @SourceTableName + '] WHERE [JobID] = @JobID AND ISNULL([Exclude],'''') != ''Yes'')
      , Created = 0
      , Updated = 0
      , Deleted = 0
      , Warnings = 0
      , Errors = 0
    WHERE [ProcessID] = @ProcessID AND [ProcessStepID] = @ProcessStepID
  '
  EXEC sp_executesql @Command, N'@ProcessID INT, @ProcessStepID INT, @JobID INT', @ProcessID = @ProcessID, @ProcessStepID = @ProcessStepID, @JobID = @JobID

  RETURN @ProcessStepID
;
GO

/****** StoredProcedure: [dbo].[EndValidationStep] ******/
IF EXISTS(SELECT 1 FROM sys.procedures WHERE Name = 'EndValidationStep')
  DROP PROCEDURE [dbo].[EndValidationStep]
GO

CREATE PROCEDURE [dbo].[EndValidationStep]
  @ProcessID INT,
  @ProcessStepID INT
AS
  PRINT 'Ending validations step'

  DECLARE @Command NVARCHAR(MAX)
  SET @Command = '
    UPDATE dbo.BlackBoxProcessStepLog
    SET Warnings = (SELECT COUNT(*) FROM [dbo].[BlackBoxProcessDetailLog] WHERE [ProcessID] = CONVERT(nvarchar(8),@ProcessID) and [ProcessStepID] = CONVERT(nvarchar(8),@ProcessStepID) and [Result] = ''warning'')
      , Errors = (SELECT COUNT(*) FROM [dbo].[BlackBoxProcessDetailLog] WHERE [ProcessID] = CONVERT(nvarchar(8),@ProcessID) and [ProcessStepID] = CONVERT(nvarchar(8),@ProcessStepID) and [Result] = ''error'')
    WHERE [ProcessID] = @ProcessID AND [ProcessStepID] = @ProcessStepID
  '

  PRINT 'Ending validations step: ' + @Command
  EXEC sp_executesql @Command, N'@ProcessID INT, @ProcessStepID INT', @ProcessID = @ProcessID, @ProcessStepID = @ProcessStepID

  UPDATE BlackBoxProcessStepLog
  SET [Status] = 2 /* Ended */, [EndDate] = GETDATE()
  WHERE [ProcessID] = @ProcessID AND [ProcessStepID] = @ProcessStepID
;

GO

/****** StoredProcedure: [dbo].[ValidationRegisterRule] ******/
IF EXISTS(SELECT 1 FROM sys.procedures WHERE Name = 'ValidationRegisterRule')
  DROP PROCEDURE [dbo].[ValidationRegisterRule]
GO

CREATE PROCEDURE [dbo].[ValidationRegisterRule]
  @ProcessStepID int,
  @ValidationRule nvarchar(MAX),
  @Level nvarchar(20),
  @ErrorMessage nvarchar(3000),
  @SourceColumn1Name nvarchar(256) = NULL,
  @SourceColumn2Name nvarchar(256) = NULL,
  @IsGlobalRule bit = 0
AS
  INSERT dbo.BlackBoxValidationRule (ProcessStepID, IsGlobalRule, SourceColumn1Name, SourceColumn2Name, ValidationRule, Level, ErrorMessage)
  VALUES (@ProcessStepID, @IsGlobalRule, @SourceColumn1Name, @SourceColumn2Name, @ValidationRule, @Level, @ErrorMessage)
;
GO

/****** StoredProcedure: [dbo].[ValidationStartRules] ******/
IF EXISTS(SELECT 1 FROM sys.procedures WHERE Name = 'ValidationStartRules')
  DROP PROCEDURE [dbo].[ValidationStartRules]
GO

CREATE PROCEDURE [dbo].[ValidationStartRules]
  @ProcessID int,
  @ProcessStepID int,
  @JobID int,
  @DatasetName nvarchar(64),
  @DataSourceInstanceID int  
AS
  -- Take the opportunity to clean up rules that have been orphaned from an associated BlackBoxProcessStepLog record (e.g. from aborted previous step)
  DELETE r
  FROM dbo.BlackBoxValidationRule r
  WHERE NOT EXISTS(SELECT 1 FROM dbo.BlackBoxProcessStepLog o WHERE o.ProcessStepID = r.ProcessStepID)

  DECLARE @NewProcessStepID int
  SET @NewProcessStepID = @ProcessStepID

  IF EXISTS(SELECT 1 FROM dbo.BlackBoxProcessStepLog WHERE [ProcessID] = @ProcessID AND [ProcessStepID] = @ProcessStepID)
  BEGIN
    UPDATE dbo.BlackBoxProcessStepLog SET [Status] = 0 WHERE [ProcessID] = @ProcessID AND [ProcessStepID] = @ProcessStepID
  END
  ELSE
  BEGIN
    INSERT dbo.BlackBoxProcessStepLog (ProcessStepName, ProcessID, JobID, DatasetName, DataSourceInstanceID, StartDate, Status)
    VALUES ('Validate', @ProcessID, @JobID, @DatasetName, @DataSourceInstanceID, GETDATE(), 0 /* not completed */)   
    SET @NewProcessStepID = SCOPE_IDENTITY()    
  END

  RETURN @NewProcessStepID
;
GO


/****** StoredProcedure: [dbo].[ValidationRuleCheckFieldValues] ******/
IF EXISTS(SELECT 1 FROM sys.procedures WHERE Name = 'ValidationRuleCheckFieldValues')
  DROP PROCEDURE [dbo].[ValidationRuleCheckFieldValues]
GO

CREATE PROCEDURE [dbo].[ValidationRuleCheckFieldValues]
  @ProcessStepID INT,
	@DataSourceInstanceID INT,
  @SourceColumnName NVARCHAR(256),
  @ExpectedType VARCHAR(50), -- text, date, integer, float
  @Level nvarchar(20) = 'error',   
  @AdditionalRule NVARCHAR(MAX) = '',
  @ErrorMessage NVARCHAR(3000) = 'The value in column [@SourceColumn1Name@] is null or empty'
AS 

	DECLARE @srcColumnTypes NVARCHAR(256)

	SET @srcColumnTypes =
		CASE 
			WHEN @ExpectedType = 'text'THEN 'System.String'
			WHEN @ExpectedType = 'date'THEN 'System.DateTime'
			WHEN @ExpectedType = 'integer'THEN 'System.Int32,System.Int64'
      WHEN @ExpectedType = 'float' THEN 'System.Single,System.Double'
		END

  /* rule validates that values are provided in mandatory or creation columns */
  DECLARE @Rule nvarchar(MAX)  
  SET @Rule = '
    ISNULL(source.[Exclude],'''') != ''Yes''
    AND ISNULL(source.[@SourceColumn1Name@],'''') = ''''

    /*
      Do not bother validating if the spreadsheet column type is incorrect.  
      In that case the staging process will have nullified the value 
      in the staging table as the source spreadsheet value would be 
      considered to be unrelable.   Thus, a value of null in the staging table
      does not necessarily mean that the value in the spreadsheet was blank.
      
      Note that this does not mean that blank values will escape validation.
      What will happen is that the invalid column type validation rule will be 
      triggered if the column type is incorrect.  Once the user has fixed that
      this validation rule will work and pick up any truely null or empty values.  
    */
		AND	EXISTS (
			SELECT 1
			FROM [dbo].[srcDataColumnMappings] sdcm
				JOIN [dbo].[Split]('','', ''' + @srcColumnTypes + ''') ct
					ON ct.s = sdcm.DataType
			WHERE 
				sdcm.DataSourceInstanceID = ' + CONVERT(NVARCHAR(16), @DataSourceInstanceID) + '
				AND
				sdcm.Field = ''' + @SourceColumnName + ''')'



  IF @AdditionalRule != ''
  BEGIN
    SET @Rule = @Rule + ' AND ' + @AdditionalRule
  END

  EXEC dbo.ValidationRegisterRule 
    @ProcessStepID, 
    @ValidationRule = @Rule, 
    @Level = @Level, 
    @ErrorMessage = @ErrorMessage, 
    @SourceColumn1Name = @SourceColumnName
    --@SourceColumn2Name nvarchar(256) = NULL,
    --@IsGlobalRule bit = 0


  SET @Rule = '
    /*
      Validation should fail in the corner case where:
      - The column type in the source spreadsheet is invalid
        AND
      - There are no cells with values in this colunn in the source spreadsheet

      In this case we know for sure that there will be no values in this field.
    */
    ISNULL(source.[Exclude],'''') != ''Yes''
		AND	NOT EXISTS (
			SELECT 1
			FROM [dbo].[srcDataColumnMappings] sdcm
				JOIN [dbo].[Split]('','', ''' + @srcColumnTypes + ''') ct
					ON ct.s = sdcm.DataType
			WHERE 
				sdcm.DataSourceInstanceID = ' + CONVERT(NVARCHAR(16), @DataSourceInstanceID) + '
				AND
				sdcm.Field = ''' + @SourceColumnName + '''
      )
		AND	EXISTS (
			SELECT 1
			FROM [dbo].[srcDataColumnMappings] sdcm
			WHERE 
				sdcm.DataSourceInstanceID = ' + CONVERT(NVARCHAR(16), @DataSourceInstanceID) + '
				AND
				sdcm.Field = ''' + @SourceColumnName + '''
        AND
        sdcm.Rows = 0
      )'
      
  IF @AdditionalRule != ''
  BEGIN
    SET @Rule = @Rule + ' AND ' + @AdditionalRule
  END

  EXEC dbo.ValidationRegisterRule 
    @ProcessStepID, 
    @ValidationRule = @Rule, 
    @Level = @Level, 
    @ErrorMessage = @ErrorMessage, 
    @SourceColumn1Name = @SourceColumnName
    --@SourceColumn2Name nvarchar(256) = NULL,
    --@IsGlobalRule bit = 0

GO

/****** StoredProcedure: [dbo].[ValidationRuleCheckFieldListValues] ******/
IF EXISTS(SELECT 1 FROM sys.procedures WHERE Name = 'ValidationRuleCheckFieldListValues')
  DROP PROCEDURE [dbo].[ValidationRuleCheckFieldListValues]
GO

CREATE PROCEDURE [dbo].[ValidationRuleCheckFieldListValues]
  @ProcessStepID INT,
  @DataSource NVARCHAR(64),  
  @SourceColumnName NVARCHAR(256),
  @Level nvarchar(20) = 'error',
  @AllowStatic bit = 1,  
  @ErrorMessage NVARCHAR(3000) = 'Column [@SourceColumn1Name@] value ''@SourceColumn1Value@'' is not in the approved list'
AS 
  /* rule validates that values are provided in mandatory or creation columns */
  DECLARE @StatusClause nvarchar(100)
  SET @StatusClause = '(vl.[Status] = 0 or vl.[Status] = 1)'
  IF @AllowStatic = 0
  BEGIN
    SET @StatusClause = 'vl.[Status] = 0'
  END
  
  DECLARE @Rule nvarchar(MAX)  
  SET @Rule = '
    NOT EXISTS (
      SELECT source.[ID] 
      FROM [dbo].[combinedValidationLists] as vl
      WHERE 
        vl.[DataSource] = ''' + @DataSource + ''' 
          and vl.[ListName] = ''@SourceColumn1Name@'' 
          and ' + @StatusClause + ' 
          and ISNULL(source.[@SourceColumn1Name@], '''') = vl.[Value]
    )
    and ISNULL(source.[@SourceColumn1Name@], '''') != '''''

  EXEC dbo.ValidationRegisterRule 
    @ProcessStepID, 
    @ValidationRule = @Rule, 
    @Level = @Level, 
    @ErrorMessage = @ErrorMessage, 
    @SourceColumn1Name = @SourceColumnName
    --@SourceColumn2Name nvarchar(256) = NULL,
    --@IsGlobalRule bit = 0

GO

/****** StoredProcedure: [dbo].[ValidationRuleCheckUserListValues] ******/
IF EXISTS(SELECT 1 FROM sys.procedures WHERE Name = 'ValidationRuleCheckUserListValues')
  DROP PROCEDURE [dbo].[ValidationRuleCheckUserListValues]
GO

CREATE PROCEDURE [dbo].[ValidationRuleCheckUserListValues]
  @ProcessStepID INT,
  @DataSource NVARCHAR(64),
  @SourceColumnName NVARCHAR(256),
  @Level nvarchar(20) = 'error',
  @AllowStatic bit = 1,  
  @ErrorMessage NVARCHAR(3000) = 'Column [@SourceColumn1Name@] value ''@SourceColumn1Value@'' contains one or more unknown users.  Ensure that you have entered the logon ID of each user.   See the FNMS Reports > Hardware Assets > Asset Criticality > User Accounts report for a list of all user accounts.  If there is more than one user ensure that they are separated by a comma.'
AS 
  /* rule validates that values are provided in mandatory or creation columns */
  DECLARE @StatusClause nvarchar(100)
  SET @StatusClause = '(vl.[Status] = 0 or vl.[Status] = 1)'
  IF @AllowStatic = 0
  BEGIN
    SET @StatusClause = 'vl.[Status] = 0'
  END
  
  DECLARE @Rule nvarchar(MAX)  
  SET @Rule = '
    EXISTS (
      SELECT 1
      FROM dbo.Split('','',source.[@SourceColumn1Name@]) usr
      WHERE LTRIM(RTRIM(ISNULL(usr.s,''''))) != ''''
    )
    AND EXISTS (
      SELECT 1
      FROM dbo.Split('','',source.[@SourceColumn1Name@]) usr
        LEFT OUTER JOIN [dbo].[combinedValidationLists] as vl
          ON 	vl.[DataSource] = ''' + @DataSource + ''' 
            and vl.[ListName] = ''SAMAccountNames'' 
            and vl.[Status] = 0 
            and vl.[Value] = LTRIM(RTRIM(ISNULL(usr.s,'''')))
      WHERE LTRIM(RTRIM(ISNULL(usr.s,''''))) != ''''
        AND vl.ID IS NULL
    )'

  EXEC dbo.ValidationRegisterRule 
    @ProcessStepID, 
    @ValidationRule = @Rule, 
    @Level = @Level, 
    @ErrorMessage = @ErrorMessage, 
    @SourceColumn1Name = @SourceColumnName
    --@SourceColumn2Name nvarchar(256) = NULL,
    --@IsGlobalRule bit = 0

GO


/****** StoredProcedure: [dbo].[ValidationRuleCheckColumnExists] ******/
IF EXISTS(SELECT 1 FROM sys.procedures WHERE Name = 'ValidationRuleCheckColumnExists')
  DROP PROCEDURE [dbo].[ValidationRuleCheckColumnExists]
GO

CREATE PROCEDURE [dbo].[ValidationRuleCheckColumnExists]
	@ProcessStepID INT,
	@DataSourceInstanceID INT,
	@ColumnName NVARCHAR(128),
	@ExpectedType VARCHAR(50) -- text, date, integer, float
AS

	DECLARE @ValidationRule NVARCHAR(1000)

	SET @ValidationRule = 'NOT EXISTS (
		SELECT 1
		FROM [dbo].[srcDataColumnMappings] sdcm
		WHERE 
			sdcm.DataSourceInstanceID = ' + CONVERT(NVARCHAR(16), @DataSourceInstanceID) + '
			AND
			Field = ''' + @ColumnName + ''')'

	DECLARE @msg NVARCHAR(1000)
	SET @msg = 'The column [' + @ColumnName + '] does not exist in the spreadsheet.'

	EXEC dbo.ValidationRegisterRule
		@ProcessStepID
		, @IsGlobalRule = 1
		, @ValidationRule = @ValidationRule
		, @Level = 'error'
		, @ErrorMessage = @msg

	DECLARE @srcColumnTypes NVARCHAR(256)

	SET @srcColumnTypes =
		CASE 
			WHEN @ExpectedType = 'text'THEN 'System.String'
			WHEN @ExpectedType = 'date'THEN 'System.DateTime'
			WHEN @ExpectedType = 'integer'THEN 'System.Int32,System.Int64'
      WHEN @ExpectedType = 'float' THEN 'System.Single,System.Double'
		END

	SET @ValidationRule = '
		EXISTS (
				SELECT 1
				FROM [dbo].[srcDataColumnMappings] sdcm
				WHERE 
					sdcm.DataSourceInstanceID = ' + CONVERT(NVARCHAR(16), @DataSourceInstanceID) + '
					AND
					sdcm.Field = ''' + @ColumnName + '''
          AND
          sdcm.Rows > 0  /* The type of the column that Excel is unpredicable if there is no data in the column.  We do not care about the type in this case anyway so we will not validate it.   */
    )
		AND	NOT EXISTS (
			SELECT 1
			FROM [dbo].[srcDataColumnMappings] sdcm
				JOIN [dbo].[Split]('','', ''' + @srcColumnTypes + ''') ct
					ON ct.s = sdcm.DataType
			WHERE 
				sdcm.DataSourceInstanceID = ' + CONVERT(NVARCHAR(16), @DataSourceInstanceID) + '
				AND
				Field = ''' + @ColumnName + ''')'

	SET @msg = 'The spreadsheet column [' + @ColumnName + '] is is not of type ' + @ExpectedType + '.  Ensure that all values in the column are proper ' + @ExpectedType + ' types.'

	EXEC dbo.ValidationRegisterRule
		@ProcessStepID
		, @IsGlobalRule = 1
		, @ValidationRule = @ValidationRule
		, @Level = 'error'
		, @ErrorMessage = @msg
		
GO


/****** StoredProcedure:: [dbo].[ValidationExecuteRules]    Script Date: 10/10/2022 7:59:31 AM ******/
IF EXISTS(SELECT 1 FROM sys.procedures WHERE Name = 'ValidationExecuteRules')
  DROP PROCEDURE [dbo].[ValidationExecuteRules]
GO

CREATE PROCEDURE [dbo].[ValidationExecuteRules]
  @ProcessID int,
  @ProcessStepID int,
  @DatasetName nvarchar(64),
  @DataSourceInstanceID int,  
  @SourceTableName nvarchar(256),
  @RecordKey nvarchar(512),
  @TraceField nvarchar(256)
AS
  PRINT 'Executing data validation rules over table ' + @SourceTableName

  DECLARE @Command NVARCHAR(MAX)

  DECLARE @SourceColumn1Name NVARCHAR(256)
  DECLARE @SourceColumn2Name NVARCHAR(256)
  DECLARE @ValidationRule NVARCHAR(MAX)
  DECLARE @Level NVARCHAR(20)
  DECLARE @ErrorMessage NVARCHAR(3000)

  DECLARE c CURSOR FOR
  SELECT
    SourceColumn1Name, 
    SourceColumn2Name, 
    REPLACE(REPLACE(ValidationRule, '@SourceColumn1Name@', ISNULL(SourceColumn1Name, '@SourceColumn1Name@')), '@SourceColumn2Name@', ISNULL(SourceColumn2Name, '@SourceColumn2Name@')),
    Level,
    REPLACE(REPLACE(ErrorMessage, '@SourceColumn1Name@', ISNULL(SourceColumn1Name, '@SourceColumn1Name@')), '@SourceColumn2Name@', ISNULL(SourceColumn2Name, '@SourceColumn2Name@'))
  FROM dbo.BlackBoxValidationRule
  WHERE ProcessStepID = @ProcessStepID and IsGlobalRule = 0  /* Execute only non-global rules */
  ORDER BY ValidationRuleID /* in order of addition */

  OPEN c
  FETCH NEXT FROM c INTO @SourceColumn1Name, @SourceColumn2Name, @ValidationRule, @Level, @ErrorMessage

  WHILE @@FETCH_STATUS = 0
  BEGIN
    DECLARE @SourceColumn1NameReference NVARCHAR(256)
    DECLARE @SourceColumn2NameReference NVARCHAR(256)

    SET @SourceColumn1NameReference = ISNULL('ISNULL(CONVERT(NVARCHAR(3000), source.[' + @SourceColumn1Name + ']), '''')', '''<Unknown column name>''')
    SET @SourceColumn2NameReference = ISNULL('ISNULL(CONVERT(NVARCHAR(3000), source.[' + @SourceColumn2Name + ']), '''')', '''<Unknown column name>''')

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
        ''Validate'',
        source.[LineNumber],
        LEFT(source.[' + @SourceColumn1Name + '],100),
        ''' + @Level + ''',
        LEFT(source.[' + @RecordKey + '],50),
        LEFT(' + @TraceField + ', 255),
        LEFT(REPLACE(REPLACE(@ErrorMessage, ''@SourceColumn1Value@'', ' + @SourceColumn1NameReference + '), ''@SourceColumn2Value@'', ' + @SourceColumn2NameReference + '), 3000)
      FROM [' + @SourceTableName + '] source,
        dbo.BlackBoxProcessStepLog lo
      WHERE (' + @ValidationRule + ')
        AND lo.ProcessID = @ProcessID AND lo.ProcessStepID = @ProcessStepID
        AND source.[DataSourceInstanceID] = ' + CONVERT(nvarchar(5), @DataSourceInstanceID) + '
        AND ISNULL(source.[Exclude],'''') != ''Yes''

      SET @Result = 0
    '
    
    DECLARE @PreCommand nvarchar(2000)
    SET @PreCommand = '
      DECLARE @ProcessID int = ' + CONVERT(nvarchar(5), @ProcessID) + '
      DECLARE @ProcessStepID int = ' + CONVERT(nvarchar(5), @ProcessStepID) + '
      DECLARE @DatasetName nvarchar(64) = ''' + @DatasetName + '''
      DECLARE @DataSourceInstanceID int = ' + CONVERT(nvarchar(5), @DataSourceInstanceID) + '
      DECLARE @SourceTableName nvarchar(256) = ''' + @SourceTableName + '''
      DECLARE @RecordKey nvarchar(512) = ''' + @RecordKey + '''
      DECLARE @TraceField nvarchar(256) = ''' + @TraceField + '''
      
      DECLARE @ErrorMessage NVARCHAR(3000) = ''' + @ErrorMessage + '''
    '
    PRINT 'SQL Header: ' + @PreCommand

    PRINT 'Executing SQL: ' + @Command
    BEGIN TRY
      DECLARE @Result BIT
      EXEC sp_executesql @Command
        , N'@ProcessID INT, @ProcessStepID INT, @ErrorMessage NVARCHAR(3000), @Result INT OUTPUT'
        , @ProcessID = @ProcessID, @ProcessStepID = @ProcessStepID, @ErrorMessage = @ErrorMessage, @Result = @Result OUTPUT

    END TRY
    BEGIN CATCH
      DECLARE @m NVARCHAR(MAX)
      SET @m = 'Error executing validation rule: ' + ERROR_MESSAGE() + ' Line ' + CAST(ERROR_LINE() AS NVARCHAR(5))
      PRINT @m
        ; THROW
    END CATCH

    --IF @Level = 'error'
    --BEGIN
    --END

    --IF @Level = 'warning'
    --BEGIN
    --END

    FETCH NEXT FROM c INTO @SourceColumn1Name, @SourceColumn2Name, @ValidationRule, @Level, @ErrorMessage
  END

  CLOSE c
  DEALLOCATE c

  DELETE FROM dbo.BlackBoxValidationRule
  WHERE ProcessStepID = @ProcessStepID

  UPDATE dbo.BlackBoxProcessStepLog
  SET Status = 1 /* Completed */, EndDate = GETDATE()
  WHERE ProcessStepID = @ProcessStepID
;

GO


/****** StoredProcedure:: [dbo].[ValidationExecuteGlobalRules] ******/
IF EXISTS(SELECT 1 FROM sys.procedures WHERE Name = 'ValidationExecuteGlobalRules')
  DROP PROCEDURE [dbo].[ValidationExecuteGlobalRules]
GO

CREATE PROCEDURE [dbo].[ValidationExecuteGlobalRules]
  @ProcessID int,
  @ProcessStepID int,
  @DatasetName nvarchar(64),	  
  @DataSourceInstanceID int,  
  @SourceTableName nvarchar(256)
AS
  PRINT 'Executing global data validation rules over table ' + @SourceTableName

  DECLARE @Command NVARCHAR(MAX)
  DECLARE @GlobalErrors BIT

  DECLARE @IsGlobalRule BIT
  DECLARE @SourceColumn1Name NVARCHAR(256)
  DECLARE @SourceColumn2Name NVARCHAR(256)
  DECLARE @ValidationRule NVARCHAR(MAX)
  DECLARE @Level NVARCHAR(20)
  DECLARE @ErrorMessage NVARCHAR(3000)

  DECLARE c CURSOR FOR
  SELECT
    SourceColumn1Name, 
    SourceColumn2Name, 
    REPLACE(REPLACE(ValidationRule, '@SourceColumn1Name@', ISNULL(SourceColumn1Name, '@SourceColumn1Name@')), '@SourceColumn2Name@', ISNULL(SourceColumn2Name, '@SourceColumn2Name@')),
    Level,
    REPLACE(REPLACE(ErrorMessage, '@SourceColumn1Name@', ISNULL(SourceColumn1Name, '@SourceColumn1Name@')), '@SourceColumn2Name@', ISNULL(SourceColumn2Name, '@SourceColumn2Name@'))
  FROM dbo.BlackBoxValidationRule
  WHERE ProcessStepID = @ProcessStepID and IsGlobalRule = 1  /* Execute only global rules */
  ORDER BY ValidationRuleID /* in order of addition */

  SET @GlobalErrors = 0

  OPEN c
  FETCH NEXT FROM c INTO @SourceColumn1Name, @SourceColumn2Name, @ValidationRule, @Level, @ErrorMessage

  WHILE @@FETCH_STATUS = 0
  BEGIN
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
        ''Validate'',
        0, /* No specific row */
        ''' + @Level + ''',
        ''All rows'',
        ''All rows'',
        '''+ @ErrorMessage + '''
      FROM dbo.BlackBoxProcessStepLog lo
      WHERE (' + @ValidationRule + ')
        AND lo.ProcessID = @ProcessID AND lo.ProcessStepID = @ProcessStepID


      IF @@ROWCOUNT = 0
        SET @Result = 0 /* Not global error */
      ELSE
      BEGIN
		SET @Result = 1 /* global error */
      END
    '

    PRINT 'Executing SQL: ' + @Command
    BEGIN TRY
      DECLARE @Result BIT

      EXEC sp_executesql @Command
        , N'@ProcessID INT, @ProcessStepID INT, @ErrorMessage NVARCHAR(3000), @Result INT OUTPUT'
        , @ProcessID = @ProcessID, @ProcessStepID = @ProcessStepID, @ErrorMessage = @ErrorMessage, @Result = @Result OUTPUT

      IF @Result = 1
        SET @GlobalErrors = 1
    END TRY
    BEGIN CATCH
      DECLARE @m NVARCHAR(MAX)
      SET @m = 'Error executing validation rule: ' + ERROR_MESSAGE() + ' Line ' + CAST(ERROR_LINE() AS NVARCHAR(5))
      PRINT @m
      ; THROW
    END CATCH

    FETCH NEXT FROM c INTO @SourceColumn1Name, @SourceColumn2Name, @ValidationRule, @Level, @ErrorMessage
  END

  CLOSE c
  DEALLOCATE c

  DELETE FROM dbo.BlackBoxValidationRule
  WHERE ProcessStepID = @ProcessStepID

  UPDATE dbo.BlackBoxProcessStepLog
  SET Status = 1 /* Completed */, EndDate = GETDATE()
  WHERE ProcessStepID = @ProcessStepID
;

GO

---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************

----
---- BLACKBOX VALIDATION ADMIN PROCEDURES
----

/****** StoredProcedure: [dbo].ClearAllProcessLogs] ******/
IF EXISTS(SELECT 1 FROM sys.procedures WHERE Name = 'ClearAllProcessLogs')
  DROP PROCEDURE [dbo].[ClearAllProcessLogs]
GO

CREATE PROCEDURE [dbo].[ClearAllProcessLogs]
AS
  PRINT 'Clearing all process logs'

  DELETE FROM [dbo].[BlackBoxProcessSummaryLog]  
  DELETE FROM [dbo].[BlackBoxProcessStepLog]  
  DELETE FROM [dbo].[BlackBoxProcessDetailLog]

;

GO

/****** StoredProcedure: [dbo].ClearProcessLogsByJobID] ******/
IF EXISTS(SELECT 1 FROM sys.procedures WHERE Name = 'ClearProcessLogsByJobID')
  DROP PROCEDURE [dbo].[ClearProcessLogsByJobID]
GO

CREATE PROCEDURE [dbo].[ClearProcessLogsByJobID]
  @JobID int
AS
  PRINT 'Clearing process logs for JobID = ' + CONVERT(nvarchar(5), @JobID)

  DELETE FROM [dbo].[BlackBoxProcessSummaryLog] WHERE [JobID] = @JobID 
  DELETE FROM [dbo].[BlackBoxProcessStepLog] WHERE [JobID] = @JobID
  DELETE FROM [dbo].[BlackBoxProcessDetailLog] WHERE [JobID] = @JobID

;

GO

/****** StoredProcedure: [dbo].ClearProcessLogsByUserID] ******/
IF EXISTS(SELECT 1 FROM sys.procedures WHERE Name = 'ClearProcessLogsByUserID')
  DROP PROCEDURE [dbo].[ClearProcessLogsByUserID]
GO

CREATE PROCEDURE [dbo].[ClearProcessLogsByUserID]
  @UserID int
AS
  PRINT 'Clearing process logs for user = ' + CONVERT(nvarchar(5), @UserID)

  DELETE FROM [dbo].[BlackBoxProcessDetailLog] WHERE [ProcessID] IN (SELECT ProcessID FROM [BlackBoxProcessSummaryLog] WHERE [UserID] = @UserID)
  DELETE FROM [dbo].[BlackBoxProcessStepLog] WHERE [ProcessID] IN (SELECT ProcessID FROM [BlackBoxProcessSummaryLog] WHERE [UserID] = @UserID)
  DELETE FROM [dbo].[BlackBoxProcessSummaryLog] WHERE [UserID] = @UserID

;

GO

----
---- BLACKBOX VALIDATION SUPPORT PROCEDURES
----

/****** StoredProcedure: [dbo].SafeDropTable] ******/
IF EXISTS(SELECT 1 FROM sys.procedures WHERE Name = 'SafeDropTable')
  DROP PROCEDURE [dbo].[SafeDropTable]
GO

CREATE PROCEDURE [dbo].[SafeDropTable]
  @TableName nvarchar(50)
AS
  PRINT 'Dropping table ' + @TableName

  DECLARE @command nvarchar(500)
  SET @command = N'DROP TABLE ' + @TableName

  IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(@TableName) AND type in (N'U'))
    EXEC sp_executesql @command, N'@TableName NVARCHAR(50)', @TableName = @TableName
;

GO


---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************
