--------------------------------------------------------------------------------------
-- Copyright (C) 2024 Crayon
-- BLACKBOX CONFIGURATION
-- This file configures BlackBox for ExtraData
--
--------------------------------------------------------------------------------------

USE $(DBName)
GO

---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************

----
---- BLACKBOX METADATA TABLES
----

--------------------------------------------------------------------------------------------------------
-- dbo.BlackBoxMetaData: Records action history records

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BlackBoxMetaData]') AND type in (N'U'))
DROP TABLE [dbo].[BlackBoxMetaData]
GO

CREATE TABLE [dbo].[BlackBoxMetaData]
(
  [ID] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
  [Object] [nvarchar](64) NOT NULL,
  [RefID] int NULL,
  [UserID] int,
  [ActorID] int,  
  [Item] [nvarchar](256) NOT NULL,  
  [Value] [nvarchar](2048),  
  [TimeStamp] datetime
)

GO

DBCC CHECKIDENT ('dbo.BlackBoxMetaData', RESEED, 1000)
GO

---- **************************************************************************************************
---- **************************************************************************************************
---- **************************************************************************************************
