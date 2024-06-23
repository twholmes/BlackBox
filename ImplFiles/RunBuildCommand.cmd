@ECHO OFF
REM Copyright (C) 2024 Crayon Australia
REM This script selects wich PowerShell command to run
REM Version: 1.00
REM Updated: 2024-06-19 10:19

REM Change to directory containing this file
CD /D C:\BlackBox\ImplFiles

REM BlackBox Folder EnvVars
SET BlackBoxRootDir=%~dp0
SET BlackBoxWorkingDir=%~dp0

REM List BlackBox comman options
ECHO BlackBox PowerShell Commands:
ECHO 0) Open PowerShell console
ECHO 1) Install all
ECHO .
ECHO 11) Rebuild database
ECHO 12) Copy DEV published to Live
ECHO 13) Copy DEV published content to Live
ECHO .
ECHO 21) Configure BlackBox web site
ECHO 22) Configure the Flexera integration
ECHO 23) Configure all Business adapters
ECHO .
ECHO 26) Configure scheduled task to process Scheduled BlackBox Files
ECHO .
ECHO 29) Synch bbadmin settings to registry
ECHO .

REM select command to run
set /P n="Run action #: "

REM TOP LEVEL COMMANDS
REM

ECHO .
IF %n% == 0 (
  powershell start-process powershell -verb runas 
)

IF %n% == 1 (
  ECHO Install all components
  PowerShell -NoProfile -ExecutionPolicy Bypass "& .\bbadmin.ps1 InstallAll"
)

REM COPY AND INSTALL 
REM

IF %n% == 11 (
  ECHO Rebuild database
  PowerShell -NoProfile -ExecutionPolicy Bypass "& .\bbadmin.ps1 ConfigureBlackBoxDatabase"
)

IF %n% == 12 (
  ECHO Copy DEV published to Live
  PowerShell -NoProfile -ExecutionPolicy Bypass "& .\bbadmin.ps1 CopyDevPublishedToLive"
)
IF %n% == 13 (
  ECHO Copy DEV published content to Live
  PowerShell -NoProfile -ExecutionPolicy Bypass "& .\bbadmin.ps1 CopyDevPublishedContentToLive"
)

REM CCONFIGURE
REM

IF %n% == 21 (
  ECHO Configure BlackBox web site
  PowerShell -NoProfile -ExecutionPolicy Bypass "& .\bbadmin.ps1 ConfigureWebSite"
)

IF %n% == 22 (
  ECHO Configure the Flexera integration
  PowerShell -NoProfile -ExecutionPolicy Bypass "& .\bbadmin.ps1 ConfigureFlexeraIntegration"
)
ECHO .

IF %n% == 23 (
  ECHO Configure all Business adapters
  PowerShell -NoProfile -ExecutionPolicy Bypass "& .\bbadmin.ps1 ConfigureAllAdapters"
)
ECHO .

IF %n% == 26 (
  ECHO Configure scheduled task to process Scheduled BlackBox Files
  PowerShell -NoProfile -ExecutionPolicy Bypass "& .\bbadmin.ps1 ConfigureProcessScheduledBlackBoxFilesScheduledTask"
)
ECHO .

IF %n% == 29 (
  ECHO Synch bbadmin settings to registry
  PowerShell -NoProfile -ExecutionPolicy Bypass "& .\bbadmin.ps1 SyncBbAdminSettings"
)
ECHO .

pause
