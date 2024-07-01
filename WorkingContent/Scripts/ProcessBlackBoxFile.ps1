##-------------------------------------------------------------------------
## Copyright (C) 2024 Crayon Australia
## This script is run from PowerShell automation
## Process BlackBox source file
## Check Number: 1.00
## Updated: 17/06/2024 19:50
##-------------------------------------------------------------------------

param
(
  [string]$target
  , [string[]]$settings
)

## Get this script name and path
$ScriptName = $MyInvocation.MyCommand.Name
$ScriptPath = $MyInvocation.MyCommand.Path

Write-Host $ScriptPath

############################################################
## DONT EDIT THIS SECTION ##

## load BlackBox module
$ScriptDir = split-path -parent $MyInvocation.MyCommand.Definition
Import-Module -Force (Join-Path $ScriptDir 'BlackBoxAutomation.psm1')

############################################################
# Mainline
 
## initialise logging
Initialize-Logging $ScriptName
 
## write script info block to log
Write-ScriptInfo

## split and parse settings param 
Split-Settings $settings

#Write-Text ""
#Write-Text "DataSource = $Global:DataSource"
#Write-Text "FileID = $Global:FileID"
#Write-Text "JobGUID = $Global:JobGUID"
#Write-Text ""

$now = Get-Date
$RunTime = [DateTime]$now - [DateTime]$Global:StartDateTime
Write-Text
Write-Text "Runtime = $RunTime"
Write-Text

## copy log file to working
Copy-LogToWorking

#Return $FileID

[hashtable]$Results = @{} 
$Results.FileID = [int]$Global:FileID
$Results.DataSource = [string]$Global:DataSource 
$Results.JobGUID = [string]$Global:JobGUID 

$Results.ReturnCode = [int]0 
$Results.ReturnString = [string]"All Done!" 

Return $Results

 