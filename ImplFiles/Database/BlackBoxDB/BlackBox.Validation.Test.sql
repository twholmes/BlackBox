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
SET @UserID = 101

DECLARE @JobID int
DECLARE @DatasetName NVARCHAR(50)
DECLARE @SourceTableName NVARCHAR(256)
DECLARE @DataSourceInstanceID int

DECLARE @AllowStatic bit

SET @JobID = 1000
SET @DataSourceInstanceID = 1000
SET @AllowStatic = 1

EXEC [dbo].[ClearProcessLogsByJobID] @JobID

SET @DatasetName='SiteAuditAssetList'
SET @SourceTableName='rioSiteAuditAssetList'

EXEC [dbo].[ValidateSiteAuditAssetListDataset] @DatasetName, @DataSourceInstanceID, @SourceTableName, @JobID, @UserID, @AllowStatic

SET @DatasetName='SIA'
SET @SourceTableName='rioSIA'

EXEC [dbo].[ValidateSIADataset] @DatasetName, @DataSourceInstanceID, @SourceTableName, @JobID, @UserID, @AllowStatic

SELECT 
  [ProcessDetailID]
      ,[ProcessID]
      ,[ProcessStepID]
      ,[ProcessName]
      ,[ProcessStepName]
      ,[JobID]
      ,[DatasetName]
      ,[DataSourceInstanceID]
      ,[RecordNumber]
      ,[Item]
      ,[Action]
      ,[RecordKey]
      ,[RecordDescription]
      ,[Message]
FROM [dbo].[vBlackBoxValidationResults]
GO
