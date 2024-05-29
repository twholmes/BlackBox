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
---- BLACKBOX ASSET VALIDATION PROCEDURES
----

/****** StoredProcedure: [dbo].[ValidateAssetsDataset] ******/
IF EXISTS(SELECT 1 FROM sys.procedures WHERE Name = 'ValidateAssetsDataset')
  DROP PROCEDURE [dbo].[ValidateAssetsDataset]
GO

CREATE PROCEDURE [dbo].[ValidateAssetsDataset]
  @DatasetName nvarchar(64),
  @DataSourceInstanceID int,  
  @SourceTableName nvarchar(256),
  @JobID int,  
  @UserID int,
  @AllowStatic bit = 1,  
  @ErrorLimit int = 100
AS
  PRINT 'Starting assets validation process'

  /* initalise validation process */
  DECLARE @ProcessID INT
  EXEC @ProcessID = [dbo].[StartValidationProcess] @JobID, @DatasetName, @DataSourceInstanceID, @UserID

  DECLARE @ProcessStepName nvarchar(255)  
  DECLARE @Level nvarchar(20)
  DECLARE @Rule nvarchar(MAX)
  DECLARE @ErrorMsg nvarchar(256) 

  DECLARE @ProcessStepID int
  
  /* prepare to start SiteAuditAssetList validation steps */
  EXEC [dbo].[StartValidationSteps] @ProcessID, @JobID, @DatasetName, @DataSourceInstanceID, @SourceTableName
 
  /* START COLUMN VALIDATIONS STEP */
  SET @ProcessStepName = 'Column Validations'
  EXEC @ProcessStepID = [dbo].[StartValidationStep] @ProcessID, @ProcessStepName, @JobID, @DatasetName, @DataSourceInstanceID, @SourceTableName
  
  EXEC dbo.ValidationStartRules @ProcessID, @ProcessStepID, @JobID, @DatasetName, @DataSourceInstanceID
  
  /* validate that the column types are set correctly */
  EXEC dbo.ValidationRuleCheckColumnExists @ProcessStepID, @DataSourceInstanceID, 'AssetName', 'text'
  EXEC dbo.ValidationRuleCheckColumnExists @ProcessStepID, @DataSourceInstanceID, 'AssetType', 'text'
  EXEC dbo.ValidationRuleCheckColumnExists @ProcessStepID, @DataSourceInstanceID, 'SerialNo', 'text'
  EXEC dbo.ValidationRuleCheckColumnExists @ProcessStepID, @DataSourceInstanceID, 'AssetTag', 'text'
  EXEC dbo.ValidationRuleCheckColumnExists @ProcessStepID, @DataSourceInstanceID, 'ManufacturerName', 'text'
  EXEC dbo.ValidationRuleCheckColumnExists @ProcessStepID, @DataSourceInstanceID, 'ModelNo', 'text'
  --EXEC dbo.ValidationRuleCheckColumnExists @ProcessStepID, @DataSourceInstanceID, 'DataSourceInstanceID', 'int'

  /* execute global validation rules */
  EXEC dbo.ValidationExecuteGlobalRules
    @ProcessID = @ProcessID,  
    @ProcessStepID = @ProcessStepID,
    @DatasetName = @DatasetName,
    @DataSourceInstanceID = @DataSourceInstanceID,    
    @SourceTableName = @SourceTableName
  
  /* mark end of global validation processing */
  EXEC [dbo].[EndValidationStep] @ProcessID = @ProcessID, @ProcessStepID = @ProcessStepID
    
  /* START REJECTIONS STEP */
  SET @ProcessStepName = 'Error Validations'
  EXEC @ProcessStepID = [dbo].[StartValidationStep] @ProcessID, @ProcessStepName, @JobID, @DatasetName, @DataSourceInstanceID, @SourceTableName
  
  EXEC dbo.ValidationStartRules @ProcessID, @ProcessStepID, @JobID, @DatasetName, @DataSourceInstanceID

  /* validate that values are provided in mandatory columns (error) */  
  EXEC dbo.ValidationRuleCheckFieldValues @ProcessStepID, @DataSourceInstanceID, 'AssetName', 'text', 'error'  
  EXEC dbo.ValidationRuleCheckFieldValues @ProcessStepID, @DataSourceInstanceID, 'AssetType', 'text', 'error'  

  /* validate that column values are listed in the list validation lists */  
  EXEC dbo.ValidationRuleCheckFieldListValues @ProcessStepID, 'Assets', 'AssetType', 'error', @AllowStatic
  
  /* mark end of error validation processing */
  EXEC [dbo].[EndValidationStep] @ProcessID = @ProcessID, @ProcessStepID = @ProcessStepID

  DECLARE @ErrorCount int
  SELECT @ErrorCount = COUNT([ProcessDetailID]) FROM [dbo].[vBlackBoxValidationResults] WHERE [Result] = 'error' and [ProcessID] = @ProcessID
  PRINT 'Errors = ' + CONVERT([nvarchar],@ErrorCount)

  /* START WARNINGS STEP (if below the error limit) */  
  IF @ErrorCount <= @ErrorLimit
  BEGIN
    SET @ProcessStepName = 'Warning Validations'
    EXEC @ProcessStepID = [dbo].[StartValidationStep] @ProcessID, @ProcessStepName, @JobID, @DatasetName, @DataSourceInstanceID, @SourceTableName

    /* validate that values are provided in columns (warning) */  
    EXEC dbo.ValidationRuleCheckFieldValues @ProcessStepID, @DataSourceInstanceID, 'AssetTag', 'text', 'warning'
  
    /* execute validation rules */
    EXEC dbo.ValidationExecuteRules
      @ProcessID = @ProcessID,
      @ProcessStepID = @ProcessStepID,
      @DatasetName = @DatasetName,
      @DataSourceInstanceID = @DataSourceInstanceID,      
      @SourceTableName = @SourceTableName,
      @RecordKey = 'AssetName',
      @TraceField = 'CONVERT(NVARCHAR,[ModelNo]) + '' '' + CONVERT(NVARCHAR,[AssetType])'
  
    /* mark end of warnings validation processing */
    EXEC [dbo].[EndValidationStep] @ProcessID = @ProcessID, @ProcessStepID = @ProcessStepID
  END
  
  /* mark end of all validation steps */
  EXEC [dbo].[EndValidationSteps] @ProcessID = @ProcessID, @ProcessStepID = @ProcessStepID
 
  /* mark end of all validation processing */
  EXEC [dbo].[EndValidationProcess] @ProcessID, @JobID, @DatasetName, @SourceTableName, 2
;

GO


---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************
  