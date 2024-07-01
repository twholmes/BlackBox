##-------------------------------------------------------------------------
## Copyright (C) 2024 Crayon Australia
## This poweshell module contains functions and scriptlets used in 
## BlackBox PowerShell Library Procedures
## Module version: 1.00
## Updated: 01/07/2024 13:15
##-------------------------------------------------------------------------

# Note: use Get-Verb to check allowed function name prefixs

Add-Type -AssemblyName System.Security
Add-Type -AssemblyName System.Text.Encoding

## Some of the code in this module requires that the following two lines are declared at the scipt level
$Global:ModuleName = $MyInvocation.MyCommand.Name
$Global:ModulePath = $MyInvocation.MyCommand.Path

## *************************
## REGISTRY FUNCTIONS
## *************************

###########################################################################
# Get-RegKeyValue

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

###########################################################################
# Set-RegKeyValue

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

###########################################################################
# Remove-RegKey

function Remove-RegKey([string]$regPath, [string]$regName)
{
  try 
  {
    # delete this registry key in path
    if (Get-ItemProperty -Path $regPath -Name $regName) 
    {
      Remove-ItemProperty -Path $regPath -Name $regName -ErrorAction Stop
      Write-Host "Registry key $regPath $regName deleted"    
    }
    else 
    {
      Write-Host "Registry key $regPath $regName does not exist"
    }
  }
  catch 
  {
    Write-Warning "$_"
  }
  return $true  
}

## *************************
## LOGGING FUNCTIONS
## *************************

############################################################
# Initialise logging

function Initialize-Logging([string]$ScriptName)
{
  ## set log file name
  $Global:LogFileName = $ScriptName + ".log"
  if ([string]::IsNullOrEmpty($ScriptName)) 
  {
    $ScriptName = $target + ".ps1"
    $Global:LogFileName = $target + ".log"  
  }

  # get log file path
  $BlackBoxPathReg = "HKLM:\SOFTWARE\WOW6432Node\Crayon Australia\BlackBox"
  $Global:LogFilesDir = Get-RegKeyValue $BlackBoxPathReg "LogDir"
  $Global:LogFilePath = Join-Path $Global:LogFilesDir $Global:LogFileName
  if ([string]::IsNullOrEmpty($Global:LogFilesDir) -OR !(Test-Path $Global:LogFilesDir)) 
  {
    $Global:LogFilePath = "C:\\BlackBox\\LogFiles\\" + $Global:LogFileName
  }
}

############################################################
# Write to the script log

function Write-Log([string]$message)
{
  # write the log entry
  $msg = "{0} POWERSHELL: {1}" -f (Get-Date -format "yyyy-MM-dd HH:mm:ss"), $message
  Write-Output $msg | Out-File -Append -Encoding ASCII -FilePath $Global:LogFilePath
}

function Write-Text([string]$message)
{
  # write the log entry and standard-out
  Write-Host $message
  Write-Output $message | Out-File -Append -Encoding ASCII -FilePath $Global:LogFilePath
}
            

## *************************
## STATUS FUNCTIONS
## *************************
            
###########################################################################
# Initialize CUA logging

function Write-ScriptInfo() 
{
  $wmi_OperatingSystem = Get-CimInstance -Class win32_operatingsystem

  $RAMTotal = [Math]::Round($wmi_OperatingSystem.TotalVisibleMemorySize/1MB)
  $RAMFree = [Math]::Round($wmi_OperatingSystem.FreePhysicalMemory/1MB)
  $os = [string]$wmi_OperatingSystem.Caption

  $loggedInUser = "{0}\{1}" -f $($env:UserDomain), $($env:UserName)

  $Global:StartDateTime = Get-Date
  $datetime = Get-Date -format "dd.MM.yyyy hh:mm"  
    
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
# Collect and report ComputerInfo

function Write-ComputerInfo()
{ 
  # Shows details of currently running PC
  $computerSystem = Get-CimInstance CIM_ComputerSystem
  $computerBIOS = Get-CimInstance CIM_BIOSElement
  $computerOS = Get-CimInstance CIM_OperatingSystem
  $computerCPU = Get-CimInstance CIM_Processor
  $computerHDD = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID = 'C:'"

  $totalLogicalCores = (
    (Get-CimInstance –ClassName Win32_Processor).NumberOfLogicalProcessors |
    Measure-Object -Sum
  ).Sum

  $loggedInUser = "{0}\{1}" -f $($env:UserDomain), $($env:UserName)
      
  ##Write-Text "------------ Starting process ($PID) -----------------"

  Write-Text ("Logged in user: {0}" -f $loggedInUser)
  Write-Text ("System Information for: {0}" -f $computerSystem.Name)
  Write-Text ("Serial Number: {0}" -f $computerBIOS.SerialNumber)
  Write-Text ""  
  
  Write-Text ("Manufacturer: {0}" -f $computerSystem.Manufacturer)
  Write-Text ("Model: {0}" -f $computerSystem.Model)
  Write-Text ""

  Write-Text ("CPU: {0}" -f $computerCPU.Name)
  Write-Text ("No. of Logical Cores: {0}" -f $totalLogicalCores)  
  Write-Text ""  

  Write-Text ("RAM: {0:N2} GB" -f ($computerSystem.TotalPhysicalMemory/1GB))
  Write-Text ("RAM Free: {0:N2} MB" -f ($computerSystem.FreePhysicalMemory/1MB/1MB))  
  Write-Text ""    
  
  Write-Text ("HDD Capacity: {0:N2} GB" -f ($computerHDD.Size/1GB))
  Write-Text ("HDD Space: {0:P2} Free ({1:N2} GB)" -f ($computerHDD.FreeSpace/$computerHDD.Size), ($computerHDD.FreeSpace/1GB)) 
  Write-Text ""

  Write-Text ("Operating System: {0}, Service Pack: " -f $computerOS.caption, $computerOS.ServicePackMajorVersion)
  Write-Text ""

  Write-Text ("Last Reboot: {0}" -f $computerOS.LastBootUpTime)

  ##Write-Text "------------------------------------------------------"
  Write-Text ""
}


## *************************
## AUTOMATION FUNCTIONS
## *************************

###########################################################################
# Split and parse settings

function Split-Settings([string]$settings) 
{
  $sx = $settings.Split(",")
  foreach ($s in $sx) 
  {
    if ($s -match "([^=]*)=(.*)") 
    {
      switch ($matches[1])
      {
        "DataSource" {
          $Global:DataSource = $($matches[2])
          Write-Text "Command line setting: DataSource = $($matches[2])"
        }

        "FileID" {
          $Global:FileID = $($matches[2])
          Write-Text "Command line setting: FileID = $($matches[2])"
        }

        "JobGUID" {
          $Global:JobGUID = $($matches[2])
          Write-Text "Command line setting: JobGUID = $($matches[2])"
        }

        default {
          Write-Text "Unknown command line setting: $($matches[1]) = $($matches[2])"
        }
      }
    }
  }
}

###########################################################################
# Copy log to working folder

function Copy-LogToWorking() 
{
  # get working folder path
  $BlackBoxPathReg = "HKLM:\SOFTWARE\WOW6432Node\Crayon Australia\BlackBox"
  $WebSiteContentDir = Get-RegKeyValue $BlackBoxPathReg "WebSiteContentPath"
  $JobsDir = Join-Path $WebSiteContentDir "Jobs"
  $Global:WorkingDir = Join-Path $JobsDir $Global:JobGUID
  if ([string]::IsNullOrEmpty($Global:WorkingDir) -OR !(Test-Path $Global:WorkingDir)) 
  {
    $Global:WorkingDir = $Global:LogFilesDir
  }
  # copy log file to working
  Copy-Item -Path $Global:LogFilePath -Recurse -Destination (Join-Path $Global:WorkingDir $Global:LogFileName) -Verbose -Force
}
