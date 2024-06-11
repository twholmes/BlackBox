###########################################################################
# Copyright (C) 2024 Crayon
###########################################################################

## Get this script name and path
$ScriptName = Split-Path (Get-Variable MyInvocation -Scope 0).Value.MyCommand.Name
$ScriptPath = Split-Path (Get-Variable MyInvocation -Scope 0).Value.MyCommand.Path

###########################################################################
# Install BlackBox Web Server

function InstallBlackBoxWebServer
{
  UpdateLiveFromDevPublished | Out-Null
  
	Log "Installation of BlackBox web server components succeeded"
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

function UpdateLiveFromDevPublished
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

  ## first stop IIS
  Log "Stopping IIS ..."
  iisreset /stop | Out-Null

  ## remove all existing website files
  Log ("Cleanup temp folder files {0}" -f $WebSitePath)
  Get-ChildItem -Path $WebSitePath -Include *.* -File -Recurse | foreach { $_.Delete()}
  
  ## delete any empty directories left behind after deleting the old files
  Get-ChildItem -Path $WebSitePath -Recurse -Force | Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer }) -eq $null } | Remove-Item -Force -Recurse

  ## copy new files from source
  Copy-Item -Path (Join-Path $DevPublishedDir "*") -Recurse -Destination $WebSitePath -Verbose

  ## restart IIS
  Log "Restarting IIS ..."  
  iisreset | Out-Null

	Log "Live web site updated from DEV published"
	return $true
}

###########################################################################
# Copy content files to live from DEV published

function UpdateLiveContentFromDevPublished
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
  Get-ChildItem -Path $VirtualDirPath -Include *.* -File -Recurse | foreach { $_.Delete()}
  Get-ChildItem -Path $VirtualDirPath -Recurse -Force | Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer }) -eq $null } | Remove-Item -Force -Recurse  

  $SourcePath = Join-Path $DevContentDir "Scripts"
  Copy-Item -Path (Join-Path $SourcePath "*") -Recurse -Destination $VirtualDirPath -Verbose
  Log ""

  ## remove all existing virtual directory files before copying new (Templates)
  $VirtualDirPath = Join-Path $WebSiteContentPath "Templates"  
  Log ("Cleanup virtial directory files {0}" -f $VirtualDirPath)
  Get-ChildItem -Path $VirtualDirPath -Include *.* -File -Recurse | foreach { $_.Delete()}
  Get-ChildItem -Path $VirtualDirPath -Recurse -Force | Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer }) -eq $null } | Remove-Item -Force -Recurse  

  $SourcePath = Join-Path $DevContentDir "Templates"
  Copy-Item -Path (Join-Path $SourcePath "*") -Recurse -Destination $VirtualDirPath -Verbose
  Log ""

  ## remove all existing virtual directory files before copying new (Tasks)
  $VirtualDirPath = Join-Path $WebSiteContentPath "Tasks"
  Log ("Cleanup virtial directory files {0}" -f $VirtualDirPath)
  Get-ChildItem -Path $VirtualDirPath -Include *.* -File -Recurse | foreach { $_.Delete()}
  Get-ChildItem -Path $VirtualDirPath -Recurse -Force | Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer }) -eq $null } | Remove-Item -Force -Recurse  

  $SourcePath = Join-Path $DevContentDir "Tasks"
  Copy-Item -Path (Join-Path $SourcePath "*") -Recurse -Destination $VirtualDirPath -Verbose
  Log ""

  ## remove all existing virtual directory files before copying new (Jobs)
  $VirtualDirPath = Join-Path $WebSiteContentPath "Jobs"
  Log ("Cleanup virtial directory files {0}" -f $VirtualDirPath)
  Get-ChildItem -Path $VirtualDirPath -Include *.* -File -Recurse | foreach { $_.Delete()}
  Get-ChildItem -Path $VirtualDirPath -Recurse -Force | Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer }) -eq $null } | Remove-Item -Force -Recurse  
  
  New-Item -Path (Join-Path $VirtualDirPath "temp") -ItemType Directory | Out-Null

  $JobsPath = Join-Path $DevContentDir "Jobs"
  $SourcePath = Join-Path $JobsPath "00000000-0000-0000-0000-000000000000"
  New-Item -Path (Join-Path $VirtualDirPath "00000000-0000-0000-0000-000000000000") -ItemType Directory | Out-Null
  Copy-Item -Path (Join-Path $SourcePath "*") -Recurse -Destination (Join-Path $VirtualDirPath "00000000-0000-0000-0000-000000000000") -Verbose
  Log ""

	Log "Live web site content files updated from DEV published"
	return $true
}
