@ECHO OFF
REM This script runs the BlackBox command line
REM Generated at 3/07/2019 07:45

REM Change to directory containing this file
CD /D %~dp0

BlackBox.exe -name Test -type job -runrepeat -debug -guid

pause
