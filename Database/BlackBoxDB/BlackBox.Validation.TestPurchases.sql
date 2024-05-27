--------------------------------------------------------------------------------------
-- Copyright (C) 2022 Crayon
-- BLACKBOX CONFIGURATION
-- This file configures BlackBox for data source validation
--
--------------------------------------------------------------------------------------

--USE [BlackBox]
--GO

---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************

DECLARE @UserID int
SET @UserID = 99

DECLARE @JobID int
DECLARE @DatasetName NVARCHAR(50)
DECLARE @SourceTableName NVARCHAR(256)
DECLARE @DataSourceInstanceID int

SET @JobID = 1000
SET @DataSourceInstanceID = 1000

EXEC [dbo].[ClearProcessLogsByJobID] @JobID

SET @DatasetName='Purchases'
SET @SourceTableName='itamPurchases'

EXEC [dbo].[ValidatePurchasesDataset] @DatasetName, @DataSourceInstanceID, @SourceTableName, @JobID, @UserID

SELECT 
  [ProcessDetailID]
      ,[ProcessID]
      ,[ProcessStepID]
      ,[ProcessName]
      ,[ProcessStepName]
      ,[JobID]
      ,[DatasetName]
      ,[RecordNumber]
      ,[Action]
      ,[RecordKey]
      ,[RecordDescription]
      ,[Message]
FROM [dbo].[vBlackBoxValidationResults]

GO
