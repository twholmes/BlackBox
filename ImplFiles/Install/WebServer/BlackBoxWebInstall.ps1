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
