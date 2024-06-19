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
ECHO 1) Open PowerShell console
ECHO .
ECHO 2) Rebuild database
ECHO 3) Copy to Live from DEV published
ECHO 4) Copy to LiveContent from DEV published
ECHO 5) Copy to GitHub from DEV published
ECHO .
ECHO 6) Configure BlackBox web site
ECHO .
ECHO 7) Configure scheduled task to process Scheduled BlackBox Files
ECHO 8) Configure the Flexera integration
ECHO .
ECHO 9) Synch bbadmin settings to registry
ECHO .

REM select command to run
set /P n="Run action #: "

ECHO .
IF %n% == 1 (
  powershell start-process powershell -verb runas 
)

IF %n% == 2 (
  ECHO Rebuild database
  PowerShell -NoProfile -ExecutionPolicy Bypass "& .\bbadmin.ps1 ConfigureBlackBoxDatabase"
)

IF %n% == 3 (
  ECHO Copy to Live from DEV published
  PowerShell -NoProfile -ExecutionPolicy Bypass "& .\bbadmin.ps1 CopyLiveFromDevPublished"
)
IF %n% == 4 (
  ECHO Copy to LiveContent from DEV published
  PowerShell -NoProfile -ExecutionPolicy Bypass "& .\bbadmin.ps1 CopyLiveContentFromDevPublished"
)

IF %n% == 5 (
  ECHO Copy to GitHub from DEV published
  PowerShell -NoProfile -ExecutionPolicy Bypass "& .\bbadmin.ps1 CopyGitHubFromDevPublished"
)

IF %n% == 6 (
  ECHO Configure BlackBox web site
  PowerShell -NoProfile -ExecutionPolicy Bypass "& .\bbadmin.ps1 ConfigureWebSite"
)

IF %n% == 7 (
  ECHO Configure scheduled task to process Scheduled BlackBox Files
  PowerShell -NoProfile -ExecutionPolicy Bypass "& .\bbadmin.ps1 ConfigureProcessScheduledBlackBoxFilesScheduledTask"
)
ECHO .

IF %n% == 8 (
  ECHO Configure the Flexera integration
  PowerShell -NoProfile -ExecutionPolicy Bypass "& .\bbadmin.ps1 ConfigureFlexeraIntegration"
)
ECHO .

IF %n% == 9 (
  ECHO Synch bbadmin settings to registry
  PowerShell -NoProfile -ExecutionPolicy Bypass "& .\bbadmin.ps1 SyncBbAdminSettings"
)
ECHO .

pause
