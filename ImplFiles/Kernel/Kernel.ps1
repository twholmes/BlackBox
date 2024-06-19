###########################################################################
# Copyright (C) 2024 Crayon
# This PowerShell script can be used with bbadmin.ps1 to perform a number
# of system readiness checks prior ti installing FlexNet Manager components
###########################################################################

$ScriptPath = Split-Path (Get-Variable MyInvocation -Scope 0).Value.MyCommand.Path

###########################################################################
# CheckNetworkConnections

function SyncBbAdminSettings
{
  Log "Synch bbadmin settings to registry"  
  try 
  {
    SyncConfigValues | Out-Null
    Log    
  }
  catch 
  {
    Log "Error performing registry synch: $_" -Level "error"
  }
  finally 
  {
    Log
  }
  Log "Done synching bbadmin settings to registry"
  
  return $true
}


