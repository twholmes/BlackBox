@ECHO OFF
REM Source script to run bbadmin.ps1
REM Working Folder is C:\BlackBox\ImplFiles
REM Created at 27/05/2024 11:30

REM Change to directory containing this file
CD /D %~dp0

REM Run the PowerShell command line as Admin
REM PowerShell -NoProfile -ExecutionPolicy Bypass "& .\bbadmin.ps1 InstallAll -FlexAdminPath C:\BlackBox\ImplFiles"

PowerShell -NoProfile -ExecutionPolicy Bypass "& .\bbadmin.ps1 BuildWebConfig"

pause

