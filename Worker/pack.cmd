@ECHO OFF
REM Copyright (C) 2024 Crayon Australia
REM This script runs a BlackBox commandline
REM Version: 1.00
REM Updated: 2024-04-12 10:53:33

REM Change to directory containing this file
CD /D %~dp0

REM REG delete HKCU\Environment /F /V BlackBoxRootDir
REM REG delete "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Environment" /F /V BlackBoxRootDir
REM SET BlackBoxRootDir=

REM Set environment variables for script run
SET BlackBoxRootDir=%~dp0
REM SET BlackBoxWorkingDir=%~dp0\Jobs\ba23064a-1062-4037-99e1-4f42d8faa00f

REM Run the BlackBox command line as Admin
BlackBox.exe -pack blackbox -local -show -debug

pause
