##-------------------------------------------------------------------------
## Copyright (C) 2024 Crayon Australia
## This poweshell module contains functions and scriptlets used in 
## FNMS Health Check procedures
## Module version: 1.00
## Updated: 12/02/2024 12:55
##-------------------------------------------------------------------------

Add-Type -AssemblyName System.Security
Add-Type -AssemblyName System.Text.Encoding

## Some of the code in this module requires that the following two lines are declared at the scipt level
#$Global:ScriptName = $MyInvocation.MyCommand.Name
#$Global:ScriptPath = $MyInvocation.MyCommand.Path

############################################################
# Write to the script log

function Write-Log([string]$message)
{
  # write the log entry
  $msg = "{0} POWERSHELL: {1}" -f (Get-Date -format "yyyy-MM-dd HH:mm:ss"), $message
  Write-Output $msg | Out-File -Append -Encoding ASCII -FilePath $LogsPath
}

############################################################
# Write to the results file

function Write-Result([string]$message)
{
  # write the results entry
  $msg = "{0}" -f $message
  Write-Output $msg | Out-File -Append -Encoding ASCII -FilePath $ResultsPath
  Write-Output $msg  
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
    
  Write-Result "------------ Starting process ($PID) -----------------"
  Write-Result "Script:             $($ScriptName)"  
  Write-Result "Computer Name:      $($env:COMPUTERNAME)"
  Write-Result "RAM:                $RAMTotal GB ($RAMFree GB available)"
  Write-Result "Operating System:   $os"
  Write-Result ("Logged in user:     {0}" -f $loggedInUser)  
  Write-Result ("----------------- {0} --------------------" -f $datetime)
  Write-Result ""
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
      
  ##Write-Result "------------ Starting process ($PID) -----------------"

  Write-Result ("Logged in user: {0}" -f $loggedInUser)
  Write-Result ("System Information for: {0}" -f $computerSystem.Name)
  Write-Result ("Serial Number: {0}" -f $computerBIOS.SerialNumber)
  Write-Result ""  
  
  Write-Result ("Manufacturer: {0}" -f $computerSystem.Manufacturer)
  Write-Result ("Model: {0}" -f $computerSystem.Model)
  Write-Result ""

  Write-Result ("CPU: {0}" -f $computerCPU.Name)
  Write-Result ("No. of Logical Cores: {0}" -f $totalLogicalCores)  
  Write-Result ""  

  Write-Result ("RAM: {0:N2} GB" -f ($computerSystem.TotalPhysicalMemory/1GB))
  Write-Result ("RAM Free: {0:N2} MB" -f ($computerSystem.FreePhysicalMemory/1MB/1MB))  
  Write-Result ""    
  
  Write-Result ("HDD Capacity: {0:N2} GB" -f ($computerHDD.Size/1GB))
  Write-Result ("HDD Space: {0:P2} Free ({1:N2} GB)" -f ($computerHDD.FreeSpace/$computerHDD.Size), ($computerHDD.FreeSpace/1GB)) 
  Write-Result ""

  Write-Result ("Operating System: {0}, Service Pack: " -f $computerOS.caption, $computerOS.ServicePackMajorVersion)
  Write-Result ""

  Write-Result ("Last Reboot: {0}" -f $computerOS.LastBootUpTime)

  ##Write-Result "------------------------------------------------------"
  Write-Result ""
}


##-------------------------------------------------------------------------
## MURRAY'S CODE
## Code from Murray's Santos modules
## Module version: 1.00
## Updated: 02/02/2024 09:55
##-------------------------------------------------------------------------

###########################################################################
# Coalesce strings

function Select-Coalesce($a, $b) 
{ 
  if ($null -ne $a) { $a } else { $b } 
}


###############################################################################
# Out-Log

function Out-Log([object]$logobj) 
{
  $logfile = $Script:LogFile
  ForEach ($obj in $logobj) 
  {
    (Get-Date -Format G) + ' (' + $PID.ToString().PadLeft(6, ' ') + ') ' + $obj.ToString() | Out-File -FilePath $Script:LogFile -Append
    Write-Host (Get-Date -Format G) $obj.ToString()
  }
}

###########################################################################
# Initialize CUA logging

function Initialize-LogSystem($LogSettings)
{
  $LogAgeThreshold = Select-Coalesce $LogSettings.RetainLogsForDays 14
  $LogFileBasename = $LogSettings.LogFileBaseName -replace "{{DateFormat}}", (Get-Date -Format $LogSettings.DateFormat)
  $LogFileName = "{0}.log" -f $LogFileBasename

  $Script:LogFile = Join-Path $LogSettings.LogFileDirectory $LogFileName

  if (Test-Path -PathType Container $LogSettings.LogFileDirectory) 
  {
    $DeleteFilter = "{0}*.log" -f ($LogSettings.LogFileBaseName -replace "{{DateFormat}}", "")
    cau_DeleteAgedFiles $LogSettings.LogFileDirectory $DeleteFilter $LogAgeThreshold
  } 
  else 
  {
    New-Item -ItemType Directory -Force -Path $LogSettings.LogFileDirectory
  }

  Try 
  { 
      [io.file]::OpenWrite($Script:LogFile).close() 
  } Catch 
  { 
    Write-Warning "Unable to write to log file [$Script:LogFile]" 
    exit
  }
}


############################################################
# Validate that a directory exists. Create if necessary

function Test-DirExists([string]$value)
{
  if (!([System.IO.Path]::IsPathRooted($value))) 
  {
    return $false
  }
  try 
  {
    if (!(Test-Path $value -PathType Container)) 
    {
      New-Item $value -type Directory -ErrorAction Stop | Out-Null
    }
  }
  catch 
  {
    cau_Log "ERROR: Failed to create directory '$value'" -level Error
    cau_Log "" 
    cau_Log $error[0]
    return $false
  }
  return (Resolve-Path $value).ProviderPath
}


############################################################
# Decrypt a Base64 encoded string

function Get-DecryptedString([string]$EncryptedText) 
{
  try 
  {
    $data = [Convert]::FromBase64String($EncryptedText)
    $data = [System.Security.Cryptography.ProtectedData]::Unprotect($data, $null, [System.Security.Cryptography.DataProtectionScope]::CurrentUser)
    [System.Text.Encoding]::UTF8.GetString($data)
  } 
  catch 
  {
    cau_SetFlexAdminResult -ReturnCode 1 -Err "EXCEPTION: [$($_.FullyQualifiedErrorId)] on line number [$($_.InvocationInfo.ScriptLineNumber)]"   
    cau_Log "EXCEPTION: [$($_.FullyQualifiedErrorId)] on line number [$($_.InvocationInfo.ScriptLineNumber)]"
    cau_Log $_.InvocationInfo.Line
    cau_Log  $_.Exception
    exit
  }
}


###########################################################################
# Invoke SqlCmd

function Invoke-CustomSqlCmd
{
  [CmdletBinding()]
  param 
  (
    [Parameter(Mandatory)][String]$ServerInstance,
    [Parameter(Mandatory)][String]$Database,
    [Parameter(Mandatory)][String]$Query 
  )
  
  #Out-Log "Executing Custom SQL Query [$Query]"
  $con = new-object System.Data.SqlClient.SqlConnection
  $con.ConnectionString = "Server=$ServerInstance;Database=$Database;Integrated Security=true"
  try
  {
    $con.Open()
    $cmd = $con.CreateCommand()
    $cmd.CommandText = $Query 
    $dt = new-object System.Data.DataTable
    $rdr = $cmd.ExecuteReader()
    $dt.Load($rdr)
    return $dt.Rows
  }
  finally
  {
    $con.Close()
  }
}

###########################################################################
# Execute SQL query

#	$ServerParams = @{
#		Server = "localhost\F1"
#		DatabaseName = "FlexeraOneIntegration"

#   Enabled = cau_coalesce $Script:Settings.SQL.Enabled $Script:GlobalSettings.SQL.Enabled
#   Server = cau_coalesce $Script:Settings.SQL.Server $Script:GlobalSettings.SQL.Server
#   DatabaseName = cau_coalesce $Script:Settings.SQL.DatabaseName $Script:GlobalSettings.SQL.DatabaseName
#   DatabaseTable = (cau_coalesce $Script:Settings.SQL.DatabaseTable $Script:GlobalSettings.SQL.DatabaseTable) -replace "{{ProcessName}}", $ProcessName            
        
#   Username = cau_coalesce $Script:Settings.SQL.Username $Script:GlobalSettings.SQL.Username
#   Password = cau_coalesce $Script:Settings.SQL.Password $Script:GlobalSettings.SQL.Password
#   PasswordEncrypted = cau_coalesce $Script:Settings.SQL.PasswordEncrypted $Script:GlobalSettings.SQL.PasswordEncrypted

#	}

function Invoke-ExecuteSQL($ServerParams, $Query) 
{
  if ($ServerParams.UserName) 
  {
    #Out-Log "Authenticating using SQL auth username [$($ServerParams.UserName)]"
    if ($ServerParams.PasswordEncrypted) 
    {
      $password = cau_DecryptString $ServerParams.PasswordEncrypted
    } 
    else 
    {
      $password = $ServerParams.Password
    }
    $sspwd = ConvertTo-SecureString $ServerParams.UserName -AsPlainText -Force        
    $sqlcred = New-Object System.Management.Automation.PSCredential -ArgumentList ($ServerParams.UserName, $sspwd) 

    Invoke-CustomSqlCmd -ErrorAction 'Stop' -ServerInstance $ServerParams.Server -Database $ServerParams.DatabaseName -Query $Query -Credential $sqlcred
  }
  else 
  {
    #Out-Log "Authenticating using current windows user [$($Env:UserName)]"
    Invoke-CustomSqlCmd -ErrorAction 'Stop' -ServerInstance $ServerParams.Server -Database $ServerParams.DatabaseName -Query $Query 
  }
}

###########################################################################
# Write data to a SQL table

function Write-SQLTable($ServerParams, $SQLTableName, $InputObject) 
{
  if ($ServerParams.UserName) 
  {
    #Out-Log "Authenticating using SQL auth username [$($ServerParams.UserName)]"
    if ($ServerParams.PasswordEncrypted) 
    {
      $password = cau_DecryptString $ServerParams.PasswordEncrypted
    } 
    else 
    {
      $password = $ServerParams.Password
    }
    $sspwd = ConvertTo-SecureString $ServerParams.UserName -AsPlainText -Force        
    $sqlcred = New-Object System.Management.Automation.PSCredential -ArgumentList ($ServerParams.UserName, $sspwd) 

    Write-SQLTableData -ServerInstance $ServerParams.Server -Database $ServerParams.DatabaseName `
    -SchemaName dbo -TableName $SQLTableName -Force -InputData $InputObject -Credential $sqlcred
  } 
  else 
  {
    #Out-Log "Authenticating using current windows user [$($Env:UserName)]"
    Write-SQLTableData -ServerInstance $ServerParams.Server -Database $ServerParams.DatabaseName `
    -SchemaName dbo -TableName $SQLTableName -Force -InputData $InputObject
  }
}

