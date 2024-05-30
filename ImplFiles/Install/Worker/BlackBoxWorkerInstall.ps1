###########################################################################
# Copyright (C) 2024 Crayon
###########################################################################

## Get this script name and path
$ScriptName = Split-Path (Get-Variable MyInvocation -Scope 0).Value.MyCommand.Name
$ScriptPath = Split-Path (Get-Variable MyInvocation -Scope 0).Value.MyCommand.Path

###########################################################################
# List BlackBox worker folders

function ListBlackBoxFolders
{
  # set key worker app config variables
	$WorkerApp = GetConfigValue "WorkerApp"
	$WorkerAppPath = GetConfigValue "WorkerAppPath"
  
  # get BlackBox folders
  Log "***********************"
  Log "GET BLACKBOX FOLDERS"
  Log "***********************"
  Log ""

  # get root path
  $RootDir = [Environment]::GetEnvironmentVariable('BlackBoxRootDir')
  if ([string]::IsNullOrEmpty($RootDir) -OR !(Test-Path $RootDir)) 
  {
    $RootDir = $WorkerAppPath
  }

  # get scripts path
  $ScriptsDir = [Environment]::GetEnvironmentVariable('BlackBoxScriptsDir')
  if ([string]::IsNullOrEmpty($ScriptsDir) -OR !(Test-Path $ScriptsDir)) 
  {
    $ScriptsDir = $RootDir + "\Scripts"
  }
  
  # get temp path
  $TempDir = [Environment]::GetEnvironmentVariable('BlackBoxTempDir')
  if ([string]::IsNullOrEmpty($TempDir) -OR !(Test-Path $TempDir)) 
  {
    $TempDir = $RootDir + "\temp"
  }
  
  # get tasks path
  $TasksDir = [Environment]::GetEnvironmentVariable('BlackBoxTasksDir')
  if ([string]::IsNullOrEmpty($TasksDir) -OR !(Test-Path $TasksDir)) 
  {
    $TasksDir = $RootDir + "\Tasks"
  }
  
  # get data path
  $DataDir = [Environment]::GetEnvironmentVariable('BlackBoxDataDir')
  if ([string]::IsNullOrEmpty($DataDir) -OR !(Test-Path $DataDir)) 
  {
    $DataDir = $RootDir + "\Data"
  }
  
  # get setup path
  $SetupDir = [Environment]::GetEnvironmentVariable('BlackBoxSetupDir')
  if ([string]::IsNullOrEmpty($SetupDir) -OR !(Test-Path $SetupDir)) 
  {
    $SetupDir = $RootDir + "\Setup"
  }
  
  # get packages path
  $PackagesDir = [Environment]::GetEnvironmentVariable('BlackBoxPackagesDir')
  if ([string]::IsNullOrEmpty($PackagesDir) -OR !(Test-Path $PackagesDir)) 
  {
    $PackagesDir = $RootDir + "\Packages"
  }
  
  # get woking directory path
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

	return $true	
}

###########################################################################
# RegKey delete

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

###########################################################################
# Clear BlackBox worker environment variables

function ClearBlackBoxWorkerEnvironmentVariables
{
  # set key worker app config variables
	$WorkerApp = GetConfigValue "WorkerApp"
	$WorkerAppPath = GetConfigValue "WorkerAppPath"
  
  # clear BlackBox folders
  Log "********************************"
  Log "CLEAR BLACKBOX FOLDER SETTINGS"
  Log "********************************"
  Log ""

  # delete this registry key path
  $regPath = "HKCU:\Environment"
  RegKeyDelete $regPath "BlackBoxRootDir" | Out-Null

  # delete this registry key path
  $regPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment"
  RegKeyDelete $regPath "BlackBoxRootDir" | Out-Null
  Log ""

  # set environment variables for script run
  #[Environment]::SetEnvironmentVariable('BlackBoxRootDir', $ScriptPath)

  # set root path
  $RootDir = [Environment]::GetEnvironmentVariable('BlackBoxRootDir')
  if ([string]::IsNullOrEmpty($RootDir) -OR !(Test-Path $RootDir)) 
  {
    $RootDir = $WorkerAppPath
    [Environment]::SetEnvironmentVariable('BlackBoxRootDir', $WorkerAppPath)
  }
  ListBlackBoxFolders | Out-Null

	return $true	
}


###########################################################################
# Install BlackBox worker app components into the local sub-folders

function InstallBlackBoxWorkerLocally
{
  Log ("Running PowerShell version: {0}" -f $PSVersionTable.PSVersion)
  Import-Module Microsoft.PowerShell.Archive

  # get key worker app config variables
	$WorkerApp = GetConfigValue "WorkerApp"
	$WorkerAppPath = GetConfigValue "WorkerAppPath"
  
  # get BlackBox folders
  Log ""  
  Log "***********************"
  Log "GET BLACKBOX FOLDERS"
  Log "***********************"
  Log ""

  # get root path
  $RootDir = [Environment]::GetEnvironmentVariable('BlackBoxRootDir')
  if ([string]::IsNullOrEmpty($RootDir) -OR !(Test-Path $RootDir)) 
  {
    $RootDir = $WorkerAppPath
  }

  # get scripts path
  $ScriptsDir = [Environment]::GetEnvironmentVariable('BlackBoxScriptsDir')
  if ([string]::IsNullOrEmpty($ScriptsDir) -OR !(Test-Path $ScriptsDir)) 
  {
    $ScriptsDir = $RootDir + "\Scripts"
  }
  
  # get temp path
  $TempDir = [Environment]::GetEnvironmentVariable('BlackBoxTempDir')
  if ([string]::IsNullOrEmpty($TempDir) -OR !(Test-Path $TempDir)) 
  {
    $TempDir = $RootDir + "\temp"
  }
  
  # get tasks path
  $TasksDir = [Environment]::GetEnvironmentVariable('BlackBoxTasksDir')
  if ([string]::IsNullOrEmpty($TasksDir) -OR !(Test-Path $TasksDir)) 
  {
    $TasksDir = $RootDir + "\Tasks"
  }
  
  # get data path
  $DataDir = [Environment]::GetEnvironmentVariable('BlackBoxDataDir')
  if ([string]::IsNullOrEmpty($DataDir) -OR !(Test-Path $DataDir)) 
  {
    $DataDir = $RootDir + "\Data"
  }
  
  # get setup path
  $SetupDir = [Environment]::GetEnvironmentVariable('BlackBoxSetupDir')
  if ([string]::IsNullOrEmpty($SetupDir) -OR !(Test-Path $SetupDir)) 
  {
    $SetupDir = $RootDir + "\Setup"
  }
  
  # get packages path
  $PackagesDir = [Environment]::GetEnvironmentVariable('BlackBoxPackagesDir')
  if ([string]::IsNullOrEmpty($PackagesDir) -OR !(Test-Path $PackagesDir)) 
  {
    $PackagesDir = $RootDir + "\Packages"
  }
  
  # get woking directory path
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
  Log "Search directories under $RootDir for $ZipFile" 
  $ZipFileList = Get-ChildItem -Path $RootDir -Filter $ZipFile -File -ErrorAction SilentlyContinue -Force
  $ZipFileItem = $ZipFileList[0]
  if ([string]::IsNullOrEmpty($ZipFileItem)) 
  {
    $ZipFileList = Get-ChildItem -Path $RootDir -Filter $ZipFile -File -Recurse -ErrorAction SilentlyContinue -Force
    $ZipFileItem = $ZipFileList[0]
    if ([string]::IsNullOrEmpty($ZipFileItem)) 
    {
      Log ("Archive filename not found in any folder under root folder {0}" -f $RootDir)
      return $false
    }
  }
  $ZipFileFullName = $ZipFileItem.FullName
  
  # create a new temp folder for file processing
  ##$tempFolderPath = Join-Path $Env:Temp $(New-Guid)
  ##$tempFolderPath = Join-Path $Env:Temp ([System.IO.Path]::GetRandomFileName())
  $tempFolderPath = $RootDir + "\Temp"  
  if (Test-Path -Path $tempFolderPath)
  {
    Write-Host "Folder $tempFolderPath already exists"  
  }
  else
  {
    Log "Creating folder: $tempFolderPath"
    New-Item -Type Directory -Path $tempFolderPath | Out-Null
  }
  
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
  
  #Get-ChildItem $tempFolderPath -r  # | % { if ($_.PsIsContainer) { $_.FullName + "\" } else { $_.FullName } }  
  
  ## copy files from temp to root subfolders
  Log "***********************"
  Log "COPY FILES TO ROOT"
  Log "***********************"
  Log ""
  
  $sourceRoot = Join-Path -Path $tempFolderPath -ChildPath "payload"
  
  $source = Join-Path -Path $sourceRoot -ChildPath "Scripts\*"
  if (Test-Path -Path $source)
  {
    Log ("Copy {0} files from [tempdir]\Scripts to [rootdir]\Scripts" -f (Get-ChildItem $source).Count)
    Copy-Item -Path $source -Destination $ScriptsDir -Recurse -Force
  }
  $source = Join-Path -Path $sourceRoot -ChildPath "Tasks\*"
  if (Test-Path -Path $source)
  {
    Log ("Copy {0} files from [tempdir]\Tasks to [rootdir]\Tasks" -f (Get-ChildItem $source).Count)
    Copy-Item -Path $source -Destination $TasksDir -Recurse -Force
  }
  $source = Join-Path -Path $sourceRoot -ChildPath "Packages\*"
  if (Test-Path -Path $source)
  {
    Log ("Copy {0} files from [tempdir]\Packages to [rootdir]\Packages" -f (Get-ChildItem $source).Count)
    Copy-Item -Path $source -Destination $PackagesDir -Recurse -Force
  }
  $source = Join-Path -Path $sourceRoot -ChildPath "Data\*"
  if (Test-Path -Path $source)
  {
    $dest = Join-Path -Path $RootDir -ChildPath "Data"
    Log ("Copy {0} files from [tempdir]\Data to [rootdir]\Data" -f (Get-ChildItem $source).Count)
    Copy-Item -Path $source -Destination $dest -Recurse -Force
  }  
  $source = Join-Path -Path $sourceRoot -ChildPath "Setup\*"
  if (Test-Path -Path $source)
  {
    $dest = Join-Path -Path $RootDir -ChildPath "Setup"
    Log ("Copy {0} files from [tempdir]\Setup to [rootdir]\Setup" -f (Get-ChildItem $source).Count)
    Copy-Item -Path $source -Destination $dest -Recurse -Force
  }
  Log ""
  
  ## remove all remaining extract files
  Log ("Cleanup temp folder files {0}" -f $tempFolderPath)
  Get-ChildItem -Path $tempFolderPath -Include *.* -File -Recurse | foreach { $_.Delete()}
  
  ## delete any empty directories left behind after deleting the old files
  Get-ChildItem -Path $tempFolderPath -Recurse -Force | Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer }) -eq $null } | Remove-Item -Force -Recurse
  
  #Log ""

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
