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

REM Clean out old packages and files
del /q /f /s %~dp0\Logs\*.*

del /q /f /s %~dp0\Jobs\*.*
rd /q /s .\Jobs
md Jobs

CD /D ..\
del /q /f /s %~dp0\Packages\*.*


pause
