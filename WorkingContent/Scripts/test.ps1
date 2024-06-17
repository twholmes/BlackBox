##-------------------------------------------------------------------------
## Copyright (C) 2024 Crayon Australia
## This script runs an FNMS Health Check procedure
## Check Name: FNMS Installed Versions
## Check Number: 1.00
## Updated: 16/06/2024 20:20
##-------------------------------------------------------------------------

param
(
  [string]$target
  , [string[]]$settings
)

## Get this script name and path
$ScriptName = $MyInvocation.MyCommand.Name
$ScriptPath = $MyInvocation.MyCommand.Path

############################################################
# RegKey functions

function Get-RegKeyValue([string]$regPath, [string]$regName)
{
  $value = ""
  try 
  {
    $value = Get-ItemPropertyValue -Path $regPath -Name $regName
    #Write-Host "Registry key found"
    #Write-Host "  key=$regPath"
    #Write-Host "  entry=$regName"
    #Write-Host "  value=$value"
  }
  catch 
  {
    Write-Warning "$_"
  }
  return $value
}

function Set-RegKeyValue([string]$regPath, [string]$regName, [string]$regValue)
{
  try 
  {
    Set-ItemProperty -Path $regPath -Name $regName -Value $regValue -Force | Out-Null
  }
  catch 
  {
    Write-Warning "$_"
  }
}

############################################################
# Write to the script log

function Write-Log([string]$message)
{
 
  # write the log entry
  $msg = "{0} POWERSHELL: {1}" -f (Get-Date -format "yyyy-MM-dd HH:mm:ss"), $message
  Write-Output $msg | Out-File -Append -Encoding ASCII -FilePath $LogFilePath
}

function Write-Text([string]$message)
{
  # write the log entry and standard-out
  Write-Host $message
  Write-Output $message | Out-File -Append -Encoding ASCII -FilePath $LogFilePath
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
## SETUP LOGGING
## *************************

## set log file name
$LogFileName = $ScriptName + ".log"

# get log file path
$BlackBoxPathReg = "HKLM:\SOFTWARE\WOW6432Node\Crayon Australia\BlackBox"
$LogFilesDir = Get-RegKeyValue $BlackBoxPathReg "LogDir"
$LogFilePath = Join-Path $LogFilesDir $LogFileName
if ([string]::IsNullOrEmpty($LogFilesDir) -OR !(Test-Path $LogFilesDir)) 
{
  $LogPath = "C:\\BlackBox\\LogFiles\\" + $LogFileName
}
 
## *************************
## SCRIPT INFO
## *************************

Write-ScriptInfo

$sx = $settings.Split(",")
foreach ($s in $sx) 
{
  if ($s -match "([^=]*)=(.*)") 
  {
    Write-Text "Command line setting: $($matches[1]) = $($matches[2])"
  }
}

