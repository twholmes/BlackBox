--------------------------------------------------------------------------------------
-- Copyright (C) 2024 Crayon
-- BLACKBOX Staged Data
-- This file configures BlackBox for a the base set of staged daat
-- and Datasets
--
--------------------------------------------------------------------------------------

USE $(DBName)
GO

---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************

----
---- BLACKBOX STATICS VIEWS
----

--------------------------------------------------------------------------------------------------------
-- dbo.vApprovedRecordCounts: View definiton for vApprovedRecordCounts

IF EXISTS (SELECT 1 FROM dbo.sysobjects WHERE id = object_id('dbo.vApprovedRecordCounts') AND OBJECTPROPERTY(id, 'IsView') = 1)
  DROP VIEW [dbo].[vApprovedRecordCounts]
GO

CREATE VIEW [dbo].[vApprovedRecordCounts] AS
WITH Counts AS
(
  SELECT dsx.*
  FROM
  (
    SELECT 'DataMappings' AS [Name]
      ,Max(saal.[DataSourceInstanceID]) AS [DataSourceInstanceID]
      ,Count(saal.[StagedID]) AS [Rows]
      ,0 AS [Age], 0 AS [Rank]
    FROM [dbo].[stagedDataMappings] AS saal

    UNION
    
    SELECT 'Contacts' AS [Name]
      ,Max(sia.[DataSourceInstanceID]) AS [DataSourceInstanceID]
      ,Count(sia.[StagedID]) AS [Rows]
      ,0 AS [Age], 0 AS [Rank]
    FROM [dbo].[stagedContacts] AS sia
  ) AS dsx
)
SELECT
  c.[Name]
  ,c.[DataSourceInstanceID]
  ,c.[Rows]
  ,c.[Age]
  ,c.[Rank]
FROM Counts as c

GO

--------------------------------------------------------------------------------------------------------
-- dbo.vStagedRecordCounts: View definiton for vStagedRecordCounts

IF EXISTS (SELECT 1 FROM dbo.sysobjects WHERE id = object_id('dbo.vStagedRecordCounts') AND OBJECTPROPERTY(id, 'IsView') = 1)
  DROP VIEW [dbo].[vStagedRecordCounts]
GO

CREATE VIEW [dbo].[vStagedRecordCounts] AS
SELECT 
  dsu.[ID]
  ,dsu.[Group]
  ,dsu.[Name]
  ,dsu.[DataSourceInstanceID]
  ,dsu.[FID]
  ,dsu.[Rows]
  ,dsu.[TimeStamp]      
  ,dsu.[Age]
  ,dsu.[UserID]
  ,dsu.[FullName]
  ,dsu.[Rank]
FROM [dbo].[vBlackBoxDatasetUpdates] AS dsu
WHERE dsu.[Group] != 'Templates'  AND dsu.[Rank] < 4

GO

--------------------------------------------------------------------------------------------------------
-- dbo.vTemplateRecordCounts: View definiton for vTemplateRecordCounts

IF EXISTS (SELECT 1 FROM dbo.sysobjects WHERE id = object_id('dbo.vTemplateRecordCounts') AND OBJECTPROPERTY(id, 'IsView') = 1)
  DROP VIEW [dbo].[vTemplateRecordCounts]
GO

CREATE VIEW [dbo].[vTemplateRecordCounts] AS
SELECT 
  dsu.[ID]
  ,dsu.[Name]
  ,dsu.[DataSourceInstanceID]
  ,dsu.[FID]
  ,dsu.[Rows]
  ,dsu.[TimeStamp]
  ,dsu.[Age]
  ,dsu.[UserID]
  ,dsu.[FullName]
  ,dsu.[Rank]
FROM [dbo].[vBlackBoxDatasetUpdates] AS dsu
WHERE dsu.[Group] = 'Templates' AND dsu.[Rank] < 4

GO

--------------------------------------------------------------------------------------------------------
-- dbo.vUploadedFileCounts: View definiton for vUploadedFileCounts

IF EXISTS (SELECT 1 FROM dbo.sysobjects WHERE id = object_id('dbo.vUploadedFileCounts') AND OBJECTPROPERTY(id, 'IsView') = 1)
  DROP VIEW [dbo].[vUploadedFileCounts]
GO

CREATE VIEW [dbo].[vUploadedFileCounts] AS
SELECT
  dsx.[Name]
  ,ISNULL(LastWeek.[Count],0) AS [LastWeek]
  ,ISNULL(LastMonth.[Count],0) AS [LastMonth]
  ,ISNULL(LastYear.[Count],0) AS [LastYear]
FROM 
(
  SELECT ds.[Name]
  FROM dbo.[BlackBoxDataSources] AS ds
  UNION
  SELECT 'Templates' AS [Name]
) AS dsx
LEFT OUTER JOIN 
(
  SELECT 
    [DataSource]
    ,Count([FID]) AS [Count]
   FROM [dbo].[vBlackBoxFiles]
   WHERE [Age] < 8 AND [Group] != 'Templates'
   GROUP BY [DataSource]
  UNION
  SELECT 
    'Templates'
    ,Count([FID]) AS [Count]
   FROM [dbo].[vBlackBoxFiles]
   WHERE [Age] < 8 AND [Group] = 'Templates'
   GROUP BY [Group]
) AS LastWeek ON dsx.[Name] = LastWeek.[DataSource]
LEFT OUTER JOIN 
(
  SELECT 
    [DataSource]
    ,Count([FID]) AS [Count]
   FROM [dbo].[vBlackBoxFiles]
   WHERE [Age] < 30 AND [Group] != 'Templates'
   GROUP BY [DataSource]
  UNION
  SELECT 
    'Templates'
    ,Count([FID]) AS [Count]
   FROM [dbo].[vBlackBoxFiles]
   WHERE [Age] < 30 AND [Group] = 'Templates'
   GROUP BY [Group]
) AS LastMonth ON dsx.[Name] = LastMonth.[DataSource]
LEFT OUTER JOIN 
(
  SELECT 
    [DataSource]
    ,Count([FID]) AS [Count]
   FROM [dbo].[vBlackBoxFiles]
   WHERE [Age] < 365 AND [Group] != 'Templates'
   GROUP BY [DataSource]
  UNION
  SELECT 
    'Templates'
    ,Count([FID]) AS [Count]
   FROM [dbo].[vBlackBoxFiles]
   WHERE [Age] < 365 AND [Group] = 'Templates'
   GROUP BY [Group]   
) AS LastYear ON dsx.[Name] = LastYear.[DataSource]

GO



---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************

