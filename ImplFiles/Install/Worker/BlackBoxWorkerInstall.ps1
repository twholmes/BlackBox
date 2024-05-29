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
# Install BlackBox worker app components

function InstallBlackBoxWorker
{
  # set key worker app config variables
	$WorkerApp = GetConfigValue "WorkerApp"
	$WorkerAppPath = GetConfigValue "WorkerAppPath"
  
  # set BlackBox folders
  Log "***********************"
  Log "SET BLACKBOX FOLDERS"
  Log "***********************"
  Log ""

  # set root path
  $RootDir = [Environment]::GetEnvironmentVariable('BlackBoxRootDir')
  if ([string]::IsNullOrEmpty($RootDir) -OR !(Test-Path $RootDir)) 
  {
    $RootDir = $WorkerAppPath
  }

  # set scripts path
  $ScriptsDir = [Environment]::GetEnvironmentVariable('BlackBoxScriptsDir')
  if ([string]::IsNullOrEmpty($ScriptsDir) -OR !(Test-Path $ScriptsDir)) 
  {
    $ScriptsDir = $RootDir + "\Scripts"
  }
  
  # set temp path
  $TempDir = [Environment]::GetEnvironmentVariable('BlackBoxTempDir')
  if ([string]::IsNullOrEmpty($TempDir) -OR !(Test-Path $TempDir)) 
  {
    $TempDir = $RootDir + "\temp"
  }
  
  # set tasks path
  $TasksDir = [Environment]::GetEnvironmentVariable('BlackBoxTasksDir')
  if ([string]::IsNullOrEmpty($TasksDir) -OR !(Test-Path $TasksDir)) 
  {
    $TasksDir = $RootDir + "\Tasks"
  }
  
  # set data path
  $DataDir = [Environment]::GetEnvironmentVariable('BlackBoxDataDir')
  if ([string]::IsNullOrEmpty($DataDir) -OR !(Test-Path $DataDir)) 
  {
    $DataDir = $RootDir + "\Data"
  }
  
  # set setup path
  $SetupDir = [Environment]::GetEnvironmentVariable('BlackBoxSetupDir')
  if ([string]::IsNullOrEmpty($SetupDir) -OR !(Test-Path $SetupDir)) 
  {
    $SetupDir = $RootDir + "\Setup"
  }
  
  # set packages path
  $PackagesDir = [Environment]::GetEnvironmentVariable('BlackBoxPackagesDir')
  if ([string]::IsNullOrEmpty($PackagesDir) -OR !(Test-Path $PackagesDir)) 
  {
    $PackagesDir = $RootDir + "\Packages"
  }
  
  # set woking directory path
  $WorkingDir = [Environment]::GetEnvironmentVariable('BlackBoxWorkingDir')
  if ([string]::IsNullOrEmpty($WorkingDir) -OR !(Test-Path $WorkingDir)) 
  {
    $WorkingDir = $RootDir + "\Jobs\00000000-0000-0000-0000-000000000000"
  }

  # Show directories
  Log ("RootDir:     {0}" -f $RootDir)
  Log ("ScriptsDir:  {0}" -f $ScriptsDir)
  Log ("TempDir:     {0}" -f $TempDir)
  Log ("TasksDir:    {0}" -f $TasksDir)  
  Log ("DataDir:     {0}" -f $DataDir)
  Log ("SetupDir:    {0}" -f $SetupDir)  
  Log ("PackagesDir: {0}" -f $PackagesDir)    
  Log ("WorkingDir:  {0}" -f $WorkingDir)
  Log ""  

  # get the archive
	$WorkerZipFile = GetConfigValue "WorkerZipFile"

  # set the package name
  $ZipFile = [Environment]::GetEnvironmentVariable('BlackBoxPackageName')
  if ([string]::IsNullOrEmpty($ZipFile)) 
  {
    $ZipFile = $WorkerZipFile
  }

  # find the package    
  $ZipFileList = Get-ChildItem -Path $RootDir -Filter $ZipFile -File -Recurse -ErrorAction SilentlyContinue -Force
  $ZipFileItem = $ZipFileList[0]
  if ([string]::IsNullOrEmpty($ZipFileItem)) 
  {
    Log ("Archive filename not in root folder {0}" -f $RootDir)
    return $false
  }
  $ZipFileFullName = $ZipFileItem.FullName
  
  # create a new temp folder for file processing
  $tempFolderPath = Join-Path $Env:Temp $(New-Guid)
  ##$tempFolderPath = Join-Path $Env:Temp ([System.IO.Path]::GetRandomFileName())
  New-Item -Type Directory -Path $tempFolderPath | Out-Null
  
  # unzip the archive
  Log "***********************"
  Log "UNZIP ARCHIVE"
  Log "***********************"
  Log ""
  Log ("Unzip archive file: {0} to temp" -f $ZipFile)
  Log ("  from: {0}" -f $ZipFileFullName)
  Log ("  to: {0}" -f $tempFolderPath)
  Log ""
  Expand-Archive -LiteralPath $ZipFileFullName -DestinationPath $tempFolderPath -Force
  
  ##Add-Type -AssemblyName System.IO.Compression.FileSystem
  ##[System.IO.Compression.ZipFile]::ExtractToDirectory($ZipFileFullName, $tempFolderPath, $true)
  
  Log ""
  
  ## copy files from temp to root subfolders
  Log "***********************"
  Log "COPY FILES TO ROOT"
  Log "***********************"
  Log ""
  
  $sourceRoot = Join-Path -Path $tempFolderPath -ChildPath "root"
  
  $source = Join-Path -Path $sourceRoot -ChildPath "Scripts\*"
  Log ("Copy {0} files from [tempdir]\Scripts to [rootdir]\Scripts" -f (Get-ChildItem $source).Count)
  Copy-Item -Path $source -Destination $ScriptsDir -Recurse -Force
  
  $source = Join-Path -Path $sourceRoot -ChildPath "Tasks\*"
  Log ("Copy {0} files from [tempdir]\Tasks to [rootdir]\Tasks" -f (Get-ChildItem $source).Count)
  Copy-Item -Path $source -Destination $TasksDir -Recurse -Force
  
  $source = Join-Path -Path $sourceRoot -ChildPath "Packages\*"
  Log ("Copy {0} files from [tempdir]\Packages to [rootdir]\Packages" -f (Get-ChildItem $source).Count)
  Copy-Item -Path $source -Destination $PackagesDir -Recurse -Force
  
  $source = Join-Path -Path $sourceRoot -ChildPath "Data\*"
  $dest = Join-Path -Path $RootDir -ChildPath "Data"
  Log ("Copy {0} files from [tempdir]\Data to [rootdir]\Data" -f (Get-ChildItem $source).Count)
  Copy-Item -Path $source -Destination $dest -Recurse -Force
  
  $source = Join-Path -Path $sourceRoot -ChildPath "Setup\*"
  $dest = Join-Path -Path $RootDir -ChildPath "Setup"
  Log ("Copy {0} files from [tempdir]\Setup to [rootdir]\Setup" -f (Get-ChildItem $source).Count)
  Copy-Item -Path $source -Destination $dest -Recurse -Force
  
  Log ""
  
  ## remove all remaining extract files
  Log ("Cleanup temp folder files {0}" -f $tempFolderPath)
  Get-ChildItem -Path $tempFolderPath -Include *.* -File -Recurse | foreach { $_.Delete()}
  
  ## delete any empty directories left behind after deleting the old files
  Get-ChildItem -Path $tempFolderPath -Recurse -Force | Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer }) -eq $null } | Remove-Item -Force -Recurse
  
  Log ""
  


	Log "Installation of BlackBox worker app components succeeded"
	return $true	
}

###########################################################################
# Uninstall BlackBox worker app

function UninstallBlackBoxWorker
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
