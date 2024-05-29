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
  Log ".with"
  
  $adaptersDir = Join-Path $WebSiteContentPath "Adapters\"
  Log "...Adapters = '$adaptersDir'"   
  New-WebVirtualDirectory -Force -Site $WebSite -Application $WebApp -Name "Adapters" -PhysicalPath $adaptersDir | Out-Host
  
  $contentDir = Join-Path $WebSiteContentPath "Content\"
  Log "...Content = '$contentDir'" 
  New-WebVirtualDirectory -Force -Site $WebSite -Application $WebApp -Name "Content" -PhysicalPath $contentDir | Out-Host
  
  $dataDir = Join-Path $WebSiteContentPath "Data\"
  Log "...Data = '$dataDir'" 
  New-WebVirtualDirectory -Force -Site $WebSite -Application $WebApp -Name "Data" -PhysicalPath $dataDir | Out-Host
  
  #$imagesDir = Join-Path $WebSiteContentPath "Images\"
  #Log "...Images = '$imagesDir'" 
  #New-WebVirtualDirectory -Force -Site $WebSite -Application $WebApp -Name "Images" -PhysicalPath $imagesDir | Out-Host
  
  $jobsDir = Join-Path $WebSiteContentPath "Jobs\"
  Log "...Jobs = '$jobsDir'" 
  New-WebVirtualDirectory -Force -Site $WebSite -Application $WebApp -Name "Jobs" -PhysicalPath $jobsDir | Out-Host
  
  $logsDir = Join-Path $WebSiteContentPath "Logs\"
  Log "...Logs = '$logsDir'" 
  New-WebVirtualDirectory -Force -Site $WebSite -Application $WebApp -Name "Logs" -PhysicalPath $logsDir | Out-Host
  
  #$photosDir = Join-Path $WebSiteContentPath "Photos\"
  #Log "...Photos = '$photosDir'" 
  #New-WebVirtualDirectory -Force -Site $WebSite -Application $WebApp -Name "Photos" -PhysicalPath $photosDir | Out-Host
  
  $scriptsDir = Join-Path $WebSiteContentPath "Scripts\"
  Log "...Scripts = '$scriptsDir'" 
  New-WebVirtualDirectory -Force -Site $WebSite -Application $WebApp -Name "Scripts" -PhysicalPath $scriptsDir | Out-Host
  
  $tasksDir = Join-Path $WebSiteContentPath "Tasks\"
  Log "...Tasks = '$tasksDir'" 
  New-WebVirtualDirectory -Force -Site $WebSite -Application $WebApp -Name "Tasks" -PhysicalPath $tasksDir | Out-Host
  
  $templatesDir = Join-Path $WebSiteContentPath "Templates\"
  Log "...Templates = '$templatesDir'" 
  New-WebVirtualDirectory -Force -Site $WebSite -Application $WebApp -Name "Templates" -PhysicalPath $templatesDir | Out-Host
  Log ""

  Log "Disable anonymous authentication"
  Set-WebConfigurationProperty -Filter '/system.webServer/security/authentication/anonymousAuthentication' -Name 'enabled' -Value 'false' -PSPath 'IIS:\' -Location "$WebSite/$WebApp" | Out-Host

  Log "Enable windows authentication"
  Set-WebConfigurationProperty -Filter '/system.webServer/security/authentication/windowsAuthentication' -Name 'enabled' -Value 'true' -PSPath 'IIS:\' -Location "$WebSite/$WebApp" | Out-Host

  Log "Web site installed"

  return $true
}

