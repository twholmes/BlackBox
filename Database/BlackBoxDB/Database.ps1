###########################################################################
# Copyright (C) 2024 Crayon
# Ths contains functions that call the installation scripts for 
# creating and configuring the BlackBox databases.
#
###########################################################################

$ScriptPath = Split-Path (Get-Variable MyInvocation -Scope 0).Value.MyCommand.Path

###########################################################################

function CreateBlackBoxDatabase
{
	if (!(EnsureSqlModuleLoaded)) 
	{
		return $false
	}

	$dbName = GetConfigValue "BlackBoxDBName"
	$dbServer = GetConfigValue "BlackBoxDBServer"
	$vars += @(
		"DBName=$dbName",
		"DBServer=$dbServer"
	)

  $script = "BlackBox.CreateDatabase.sql"
	try 
	{
		Log ""
		Log "Executing SQL script '$script' with database $dbName on $dbServer"
		Invoke-Sqlcmd -ServerInstance $dbServer -Database "master" -InputFile $script -Variable $vars -ErrorAction Stop -Verbose -QueryTimeout 65535 4>&1 | %{ Log $_ }
	}
	catch 
	{
		Log "Error executing SQL script '$script': $_" -level Error
		Log "$($Error[0].InvocationInfo.PositionMessage)" -level Error
		return $false
	}
	Log "SQL script successfully executed"

	return $true
}

