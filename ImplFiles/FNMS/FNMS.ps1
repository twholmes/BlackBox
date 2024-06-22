###########################################################################
# Copyright (C) 2024 Crayon
# This PowerShell script can be used with bbadmin.ps1 to perform a number
# of system readiness checks prior ti installing FlexNet Manager components
###########################################################################

$ScriptPath = Split-Path (Get-Variable MyInvocation -Scope 0).Value.MyCommand.Path

###########################################################################
# Check IIS features for Beacon

function CheckIISFeaturesForBeacon
{
  Log "Checking IIS features for FlexNet Beacon"
  Import-Module ServerManager

  $features = (
    "Web-Server", "Web-WebServer",

    # Common HTTP Features
    "Web-Common-Http", "Web-Static-Content", "Web-Default-Doc",
    "Web-Dir-Browsing", "Web-Http-Errors",

    # Application Development
    "Web-App-Dev", "Web-CGI", "Web-ISAPI-Ext", "Web-ISAPI-Filter",

    # Health and Diagnostics
    "Web-Health", "Web-Http-Logging",

    # Security
    "Web-Security", "Web-Basic-Auth", "Web-Windows-Auth",

    # Performance
    "Web-Performance", "Web-Stat-Compression", "Web-Dyn-Compression",

    # Management Tools
    "Web-Mgmt-Tools", "Web-Mgmt-Console"
  )

  if (Get-WindowsFeature Web-Asp-Net45) 
  { 
    $features += (
      "Web-Asp-Net45", "Web-Net-Ext45"
    )
  } 
  elseif (Get-WindowsFeature Web-Asp-Net) 
  {
    $features += (
      "Web-Asp-Net", "Web-Net-Ext"
    )
  }
  Write-Host
  
  # Get the installed features list
  $winfeatures = Get-WindowsFeature $features
  $winfeatures |
  % {
    $f = "[{0}] {1,-72} {2,-50} {3}"  
    if ($_.Depth -eq 1) { $f = "[{0}] {1,-72} {2,-50} {3}" }
    if ($_.Depth -eq 2) { $f = "    [{0}] {1,-68} {2,-50} {3}" }
    if ($_.Depth -eq 3) { $f = "        [{0}] {1,-64} {2,-50} {3}" }
    if ($_.Depth -eq 4) { $f = "            [{0}] {1,-60} {2,-50} {3}" }    
    $x = " "
    if ($_.InstallState -eq "Installed") { $x = "x" }
    Log $([string]::Format($f, $x, $_.DisplayName, $_.Name, $_.InstallState)) -Level "info"
  }   
  Write-Host

  Log "Done checking IIS feature configuration"
  return $true
}


###########################################################################
# Configure IIS features for Beacon

function ConfigureIISFeaturesForBeacon
{
  Log "Configuring IIS features for FlexNet Beacon"

  Import-Module ServerManager

  $restartNeeded = $false

  $features = (
    "Web-Server", "Web-WebServer",

    # Common HTTP Features
    "Web-Common-Http", "Web-Static-Content", "Web-Default-Doc",
    "Web-Dir-Browsing", "Web-Http-Errors",

    # Application Development
    "Web-App-Dev", "Web-CGI", "Web-ISAPI-Ext", "Web-ISAPI-Filter",

    # Health and Diagnostics
    "Web-Health", "Web-Http-Logging",

    # Security
    "Web-Security", "Web-Basic-Auth", "Web-Windows-Auth",

    # Performance
    "Web-Performance", "Web-Stat-Compression", "Web-Dyn-Compression",

    # Management Tools
    "Web-Mgmt-Tools", "Web-Mgmt-Console"
  )

  if (Get-WindowsFeature Web-Asp-Net45) { 
    $features += (
      "Web-Asp-Net45", "Web-Net-Ext45"
    )
  } elseif (Get-WindowsFeature Web-Asp-Net) {
    $features += (
      "Web-Asp-Net", "Web-Net-Ext"
    )
  }

  Log ""
  Log "Adding Windows features:"
  $features | %{ Log "`t$_" }

  $result = Add-WindowsFeature $features
  if (!$result.Success) {
    Log "ERROR: Failed to configure IIS features" -level Error
    return $false
  }

  $restartNeeded = $restartNeeded -or $result.RestartNeeded

  $result = Remove-WindowsFeature Web-DAV-Publishing
  $restartNeeded = $restartNeeded -or $result.RestartNeeded

  if ($restartNeeded) 
  {
    Log "WARNING: System restart may be needed to complete configuration of IIS features" -level Warning
  }

  Log "Done IIS feature configuration"
  return $true
}


###########################################################################
# TestNetConnections

function TestNetConnection([string]$ComputerName, [int32]$Port)
{
  Log "Running Test-NetConnection for Target $ComputerName on Port $Port"
  $result = Test-NetConnection -ComputerName $ComputerName -Port $Port -InformationLevel $InformationLevel
  $delay = $result.'PingReplyDetails'.Roundtriptime | % { ("$_" + " ms") }
  $IPAddress = ($result.SourceAddress).IPAddress  

  Log -Level "info"
  Log "ComputerName:      $($result.ComputerName)" -Level "info"
  Log "RemoteAddress:     $($result.RemoteAddress)" -Level "info"
  Log "RemotePort:        $($result.RemotePort)" -Level "info"
  Log "InterfaceAlias:    $($result.InterfaceAlias)" -Level "info" 
  Log "SourceAddress:     $IPAddress" -Level "info"     
  Log "PingSucceeded:     $($result.PingSucceeded)" -Level "info"
  Log "PingReplyDetails:  $delay" -Level "info"  
  Log "TcpTestSucceeded:  $($result.TcpTestSucceeded)" -Level "info"
  Log -Level "info"
}


###########################################################################
# CheckFNMSNetworkConnections

function CheckFNMSNetworkConnections
{
  Log "Checking FNMS network connectivity"
  $target = GetConfigValue "FNMSBatchServerFQDN"  
  try 
  {
    # what PowerShell version is installed?
    Log "What PowerShell version is installed?"   
    Log $PSVersionTable.PSVersion -Level "info"
    Log
  
    # test connections to the target computer 
    Log "Running Test-NetConnection for Target $target on Port 80" 
    Test-NetConnection -ComputerName $target -Port 80 | Out-Null
    Log
  
    Log "Running Test-NetConnection for Target $target on Port 443"  
    Test-NetConnection -ComputerName $target -Port 443 | Out-Null
    Log    
  }
  catch 
  {
    Log "Error performing net connection tests: $_" -Level "error"
  }
  finally 
  {
    Log
  }
  Log "Done checking FNMS network connectivity"
  
  return $true
}


###########################################################################
# Test-SQLDatabase

function Test-SQLDatabase 
{
  param
  ( 
    [Parameter(Position=0, Mandatory=$True, ValueFromPipeline=$True)] [string] $Server,
    [Parameter(Position=1, Mandatory=$True)] [string] $Database,
    [Parameter(Position=2, Mandatory=$True, ParameterSetName="SQLAuth")] [string] $Username,
    [Parameter(Position=3, Mandatory=$True, ParameterSetName="SQLAuth")] [string] $Password,
    [Parameter(Position=2, Mandatory=$True, ParameterSetName="WindowsAuth")] [switch] $UseWindowsAuthentication
  )

  # connect to the database, then immediatly close the connection. If an exception occurrs it indicates the conneciton was not successful. 
  process 
  { 
    $dbConnection = New-Object System.Data.SqlClient.SqlConnection
    if (!$UseWindowsAuthentication) 
    {
      $dbConnection.ConnectionString = "Data Source=$Server; uid=$Username; pwd=$Password; Database=$Database;Integrated Security=False"
      $authentication = "SQL ($Username)"
    }
    else 
    {
      $dbConnection.ConnectionString = "Data Source=$Server; Database=$Database;Integrated Security=True;"
      $authentication = "Windows ($env:USERNAME)"
    }
    try 
    {
      $connectionTime = measure-command {$dbConnection.Open()}
      $Result = @{
        Connection = "Successful"
        ElapsedTime = $connectionTime.TotalSeconds
        Server = $Server
        Database = $Database
        User = $authentication
      }
    }
    # exceptions will be raised if the database connection failed.
    catch 
    {
      $Result = @{
        Connection = "Failed"
        ElapsedTime = $connectionTime.TotalSeconds
        Server = $Server
        Database = $Database
        User = $authentication
      }
    }
    finally
    {
      # close the database connection
      $dbConnection.Close()
      #return the results as an object
      $outputObject = New-Object -Property $Result -TypeName psobject
      #write-output $outputObject
      Log $outputObject
    }
  }
}

###########################################################################
# CheckFNMSDatabaseConnections

function CheckFNMSDatabaseConnections
{
  Log "Checking FNMS database connectivity"
  $target = GetConfigValue "FNMSDBServer"  
  $FNMSComplianceDBName = GetConfigValue "FNMSComplianceDBName"
  $FNMSInvDBName = GetConfigValue "FNMSComplianceDBName"  
  $FNMSDataWarehouseDBName = GetConfigValue "FNMSDataWarehouseDBName"  
  try 
  {    
    # test database connectivity
    Log "Running Test-SqlDatabase function to test connectivity to <master> on $target"    
    Test-SQLDatabase -Server $target -Database master -UseWindowsAuthentication
    
    # test database connectivity
    Log "Running Test-SqlDatabase function to test connectivity to $FNMSComplianceDBName on $target"    
    Test-SQLDatabase -Server $target -Database $FNMSComplianceDBName -UseWindowsAuthentication | Out-Null
    
    # test database connectivity
    Log "Running Test-SqlDatabase function to test connectivity to $FNMSInvDBName on $target"    
    Test-SQLDatabase -Server $target -Database $FNMSInvDBName -UseWindowsAuthentication | Out-Null
    
    # test database connectivity
    Log "Running Test-SqlDatabase function to test connectivity to $FNMSDataWarehouseDBName on $target"    
    Test-SQLDatabase -Server $target -Database $FNMSDataWarehouseDBName -UseWindowsAuthentication | Out-Null
  }
  catch 
  {
    Log "Error performing FNMS database checks: $_" -Level "error"
  }
  finally 
  {
    Log
  }
  Log "Done checking FNMS database connectivity"

  return $true
}


###########################################################################
# Configure the Flexera integration

function ConfigureFlexeraIntegration
{
  ## set the Flexera integration type
	$FlexeraIntegration = GetConfigValue "FlexeraIntegration"

  ## set the path to MGSBI.exe
	$MGSBIPath = GetConfigValue "MGSBIPath"

  ## set the path to FlxBizAdapterImporter.exe
	$FBAIPath = GetConfigValue "FBAIPath"

  ## set the path to FNMS InvSvr IncomingD
	$FNMSInvSvrIncomingPath = GetConfigValue "FNMSInvSvrIncomingDir"

  ## set the path to FNMS Beacon Server FQDN
	$FNMSBeaconServerFQDN = GetConfigValue "FNMSBeaconServerFQDN"

  ## set the path to FNMS Beacon BusinessAdapter
	$FNMSBeaconBusinessAdapterPath = GetConfigValue "FNMSBeaconBusinessAdapterDir"

	Log "Flexera is integrated at the $FlexeraIntegration level"
	return $true
}
  


