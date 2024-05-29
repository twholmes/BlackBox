@ECHO OFF
REM Copyright (C) 2024 Crayon Australia
REM This script runs a BlackBox commandline
REM Version: 1.00
REM Updated: 2024-04-16 14:35:31

REM Change to the previous root directory
CD /D D:\DevOps\Workspace\BlackBox.Worker\packages\blackbox

REM Change to directory containing this file
REM CD /D %~dp0

REM Set environment variables for script run
SET BlackBoxRootDir=D:\DevOps\Workspace\BlackBox.Worker\packages\blackbox
SET BlackBoxWorkingDir=D:\DevOps\Workspace\BlackBox.Worker\packages\blackbox\Jobs\8059431d-f83b-4ba3-b852-0b38d1dce33a

REM Run the BlackBox command line as Admin
"D:\DevOps\Workspace\BlackBox.Worker\packages\blackbox\BlackBox.exe" -catalog blackbox -include setup -local -show -debug

pause
