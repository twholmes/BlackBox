###########################################################################
# Copyright (C) 2024 Crayon
###########################################################################

###########################################################################
# Write Script Info

function Write-ScriptInfo() 
{
  $wmi_OperatingSystem = Get-CimInstance -Class win32_operatingsystem

  $RAMTotal = [Math]::Round($wmi_OperatingSystem.TotalVisibleMemorySize/1MB)
  $RAMFree = [Math]::Round($wmi_OperatingSystem.FreePhysicalMemory/1MB)
  $os = [string]$wmi_OperatingSystem.Caption

  $loggedInUser = "{0}\{1}" -f $($env:UserDomain), $($env:UserName)

  $datetime = Get-Date -format "dd.MM.yyyy hh:mm"

  Log ""    
  Log "------------ Starting process ($PID) -----------------"
  Log "Script:             $($ScriptName)"  
  Log "Computer Name:      $($env:COMPUTERNAME)"
  Log "RAM:                $RAMTotal GB ($RAMFree GB available)"
  Log "Operating System:   $os"
  Log ("Logged in user:     {0}" -f $loggedInUser)  
  Log ("----------------- {0} --------------------" -f $datetime)
  Log ""
}

function WriteScriptInfo
{ 
  ## *************************
  ## SCRIPT INFO
  ## *************************
  Write-ScriptInfo

	return $true
}

###########################################################################
# Configure Windows Features For BlackBox

function ConfigureWindowsFeaturesForBlackBox
{
	Log "Configuring Windows features required for BlackBox"
	Import-Module ServerManager

	$features = (
		"Web-Server", "Web-WebServer",

		# Common HTTP Features
		"Web-Common-Http", "Web-Static-Content", "Web-Default-Doc",
		"Web-Dir-Browsing", "Web-Http-Errors", "Web-Http-Redirect",

		# Application Development
		"Web-App-Dev", "Web-CGI", "Web-ISAPI-Ext",
		"Web-ISAPI-Filter",

		# Health and Diagnostics
		"Web-Health", "Web-Http-Logging",

		# Security
		"Web-Security", "Web-Basic-Auth", "Web-Filtering", "Web-Windows-Auth",

		# Performance
		"Web-Performance", "Web-Stat-Compression", "Web-Dyn-Compression",

		# Management Tools
		"Web-Mgmt-Tools", "Web-Mgmt-Console"
	)

	if (Get-WindowsFeature NET-Framework-45-Features) 
	{ 
		$features += (
			"Net-Framework-45-Features", "Net-Framework-45-Core", "Net-Framework-45-ASPNET",
			"Net-WCF-Services45", "Net-WCF-TCP-PortSharing45",

			# Configure ASP.NET in IIS
			"Net-Framework-45-ASPNET", "Web-Asp-Net45", "Web-Net-Ext45"
		)
	} elseif (Get-WindowsFeature NET-Framework) {
		$features += (
			"NET-Framework", "Web-Asp-Net", "Web-Net-Ext"
		)
	}

	Log ""
	Log "Adding Windows features:"
	$features | %{ Log "`t$_" }

	$result = Add-WindowsFeature $features
	if (!$result.Success) 
	{
		Log "ERROR: Failed to configure IIS features" -level Error
		return $false
	}
	$restartNeeded = $result.RestartNeeded
	$features = "Web-DAV-Publishing"
	
	Log ""
	Log "Removing Windows features:"
	$features | %{ Log "`t$_" }

	$result = Remove-WindowsFeature $features
	$restartNeeded = $restartNeeded -or $result.RestartNeeded

	Log ""
	if ($restartNeeded) 
	{
		Log "NOTE: System restart may be needed to complete configuration of IIS features" -level Warning
	}

	Log "Completed Windows feature configuration"
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
# Copy files to GitHub from DEV published

function UpdateGitHubFromDevPublished
{
  ## set key web site config variables
	$GitHubWebSitePath = GetConfigValue "GitHubWebSiteDir"

  ## what is the source?
	$DevPublishedDir = GetConfigValue "DevPublishDir"

  ## remove all existing website files
  Log ("Cleanup temp folder files {0}" -f $GitHubWebSitePath)
  Get-ChildItem -Path $GitHubWebSitePath -Include *.* -File -Recurse | foreach { $_.Delete()}
  
  ## delete any empty directories left behind after deleting the old files
  Get-ChildItem -Path $GitHubWebSitePath -Recurse -Force | Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer }) -eq $null } | Remove-Item -Force -Recurse

  ## copy new files from source
  Copy-Item -Path (Join-Path $DevPublishedDir "*") -Recurse -Destination $GitHubWebSitePath -Verbose

	Log "GitHub web site files updated from DEV published"
	return $true
}
