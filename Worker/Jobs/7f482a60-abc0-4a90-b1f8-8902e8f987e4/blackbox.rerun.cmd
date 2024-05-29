@ECHO OFF
REM Copyright (C) 2024 Crayon Australia
REM This script runs a BlackBox commandline
REM Version: 1.00
REM Updated: 2024-04-16 14:36:21

REM Change to the previous root directory
CD /D D:\DevOps\Workspace\BlackBox.Worker\packages\blackbox

REM Change to directory containing this file
REM CD /D %~dp0

REM Set environment variables for script run
SET BlackBoxRootDir=D:\DevOps\Workspace\BlackBox.Worker\packages\blackbox
SET BlackBoxWorkingDir=D:\DevOps\Workspace\BlackBox.Worker\packages\blackbox\Jobs\7f482a60-abc0-4a90-b1f8-8902e8f987e4

REM Run the BlackBox command line as Admin
"D:\DevOps\Workspace\BlackBox.Worker\packages\blackbox\BlackBox.exe" -unpack blackbox -dest map -local -show -debug

pause
