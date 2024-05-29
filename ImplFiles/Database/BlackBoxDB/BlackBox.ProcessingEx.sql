--------------------------------------------------------------------------------------
-- Copyright (C) 2023 Crayon
-- BLACKBOX CONFIGURATION
-- This file configures BlackBox for dataset recording and transacrions 
--
--------------------------------------------------------------------------------------

--USE [BlackBox]
--GO

---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************

----
---- BLACKBOX STAGING PROCEDURES
----

/****** StoredProcedure: [dbo].[StageSIDA] ******/
IF EXISTS(SELECT 1 FROM sys.procedures WHERE Name = 'StageSIDA')
  DROP PROCEDURE [dbo].[StageSIDA]
GO

CREATE PROCEDURE [dbo].[StageSIDA]
  @DataSourceInstanceID int,
  @JobID int = 0,   
  @SourceDataset [nvarchar](100) = '%',
  @KeepExisting [bit] = 0
AS
  PRINT 'Finalise SIDA Staging'

  DECLARE @FID int  
  DECLARE @Site [nvarchar](1024)  
  DECLARE @StagedCount int  

  SELECT @FID = [FID] FROM [dbo].[BlackBoxFiles] WHERE [DataSourceInstanceID] = @DataSourceInstanceID  
  SELECT @Site = [Value] FROM [dbo].[BlackBoxMetaData] WHERE [Object] = 'file' AND [RefID] = @FID
  IF @Site IS NOT NULL
  BEGIN
    UPDATE [dbo].[rioSIDA] 
    SET [AssetSiteName] = @Site
    WHERE [DataSourceInstanceID] = @DataSourceInstanceID  	
  END

  IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[rioSIDA]') AND type in (N'U'))  
  BEGIN
    SELECT @StagedCount = COUNT(*) FROM [dbo].[rioSIDA] WHERE [DataSourceInstanceID] = @DataSourceInstanceID
  END
 
  RETURN @StagedCount

GO

/****** StoredProcedure: [dbo].[Stage3DSIDA] ******/
IF EXISTS(SELECT 1 FROM sys.procedures WHERE Name = 'Stage3DSIDA')
  DROP PROCEDURE [dbo].[Stage3DSIDA]
GO

CREATE PROCEDURE [dbo].[Stage3DSIDA]  
  @DataSourceInstanceID int,
  @JobID int = 0,   
  @SourceDataset [nvarchar](100) = '%',
  @KeepExisting [bit] = 0
AS
  PRINT 'Finalise 3D-SIDA Staging'
  
  DECLARE @StagedCount int
  IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[rioSIDA]') AND type in (N'U'))  
  BEGIN
    SELECT @StagedCount = COUNT(*) FROM [dbo].[rioSIDA] WHERE [DataSourceInstanceID] = @DataSourceInstanceID
  END
 
  RETURN @StagedCount

GO

/****** StoredProcedure: [dbo].[StageSIA] ******/
IF EXISTS(SELECT 1 FROM sys.procedures WHERE Name = 'StageSIA')
  DROP PROCEDURE [dbo].[StageSIA]
GO

CREATE PROCEDURE [dbo].[StageSIA]  
  @DataSourceInstanceID int,
  @JobID int = 0,   
  @SourceDataset [nvarchar](100) = '%',
  @KeepExisting [bit] = 0
AS
  PRINT 'Finalise SIA Staging'

  UPDATE [dbo].[rioSIA] 
  SET [Exclude] = ''
  WHERE [Exclude] IS NULL
  
  DECLARE @StagedCount int 
  IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[rioSIA]') AND type in (N'U'))  
  BEGIN
    SELECT @StagedCount = COUNT(*) FROM [dbo].[rioSIA] WHERE [DataSourceInstanceID] = @DataSourceInstanceID
  END
 
  RETURN @StagedCount

GO

/****** StoredProcedure: [dbo].[StageSiteAuditAssetList] ******/
IF EXISTS(SELECT 1 FROM sys.procedures WHERE Name = 'StageSiteAuditAssetList')
  DROP PROCEDURE [dbo].[StageSiteAuditAssetList]
GO

CREATE PROCEDURE [dbo].[StageSiteAuditAssetList]  
  @DataSourceInstanceID int,
  @JobID int = 0,   
  @SourceDataset [nvarchar](100) = '%',
  @KeepExisting [bit] = 0
AS
  PRINT 'Finalise SiteAuditAssetList Staging'

  UPDATE [dbo].[rioSiteAuditAssetList] 
  SET [Exclude] = ''
  WHERE [Exclude] IS NULL
  
  DECLARE @StagedCount int 
  IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[rioSiteAuditAssetList]') AND type in (N'U'))  
  BEGIN
    SELECT @StagedCount = COUNT(*) FROM [dbo].[rioSiteAuditAssetList] WHERE [DataSourceInstanceID] = @DataSourceInstanceID
  END

GO

/****** StoredProcedure: [dbo].[PublishSIA] ******/
IF EXISTS(SELECT 1 FROM sys.procedures WHERE Name = 'PublishSIA')
  DROP PROCEDURE [dbo].[PublishSIA]
GO

CREATE PROCEDURE [dbo].[PublishSIA]
  @DataSourceInstanceID int = 0,
  @JobID int = 0,   
  @SourceDataset [nvarchar](100) = '%',
  @KeepExisting [bit] = 0
AS
  PRINT 'Publish SIA'
  
  IF @KeepExisting = 0
  BEGIN
    DELETE FROM [dbo].[stagedSIA]
  END

  INSERT INTO [dbo].[stagedSIA]
  SELECT  
    [ID],[JobID],[DataSourceInstanceID],[LineNumber],[FlexeraID]
    ,[Site_Name],[Common_Application_Name],[CI_Application_Name],[SIA_Stakeholders],[Business_Process],[Functional_Description],[End_User_Execution]
    ,[Business_Impact],[Primary_Consequence_Category],[Financial_Impact],[Non_Financial_Impact],[Criticality_Rating],[Comments],[System_Owners]
    ,[Business_Owners],[Approvers]
  FROM [dbo].[rioSIA] 
  WHERE [DataSourceInstanceID] = @DataSourceInstanceID AND ISNULL([Exclude], '') !='Yes'

GO

/****** StoredProcedure: [dbo].[PublishSiteAuditAssetList] ******/
IF EXISTS(SELECT 1 FROM sys.procedures WHERE Name = 'PublishSiteAuditAssetList')
  DROP PROCEDURE [dbo].[PublishSiteAuditAssetList]
GO

CREATE PROCEDURE [dbo].[PublishSiteAuditAssetList]
  @DataSourceInstanceID int = 0,
  @JobID int = 0,   
  @SourceDataset [nvarchar](100) = '%',
  @KeepExisting [bit] = 0
AS
  PRINT 'Publish SiteAuditAssetList'
  
  IF @KeepExisting = 0
  BEGIN
    DELETE FROM [dbo].[stagedSiteAuditAssetList]
  END

  INSERT INTO [dbo].[stagedSiteAuditAssetList]
  SELECT  
    [ID],[JobID],[DataSourceInstanceID],[LineNumber],[FlexeraID]
    ,[Serial_Number],[Model_Category],[Manufacturer],[Model],[End_of_Warranty],[End_of_Service_Life],[Status],[Ship_Date],[Asset_Name],[Resolver_Group]
    ,[Site],[Physical_Location],[Managed_By],[IP_Address],[Sub_Model_Category],[Firmware],[GPS_Location_or_Coordinates],[Physical_Inventory_Date]
    ,[Serial_Duplicated_as_Asset_Name],[Core_CI],[Information_Technology_or_OT_Asset],[Financial_Ownership]
  FROM [dbo].[rioSiteAuditAssetList] 
  WHERE [DataSourceInstanceID] = @DataSourceInstanceID AND ISNULL([Exclude], '') !='Yes'

GO

/****** StoredProcedure: [dbo].[PublishSIDA] ******/
IF EXISTS(SELECT 1 FROM sys.procedures WHERE Name = 'PublishSIDA')
  DROP PROCEDURE [dbo].[PublishSIDA]
GO

CREATE PROCEDURE [dbo].[PublishSIDA]
  @DataSourceInstanceID int = 0,
  @JobID int = 0,   
  @SourceDataset [nvarchar](100) = '%',
  @KeepExisting [bit] = 0
AS
  PRINT 'Publish SIDA'
  
  IF @KeepExisting = 0
  BEGIN
    DELETE FROM [dbo].[stagedSIDA]
  END

  INSERT INTO [dbo].[stagedSIDA]
  SELECT  
    [ID],[JobID],[DataSourceInstanceID],[LineNumber],[FlexeraID],[ApplicationSiteName],[ApplicationName],[AssetSiteName],[AssetName]
  FROM [dbo].[rioSIDA] 
  WHERE [DataSourceInstanceID] = @DataSourceInstanceID AND ISNULL([Exclude], '') !='Yes'

GO

---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************
