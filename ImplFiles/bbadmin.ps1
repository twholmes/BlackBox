#Requires -Version 3.0
###########################################################################
# This script provides an interface to perform administrative operations
# for a BlackBox implementations. It is a wrapper to execute
# functions provided by different "modules" containing different capabilities
# and configuration details for a system implementation.
#
# Copyright (C) 2024 Crayon
###########################################################################

<#
.SYNOPSIS
bbadmin is a script for running various administrative operations related to BlackBox implementations.

.DESCRIPTION
bbadmin is a Windows PowerShell administration script for BlackBox implementations, providing a modularized architecture for scripting and automating administrative operations.

See the "bbadmin User Guide" for more information about bbadmin.

bbadmin is a contributed sample, and is provided on an as-is basis without support or warranty of any kind.

.PARAMETER target
Execute steps for named target.

.PARAMETER step
Skip steps for named target up until the specified number (useful for re-starting after a failure).

.PARAMETER settings
Specifies setting values to use for this invocation only. Any other value for the setting(s) specified in the settings file is ignored.

.PARAMETER quiet
Run without prompting for any details (for use in a non-interactive mode).

.PARAMETER listTargets
List all targets matching the specified regular expression pattern that have been configured. The pattern is matched against both target names and module paths. Use "*" as a wildcard.

.PARAMETER settingsTemplate
Save a settings template to the named file.

.PARAMETER noEventLog
Do not create events in the Windows Application event log when bbadmin targets are executed.

.PARAMETER logLevel
Specifies the level of verbosity to use in generated logging. Must be one of the following values: Error, Warning, Info, Debug. The default log level is Info.

.PARAMETER help
Display help for the bbadmin script.

.EXAMPLE
.\bbadmin.ps1 InstallAll

Executes all steps for the target "InstallAll".

.EXAMPLE
.\bbadmin.ps1 InstallAll -step 8

Executes the 8th and subsequent steps for the target "InstallAll". For example, this may be useful if an attempt had been made to execute the "InstallAll" target previously, but it had failed at the 8th step.

.EXAMPLE
.\bbadmin.ps1 InstallAll -settings LogDir=c:\SpecialLogDir,AnotherSetting=42

Executes the "InstallAll" target, with the value "c:\SpecialLogDir" for the setting "LogDir", and the value "42" for the setting "AnotherSetting".

.EXAMPLE
.\bbadmin.ps1 -listTargets Install

Displays a list of configured targets including the text "Install" in the target name or module path.

.EXAMPLE
.\bbadmin.ps1 -listTargets *

Displays a list of all configured targets that bbadmin can execute.

.EXAMPLE
.\bbadmin.ps1 -settingsTemplate blackbox.template.settings

Generates the file "blackbox.template.settings" containing a template that can be filled in with configuration settings values.
#>



param
(
	[string]$target
	, [int]$step
	, [string[]]$settings
	, [switch]$quiet
	, [string]$listTargets
	, [string]$settingsTemplate
	, [switch]$noEventLog
	, [switch]$help
	, [ValidateSet("Error", "Warning", "Info", "Debug")][string]$logLevel="Info"
)


$BlackBoxAdminPath = Split-Path $MyInvocation.MyCommand.Path
$BlackBoxAdminName = $MyInvocation.MyCommand.Name


############################################################
# Set the name of the log file to write logging to

function SetLogFile([string]$logFile)
{
	$previousLog = GetLogFile

	Log "Further logging from this session will be written to $logFile"

	[System.Diagnostics.Debug]::Listeners |
	? { $_.Name -eq "Default" } |
	% { $_.LogFileName = $logFile }

	$msg = "{0} {1}" -f (Get-Date -format "yyyy-MM-dd HH:mm:ss"), "This is $BlackBoxAdminName"
	[System.Diagnostics.Debug]::WriteLine($msg)

	$msg = "{0} {1}" -f (Get-Date -format "yyyy-MM-dd HH:mm:ss"), ("Computer: " + [System.Net.Dns]::GetHostName())
	[System.Diagnostics.Debug]::WriteLine($msg)

	$msg = "{0} {1}" -f (Get-Date -format "yyyy-MM-dd HH:mm:ss"), ("User: " + [System.Security.Principal.WindowsIdentity]::GetCurrent().Name)
	[System.Diagnostics.Debug]::WriteLine($msg)

	if (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
		$hasLocalAdminRights = "YES"
	} else {
		$hasLocalAdminRights = "NO"
		Write-Warning "bbadmin script is running without local administrator rights"
	}
	$msg = "{0} {1}" -f (Get-Date -format "yyyy-MM-dd HH:mm:ss"), "Running with local administrator rights? $hasLocalAdminRights"
	[System.Diagnostics.Debug]::WriteLine($msg)

	$msg = "{0} {1}" -f (Get-Date -format "yyyy-MM-dd HH:mm:ss"), ("Settings file: " + $GlobalConfigSettings["__SettingsFile"])
	[System.Diagnostics.Debug]::WriteLine($msg)

	[System.Diagnostics.Debug]::WriteLine("")
	
	if ($previousLog) {
		Log "Previous logging from this session can be found in $previousLog"
		Log ""
	}
}


############################################################
# Get the name of the log file

function GetLogFile
{
	[System.Diagnostics.Debug]::Listeners |
	? { $_.Name -eq "Default" } |
	% { return $_.LogFileName }
}


###########################################################################
# Write a log message

$global:ErrorLogMessages = @()

function Log([Parameter(ValueFromPipeline=$true)][string]$msg, [switch]$noHost, [ValidateSet("Error", "Warning", "Info", "Debug")][string]$level="Info")
{
	if ($level -eq "Error") {
		$global:ErrorLogMessages += $msg
	}

	if (($level -eq "Error" -and $GlobalLogLevel -lt 0) -or
		($level -eq "Warning" -and $GlobalLogLevel -lt 1) -or
		($level -eq "Info" -and $GlobalLogLevel -lt 2) -or
		($level -eq "Debug" -and $GlobalLogLevel -lt 3)
	) {
		return
	}

	if (!$noHost) {
		if ($level -eq "Error") {
			Write-Host -ForegroundColor Red $msg
		} elseif ($level -eq "Warning") {
			Write-Host -ForegroundColor Yellow $msg
		} elseif ($level -eq "Info") {
			Write-Host -ForegroundColor Green $msg
		} else {
			Write-Host $msg
		}
	}

	$msg = "{0} [{2,-7}] {1}" -f (Get-Date -format "yyyy-MM-dd HH:mm:ss"), $msg, $level
	[System.Diagnostics.Debug]::WriteLine($msg)
}


###########################################################################
# Initialise logging

function InitialiseLogging([string]$logDirectory, [string]$logFileNamePrefix)
{
	if (!(Test-Path $logDirectory -PathType Container)) {
		New-Item $logDirectory -type Directory | Out-Null
	}

	$logFileName = "{0}_{1}.log" -f $logFileNamePrefix, (Get-Date -format "yyyyMMdd_HHmmss")
	SetLogFile (Join-Path $logDirectory $logFileName)
}


###########################################################################
#

function DumpTargetResultToEventLog($entryType, $summary, $target, $runTime)
{
	if ($noEventLog) {
		return
	}

	New-EventLog Application bbadmin -ErrorAction Ignore # Create bbadmin source if it doesn't already exist

	$message = @"
$summary

Target: $target
Settings file: $($GlobalConfigSettings["__SettingsFile"])
Settings:
`t$($settings -join "`n`t")
User: $([System.Security.Principal.WindowsIdentity]::GetCurrent().Name)
Execution time: $runTime
Log file: $(GetLogFile)

Error messages:
$($global:ErrorLogMessages -join "`n")
"@

	if ($message.Length -gt 31000) { # Trim long messages to ensure they can fit into the event log
		$message = $message.Substring(0, 31000)
	}

	Write-EventLog -LogName Application -Source bbadmin -EntryType $entryType -EventId 1 -Message $message
}


###########################################################################
# Validate the value provided for a configuration setting is
# valid by ensuring that it is an absolute path and that the directory
# can be created if it doesn't already exist.

function ValidateDirExists([string]$value)
{
	if (!([System.IO.Path]::IsPathRooted($value))) {
		Write-Host ""
		Write-Warning "Directory must be an absolute path"
		Write-Host ""

		return $false
	}

	try {
		if (!(Test-Path $value -PathType Container)) {
			New-Item $value -type Directory -ErrorAction Stop | Out-Null
		}
	}
	catch {
		Log "ERROR: Failed to create directory '$value'" -level Error
		Log "" -level Error
		$error[0] | Log -level Error

		return $false
	}

	return (Resolve-Path $value).ProviderPath
}


###########################################################################
#

function LoadConfigSettings(
	[Parameter(Mandatory=$true)][ValidateScript({[System.IO.Path]::IsPathRooted($_)})][string]$settingsFile,
	[System.Collections.ArrayList]$moduleConfigs
)
{
	if (Test-Path $settingsFile) {
		Log "Loading config settings from '$settingsFile'"
		$s = Get-Content $settingsFile
		if ($s.Count -gt 0) {
			try {
				$configSettings = Invoke-Expression ([string]::Join("`n", $s))
			}
			catch {
				Log "Failed to load config settings file '$settingsFile': $_" -level Error
				Log $Error[0].InvocationInfo.PositionMessage -level Error
				return $false
			}
		}
	}

	if (!$configSettings) {
		$configSettings = @{}
	}

	$configSettings["__SettingsFile"] = $settingsFile
	$configSettings["__ModuleConfigs"] = $moduleConfigs

	Set-Variable -name GlobalConfigSettings -value $configSettings -scope global

	return $true
}


###########################################################################
#

function SaveConfigSetting([Hashtable]$settings, [string]$name, [switch]$dumpDefaults, [string]$default, [switch]$optional, [string]$settingsFile)
{
	if ($settings -and $settings.Contains($name)) {
		$v = $settings[$name]
	} elseif ($dumpDefaults -and $default -ne $null) {
		$v = $default
	} elseif ($dumpDefaults -and $optional) {
		$v = ""
	} else {
		$v = $null
	}

	if ($v -ne $null) {
		# Escape quotes
		$v = $v -replace '`', '``' -replace '"', '`"' -replace '\$', '`$'

		"`t$name = `"$v`"" >> $settingsFile
	} else {
		"`t# $name = `"`"" >> $settingsFile
	}

	"" >> $settingsFile
}


###########################################################################
# Generates PowerShell code to build a hashtable containing
# configuration settings. Generated code is saved to $settingsFile.

function SaveConfigSettings([string]$settingsFile, [System.Collections.ArrayList]$moduleConfigs, [switch]$dumpDefaults, [Hashtable]$settings)
{
	$newSettingsFile = Join-Path $env:TEMP (Split-Path -Leaf $settingsFile)

	"# This file contains bbadmin configuration settings." > $newSettingsFile
	"#" >> $newSettingsFile
	"# The values of configuration settings specified in this file may be" >> $newSettingsFile
	"# manually edited. However be aware that any *other* types of changes made in" >> $newSettingsFile
	"# this file are likely to be lost the next time the file is" >> $newSettingsFile
	"# automatically generated/saved." >> $newSettingsFile
	"#" >> $newSettingsFile
	"# Generated at $(Get-Date -format "yyyy-MM-dd HH:mm:ss") on $(hostname)" >> $newSettingsFile
	"" >> $newSettingsFile
	"@{" >> $newSettingsFile

	$dumpedSettings = @{}

	$moduleConfigs |
	%{
		$config = $_
		$dumpedConfigFile = $false
		$_.Xml.Configuration.Setting
	} |
	? { $_.Name } |
	%{
		if (!$dumpedConfigFile) {
			"" >> $newSettingsFile
			"`t######################################################################" >> $newSettingsFile
			"`t# Configuration settings for module $($config.ModulePath)" >> $newSettingsFile
			"`t######################################################################" >> $newSettingsFile
			"" >> $newSettingsFile

			$dumpedConfigFile = $true
		}

		if ($_.Prompt) {
			"`t# $($_.Prompt)" >> $newSettingsFile
		}

		$optional = $_.Optional -and $_.Optional.ToLower() -eq "true"
		SaveConfigSetting $settings $_.Name $dumpDefaults $_.Default -optional:$optional -settingsFile $newSettingsFile

		$dumpedSettings[$_.Name] = $true
	}

	$dumpedConfigFile = $false
	$settings.Keys |
	? { -not ($_ -match "^__") -and -not $dumpedSettings[$_] } |
	%{
		if (!$dumpedConfigFile) {
			"" >> $newSettingsFile
			"`t######################################################################" >> $newSettingsFile
			"`t# General non-predefined configuration settings" >> $newSettingsFile
			"`t######################################################################" >> $newSettingsFile
			"" >> $newSettingsFile

			$dumpedConfigFile = $true
		}

		SaveConfigSetting $settings $_ $dumpDefaults "" -optional:$false -settingsFile $newSettingsFile

		$dumpedSettings[$_] = $true
	}

	"}" >> $newSettingsFile

	try {
		Move-Item $newSettingsFile $settingsFile -Force -ErrorAction Stop
	}
	catch {
		Log "ERROR: Moving '$newSettingsFile' to '$settingsFile' failed" -level Error
		Log "" -level Error
		$error[0] | Log -level Error
	}

	Log ""
	Log "Configuration settings have been saved."
	Log "Edit the following file to review or modify settings:"
	Log $settingsFile
	Log ""
}


######################################################################
#

function SetConfigValue([string]$settingName, [string]$value)
{
	$GlobalConfigSettings[$settingName] = $value

	SaveConfigSettings $GlobalConfigSettings["__SettingsFile"] $GlobalConfigSettings["__ModuleConfigs"] $GlobalConfigSettings
}


############################################################
# Prompt the user to enter the value for a configuration setting

function PromptForSetting([string]$prompt, [string]$validateFunction, [string]$defaultValue, [switch]$optional)
{
	if ($quiet) {
		throw "Prompt for setting value is required, but quiet (non-interactive) mode is enabled. Prompt was: $prompt"
	}

	while ($true) {
		$v = Read-Host -prompt $prompt

		if (!$v -and $defaultValue) {
			$v = $defaultValue
		}

		if ($validateFunction) {
			$v = Invoke-Expression "$validateFunction `$v"
			if ($v -eq $false) {
				continue
			}
		} elseif (!$optional -and !$v) {
			Write-Warning "Value must be specified"
		}

		if ($v -or $optional) {
			Log "Prompted for config setting value: $prompt" -noHost
			Log "Supplied value: $v" -noHost

			return $v
		}
	}
}


######################################################################
#

function GetConfigValue([Parameter(Mandatory=$true)][string]$settingName, [string]$prompt, [string]$default, [switch]$noPrompt, [switch]$encrypt)
{
	if ($GlobalCommandLineSettings -and $GlobalCommandLineSettings.ContainsKey($settingName)) {
		$v = $GlobalCommandLineSettings[$settingName]
		Log "Returning value from command line for config setting '$settingName': $v" -level Debug
		return $v
	}

	$setting = $null
	foreach ($mc in $GlobalConfigSettings["__ModuleConfigs"]) {
		foreach ($setting in $mc.Xml.Configuration.Setting | ?{ $_.Name -eq $settingName }) {
			Log "Found config setting '$settingName' in $($mc.ConfigFile)" -level Debug
			break
		}
	}

	if (!$setting) {
		Log "NOTE: Failed to find config setting '$settingName' in any bbadmin.config file" -level Debug
	}

	if (!$GlobalConfigSettings.ContainsKey($settingName) -or ($setting -and $setting.AlwaysPrompt -and $setting.AlwaysPrompt.ToLower() -eq "true")) {
		Log "Need to obtain value for config setting '$settingName'" -level Debug

		if ($setting) {
			if (-not $prompt) {
				$prompt = $setting.Prompt
			}
			$validate = $setting.Validate
			if (-not $default) {
				$default = $setting.Default
			}

			$optional = ($setting.Optional -and $setting.Optional.ToLower() -eq "true")
			if (!$encrypt) {
				$encrypt = ($setting.Encrypt -and $setting.Encrypt.ToLower() -eq "true")
			}
		}

		if (!$prompt) {
			$prompt = "Enter value for '$settingName'"
		}

		if ($noPrompt) {
			$value = $default
		} elseif ($encrypt) {
			$value = "enc:" + (EncryptForLocalMachine (GetPasswordFromConsole $prompt -verify))
		} else {
			$value = PromptForSetting $prompt $validate $default -optional:$optional
		}

		SetConfigValue $settingName $value
	}

	$v = $GlobalConfigSettings[$settingName]
	Log "Returning value for config setting '$settingName': $v" -level Debug

	if ($v.StartsWith("enc:")) {
		# Value has "enc:" prefix indicating that the value may be encrypted. Check that
		# the config setting really is configured to be encrypted, and if so, decrypt it.

		foreach ($mc in $GlobalConfigSettings["__ModuleConfigs"]) {
			foreach ($s in $mc.Xml.Configuration.Setting) {
				if ($s.Name -eq $settingName) {
					if ($s.Encrypt -and $s.Encrypt.ToLower() -eq "true") {
						try {
							return UnencryptForLocalMachine $v.Substring(4)
						}
						catch {
							# If an exception occurs while decrypting we assume
							# we have a situation where the encrypted value
							# cannot be decrypted on this machine. In that case
							# we delete the encrypted value, and recursively
							# call GetConfigValue to retrieve a fresh value for
							# the setting.

							$GlobalConfigSettings.Remove($settingName)
							return GetConfigValue $settingName $prompt $default -noPrompt:$noPrompt
						}
					}

					return $v
				}
			}
		}
	}

	return $v
}


###########################################################################
# Replaces references of the form "$(ConfigVariableName)" in $string
# with the actual value of the specified configuration variable.

function ReplaceConfigValueReferences([string]$string)
{
	$result = $string

	while ($string -match "\`$\(.*\)") {
		$varName = $string -replace ".*\`$\((.*)\).*", "`$1"

		$varValue = GetConfigValue $varName
		$result = $result -replace "\`$\($varName\)", $varValue
		$string = $string -replace "\`$\($varName\)", ""
	}

	return $result
}


###########################################################################
# Copy a set of files/directories to a specified file or directory.
#
# Usage example:
#
# function ConfigureImportProcedures
# {
# 	$targetDir = "c:\Somewhere"
# 	Log "Installing files to '$targetDir'"
#
# 	$source = (
# 		(Join-Path $ScriptPath "Dir1"),
# 		((Join-Path $ScriptPath "AFile.txt"), "TargetFileNameForRename.txt")
# 	)
#
# 	if (!(CopyFiles $source $targetDir)) {
# 		return $false
# 	}
#
# 	Log "Files installed"
# 	return $true
# }

function CopyFiles($from, [string]$to)
{
	foreach ($f in $from) {
		if ($f.Count -eq 2) {
			$target = Join-Path $to $f[1]
			$f = $f[0]
		} else {
			$target = $to
		}

		try {
			Log "`t$f"
			Copy-Item $f $target -Recurse -Force -ErrorAction Stop
		}
		catch {
			Log "ERROR: Copying '$f' to '$target' failed" -level Error
			Log "" -level Error
			$error[0] | Log -level Error

			return $false
		}
	}

	return $true
}


###########################################################################
# Execute a command. Return $true if executed successfully, or $false
# on any error or a non-0 exit code from the process is returned.

function ExecuteProcess([string]$exe, [string[]]$arguments, [string]$workingDirectory = ".", [int[]]$goodExitCodes = (0), [string[]]$hiddenArguments)
{
	Log "Executing command:"

	$quotedExe = $exe -replace "(.* .*)", "`"`$1`""
	if ($arguments) {
		$filteredArgs = $arguments | %{ if ($hiddenArguments -contains $_) { "<hidden>" } else { $_ } }
		Log "$quotedExe $filteredArgs"
	} else {
		Log $quotedExe
	}

	try {
		$p = New-Object System.Diagnostics.Process

		$pinfo = $p.StartInfo
		$pinfo.FileName = $exe
		$pinfo.RedirectStandardError = $true
		$pinfo.RedirectStandardOutput = $true
		$pinfo.UseShellExecute = $false
		$pinfo.Arguments = $arguments

		$pwd = pwd
		if ($pwd.Provider.Name -ne "FileSystem") { # Take care to avoid strangeness if pwd is not a filesystem directory
			$pwd = $env:TEMP
		} else {
			$pwd = $pwd.ProviderPath
		}
		$pinfo.WorkingDirectory = JoinPathIfRelative $workingDirectory $pwd

		$messageData = @{
			hadAnyOutput = $false;
			Log = $function:Log;
			LastOutput = [DateTime]::Now;
			HandleOutput = {
				param($event, [System.Object] $sender, [System.Diagnostics.DataReceivedEventArgs] $e, [string] $level)

				if (!$e.Data) {
					return
				}

				if (!$event.MessageData.hadAnyOutput) {
					$event.MessageData.Log.Invoke("Process output:")
					$event.MessageData.Log.Invoke("===============================================================================")
					$event.MessageData.hadAnyOutput = $true
				}

				$event.MessageData.Log.Invoke($e.data, $false, $level)
			}
		}

		$errEvent = Register-ObjectEvent -InputObj $p -Event "ErrorDataReceived" -MessageData $messageData `
			-Action {
				param([System.Object] $sender, [System.Diagnostics.DataReceivedEventArgs] $e)
				$event.MessageData.LastOutput = [DateTime]::Now
				$event.MessageData.HandleOutput.Invoke($event, $sender, $e, "Error")
			}

		$outEvent = Register-ObjectEvent -InputObj $p -Event "OutputDataReceived" -MessageData $messageData `
			-Action {
				param([System.Object] $sender, [System.Diagnostics.DataReceivedEventArgs] $e)
				$event.MessageData.LastOutput = [DateTime]::Now
				$event.MessageData.HandleOutput.Invoke($event, $sender, $e, "Info")
			}

		$p.Start() | Out-Null
		$p.BeginOutputReadLine()
		$p.BeginErrorReadLine()
		$p.WaitForExit()

		# Busy-wait until all asynchronous output appears to have come through before proceeding
		$messageData.LastOutput = [DateTime]::Now
		while (([DateTime]::Now - $messageData.LastOutput).TotalMilliseconds -lt 250) { }

		if ($messageData.hadAnyOutput) {
			Log "==============================================================================="
		}
	}
	catch {
		Log "ERROR: Failed to invoke command" -level Error
		Log "" -level Error
		$error[0] | Log -level Error
		return $false
	}

	Log ("Command terminated with exit code {0}" -f $p.ExitCode)
	Log ""

	return $goodExitCodes -Contains $p.ExitCode
}


###########################################################################
# Prompt the user for credentials, and validate them against the
# target domain $targetName

function GetCredentials([string]$prompt, [string]$caption, [string]$message, [string]$userName, [string]$targetName, [switch]$noCheck)
{
	if ($g_CachedCredentials) {
		$cred = $g_CachedCredentials.Get_Item($userName)
		if ($cred)
		{
			Log "Reusing credentials for the user `"$userName`" entered earlier"
			return $cred
		}
	}

	if ($quiet) {
		throw "Prompt for credentials is required, but quiet (non-interactive) mode is enabled. Prompt was: $prompt"
	}

	Add-Type -AssemblyName System.DirectoryServices.AccountManagement

	Write-Host $prompt

	while ($true) {
		$cred = $Host.UI.PromptForCredential($caption, $message, $userName, $targetName)
		if (!$cred) { # Cancelled?
			return $null
		}

		Write-Host ""

		if ($noCheck) {
			$validated = $true
		} else {
			$domain = $cred.UserName -replace "\\.*", ""
			if ($domain) {
				$ds = New-Object System.DirectoryServices.AccountManagement.PrincipalContext([System.DirectoryServices.AccountManagement.ContextType]::Domain, $domain)
			} else {
				$ds = New-Object System.DirectoryServices.AccountManagement.PrincipalContext([System.DirectoryServices.AccountManagement.ContextType]::Machine, $env:COMPUTERNAME)
			}

			try {
				$validated = $ds.ValidateCredentials(($cred.UserName -replace ".*\\", ""), $cred.GetNetworkCredential().Password)
			}
			catch
			{
				$validated = $false
				# Ignore exception
			}
		}

		if ($validated) {
			# Cache the credentials so that the user doesn't get prompted every time the same account's credentials are needed.
			if (!$g_CachedCredentials) {
				Set-Variable -Scope script -Name g_CachedCredentials -Value @{}
			}
			$g_CachedCredentials.Set_Item($cred.UserName, $cred)

			return $cred
		}

		Write-Warning "Failed to verify username $($cred.UserName) and password. Please try again..."
	}
}


###########################################################################
#

function GetPasswordFromConsole([string]$prompt, [switch]$verify)
{
	if ($quiet) {
		throw "Prompt for password is required, but quiet (non-interactive) mode is enabled. Prompt was: $prompt"
	}

	while ($true)
	{
		$p = Read-Host -Prompt $prompt -AsSecureString
		$p = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($p))
		if (!$verify) {
			return $p
		}

		$p2 = Read-Host -Prompt "Repeat password" -AsSecureString
		$p2 = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto([System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($p2))
		if ($p2 -eq $p) {
			return $p
		}

		Write-Warning "Passwords do not match; please try again"
	}
}


###########################################################################
#

function EnsureSqlModuleLoaded
{
	# Attempt to load SQL snapins
	# First attempt to load SQL Server 2008 snapins
	Add-PSSnapin SqlServerCmdletSnapin100 -ErrorAction SilentlyContinue
	Add-PSSnapin SqlServerProviderSnapin100 -ErrorAction SilentlyContinue

	# Now attempt to load SQL Server 2012 snapins
	Push-Location
	Import-Module sqlps -DisableNameChecking -ErrorAction SilentlyContinue
	Pop-Location

	if (!(Get-Command Invoke-Sqlcmd -ErrorAction SilentlyContinue)) {
		Log "ERROR: The PowerShell command Invoke-Sqlcmd is not defined, possibly because SQL Server PowerShell components are not installed on this server." -level Error
		Log "" -level Error
		Log "If PowerShell 5.0 or later is installed, try installing the SqlServer PowerShell module as follows (this requires an Internet connection):" -level Error
		Log "Install-Module -Name SqlServer" -level Error
		Log "" -level Error
		Log "Alternatively, see the following URL for manual installation guidance: https://www.powershellgallery.com/packages/Sqlserver" -level Error

		return $false
	}

	return $true
}


###########################################################################
#

function GetSQLAccountPassword([string]$prompt, [string]$username, [string]$server)
{
	if (!(EnsureSqlModuleLoaded)) {
		return $false
	}

	while ($true) {
		$p = GetPasswordFromConsole $prompt

		if (!$server) {
			return $p
		}

		# Attempt to open a connection if server is specified
		try {
			Invoke-Sqlcmd -ServerInstance $server -Username $username -Password $p -Query "PRINT ''" -ErrorAction Stop

			return $p
		}
		catch {
			Write-Warning "Unable to connect to $server as $username using specified password: $_"
			Write-Warning "Please try again"
		}
	}
}


###########################################################################
#

function DisableScheduledTask([string]$taskName)
{
	$ok = ExecuteProcess "schtasks.exe" ("/change", "/tn", "`"$taskName`"", "/disable")

	if (!$ok) {
		Log ""
		Log "ERROR: Failed to disable scheduled task '$taskName'" -level Error
		return $false
	}

	return $true
}


###########################################################################
#

function CreateScheduledTask([string]$taskName, [string]$commandLine, [string[]]$schedulingOptions, [string]$user, [string]$password)
{
	$args = (
		"/create",
		"/tn", "`"$taskName`"",
		"/tr", ("`"{0}`"" -f ($commandLine -replace '"', '\"')),
		"/f",
		"/ru", $user
	)

	if ($password) {
		$args += ("/rp", $password)
	}

	$args += $schedulingOptions

	$ok = ExecuteProcess "schtasks.exe" $args -hiddenArguments ($password)

	if (!$ok) {
		Log ""
		Log "ERROR: Failed to create scheduled task '$taskName'"
		return $false
	}

	return $true
}


###########################################################################
#

function GetCurrentDomainFQDN
{
	return [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain().Name
}


###########################################################################
#

function GetCurrentDomainDN
{
	return ([ADSI]"").distinguishedName
}


###########################################################################
#

function GetCurrentDomainNetBIOSName
{
	return ([ADSI]"").name

	# Alternate code which some Internet sites suggest should be used:
#	$fqdn = GetCurrentDomainFQDN
#
#	$searcher = New-Object System.DirectoryServices.DirectorySearcher
#	$searcher.SearchRoot = New-Object System.DirectoryServices.DirectoryEntry("LDAP://CN=Partitions," + ([ADSI]"LDAP://RootDSE").configurationNamingContext)
#	$searcher.Filter = "(&(objectClass=crossRef)(dnsRoot=$fqdn)(netBIOSName=*))"
#	$searcher.PropertiesToLoad.Add("nETBIOSName")
#
#	return $searcher.FindAll()[0].Properties.netbiosname
}


###########################################################################
# Create a crypto service provider that can be used by any user to encrypt
# and decrypt values on the local machine.

function CreateCryptoServiceProvider()
{
	$cspParams = New-Object System.Security.Cryptography.CspParameters
	$cspParams.KeyContainerName = "bbadmin"
	$cspParams.Flags = $cspParams.Flags -bor [System.Security.Cryptography.CspProviderFlags]::UseMachineKeyStore

	# Grant access for any user to the key container
	$rule = New-Object System.Security.AccessControl.CryptoKeyAccessRule("Everyone", [System.Security.AccessControl.CryptoKeyRights]::FullControl, [System.Security.AccessControl.AccessControlType]::Allow)

	$cspParams.CryptoKeySecurity = New-Object System.Security.AccessControl.CryptoKeySecurity
	$cspParams.CryptoKeySecurity.SetAccessRule($rule)

	$csp = New-Object System.Security.Cryptography.RSACryptoServiceProvider -ArgumentList 5120, $cspParams
	$csp.PersistKeyInCsp = $true

	return $csp
}


###########################################################################
# Encrypt a string in such a way that it can only be decrypted on the same machine
# that it was encrypted on. The value returned is a string in base 64 format.
#
# Example:
#	$encryptedString = EncryptForLocalMachine("MySecret")
#	$unencryptedString = UnencryptForLocalMachine($encryptedString)

function EncryptForLocalMachine([string]$unencryptedValue)
{
	$csp = CreateCryptoServiceProvider
	$encryptedBytes = $csp.Encrypt([System.Text.Encoding]::UTF8.GetBytes($unencryptedValue), $true)
	return [System.Convert]::ToBase64String($encryptedBytes)
}


###########################################################################
# Decrypt a string that was previously returned by a call to EncryptForLocalMachine
# on the same computer.

function UnencryptForLocalMachine([string]$encryptedValue)
{
	$csp = CreateCryptoServiceProvider
	return [System.Text.Encoding]::UTF8.GetString($csp.Decrypt([System.Convert]::FromBase64String($encryptedValue), $true))
}


###########################################################################
#

function RunSQLCMDScript([string]$script, [string]$dbName, [string]$dbServer, [string[]]$vars)
{
	if (!(EnsureSqlModuleLoaded)) {
		return $false
	}

	$vars += @(
		"DBName=$dbName",
		"DBServer=$dbServer"
	)

	try {
		Log ""
		Log "Executing SQL script '$script' with database $dbName on $dbServer"
		Invoke-Sqlcmd -ServerInstance $dbServer -Database $dbName -InputFile $script -Variable $vars -ErrorAction Stop -Verbose -QueryTimeout 65535 4>&1 | %{ Log $_ }
	}
	catch {
		Log "Error executing SQL script '$script': $_" -level Error
		Log "$($Error[0].InvocationInfo.PositionMessage)" -level Error
		return $false
	}

	Log "`tSQL script successfully executed"
	return $true
}


###########################################################################
# SYNTAX: MakeAbsolute [-path] <string> [-base] <string>
#
# Returns the $path as an absolute path. If the passed in $path is a
# relative path, it is treated as being relative to $base. If the
# passed in $path is already absolute, it is returned unmodified.

function JoinPathIfRelative([string]$path, [string]$base)
{
	if ([System.IO.Path]::IsPathRooted($path)) {
		return $path
	}

	return Join-Path $base $path
}


###########################################################################
#

function LoadScript([string]$script, [string]$configFile, [hashtable]$loadedScripts)
{
	$script = JoinPathIfRelative $script (Split-Path $configFile)

	if (!$loadedScripts.ContainsKey($script)) {
		$loadedScripts[$script] = $true

		try {
			Log "Loading script '$script'" -level Debug
			. $script
		}
		catch {
			Log "Failed to load script '$script' referenced from '$configFile': $_" -level Error
			Log $_.InvocationInfo.PositionMessage -level Error
			return $false
		}
	}

	return $true
}


###########################################################################
# Load bbadmin configuration from an XML file, recursively loading
# modules specified in the file.

function LoadBlackBoxAdminConfig([string]$configFile, [System.Collections.ArrayList]$moduleConfigs)
{
	$configFile = (Get-Item $configFile).FullName	# Ensure $configFile is an absolute path

	if (($moduleConfigs | ?{$_.ConfigFile -eq $configFile}) -ne $null) {
		# Bail out: File has already been loaded
		return $true
	}

	Log "`tLoading bbadmin configuration from '$configFile'" -level Debug

	try {
		$xml = [xml](Get-Content $configFile)
	}
	catch {
		Log "ERROR: Failed to load config file '$configFile': $_" -level Error
		return $false
	}

	Push-Location $BlackBoxAdminPath
	$modulePath = (Split-Path (Resolve-Path $configFile -relative)) -replace "^\.\\", ""
	Pop-Location

	$moduleConfigs.Add(@{ ConfigFile = $configFile; ModulePath = $modulePath; Xml = $xml; DepthFirstOrder = $moduleConfigs.Count })

	foreach ($f in $xml.Configuration.ConfigSettings) {
		if ($f.StoreInRegistry -eq "true") {
			$k = "HKLM:\SOFTWARE\Crayon"
			$n = "BlackBoxAdminSettings"

			$af = (Get-ItemProperty $k -name $n -ErrorAction Ignore).$n

			if (!$af) {
				try {
					do {
						$af = Read-Host -prompt "Enter name of BlackBoxAdmin config settings file for *this* computer (example name: blackbox.settings)"
						$af = JoinPathIfRelative $af (Split-Path $configFile)
					} while (Test-Path $af -PathType Container) # Do not accept a directory name (or if no value is provided at the prompt)

					# Store path to settings file in registry
					New-Item -Path (Split-Path $k) -Name (Split-Path -Leaf $k) -ErrorAction Ignore | Out-Null
					Set-ItemProperty $k -Name $n -Value $af
				}
				catch {
					Log "ERROR: Could not set registry entry $k\$($n): $_" -level Error
					return $false
				}
			}
		}
		elseif ($f.File) {
			$af = JoinPathIfRelative $f.File (Split-Path $configFile)
		}

		if ($af) {
			if (!(LoadConfigSettings $af $moduleConfigs)) {
				return $false
			}
		}
	}

	foreach ($ms in $xml.Configuration.Module) {
		if ($ms.Path) {
			$p = Join-Path (JoinPathIfRelative $ms.Path (Split-Path $configFile)) "bbadmin.config"
			foreach ($f in $p) {
				if (!(Test-Path $f)) {
					Log "WARNING: Config file search path '$f' referenced in '$configFile' does not exist" -level Warning
					continue
				}

				foreach ($f2 in (Get-ChildItem $f)) {
					if (!(LoadBlackBoxAdminConfig $f2 $moduleConfigs)) {
						return $false
					}
				}
			}
		}
	}

	return $true
}


###########################################################################
#

function ListTargets([System.Collections.ArrayList]$moduleConfigs, $pattern)
{
	Write-Host "Targets matching pattern '$pattern':"

	$prevName = $null
	$prevDescription = $null
	$prevModules = @()
	$prevChildTargets = @()

	$moduleConfigs | %{
		$config = $_
		$_.Xml.Configuration.Target
	} |	%{ @{ Target = $_; Config = $config } } |
	?{ $_.Target.Name -and ($_.Target.Name -like "*$pattern*" -or $_.Config.ModulePath -like "*$pattern*") } |
	Sort-Object @{ Expression = { $_.Target.Name } }, @{ Expression = { $_.Config.DepthFirstOrder } } |
	%{
		$target = $_.Target
		$config = $_.Config

		if ($prevName -and $target.Name -ne $prevName) {
			Write-Host "* $($prevName): $prevDescription"
			if ($prevChildTargets.Count -gt 0) {
				Write-Host "`tChild targets: $($prevChildTargets -join ", ")"
			}
			Write-Host "`tModules: $(($prevModules | Sort-Object -Unique) -join ", ")"
			Write-Host ""

			$prevDescription = $null
			$prevModules = @()
			$prevChildTargets = @()
		}

		$prevName = $target.Name
		if ($target.Description) {
			$prevDescription = $target.Description
		}

		$prevModules += $config.ModulePath
		
		$target.Step | ?{ $_.Target } | %{ $prevChildTargets += $_.Target }
	}

	if ($prevName) {
		Write-Host "* $($prevName): $prevDescription"
		if ($prevChildTargets.Count -gt 0) {
			Write-Host "`tChild targets: $($prevChildTargets -join ", ")"
		}
		Write-Host "`tModules: $(($prevModules | Sort-Object -Unique) -join ", ")"
	}
}


###########################################################################
#

function DoLoadStep($step, $target, $moduleConfig, $loadedScripts)
{
	return (. LoadScript $step.Load $moduleConfig.ConfigFile $loadedScripts)
}


###########################################################################
#

function DoCallStep($step, $target, $moduleConfig)
{
	$call = ReplaceConfigValueReferences $step.Call

	Log "Executing PowerShell expression: $call" -level Debug

	# Ensure call is made with current working directory set to the module directory
	Push-Location (Split-Path $moduleConfig.ConfigFile)

	try {
		$result = Invoke-Expression $call
		if ($result -eq $null -or !($result.Equals($true) -or $result.Equals($false))) {
			Log "Scripting error: Call to '$call' returned unexpected value '$result'; `$true or `$false should be returned" -level Error
			return $false
		}
		if (!$result) {
			Log "Error returned from '$call'" -level Error
			return $false
		}
	}
	catch {
		Log "Error from function '$call' for target '$target' in '$($moduleConfig.ConfigFile)': $_" -level Error
		Log "" -level Debug
		Log $_.Exception -level Debug
		Log "" -level Debug
		Log $Error[0].InvocationInfo.PositionMessage -level Error
		return $false
	}
	finally {
		Pop-Location
	}

	return $true
}


###########################################################################
#

function DoSQLStep($step, $target, $moduleConfig)
{
	$script = JoinPathIfRelative (ReplaceConfigValueReferences $step.SQLScript) (Split-Path $moduleConfig.ConfigFile)

	$dbServer = ReplaceConfigValueReferences $step.DBServer
	$dbName = ReplaceConfigValueReferences $step.DBName

	$vars = @()
	if ($step.ConfigSettings) {
		foreach ($setting in $step.ConfigSettings.Split(",")) {
			$parts = $setting.Split("=")
			if ($parts.Count -gt 1) {
				$varName = $parts[0]
				$value = ReplaceConfigValueReferences $parts[1]
			} else {
				$varName = $setting
				$value = GetConfigValue $setting
			}

			if (!$value) {
				$value = "Not set"
			}
			$vars += "$varName=$value"
		}
	}

	return RunSQLCMDScript $script $dbName $dbServer $vars
}


###########################################################################
# Execute an bbadmin target step to configure a scheduled task to
# invoke bbadmin to execute another specified target.
#
# This type of step should be configured similarly to the following in
# an bbadmin.config file:
#
#    <Step ScheduleBlackBoxAdminTarget="TargetToBeExecuted"
#		  BlackBoxAdminSettings="a=b, c=d"
#         TaskName="My Folder\Name of the scheduled task"
#         ScheduleOptions="/sc DAILY /st 01:00:00"
#         RunAs="$(TheServiceAccount)"
#    />
#
# ScheduleBlackBoxAdminTarget: Name of the bbadmin target to be executed
# by the scheduled task.
#
# BlackBoxAdminSettings: Setting values to be passed on the bbadmin.ps1
# command line via the "-settings" argument.
#
# TaskName: Name of the scheduled task to configure.
#
# ScheduleOptions: Command line options (space separated) to pass to
# the schtasks.exe utility.
#
# RunAs: User account to run the scheduled task as. This account may
# be overridden by the user when they are prompted for a password.
# This value may be a literal value (e.g. "MYDOM\serviceac"), or a
# configuration variable reference (e.g. "$(TheServiceAccount)").

function DoScheduleBlackBoxAdminTargetStep($step, $target, $moduleConfig)
{
	$scheduledTarget = $step.ScheduleBlackBoxAdminTarget
	$settings = $step.BlackBoxAdminSettings
	$taskName = $step.TaskName
	$scheduleOptions = $step.ScheduleOptions -split " "
	$psArgs = $step.PowerShellArgs

	if ($settings) { $settings = "-settings $settings" }
	$commandLine = "`"$PSHOME\PowerShell.exe`" $psArgs -Command `"& {'$BlackBoxAdminPath\bbadmin.ps1' $scheduledTarget -quiet $settings}`""

	Log "Configuring scheduled task '$taskName' to run bbadmin target $scheduledTarget"
	Log "Scheduled task command line: $commandLine"

	# Ensure a value for any config settings used by the task is available
	if ($step.ConfigSettings) {
		foreach ($setting in $step.ConfigSettings.Split(",")) {
			GetConfigValue $setting | Out-Null
		}
	}

	$cred = GetCredentials `
		"Requesting credentials for the scheduled task..." `
		"Scheduled task credentials" `
		"Enter user credentials for running scheduled tasks" `
		(ReplaceConfigValueReferences $step.RunAs)

	if (!$cred) { # Cancelled?
		Log "Configuration cancelled by user"
		return $false
	}

	if (!(CreateScheduledTask $taskName $commandLine $scheduleOptions $cred.UserName $cred.GetNetworkCredential().Password)) {
		return $false
	}

	Log "Scheduled task configured successfully"
	return $true
}


###########################################################################
#

function DoTarget([System.Collections.ArrayList]$moduleConfigs, [string]$target, [int]$startStepNumber, [ref]$currentStepNumber, [hashtable]$loadedScripts, [hashtable]$doneTargets)
{
	if (!$loadedScripts) {
		$loadedScripts = @{}
	}

	foreach ($mc in $moduleConfigs) {
		foreach ($l in $mc.Xml.Configuration.Load) {
			if ($l.Script -and !(. LoadScript $l.Script $mc.ConfigFile $loadedScripts)) {
				return $false
			}
		}
	}

	Log "============================================================"
	Log "Execute target '$target'"

	if (!$doneTargets) {
		$doneTargets = @{}
	}

	if ($doneTargets[$target]) {
		Log "Already done target '$target'" -level Debug
		return $true
	}

	$doneTargets[$target] = $true

	$found = $false

	foreach ($mc in $moduleConfigs) {
		foreach ($targetNode in $mc.Xml.Configuration.Target | ?{$_.Name -eq $target}) {
			Log "Found target in '$($mc.ConfigFile)'" -level Debug
			$found = $true

			foreach ($s in $targetNode.Step) {
				Log ""

				if ($s.Load) {
					if (!(. DoLoadStep $s $target $mc $loadedScripts)) {
						return $false
					}
				}

				if ($s.Target) {
					if ($s.If -and !(Invoke-Expression $s.If)) {
						Log "`tNOTE: Target $($s.Target) skipped as condition step expression evaluated to false"
					} elseif (!(DoTarget $moduleConfigs $s.Target $startStepNumber $currentStepNumber $loadedScripts.Clone() $doneTargets)) {
						return $false
					}
				}

				if ($s.Call) {
					$currentStepNumber.Value++
					Log "Executing step $($currentStepNumber.Value) (call $($s.Call))"

					if ($currentStepNumber.Value -lt $startStepNumber) {
						Log "`tNOTE: Step skipped as it is before starting step $startStepNumber"
					}
					elseif ($s.If -and !(Invoke-Expression $s.If)) {
						Log "`tNOTE: Step skipped as condition step expression evaluated to false"
					}
					elseif (!(DoCallStep $s $target $mc)) {
						return $false
					}
				}

				if ($s.SQLScript) {
					$currentStepNumber.Value++
					Log "Executing step $($currentStepNumber.Value) (execute SQL $($s.SQLScript))"

					if ($currentStepNumber.Value -lt $startStepNumber) {
						Log "`tNOTE: Step skipped as it is before starting step $startStepNumber"
					}
					elseif ($s.If -and !(Invoke-Expression $s.If)) {
						Log "`tNOTE: Step skipped as condition step expression evaluated to false"
					}
					elseif (!(DoSQLStep $s $target $mc)) {
						return $false
					}
				}

				if ($s.ScheduleBlackBoxAdminTarget) {
					$currentStepNumber.Value++
					Log "Executing step $($currentStepNumber.Value) (schedule bbadmin target $($s.ScheduleBlackBoxAdminTarget))"

					if ($currentStepNumber.Value -lt $startStepNumber) {
						Log "`tNOTE: Step skipped as it is before starting step $startStepNumber"
					}
					elseif ($s.If -and !(Invoke-Expression $s.If)) {
						Log "`tNOTE: Step skipped as condition step expression evaluated to false"
					}
					elseif (!(DoScheduleBlackBoxAdminTargetStep $s $target $mc)) {
						return $false
					}
				}
			}
		}
	}

	if (!$found) {
		Log "Target '$target' not found" -level Error
		return $false
	}

	return $true
}


###########################################################################
# Main script

switch ($LogLevel) {
	"Error" { $GlobalLogLevel = 0 }
	"Warning" { $GlobalLogLevel = 1 }
	"Info" { $GlobalLogLevel = 2 }
	"Debug" { $GlobalLogLevel = 3 }
}

Log "Loading bbadmin configuration" -level Debug

$ModuleConfigs = New-Object System.Collections.ArrayList
if (!(LoadBlackBoxAdminConfig "$BlackBoxAdminPath\bbadmin.config" $ModuleConfigs)) {
	exit 1
}

Log "Done loading bbadmin configuration" -level Debug
Log "" -level Debug

$logPrefix = (Split-Path -Leaf $BlackBoxAdminName) -replace "\.[^.]*`$", ""
if ($target) {
	$logPrefix += "-$target"
}
InitialiseLogging (GetConfigValue "LogDir") $logPrefix

if ($help) {
	Get-Help $MyInvocation.InvocationName
}

if ($settingsTemplate) {
	SaveConfigSettings $settingsTemplate $ModuleConfigs -dumpDefaults
}

if ($listTargets) {
	ListTargets $ModuleConfigs $listTargets
}

if ($target) {
	$startTime = Get-Date

	# Parse setting values specified on the command line
	$GlobalCommandLineSettings = @{}
	foreach ($s in $settings) {
		if ($s -match "([^=]*)=(.*)") {
			$GlobalCommandLineSettings[$matches[1]] = $matches[2]
			Log "Command line setting: $($matches[1]) = $($matches[2])"
		} else {
			Log "WARNING: Ignoring setting '$s': Not in format <name>=<value>" -level Warning
		}
	}

	$currentStepNumber = 0
	$ok = DoTarget $ModuleConfigs $target $step ([ref]$currentStepNumber)
	$runTime = ((Get-Date) - $startTime).ToString("d\.hh\:mm\:ss")

	if (!$ok) {
		DumpTargetResultToEventLog Error "bbadmin target terminated with error" $target $runTime

		Log "" -level Error
		Log "Execute the following command to restart processing at the point of failure:" -level Error
		Log "" -level Error
		Log "$($MyInvocation.MyCommand.Path) $target -step $currentStepNumber" -level Error
		Log "" -level Error

		Log "Execution time: $runTime"
		Log "bbadmin completed with error (see previous messages for details)" -level Error
		Log ""
		exit 1
	}

	DumpTargetResultToEventLog Information "bbadmin target completed successfully" $target $runTime

	Log ""
	Log "Execution time: $runTime"
	Log "bbadmin completed successfully"
	Log ""
}

exit 0
