@ECHO OFF
REM Copyright (C) 2024 Crayon Australia
REM This script runs a BlackBoxWorker PowerShell procedure
REM Version: 1.00
REM Updated: 2024-06-17 15:40:33

REM Change to directory containing this file
CD /D C:\BlackBox\WorkingContent\Scripts

REM Run ImplFiles
REM with args:
REM   -NoProfile -ExecutionPolicy Bypass -File "PublishBlackBoxDataSource.ps1" -target PublishBlackBoxDataSource -settings DataSource=AglPurchases,FileID=1000,JobGUID=a7b0b584-4156-4e15-8b2d-02a0e3980866"
REM and with:
REM   WorkingDir: "C:\BlackBox\WorkingContent\Jobs\a7b0b584-4156-4e15-8b2d-02a0e3980866"

REM BlackBox Folder EnvVars
SET BlackBoxRootDir=%~dp0
SET BlackBoxWorkingDir=%~dp0

REM Run the PowerShell command line as Admin
PowerShell.exe -NoProfile -ExecutionPolicy Bypass -File "PublishBlackBoxDataSource.ps1" -target PublishBlackBoxDataSource -settings DataSource=AglPurchases,FileID=1000,JobGUID=a7b0b584-4156-4e15-8b2d-02a0e3980866"

exit
