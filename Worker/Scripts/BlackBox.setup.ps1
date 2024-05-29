##-------------------------------------------------------------------------
## Copyright (C) 2024 Crayon Australia
## This script runs the default BlackBox package setup procedure
## Name: BlackBox package setup
## Version: 1.00
## Updated: 08/04/2024 09:00
##-------------------------------------------------------------------------

param(
  [switch]$ShowLog
  ,[switch]$Debug  
)

## Get this script name and path
$Global:ScriptName = $MyInvocation.MyCommand.Name
$Global:ScriptPath = $MyInvocation.MyCommand.Path

################################################################################################
## GENERIC CODE - DONT EDIT THIS SECTION ##

## set root path
$RootDir = [Environment]::GetEnvironmentVariable('BlackBoxRootDir')
if ([string]::IsNullOrEmpty($RootDir) -OR !(Test-Path $RootDir)) 
{
  $RootDir = (Split-Path $script:MyInvocation.MyCommand.Path)
}

## set scripts path
$ScriptsDir = [Environment]::GetEnvironmentVariable('BlackBoxScriptsDir')
if ([string]::IsNullOrEmpty($ScriptsDir) -OR !(Test-Path $ScriptsDir)) 
{
  $ScriptsDir = $RootDir + "\Scripts"
}

## set temp path
$TempDir = [Environment]::GetEnvironmentVariable('BlackBoxTempDir')
if ([string]::IsNullOrEmpty($TempDir) -OR !(Test-Path $TempDir)) 
{
  $TempDir = $RootDir + "\temp"
}

## set tasks path
$TasksDir = [Environment]::GetEnvironmentVariable('BlackBoxTasksDir')
if ([string]::IsNullOrEmpty($TasksDir) -OR !(Test-Path $TasksDir)) 
{
  $TasksDir = $RootDir + "\Tasks"
}

## set data path
$DataDir = [Environment]::GetEnvironmentVariable('BlackBoxDataDir')
if ([string]::IsNullOrEmpty($DataDir) -OR !(Test-Path $DataDir)) 
{
  $DataDir = $RootDir + "\Data"
}

## set setup path
$SetupDir = [Environment]::GetEnvironmentVariable('BlackBoxSetupDir')
if ([string]::IsNullOrEmpty($SetupDir) -OR !(Test-Path $SetupDir)) 
{
  $SetupDir = $RootDir + "\Setup"
}

## set packages path
$PackagesDir = [Environment]::GetEnvironmentVariable('BlackBoxPackagesDir')
if ([string]::IsNullOrEmpty($PackagesDir) -OR !(Test-Path $PackagesDir)) 
{
  $PackagesDir = $RootDir + "\Packages"
}

## set woking directory path
$WorkingDir = [Environment]::GetEnvironmentVariable('BlackBoxWorkingDir')
if ([string]::IsNullOrEmpty($WorkingDir) -OR !(Test-Path $WorkingDir)) 
{
  $WorkingDir = $RootDir + "\Jobs\00000000-0000-0000-0000-000000000000"
}

## set log file name
$LogFileName = $Global:ScriptName + ".log"
$LogPath = $WorkingDir + "\" + $LogFileName

############################################################
# Debug

#write-host "Press any key to continue..."
#[void][System.Console]::ReadKey($true)

############################################################
# Write to the script log

function Write-Log([string]$message)
{
  # write the log entry
  $msg = "{0} POWERSHELL: {1}" -f (Get-Date -format "yyyy-MM-dd HH:mm:ss"), $message
  Write-Output $msg | Out-File -Append -Encoding ASCII -FilePath $LogPath
}

function Write-Text([string]$message)
{
  # write the log entry and standard-out
  Write-Host $message
  Write-Output $message | Out-File -Append -Encoding ASCII -FilePath $LogPath
}

###########################################################################
# Initialize CUA logging

function Write-ScriptInfo() 
{
  $wmi_OperatingSystem = Get-CimInstance -Class win32_operatingsystem

  $RAMTotal = [Math]::Round($wmi_OperatingSystem.TotalVisibleMemorySize/1MB)
  $RAMFree = [Math]::Round($wmi_OperatingSystem.FreePhysicalMemory/1MB)
  $os = [string]$wmi_OperatingSystem.Caption

  $loggedInUser = "{0}\{1}" -f $($env:UserDomain), $($env:UserName)

  $datetime = Get-Date -format "dd.MM.yyyy hh:mm"

  Write-Text ""    
  Write-Text "------------ Starting process ($PID) -----------------"
  Write-Text "Script:             $($ScriptName)"  
  Write-Text "Computer Name:      $($env:COMPUTERNAME)"
  Write-Text "RAM:                $RAMTotal GB ($RAMFree GB available)"
  Write-Text "Operating System:   $os"
  Write-Text ("Logged in user:     {0}" -f $loggedInUser)  
  Write-Text ("----------------- {0} --------------------" -f $datetime)
  Write-Text ""
}


############################################################
# Mainline
 
## *************************
## SCRIPT INFO
## *************************
Write-ScriptInfo

## Show directories
if ($Debug) 
{
  Write-Text ("RootDir:     {0}" -f $RootDir)
  Write-Text ("ScriptsDir:  {0}" -f $ScriptsDir)
  Write-Text ("TempDir:     {0}" -f $TempDir)
  Write-Text ("TasksDir:    {0}" -f $TasksDir)  
  Write-Text ("DataDir:     {0}" -f $DataDir)
  Write-Text ("SetupDir:    {0}" -f $SetupDir)  
  Write-Text ("PackagesDir: {0}" -f $PackagesDir)    
  Write-Text ("WorkingDir:  {0}" -f $WorkingDir)
  Write-Text ""  
}

## set the package name
$ZipFile = [Environment]::GetEnvironmentVariable('BlackBoxPackageName')
if ([string]::IsNullOrEmpty($ZipFile)) 
{
  Write-Text "Archive filename not set in environment"
  write-host "Press any key to continue..."
  [void][System.Console]::ReadKey($true)
  Exit
}

## find the package
$ZipFileList = Get-ChildItem -Path $RootDir -Filter $ZipFile -File -Recurse -ErrorAction SilentlyContinue -Force
$ZipFileItem = $ZipFileList[0]
if ([string]::IsNullOrEmpty($ZipFileItem)) 
{
  Write-Text ("Archive filename not in root folder {0}" -f $RootDir)
  write-host "Press any key to continue..."
  [void][System.Console]::ReadKey($true)
  Exit
}
$ZipFileFullName = $ZipFileItem.FullName

## create a new temp folder for file processing
$tempFolderPath = Join-Path $Env:Temp $(New-Guid)
##$tempFolderPath = Join-Path $Env:Temp ([System.IO.Path]::GetRandomFileName())
New-Item -Type Directory -Path $tempFolderPath | Out-Null

## unzip the archive
Write-Text "***********************"
Write-Text "UNZIP ARCHIVE"
Write-Text "***********************"
Write-Text ""
Write-Text ("Unzip archive file: {0} to temp" -f $ZipFile)
Write-Text ("  from: {0}" -f $ZipFileFullName)
Write-Text ("  to: {0}" -f $tempFolderPath)
Write-Text ""
Expand-Archive -LiteralPath $ZipFileFullName -DestinationPath $tempFolderPath -Force

##Add-Type -AssemblyName System.IO.Compression.FileSystem
##[System.IO.Compression.ZipFile]::ExtractToDirectory($ZipFileFullName, $tempFolderPath, $true)

Write-Text ""

## copy files from temp to root subfolders
Write-Text "***********************"
Write-Text "COPY FILES TO ROOT"
Write-Text "***********************"
Write-Text ""

$sourceRoot = Join-Path -Path $tempFolderPath -ChildPath "root"

$source = Join-Path -Path $sourceRoot -ChildPath "Scripts\*"
Write-Text ("Copy {0} files from [tempdir]\Scripts to [rootdir]\Scripts" -f (Get-ChildItem $source).Count)
Copy-Item -Path $source -Destination $ScriptsDir -Recurse -Force

$source = Join-Path -Path $sourceRoot -ChildPath "Tasks\*"
Write-Text ("Copy {0} files from [tempdir]\Tasks to [rootdir]\Tasks" -f (Get-ChildItem $source).Count)
Copy-Item -Path $source -Destination $TasksDir -Recurse -Force

$source = Join-Path -Path $sourceRoot -ChildPath "Packages\*"
Write-Text ("Copy {0} files from [tempdir]\Packages to [rootdir]\Packages" -f (Get-ChildItem $source).Count)
Copy-Item -Path $source -Destination $PackagesDir -Recurse -Force

$source = Join-Path -Path $sourceRoot -ChildPath "Data\*"
$dest = Join-Path -Path $RootDir -ChildPath "Data"
Write-Text ("Copy {0} files from [tempdir]\Data to [rootdir]\Data" -f (Get-ChildItem $source).Count)
Copy-Item -Path $source -Destination $dest -Recurse -Force

$source = Join-Path -Path $sourceRoot -ChildPath "Setup\*"
$dest = Join-Path -Path $RootDir -ChildPath "Setup"
Write-Text ("Copy {0} files from [tempdir]\Setup to [rootdir]\Setup" -f (Get-ChildItem $source).Count)
Copy-Item -Path $source -Destination $dest -Recurse -Force

Write-Text ""

## remove all remaining extract files
Write-Text ("Cleanup temp folder files {0}" -f $tempFolderPath)
Get-ChildItem -Path $tempFolderPath -Include *.* -File -Recurse | foreach { $_.Delete()}

## delete any empty directories left behind after deleting the old files
Get-ChildItem -Path $tempFolderPath -Recurse -Force | Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer }) -eq $null } | Remove-Item -Force -Recurse

Write-Text ""

if ($ShowLog)
{
  write-host "Press any key to continue..."
  [void][System.Console]::ReadKey($true)
}
