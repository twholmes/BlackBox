###########################################################################
# Copyright (C) 2024 Crayon
###########################################################################

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
# Install BlackBox App Server

function InstallBlackBoxAppServer
{
	Log "Installation of BlackBox app server components succeeded"
	return $true	
}

###########################################################################
# Uninstall BlackBox App Server

function UninstallBlackBoxAppServer
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
