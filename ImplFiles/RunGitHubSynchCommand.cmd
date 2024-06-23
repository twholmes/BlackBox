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
ECHO 1) Push all files to GitHub
ECHO .
ECHO 32) Copy DEV published to GitHub
ECHO 33) Copy Live ImplFiles to GitHub
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
  ECHO Push all files to GitHub
  PowerShell -NoProfile -ExecutionPolicy Bypass "& .\bbadmin.ps1 UpdateGitHubFiles"
)

REM COPY BACK TO GITHUB
REM

IF %n% == 32 (
  ECHO DEV published to GitHub
  PowerShell -NoProfile -ExecutionPolicy Bypass "& .\bbadmin.ps1 CopyDevPublishedToGitHub"
)

IF %n% == 33 (
  ECHO Live ImplFiles to GitHub
  PowerShell -NoProfile -ExecutionPolicy Bypass "& .\bbadmin.ps1 CopyLiveImplFilesToGitHub"
)

pause
