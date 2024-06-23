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
ECHO 2) Copy DEV published to GitHub
ECHO 3) Copy Live ImplFiles to GitHub
ECHO 4) Copy Live WorkingContent to GitHub
ECHO .
ECHO 11) Push all files to GitHubCrayon
ECHO .
ECHO 12) Copy DEV published to GitHubCrayon
ECHO 13) Copy Live ImplFiles to GitHubCrayon
ECHO 14) Copy Live WorkingContent to GitHubCrayon
ECHO .

REM select command to run
set /P n="Run action #: "

REM TOP LEVEL COMMANDS
REM

ECHO .
IF %n% == 0 (
  powershell start-process powershell -verb runas 
)

REM COPY BACK TO GITHUB
REM

IF %n% == 1 (
  ECHO Push all files to GitHub
  PowerShell -NoProfile -ExecutionPolicy Bypass "& .\bbadmin.ps1 UpdateGitHubFiles"
)

IF %n% == 2 (
  ECHO DEV published to GitHub
  PowerShell -NoProfile -ExecutionPolicy Bypass "& .\bbadmin.ps1 CopyDevPublishedToGitHub"
)

IF %n% == 3 (
  ECHO Live ImplFiles to GitHub
  PowerShell -NoProfile -ExecutionPolicy Bypass "& .\bbadmin.ps1 CopyLiveImplFilesToGitHub"
)

IF %n% == 4 (
  ECHO Live WorkingContent to GitHub
  PowerShell -NoProfile -ExecutionPolicy Bypass "& .\bbadmin.ps1 CopyLiveWorkingContentToGitHub"
)

REM COPY BACK TO GITHUBCRAYON
REM

IF %n% == 11 (
  ECHO Push all files to GitHubCrayon
  PowerShell -NoProfile -ExecutionPolicy Bypass "& .\bbadmin.ps1 UpdateGitHubCrayonFiles"
)

IF %n% == 12 (
  ECHO DEV published to GitHubCrayon
  PowerShell -NoProfile -ExecutionPolicy Bypass "& .\bbadmin.ps1 CopyDevPublishedToGitHubCrayon"
)

IF %n% == 13 (
  ECHO Live ImplFiles to GitHubCrayon
  PowerShell -NoProfile -ExecutionPolicy Bypass "& .\bbadmin.ps1 CopyLiveImplFilesToGitHubCrayon"
)

IF %n% == 14 (
  ECHO Live WorkingContent to GitHubCrayon
  PowerShell -NoProfile -ExecutionPolicy Bypass "& .\bbadmin.ps1 CopyLiveWorkingContentToGitHubCrayon"
)

pause
