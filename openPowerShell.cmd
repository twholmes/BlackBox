@ECHO OFF
REM Source script to run bbdmin.ps1
REM Working Folder is C:\BlackBox\ImplFiles
REM Created at 23/12/20220 16:30

REM Change to directory containing this file
CD /D %~dp0

REM Run the PowerShell command line as Admin
REM PowerShell -NoProfile -ExecutionPolicy Bypass "& .\bbadmin.ps1 InstallAll -FlexAdminPath C:\Crayon\ImplFiles"

powershell start-process powershell -verb runas 
