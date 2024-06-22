###########################################################################
# Copyright (C) 2024 Crayon
###########################################################################


###########################################################################
# Copy adapter files to Beacon BusinessAdapters folder

function CopyAdaptersToBeacon
{
  ## what is the source?
  $WorkingContentPath = GetConfigValue "WorkingContentPath" 
  $WorkingDirPath = Join-Path $WorkingContentPath "BusinessAdapter"  

  ## what is the destination?
  $FNMSBeaconBusinessAdapterDir = GetConfigValue "FNMSBeaconBusinessAdapterDir"  

  ## copy adapter files from source to Beacon BusinessAdapter
  Log "Copy business adapter files:"
  Log ("  from {0}" -f $WorkingDirPath)
  Log ("  to   {0}" -f $FNMSBeaconBusinessAdapterDir)
  if (Test-Path $FNMSBeaconBusinessAdapterDir)
  {
    ## copy new files from source
    Copy-Item -Path (Join-Path $WorkingDirPath "*") -Recurse -Destination $FNMSBeaconBusinessAdapterDir -Verbose
  }
  Log ""

  return $true
}

