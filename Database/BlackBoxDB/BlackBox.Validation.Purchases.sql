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

/****** StoredProcedure: [dbo].[ValidatePurchasesDataset] ******/
IF EXISTS(SELECT 1 FROM sys.procedures WHERE Name = 'ValidatePurchasesDataset')
  DROP PROCEDURE [dbo].[ValidatePurchasesDataset]
GO

CREATE PROCEDURE [dbo].[ValidatePurchasesDataset]
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
  
  /* prepare to start validation steps */
  EXEC [dbo].[StartValidationSteps] @ProcessID, @JobID, @DatasetName, @DataSourceInstanceID, @SourceTableName

  DECLARE @ProcessStepName nvarchar(255)  
  DECLARE @Level nvarchar(20)
  DECLARE @Rule nvarchar(MAX)
  DECLARE @ErrorMsg nvarchar(256) 
  
  DECLARE @ProcessStepID int
 
  /* START COLUMN VALIDATIONS STEP */
  SET @ProcessStepName = 'Column Validations'
  EXEC @ProcessStepID = [dbo].[StartValidationStep] @ProcessID, @ProcessStepName, @JobID, @DatasetName, @DataSourceInstanceID, @SourceTableName
  
  EXEC dbo.ValidationStartRules @ProcessID, @ProcessStepID, @JobID, @DatasetName, @DataSourceInstanceID
  
  /* validate that the column types are set correctly */
  EXEC dbo.ValidationRuleCheckColumnExists @ProcessStepID, @DataSourceInstanceID, 'PurchaseOrderNo', 'text'
  EXEC dbo.ValidationRuleCheckColumnExists @ProcessStepID, @DataSourceInstanceID, 'POLineNo', 'int'
  EXEC dbo.ValidationRuleCheckColumnExists @ProcessStepID, @DataSourceInstanceID, 'PurchaseType', 'text'
  EXEC dbo.ValidationRuleCheckColumnExists @ProcessStepID, @DataSourceInstanceID, 'PurchaseQuantity', 'int'
  EXEC dbo.ValidationRuleCheckColumnExists @ProcessStepID, @DataSourceInstanceID, 'Description', 'text'
  EXEC dbo.ValidationRuleCheckColumnExists @ProcessStepID, @DataSourceInstanceID, 'VendorName', 'text'
  --EXEC dbo.ValidationRuleCheckColumnExists @ProcessStepID, @SourceTableName, 'DataSourceInstanceID', 'int'

  /* execute global validation rules */
  EXEC dbo.ValidationExecuteGlobalRules
    @ProcessID = @ProcessID,  
    @ProcessStepID = @ProcessStepID,
    @DatasetName = @DatasetName,
    @DataSourceInstanceID = @DataSourceInstanceID,    
    @SourceTableName = @SourceTableName
  
  /* mark end of error validation processing */
  EXEC [dbo].[EndValidationStep] @ProcessID = @ProcessID, @ProcessStepID = @ProcessStepID
    
  /* START REJECTIONS STEP */
  SET @ProcessStepName = 'Error Validations'
  EXEC @ProcessStepID = [dbo].[StartValidationStep] @ProcessID, @ProcessStepName, @JobID, @DatasetName, @DataSourceInstanceID, @SourceTableName
  
  EXEC dbo.ValidationStartRules @ProcessID, @ProcessStepID, @JobID, @DatasetName, @DataSourceInstanceID

  /* validate that values are provided in mandatory columns */  
  EXEC dbo.ValidationRuleCheckFieldValues @ProcessStepID, @DataSourceInstanceID, 'PurchaseOrderNo', 'text', 'error'  
  EXEC dbo.ValidationRuleCheckFieldValues @ProcessStepID, @DataSourceInstanceID, 'POLineNo', 'integer', 'error'  
  EXEC dbo.ValidationRuleCheckFieldValues @ProcessStepID, @DataSourceInstanceID, 'PurchaseType', 'text', 'error'    
  EXEC dbo.ValidationRuleCheckFieldValues @ProcessStepID, @DataSourceInstanceID, 'PurchaseQuantity', 'integer', 'error'
  EXEC dbo.ValidationRuleCheckFieldValues @ProcessStepID, @DataSourceInstanceID, 'VendorName', 'text', 'error'  
 
  /* execute validation rules */
  EXEC dbo.ValidationExecuteRules
    @ProcessID = @ProcessID,  
    @ProcessStepID = @ProcessStepID,
    @DatasetName = @DatasetName,
    @DataSourceInstanceID = @DataSourceInstanceID,    
    @SourceTableName = @SourceTableName,
    @RecordKey = 'PurchaseOrderNo',
    @TraceField = 'CONVERT(NVARCHAR,[VendorName]) + '' '' + CONVERT(NVARCHAR,[POLineNo]) + '' with PurchaseType '' + CONVERT(NVARCHAR,[PurchaseType])'
  
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

    /* validate that values are provided in creation columns */  
    EXEC dbo.ValidationRuleCheckFieldValues @ProcessStepID, @DataSourceInstanceID, 'Description', 'text', 'warning'
    EXEC dbo.ValidationRuleCheckFieldValues @ProcessStepID, @DataSourceInstanceID, 'UnitPrice', 'float', 'warning'    
  
    /* execute validation rules */
    EXEC dbo.ValidationExecuteRules
      @ProcessID = @ProcessID,
      @ProcessStepID = @ProcessStepID,
      @DatasetName = @DatasetName,
      @DataSourceInstanceID = @DataSourceInstanceID,      
      @SourceTableName = @SourceTableName,
      @RecordKey = 'PurchaseOrderNo',
      @TraceField = 'CONVERT(NVARCHAR,[VendorName]) + '' '' + CONVERT(NVARCHAR,[POLineNo])'
  
    /* mark end of warning validation processing */
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
  