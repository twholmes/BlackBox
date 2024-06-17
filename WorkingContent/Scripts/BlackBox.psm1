##-------------------------------------------------------------------------
## Copyright (C) 2024 Crayon Australia
## This poweshell module contains functions and scriptlets used in 
## BlackBox PowerShell Library Procedures
## Module version: 1.00
## Updated: 28/02/2024 09:55
##-------------------------------------------------------------------------

# Note: use Get-Verb to check allowed function name prefixs

Add-Type -AssemblyName System.Security
Add-Type -AssemblyName System.Text.Encoding

## Some of the code in this module requires that the following two lines are declared at the scipt level
$Global:ModuleName = $MyInvocation.MyCommand.Name
$Global:ModulePath = $MyInvocation.MyCommand.Path

###########################################################################
# Get the name of the log file

function Get-LogFile
{
  [System.Diagnostics.Debug]::Listeners | ? { $_.Name -eq "Default" } |
  % { return $_.LogFileName }
}

###########################################################################
# Set the name of the log file to write logging to

function Set-LogFile([string]$logFile)
{
  $BlackBoxAdminName = $MyInvocation.MyCommand.Name
  $previousLog = Get-LogFile

  Write-Log "Further logging from this session will be written to $logFile"

  [System.Diagnostics.Debug]::Listeners | ? { $_.Name -eq "Default" } |
  % { $_.LogFileName = $logFile }

  $msg = "{0} {1}" -f (Get-Date -format "yyyy-MM-dd HH:mm:ss"), "This is $BlackBoxAdminName"
  [System.Diagnostics.Debug]::WriteLine($msg)

  $msg = "{0} {1}" -f (Get-Date -format "yyyy-MM-dd HH:mm:ss"), ("Computer: " + [System.Net.Dns]::GetHostName())
  [System.Diagnostics.Debug]::WriteLine($msg)

  $msg = "{0} {1}" -f (Get-Date -format "yyyy-MM-dd HH:mm:ss"), ("User: " + [System.Security.Principal.WindowsIdentity]::GetCurrent().Name)
  [System.Diagnostics.Debug]::WriteLine($msg)

  if (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) 
  {
    $hasLocalAdminRights = "YES"
  } 
  else 
  {
    $hasLocalAdminRights = "NO"
    Write-Warning "bbadmin script is running without local administrator rights"
  }
  $msg = "{0} {1}" -f (Get-Date -format "yyyy-MM-dd HH:mm:ss"), "Running with local administrator rights? $hasLocalAdminRights"
  [System.Diagnostics.Debug]::WriteLine($msg)

  $msg = "{0} {1}" -f (Get-Date -format "yyyy-MM-dd HH:mm:ss"), ("Settings file: " + $GlobalConfigSettings["__SettingsFile"])
  [System.Diagnostics.Debug]::WriteLine($msg)

  [System.Diagnostics.Debug]::WriteLine("") 
  if ($previousLog) 
  {
    Write-Log "Previous logging from this session can be found in $previousLog"
    Write-Log ""
  }
}

###########################################################################
# Initialise logging

function Initialize-Logging([string]$logDirectory, [string]$logFileNamePrefix)
{
  if (!(Test-Path $logDirectory -PathType Container)) 
  {
    New-Item $logDirectory -type Directory | Out-Null
  }
  $logFileName = "{0}_{1}.log" -f $logFileNamePrefix, (Get-Date -format "yyyyMMdd_HHmmss")
  SetLogFile (Join-Path $logDirectory $logFileName)
}

###########################################################################
# Write to the script log

function Write-Log([Parameter(ValueFromPipeline=$true)][string]$msg, [switch]$noHost, [ValidateSet("Error", "Warning", "Info", "Debug")][string]$level="Info")
{
  if (($level -eq "Error" -and $GlobalLogLevel -lt 0) -or ($level -eq "Warning" -and $GlobalLogLevel -lt 1) -or ($level -eq "Info" -and $GlobalLogLevel -lt 2) -or ($level -eq "Debug" -and $GlobalLogLevel -lt 3)) 
  {
    return
  }
  if (!$noHost) 
  {
    if ($level -eq "Error") 
    {
      Write-Host -ForegroundColor Red $msg
    } 
    elseif ($level -eq "Warning") 
    {
      Write-Host -ForegroundColor Yellow $msg
    } 
    elseif ($level -eq "Info") 
    {
      Write-Host -ForegroundColor Green $msg
    } 
    else 
    {
      Write-Host $msg
    }
  }
  $msg = "{0} [{2,-7}] {1}" -f (Get-Date -format "yyyy-MM-dd HH:mm:ss"), $msg, $level
  [System.Diagnostics.Debug]::WriteLine($msg)
}

###########################################################################
# Write to the results file

function Write-Result([Parameter(ValueFromPipeline=$true)][string]$msg, [switch]$noHost, [ValidateSet("Error", "Warning", "Info", "Debug")][string]$level="Info")
{
  if (($level -eq "Error" -and $GlobalLogLevel -lt 0) -or ($level -eq "Warning" -and $GlobalLogLevel -lt 1) -or ($level -eq "Info" -and $GlobalLogLevel -lt 2) -or ($level -eq "Debug" -and $GlobalLogLevel -lt 3)) 
  {
    return
  }
  if (!$noHost) 
  {
    if ($level -eq "Error") 
    {
      Write-Host -ForegroundColor Red $msg
    } elseif ($level -eq "Warning") 
    {
      Write-Host -ForegroundColor Yellow $msg
    } elseif ($level -eq "Info") 
    {
      Write-Host -ForegroundColor Green $msg
    } else 
    {
      Write-Host $msg
    }
  }
  $msg = "{0}" -f $msg
  [System.Diagnostics.Debug]::WriteLine($msg)
}

###########################################################################
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


###########################################################################
# Create a crypto service provider that can be used by any user to encrypt
# and decrypt values on the local machine.

function Get-CryptoServiceProvider()
{
  $cspParams = New-Object System.Security.Cryptography.CspParameters
  $cspParams.KeyContainerName = "flexadmin"
  $cspParams.Flags = $cspParams.Flags -bor [System.Security.Cryptography.CspProviderFlags]::UseMachineKeyStore

  # Grant access for any user to the key container
  $rule = New-Object System.Security.AccessControl.CryptoKeyAccessRule("Everyone", [System.Security.AccessControl.CryptoKeyRights]::FullControl, [System.Security.AccessControl.AccessControlType]::Allow)

  $cspParams.CryptoKeySecurity = New-Object System.Security.AccessControl.CryptoKeySecurity
  $cspParams.CryptoKeySecurity.SetAccessRule($rule)

  $csp = New-Object System.Security.Cryptography.RSACryptoServiceProvider -ArgumentList 5120, $cspParams
  $csp.PersistKeyInCsp = $true

  return $csp
}

###########################################################################
# Encrypt a string in such a way that it can only be decrypted on the same machine
# that it was encrypted on. The value returned is a string in base 64 format.

function Get-EncryptedStringForLocalMachine([string]$unencryptedString)
{
  $csp = Get-CryptoServiceProvider
  $encryptedBytes = $csp.Encrypt([System.Text.Encoding]::UTF8.GetBytes($unencryptedString), $true)
  $encryptedString = [System.Convert]::ToBase64String($encryptedBytes)
  $encodedString = "enc:" + $encryptedString
  
  return $encodedString
}

###########################################################################
# Decrypt a string that was previously returned by a call to EncryptForLocalMachine
# on the same computer.

function Get-DecryptedStringForLocalMachine([string]$encodedString)
{
  $encryptedString = $encodedString.Substring(4)
  
  $csp = CreateCryptoServiceProvider
  $decryptedString = [System.Text.Encoding]::UTF8.GetString($csp.Decrypt([System.Convert]::FromBase64String($encryptedString), $true))  
  
  return $decryptedString
}


###########################################################################
# Read external parameters file

function Read-Params([string]$workingdir, [string]$paramsfile)
{
  $ParamsFileName = (Join-Path $workingdir $paramsfile)
  if (-Not (Test-Path $ParamsFileName)) 
  {
    Write-Result "ERROR: External parameters file not found [$ParamsFileName]"
    exit
  } 
  else 
  {
    #Write-Result ("Parameter file name: {0}" -f $ParamsFileName)  
    [xml]$xml = Get-Content $ParamsFileName
    #Write-Result ("Schema: {0}" -f $xml.BlackBox.Schema)
    
    $Global:Params = $xml.BlackBox.Params.Param
  }
}

###########################################################################
# Get a named param fro the previously read params file

function Get-Param([string]$name)
{
  $param = ""
  #Write-Result ""
  #Write-Result "Searching for: $name"
  foreach ($pv in $Global:Params) 
  {
    #Write-Result ("{0}={1}" -f $pv.name, $pv.value)
    if ($pv.name -eq $name)
    {
      #Write-Result ("FOUND {0}={1}" -f $pv.name, $pv.value)
      #Write-Result ""      
      $param = $pv.value
    }
  }  
  #Write-Result ""  
  #Write-Result ("RETURN {0}" -f $param)  
  return $param
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

# $ServerParams = @{
#   Server = "localhost\F1"
#   DatabaseName = "FlexeraOneIntegration"

#   Enabled = cau_coalesce $Script:Settings.SQL.Enabled $Script:GlobalSettings.SQL.Enabled
#   Server = cau_coalesce $Script:Settings.SQL.Server $Script:GlobalSettings.SQL.Server
#   DatabaseName = cau_coalesce $Script:Settings.SQL.DatabaseName $Script:GlobalSettings.SQL.DatabaseName
#   DatabaseTable = (cau_coalesce $Script:Settings.SQL.DatabaseTable $Script:GlobalSettings.SQL.DatabaseTable) -replace "{{ProcessName}}", $ProcessName            
        
#   Username = cau_coalesce $Script:Settings.SQL.Username $Script:GlobalSettings.SQL.Username
#   Password = cau_coalesce $Script:Settings.SQL.Password $Script:GlobalSettings.SQL.Password
#   PasswordEncrypted = cau_coalesce $Script:Settings.SQL.PasswordEncrypted $Script:GlobalSettings.SQL.PasswordEncrypted

# }

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

