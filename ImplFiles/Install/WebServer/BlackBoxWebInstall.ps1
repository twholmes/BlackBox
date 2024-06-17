###########################################################################
# Copyright (C) 2024 Crayon
###########################################################################

## Get this script name and path
$ScriptName = Split-Path (Get-Variable MyInvocation -Scope 0).Value.MyCommand.Name
$ScriptPath = Split-Path (Get-Variable MyInvocation -Scope 0).Value.MyCommand.Path

###########################################################################
# Start and s Stop IIS

function StartIIS
{
  Log "Restarting IIS ..."  
  iisreset | Out-Null

  return $true
}

function StopIIS
{
  Log "Stopping IIS ..."
  iisreset /stop | Out-Null

  return $true
}

###########################################################################
# Install BlackBox Web Server

function InstallBlackBoxWebServer
{
  UpdateLiveFromDevPublished | Out-Null
  Log "Installation of BlackBox web server components succeeded"
  
  ConfigureWebSite | Out-Null
  Log "BlackBox web site installed"
  
  return $true  
}

###########################################################################
# Uninstall BlackBox Web Server

function UninstallBlackBoxWebServer
{
  $supportDir = Join-Path $dlDir "Support"
  $configFile = Join-Path $supportDir "Config\FNMS Windows Authentication Config.xml"

  # Files in the support directory often end up in a 'blocked' state after being downloaded from an
  # untrusted Internet site. We unblock these files here to seek to avoid failures while running the
  # config script.
  Get-ChildItem -Recurse $supportDir | Unblock-File

  Push-Location $supportDir 
  try 
  {
    $configScript = Join-Path $supportDir "Config.ps1"
    Log "Executing: & $configScript $configFile removeConfig"
    & $configScript $configFile removeConfig
  }
  catch 
  {
    Log "" -level Error
    Log "ERROR: Failed to execute config script: $_" -level Error
    return $false
  }
  finally 
  {
    Log "Config script execution completed"
    Pop-Location
  }
  
  Log "Uninstall of FlexNet Manager Suite server components succeeded"

  return $true
}


###########################################################################
# Copy files to live from DEV published

function CopyLiveFromDevPublished
{
  ## set key web site config variables
  $WebSite = GetConfigValue "WebSiteName"
  $AppPoolName = GetConfigValue "WebAppPool"
  $WebApp = GetConfigValue "WebApplication"

  $WebSitePath = GetConfigValue "WebSitePath"
  $WebSiteContentPath = GetConfigValue "WebSiteContentPath" 

  $WorkerPath = GetConfigValue "WorkerAppPath"

  ## what is the source?
  $DevPublishedDir = GetConfigValue "DevPublishDir"

  ## Files in the support directory often end up in a 'blocked' state after being downloaded from an
  ## untrusted Internet site. We unblock these files here to seek to avoid failures while running the website
  #Get-ChildItem -Recurse $DevPublishedDir | Unblock-File | Out-Null

  ## remove all existing website files
  Log ("Cleanup temp folder files {0}" -f $WebSitePath)
  Get-ChildItem -Path $WebSitePath -Include *.* -File -Recurse | foreach { $_.Delete()}
  
  ## delete any empty directories left behind after deleting the old files
  Get-ChildItem -Path $WebSitePath -Recurse -Force | Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer }) -eq $null } | Remove-Item -Force -Recurse

  ## copy new files from source
  Copy-Item -Path (Join-Path $DevPublishedDir "*") -Recurse -Destination $WebSitePath -Verbose

  Log "Live web site updated from DEV published"
  return $true
}

###########################################################################
# Copy content files to live from DEV published

function CopyLiveContentFromDevPublished
{
  ## set key web site config variables
  $WebSite = GetConfigValue "WebSiteName"
  $AppPoolName = GetConfigValue "WebAppPool"
  $WebApp = GetConfigValue "WebApplication"

  $WebSitePath = GetConfigValue "WebSitePath"
  $WebSiteContentPath = GetConfigValue "WebSiteContentPath" 

  $WorkerPath = GetConfigValue "WorkerAppPath"

  ## what is the source?
  $DevContentDir = GetConfigValue "DevContentDir"

  ## Files in the support directory often end up in a 'blocked' state after being downloaded from an
  ## untrusted Internet site. We unblock these files here to seek to avoid failures while running the website
  #Get-ChildItem -Recurse $DevPublishedDir | Unblock-File | Out-Null

  ## remove all existing virtual directory files before copying new (Content)
  $VirtualDirPath = Join-Path $WebSiteContentPath "Content"  
  Log ("Cleanup virtial directory files {0}" -f $VirtualDirPath)
  Get-ChildItem -Path $VirtualDirPath -Include *.* -File -Recurse | foreach { $_.Delete()}
  Get-ChildItem -Path $VirtualDirPath -Recurse -Force | Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer }) -eq $null } | Remove-Item -Force -Recurse  

  $SourcePath = Join-Path $DevContentDir "Content"  
  Copy-Item -Path (Join-Path $SourcePath "*") -Recurse -Destination $VirtualDirPath -Verbose
  Log ""

  ## remove all existing virtual directory files before copying new (Scripts)
  $VirtualDirPath = Join-Path $WebSiteContentPath "Scripts"  
  Log ("Cleanup virtial directory files {0}" -f $VirtualDirPath)
  if (Test-Path $VirtualDirPath) 
  {
    Get-ChildItem -Path $VirtualDirPath -Include *.* -File -Recurse | foreach { $_.Delete()}
    Get-ChildItem -Path $VirtualDirPath -Recurse -Force | Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer }) -eq $null } | Remove-Item -Force -Recurse  
  }
  else
  {
    New-Item -Path $WebSiteContentPath -Name "Scripts" -ItemType "directory" | Out-Null
  }

  $SourcePath = Join-Path $DevContentDir "Scripts"
  Copy-Item -Path (Join-Path $SourcePath "*") -Recurse -Destination $VirtualDirPath -Verbose
  Log ""

  ## remove all existing virtual directory files before copying new (Templates)
  $VirtualDirPath = Join-Path $WebSiteContentPath "Templates"  
  Log ("Cleanup virtial directory files {0}" -f $VirtualDirPath)
  if (Test-Path $VirtualDirPath) 
  {
    Get-ChildItem -Path $VirtualDirPath -Include *.* -File -Recurse | foreach { $_.Delete()}
    Get-ChildItem -Path $VirtualDirPath -Recurse -Force | Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer }) -eq $null } | Remove-Item -Force -Recurse  
  }
  else
  {
    New-Item -Path $WebSiteContentPath -Name "Templates" -ItemType "directory" | Out-Null
  }

  $SourcePath = Join-Path $DevContentDir "Templates"
  Copy-Item -Path (Join-Path $SourcePath "*") -Recurse -Destination $VirtualDirPath -Verbose
  Log ""

  ## remove all existing virtual directory files before copying new (Tasks)
  $VirtualDirPath = Join-Path $WebSiteContentPath "Tasks"
  Log ("Cleanup virtial directory files {0}" -f $VirtualDirPath)
  if (Test-Path $VirtualDirPath) 
  {
    Get-ChildItem -Path $VirtualDirPath -Include *.* -File -Recurse | foreach { $_.Delete()}
    Get-ChildItem -Path $VirtualDirPath -Recurse -Force | Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer }) -eq $null } | Remove-Item -Force -Recurse  
  }
  else
  {
    New-Item -Path $WebSiteContentPath -Name "Tasks" -ItemType "directory" | Out-Null 
  }

  $SourcePath = Join-Path $DevContentDir "Tasks"
  Copy-Item -Path (Join-Path $SourcePath "*") -Recurse -Destination $VirtualDirPath -Verbose
  Log ""

  ## remove all existing virtual directory files before copying new (Jobs)
  $VirtualDirPath = Join-Path $WebSiteContentPath "Jobs"
  Log ("Cleanup virtial directory files {0}" -f $VirtualDirPath)
  if (Test-Path $VirtualDirPath) 
  {
    Get-ChildItem -Path $VirtualDirPath -Include *.* -File -Recurse | foreach { $_.Delete()}
    Get-ChildItem -Path $VirtualDirPath -Recurse -Force | Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer }) -eq $null } | Remove-Item -Force -Recurse  
  }
  else
  {
    New-Item -Path $WebSiteContentPath -Name "Jobs" -ItemType "directory" | Out-Null 
  }
  
  New-Item -Path (Join-Path $VirtualDirPath "temp") -ItemType Directory | Out-Null

  $JobsPath = Join-Path $DevContentDir "Jobs"
  $SourcePath = Join-Path $JobsPath "00000000-0000-0000-0000-000000000000"
  New-Item -Path (Join-Path $VirtualDirPath "00000000-0000-0000-0000-000000000000") -ItemType Directory | Out-Null
  Copy-Item -Path (Join-Path $SourcePath "*") -Recurse -Destination (Join-Path $VirtualDirPath "00000000-0000-0000-0000-000000000000") -Verbose
  Log ""

  ## remove all existing virtual directory files before copying new (Archives)
  $VirtualDirPath = Join-Path $WebSiteContentPath "Archives"
  Log ("Cleanup virtial directory files {0}" -f $VirtualDirPath)
  if (Test-Path $VirtualDirPath) 
  {
    Get-ChildItem -Path $VirtualDirPath -Include *.* -File -Recurse | foreach { $_.Delete()}
    Get-ChildItem -Path $VirtualDirPath -Recurse -Force | Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer }) -eq $null } | Remove-Item -Force -Recurse  
  }
  else
  {
    New-Item -Path $WebSiteContentPath -Name "Archives" -ItemType "directory" | Out-Null 
  }

  Log "Live web site content files updated from DEV published"
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

	$WorkerPath = GetConfigValue "WorkerAppPath"

	$WebSitePath = GetConfigValue "WebSitePath"
	$WebSiteContentPath = GetConfigValue "WebSiteContentPath"	
	
	$ServiceAccount = GetConfigValue "BlackBoxServiceAccount"

  ## announce configuration
  Log "Configure IIS WebSite: $WebSite"
  Log "Configure WebSite for WebApp: $WebApp"
  Log " @ location $WebSitePath"  
  Log ""

  ## get service account credentials
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

  ## check it an AppPool already exists
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

  ## set AppPool properties
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

  ## create WebApplication
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

  ## add virtual directories to WebApplication
  Log ""
  Log "Configure virtual directories"
  Log "...with"
  
  ## get worker path and set virtual directory
  Log "...Worker = '$WorkerPath'"   
  New-WebVirtualDirectory -Force -Site $WebSite -Application $WebApp -Name "Worker" -PhysicalPath $WorkerPath | Out-Host

  ## get adapters path and set virtual directory
  $regPath = "HKLM:\SOFTWARE\WOW6432Node\ManageSoft Corp\ManageSoft\Beacon\CurrentVersion"
  $beaconDir = Get-RegKeyValue $regPath "BaseDirectory"
  $adaptersDir = Join-Path $beaconDir "BusinessAdapter\"
  if ([string]::IsNullOrEmpty($adaptersDir) -OR !(Test-Path $adaptersDir)) 
  {
    $adaptersDir = Join-Path $WebSiteContentPath "Adapters\"
  }
  Log "...Adapters = '$adaptersDir'"   
  New-WebVirtualDirectory -Force -Site $WebSite -Application $WebApp -Name "Adapters" -PhysicalPath $adaptersDir | Out-Host
  
  ## get archives path and set virtual directory
  $archivesDir = Join-Path $WebSiteContentPath "Archives\"
  Log "...Archives = '$archivesDir'"   
  New-WebVirtualDirectory -Force -Site $WebSite -Application $WebApp -Name "Archives" -PhysicalPath $archivesDir | Out-Host

  ## get content path and set virtual directory
  $contentDir = Join-Path $WebSiteContentPath "Content\"
  Log "...Content = '$contentDir'" 
  New-WebVirtualDirectory -Force -Site $WebSite -Application $WebApp -Name "Content" -PhysicalPath $contentDir | Out-Host
  
  ## get data path and set virtual directory
  $dataDir = Join-Path $WebSiteContentPath "Data\"
  Log "...Data = '$dataDir'" 
  New-WebVirtualDirectory -Force -Site $WebSite -Application $WebApp -Name "Data" -PhysicalPath $dataDir | Out-Host
  
  ## images data path and set virtual directory
  #$imagesDir = Join-Path $WebSiteContentPath "Images\"
  #Log "...Images = '$imagesDir'" 
  #New-WebVirtualDirectory -Force -Site $WebSite -Application $WebApp -Name "Images" -PhysicalPath $imagesDir | Out-Host

  ## get jobs path and set virtual directory  
  $jobsDir = Join-Path $WebSiteContentPath "Jobs\"
  Log "...Jobs = '$jobsDir'" 
  New-WebVirtualDirectory -Force -Site $WebSite -Application $WebApp -Name "Jobs" -PhysicalPath $jobsDir | Out-Host

  ## get logs path and set virtual directory  
  $logsDir = Join-Path $WebSiteContentPath "Logs\"
  Log "...Logs = '$logsDir'" 
  New-WebVirtualDirectory -Force -Site $WebSite -Application $WebApp -Name "Logs" -PhysicalPath $logsDir | Out-Host

  ## get packages path and set virtual directory  
  $packagesDir = Join-Path $WebSiteContentPath "Packages\"
  Log "...Packages = '$packagesDir'" 
  New-WebVirtualDirectory -Force -Site $WebSite -Application $WebApp -Name "Packages" -PhysicalPath $packagesDir | Out-Host
  
  ## get photos path and set virtual directory  
  #$photosDir = Join-Path $WebSiteContentPath "Photos\"
  #Log "...Photos = '$photosDir'" 
  #New-WebVirtualDirectory -Force -Site $WebSite -Application $WebApp -Name "Photos" -PhysicalPath $photosDir | Out-Host

  ## get scripts path and set virtual directory  
  $scriptsDir = Join-Path $WebSiteContentPath "Scripts\"
  Log "...Scripts = '$scriptsDir'" 
  New-WebVirtualDirectory -Force -Site $WebSite -Application $WebApp -Name "Scripts" -PhysicalPath $scriptsDir | Out-Host

  ## get tasks path and set virtual directory  
  $tasksDir = Join-Path $WebSiteContentPath "Tasks\"
  Log "...Tasks = '$tasksDir'" 
  New-WebVirtualDirectory -Force -Site $WebSite -Application $WebApp -Name "Tasks" -PhysicalPath $tasksDir | Out-Host
  
  ## get templates path and set virtual directory  
  $templatesDir = Join-Path $WebSiteContentPath "Templates\"
  Log "...Templates = '$templatesDir'" 
  New-WebVirtualDirectory -Force -Site $WebSite -Application $WebApp -Name "Templates" -PhysicalPath $templatesDir | Out-Host
  Log ""

  ## configure web site authentication
  Log "Disable anonymous authentication"
  Set-WebConfigurationProperty -Filter '/system.webServer/security/authentication/anonymousAuthentication' -Name 'enabled' -Value 'false' -PSPath 'IIS:\' -Location "$WebSite/$WebApp" | Out-Host

  Log "Enable windows authentication"
  Set-WebConfigurationProperty -Filter '/system.webServer/security/authentication/windowsAuthentication' -Name 'enabled' -Value 'true' -PSPath 'IIS:\' -Location "$WebSite/$WebApp" | Out-Host

  Log "Web site configured"

  return $true
}

  