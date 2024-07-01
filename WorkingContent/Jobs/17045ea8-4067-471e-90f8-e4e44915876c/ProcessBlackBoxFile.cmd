@ECHO OFF
REM Copyright (C) 2024 Crayon Australia
REM This script runs a BlackBoxWorker PowerShell procedure
REM Version: 1.00
REM Updated: 2024-07-01 09:37:11

REM Change to directory containing this file
CD /D C:\BlackBox\WorkingContent\Scripts

REM Run ImplFiles
REM with args:
REM   -NoProfile -ExecutionPolicy Bypass -File "ProcessBlackBoxFile.ps1" -target ProcessBlackBoxFile -settings FileID=1000"
REM and with:
REM   WorkingDir: "C:\BlackBox\WorkingContent\Jobs\17045ea8-4067-471e-90f8-e4e44915876c"

REM BlackBox Folder EnvVars
SET BlackBoxRootDir=%~dp0
SET BlackBoxWorkingDir=%~dp0

REM Run the PowerShell command line as Admin
PowerShell.exe -NoProfile -ExecutionPolicy Bypass -File "ProcessBlackBoxFile.ps1" -target ProcessBlackBoxFile -settings FileID=1000"

exit
