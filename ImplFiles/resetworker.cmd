@ECHO OFF
REM Source script to run bbadmin.ps1
REM Working Folder is C:\BlackBox\ImplFiles
REM Created at 29/05/2024 17:00

REM Change to directory containing this file
CD /D %~dp0

REM Run the PowerShell command line as Admin
REM PowerShell -NoProfile -ExecutionPolicy Bypass "& .\bbadmin.ps1 InstallAll -FlexAdminPath C:\BlackBox\ImplFiles"

PowerShell -NoProfile -ExecutionPolicy Bypass "& .\bbadmin.ps1 ResetBlackBoxWorker"

pause

