@ECHO OFF
REM Copyright (C) 2024 Crayon Australia
REM This script runs a BlackBoxWorker PowerShell procedure
REM Version: 1.00
REM Updated: 2024-06-16 17:13:20

REM Change to directory containing this file
CD /D C:\BlackBox\ImplFiles

REM Run ImplFiles
REM with args:
REM   -NoProfile -ExecutionPolicy Bypass "& .\bbadmin.ps1 -target PublishBlackBoxDataSource -settings DataSource=AglPurchases,FileID=1000,JobGUID=02b4c630-661d-44d5-a9eb-9a31035d01d4" < NUL
REM and with:
REM   WorkingDir: "C:\ProgramData\Crayon\BlackBox\Jobs\02b4c630-661d-44d5-a9eb-9a31035d01d4"

REM BlackBox Folder EnvVars
SET BlackBoxRootDir=%~dp0
SET BlackBoxWorkingDir=%~dp0

REM Run the PowerShell command line as Admin
PowerShell.exe -NoProfile -ExecutionPolicy Bypass -File "test.ps1" -target PublishBlackBoxDataSource -settings DataSource=AglPurchases,FileID=1000,JobGUID=02b4c630-661d-44d5-a9eb-9a31035d01d4

pause
