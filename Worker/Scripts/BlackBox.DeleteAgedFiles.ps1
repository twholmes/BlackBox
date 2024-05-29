##-------------------------------------------------------------------------
## Copyright (C) 2024 Crayon Australia
## This script runs the aged file cleanup procedure
## Name: Aged file cleanup
## Version: 1.00
## Updated: 03/03/2023 18:00
##-------------------------------------------------------------------------

param(
  [string]$TaskName
  , [string]$WorkingDir
)

## Get this script name and path
$Global:ScriptName = $MyInvocation.MyCommand.Name
$Global:ScriptPath = $MyInvocation.MyCommand.Path

################################################################################################
## GENERIC CODE - DONT EDIT THIS SECTION ##

## set result file name
if ([string]::IsNullOrEmpty($TaskName))
{
  $TaskName = $Global:ScriptName + ".txt"
  $Global:ResultsPath = $MyInvocation.MyCommand.Path + ".txt"
}
else
{
  $Global:ResultsPath = $TaskName + ".txt"
}

## set scripts path if not supplied in params
$ScriptsDir = [Environment]::GetEnvironmentVariable('BlackBoxScriptsDir','User')
if ([string]::IsNullOrEmpty($ScriptsDir) -OR !(Test-Path $ScriptsDir)) 
{
  $ScriptsDir = (Split-Path $script:MyInvocation.MyCommand.Path)
} 
## load BlackBox module
Import-Module -Force (Join-Path $ScriptsDir 'BlackBox.psm1')

## set data path if not supplied in params
$DataDir = [Environment]::GetEnvironmentVariable('BlackBoxDataDir','User')
if ([string]::IsNullOrEmpty($DataDir) -OR !(Test-Path $DataDir)) 
{
  $DataDir = (Split-Path $script:MyInvocation.MyCommand.Path)
}

## set working path if not supplied in params
if (!(Test-Path $WorkingDir)) 
{
  $WorkingDir = (Split-Path $script:MyInvocation.MyCommand.Path)
} 

############################################################
# Debug

#write-host "Press any key to continue..."
#[void][System.Console]::ReadKey($true)

############################################################
# Check folder for files greater than N days

function CheckFileAges([string]$filePath, [int]$days)
{
  cd $filePath

  $files = Get-ChildItem $filePath -Recurse -File
  $limit = [datetime]::Now.AddDays(-$days)
  $count = 0
  
  Write-Result ""  
  foreach($file in $files) 
  {
    if ($file.CreationTime -lt $limit) 
    {
      Write-Result ('{0}' -f $file.FullName)    
      $count++
    }
  }
  Write-Result ""
  Write-Result ('{0} files older than {1} days' -f $count, $days)
}

############################################################
# Mainline

## set results path
$Global:ResultsPath = $WorkingDir + "\" + $TaskName + ".txt"

## log the folder paths
Write-Result ("WorkingDir = {0}" -f $WorkingDir)
Write-Result ("ScriptDir = {0}" -f $ScriptsDir)
Write-Result ""

## log the results folder path
Write-Result ("ResultsPath = {0}" -f $Global:ResultsPath)
Write-Result ""

## remove any old check run results
if (Test-Path $ResultsPath) {
  Remove-Item $ResultsPath
} 
  
## *************************
## X01.AGED FILE CLEANUP
## *************************
Write-ScriptInfo

## read params file
Write-Result "***********************"
Write-Result "X01.AGED FILE CLEANUP"
Write-Result "***********************"
Write-Result ""

## read params file
Read-Params $WorkingDir ("{0}.params.xml" -f $TaskName)

## get the age limit in days
$agelimit = Get-Param "AgeLimit"
Write-Result ("Aged File Limit (days): {0}" -f $agelimit)

## translate to a date limit
$limit = (Get-Date).AddDays($agelimit)
Write-Result ("Aged File Date Limit: {0}" -f $limit)

## get the root file path to clean
$path = (get-item $WorkingDir ).parent.FullName

## list the aged files
CheckFileAges $path $agelimit

## delete files older than the $limit
Get-ChildItem -Path $path -Recurse -Force | Where-Object { !$_.PSIsContainer -and $_.CreationTime -lt $limit } | Remove-Item -Force

## delete any empty directories left behind after deleting the old files
Get-ChildItem -Path $path -Recurse -Force | Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer }) -eq $null } | Remove-Item -Force -Recurse

Write-Result ""
