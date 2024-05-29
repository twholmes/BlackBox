@ECHO OFF
REM Copyright (C) 2024 Crayon Australia
REM This script runs a BlackBox commandline
REM Version: 1.00
REM Updated: 2024-04-16 14:35:45

REM Change to the previous root directory
CD /D D:\DevOps\Workspace\BlackBox.Worker\packages\blackbox

REM Change to directory containing this file
REM CD /D %~dp0

REM Set environment variables for script run
SET BlackBoxRootDir=D:\DevOps\Workspace\BlackBox.Worker\packages\blackbox
SET BlackBoxWorkingDir=D:\DevOps\Workspace\BlackBox.Worker\packages\blackbox\Jobs\63cccac1-6ec8-4212-a0fd-efce204eab46

REM Run the BlackBox command line as Admin
"D:\DevOps\Workspace\BlackBox.Worker\packages\blackbox\BlackBox.exe" -pack blackbox -local -show -debug

pause
