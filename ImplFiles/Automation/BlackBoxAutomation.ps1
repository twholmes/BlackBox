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

function CompleteUploadJob
{ 
  ## *************************
  ## SCRIPT INFO
  ## *************************
  Write-ScriptInfo

	return $true
}

