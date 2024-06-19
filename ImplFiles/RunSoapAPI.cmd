@ECHO OFF
REM Copyright (C) 2024 Crayon Australia
REM This script selects wich PowerShell command to run
REM Version: 1.00
REM Updated: 2024-06-19 10:19

REM Change to directory containing this file
CD /D %~dp0
REM CD /D C:\BlackBox\ImplFiles

REM BlackBox Folder EnvVars
SET BlackBoxRootDir=%~dp0
SET BlackBoxWorkingDir=%~dp0

REM List BlackBox comman options
ECHO BlackBox PowerShell Commands:
ECHO 1) Open PowerShell console
ECHO .
ECHO 2) Call BlackBoxValidate API
ECHO .

REM select command to run
set /P n="Run SOAP API #: "

ECHO .
IF %n% == 1 (
  powershell start-process powershell -verb runas 
)

IF %n% == 2 (
  ECHO Call BlackBoxValidate API
  PowerShell -NoProfile -ExecutionPolicy Bypass "& .\bbadmin.ps1 DoBlackBoxValidateAction"
)

ECHO .

pause
