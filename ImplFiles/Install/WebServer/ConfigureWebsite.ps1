##-------------------------------------------------------------------------
## Copyright (C) 2024 Crayon Australia
## This script runs a PowerShell procedure to setup IIS for Blackbox
## Updated: 24/05/2024 8:15
##-------------------------------------------------------------------------

## Get this script name and path
$ScriptName = Split-Path (Get-Variable MyInvocation -Scope 0).Value.MyCommand.Name
$ScriptPath = Split-Path (Get-Variable MyInvocation -Scope 0).Value.MyCommand.Path

################################################################################################
## GENERIC CODE - DONT EDIT THIS SECTION ##
#I mport-Module -Force (Join-Path  (Split-Path $script:MyInvocation.MyCommand.Path) 'blackbox.psm1')

#Import-Module WebAdministration

###########################################################################
# RegKey functions

function GetRegKeyValue([string]$regPath, [string]$regName)
{
  $value = ""
  try 
  {
    $value = Get-ItemPropertyValue -Path $regPath -Name $regName -ErrorAction Stop
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

function RegKeyDelete([string]$regPath, [string]$regName)
{
  try 
  {
    # delete this registry key in path
    if (Get-ItemProperty -Path $regPath -Name $regName -ErrorAction Stop) 
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

############################################################
# Configure BlackBox WebSite

function ConfigureWebSite
{
  Import-Module WebAdministration

  # set key web site config variables
	$WebSite = GetConfigValue "WebSiteName"
	$AppPoolName = GetConfigValue "WebAppPool"
	$WebApp = GetConfigValue "WebApplication"

	$WebSitePath = GetConfigValue "WebSitePath"
	$WebSiteContentPath = GetConfigValue "WebSiteContentPath"	
	
	$ServiceAccount = GetConfigValue "BlackBoxServiceAccount"

  # announce configuration
  Log "Configure IIS WebSite: $WebSite"
  Log "Configure WebSite for WebApp: $WebApp"
  Log " @ location $WebSitePath"  
  Log ""

  # get service account credentials
	$cred = GetCredentials `
		"Requesting credentials for the AppPool..." `
		"AppPool credentials" `
		"Enter AppPool user credentials" `
		$ServiceAccount

	if (!$cred) { # Cancelled?
		Log "Configuration cancelled by user"
		return $false
	}
  #$cred.UserName
  $ServiceAccountPassword = $cred.GetNetworkCredential().Password

  # check it an AppPool already exists
  if (Test-Path IIS:\AppPools\$AppPoolName)
  {
    Log "AppPool $AppPoolName already exists"
    #Get-ItemProperty IIS:\AppPools\$AppPoolName | Select-Object *  
  }
  else
  {
    Log "Creating new AppPool $AppPoolName"
    New-WebAppPool -Force -Name $AppPoolName | Out-Host
  }

  # set AppPool properties
  $AppPoolPath = "IIS:\AppPools\$AppPoolName"
  Log "Configuring AppPool: $AppPoolName"
  Log " @ location $AppPoolPath"
  Log " with" 

  Log "   managedRuntimeVersion = 'v4.0'"
  Set-ItemProperty -Path $AppPoolPath -Name managedRuntimeVersion -Value "v4.0" | Out-Host

  Log "   managedPipeLineMode = 'Integrated'"  
  Set-ItemProperty -Path $AppPoolPath -Name managedPipeLineMode -Value "Integrated" | Out-Host
  
  Log "   enable32BitAppOnWin64 = 'true'"
  Set-ItemProperty -Path $AppPoolPath -Name enable32BitAppOnWin64 -Value $true | Out-Host
  
  Log "   autoStart = 'true'" 
  Set-ItemProperty -Path $AppPoolPath -Name autoStart -Value $true | Out-Host 

  Log "   processmodel.identityType = '3'" 
  Set-ItemProperty -Path $AppPoolPath -Name processmodel.identityType -Value 3 | Out-Host

  Log "   processmodel.userName = '$ServiceAccount'" 
  Set-ItemProperty -Path $AppPoolPath -Name processmodel.userName -Value $ServiceAccount | Out-Host

  Log "   processmodel.password = *****" 
  Set-ItemProperty -Path $AppPoolPath -Name processmodel.password -Value $ServiceAccountPassword | Out-Host

  # create WebApplication
  Log ""
  Log "Recreate WebApplication Configure $WebApp"
  Log " @ location $WebSitePath"  
  Log " with"
  Log "   ApplicationPool = '$AppPoolName'"   
  New-WebApplication -Force -Name $WebApp -Site $WebSite -PhysicalPath $WebSitePath -ApplicationPool $AppPoolName | Out-Host

  Log ""
  Log "Set web site properties"
  $WebSitePath = "IIS:\Sites\$WebSite"

  Log ""
  Log "Set web app properties"
  $WebAppPath = "IIS:\Sites\$WebSite\$WebApp"

  #Set-ItemProperty $WebAppPath -Name defaultDocument -Value "Default.aspx"

  #Start-IISCommitDelay
  Set-ItemProperty $WebAppPath -Name applicationPool -Value $AppPoolName | Out-Host
  #Stop-IISCommitDelay

  # add virtual directories to WebApplication
  Log ""
  Log "Configure virtual directories"
  Log "...with"

  # get adapters path and set virtual directory
  $regPath = "HKLM:\SOFTWARE\WOW6432Node\ManageSoft Corp\ManageSoft\Beacon\CurrentVersion"
  $beaconDir = GetRegKeyValue $regPath "BaseDirectory"
  $adaptersDir = Join-Path $beaconDir "BusinessAdapter\"
  if ([string]::IsNullOrEmpty($adaptersDir) -OR !(Test-Path $adaptersDir)) 
  {
    $adaptersDir = Join-Path $WebSiteContentPath "Adapters\"
  }
  Log "...Adapters = '$adaptersDir'"   
  New-WebVirtualDirectory -Force -Site $WebSite -Application $WebApp -Name "Adapters" -PhysicalPath $adaptersDir | Out-Host
  
  # get archives path and set virtual directory
  $archivesDir = Join-Path $WebSiteContentPath "Archives\"
  Log "...Archives = '$archivesDir'"   
  New-WebVirtualDirectory -Force -Site $WebSite -Application $WebApp -Name "Archives" -PhysicalPath $archivesDir | Out-Host

  # get content path and set virtual directory
  $contentDir = Join-Path $WebSiteContentPath "Content\"
  Log "...Content = '$contentDir'" 
  New-WebVirtualDirectory -Force -Site $WebSite -Application $WebApp -Name "Content" -PhysicalPath $contentDir | Out-Host
  
  # get data path and set virtual directory
  $dataDir = Join-Path $WebSiteContentPath "Data\"
  Log "...Data = '$dataDir'" 
  New-WebVirtualDirectory -Force -Site $WebSite -Application $WebApp -Name "Data" -PhysicalPath $dataDir | Out-Host
  
  # images data path and set virtual directory
  #$imagesDir = Join-Path $WebSiteContentPath "Images\"
  #Log "...Images = '$imagesDir'" 
  #New-WebVirtualDirectory -Force -Site $WebSite -Application $WebApp -Name "Images" -PhysicalPath $imagesDir | Out-Host

  # get jobs path and set virtual directory  
  $jobsDir = Join-Path $WebSiteContentPath "Jobs\"
  Log "...Jobs = '$jobsDir'" 
  New-WebVirtualDirectory -Force -Site $WebSite -Application $WebApp -Name "Jobs" -PhysicalPath $jobsDir | Out-Host

  # get logs path and set virtual directory  
  $logsDir = Join-Path $WebSiteContentPath "Logs\"
  Log "...Logs = '$logsDir'" 
  New-WebVirtualDirectory -Force -Site $WebSite -Application $WebApp -Name "Logs" -PhysicalPath $logsDir | Out-Host

  # get packages path and set virtual directory  
  $packagesDir = Join-Path $WebSiteContentPath "Packages\"
  Log "...Packages = '$packagesDir'" 
  New-WebVirtualDirectory -Force -Site $WebSite -Application $WebApp -Name "Packages" -PhysicalPath $packagesDir | Out-Host
  
  # get photos path and set virtual directory  
  #$photosDir = Join-Path $WebSiteContentPath "Photos\"
  #Log "...Photos = '$photosDir'" 
  #New-WebVirtualDirectory -Force -Site $WebSite -Application $WebApp -Name "Photos" -PhysicalPath $photosDir | Out-Host

  # get scripts path and set virtual directory  
  $scriptsDir = Join-Path $WebSiteContentPath "Scripts\"
  Log "...Scripts = '$scriptsDir'" 
  New-WebVirtualDirectory -Force -Site $WebSite -Application $WebApp -Name "Scripts" -PhysicalPath $scriptsDir | Out-Host

  # get tasks path and set virtual directory  
  $tasksDir = Join-Path $WebSiteContentPath "Tasks\"
  Log "...Tasks = '$tasksDir'" 
  New-WebVirtualDirectory -Force -Site $WebSite -Application $WebApp -Name "Tasks" -PhysicalPath $tasksDir | Out-Host
  
  # get templates path and set virtual directory  
  $templatesDir = Join-Path $WebSiteContentPath "Templates\"
  Log "...Templates = '$templatesDir'" 
  New-WebVirtualDirectory -Force -Site $WebSite -Application $WebApp -Name "Templates" -PhysicalPath $templatesDir | Out-Host
  Log ""

  # configure web site authentication
  Log "Disable anonymous authentication"
  Set-WebConfigurationProperty -Filter '/system.webServer/security/authentication/anonymousAuthentication' -Name 'enabled' -Value 'false' -PSPath 'IIS:\' -Location "$WebSite/$WebApp" | Out-Host

  Log "Enable windows authentication"
  Set-WebConfigurationProperty -Filter '/system.webServer/security/authentication/windowsAuthentication' -Name 'enabled' -Value 'true' -PSPath 'IIS:\' -Location "$WebSite/$WebApp" | Out-Host

  Log "Web site installed"

  return $true
}

