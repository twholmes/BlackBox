SET NOCOUNT ON
GO

USE [FNMSStaging]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[StagedReportHistory]') AND type in (N'U'))
DROP TABLE [dbo].[StagedReportHistory]
GO

CREATE TABLE [dbo].[StagedReportHistory]
(
  [ID] int IDENTITY NOT NULL PRIMARY KEY,
  [ReportID] int,
  [ReportName] [nvarchar](256),
  [Rows] int,
  [Status] int,
  [TimeStamp] datetime
)
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[StagedInstalledSoftware]') AND type in (N'U'))
DROP TABLE [dbo].[StagedInstalledSoftware]
GO

CREATE TABLE [dbo].[StagedInstalledSoftware]
(
  [ComplianceComputerID] [nvarchar](10),
  [ComputerName] [nvarchar](256),
  [InstalledSoftwareLicenseID] [nvarchar](10),
  [ApplicationName] [nvarchar](1024),
  [ApplicationVersion] [nvarchar](256),
  [IsAllocated] [nvarchar](10),
  [SoftwareLicenseAllocationID] [nvarchar](10),
  [IsExempt] [nvarchar](10),
  [SoftwareLicenseExemptionReason] [nvarchar](4000),
  [LastUsedDate] [nvarchar](256),
  [id] [nvarchar](256),
  [rowOrder] [nvarchar](256),    
)
GO
