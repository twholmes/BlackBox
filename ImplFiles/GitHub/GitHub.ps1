###########################################################################
# Copyright (C) 2024 Crayon
###########################################################################

###########################################################################
###########################################################################
# Copy files from DEV published to destination

function CopyDevPublishedToDestination([string] $destination)
{
  ## what is the source?
  $DevPublishedDir = GetConfigValue "DevSourcePublishDir"

  ## remove all existing GitHub website files
  Log ("Cleanup GitHub WebSite folder files {0}" -f $destination)
  if (Test-Path $destination)
  {  
    Get-ChildItem -Path $destination -Include *.* -File -Recurse | foreach { $_.Delete()}
  }  

  ## delete any empty directories left behind after deleting the old files
  #Get-ChildItem -Path $destination -Recurse -Force | Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer }) -eq $null } | Remove-Item -Force -Recurse

  ## copy new files from source
  Copy-Item -Path (Join-Path $DevPublishedDir "*") -Recurse -Destination $destination -Verbose -Force
}

###########################################################################
# Copy files from Live ImplFiles to destination

function CopyLiveImplFilesToDestination([string] $destination)
{
  ## what is the source?
  $LiveImplFilesDir = GetConfigValue "LiveImplFilesDir"

  ## remove all existing GitHub ImplFiles files
  Log ("Cleanup GitHub ImplFiles folder files {0}" -f $destination)
  if (Test-Path $destination)
  {  
    Get-ChildItem -Path $destination -Include *.* -File -Recurse | foreach { $_.Delete()}
  }  
  
  ## delete any empty directories left behind after deleting the old files
  #Get-ChildItem -Path $destination -Recurse -Force | Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer }) -eq $null } | Remove-Item -Force -Recurse

  ## copy ImplFiles from Live
  Copy-Item -Path (Join-Path $LiveImplFilesDir "*") -Recurse -Destination $destination -Verbose -Force
}

###########################################################################
# Copy files from Live WorkingContent to GitHub

function CopyLiveWorkingContentToDestination([string] $destination)
{
  ## what is the source?
  $LiveWorkingContentDir = GetConfigValue "LiveWorkingContentDir"

  ## remove all existing GitHub ImplFiles files
  Log ("Cleanup GitHub ImplFiles folder files {0}" -f $destination)
  if (Test-Path $destination)
  {  
    Get-ChildItem -Path $destination -Include *.* -File -Recurse | foreach { $_.Delete()}
  }  
  
  ## delete any empty directories left behind after deleting the old files
  #Get-ChildItem -Path $destination -Recurse -Force | Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer }) -eq $null } | Remove-Item -Force -Recurse

  ## copy WorkingContent from Live
  Copy-Item -Path (Join-Path $LiveWorkingContentDir "*") -Recurse -Destination $destination -Verbose -Force
}

###########################################################################
###########################################################################
# Copy files from DEV published to GitHub

function CopyDevPublishedToGitHub
{
  ## which GitHub destination?
  $GitHubBlackBoxDir = GetConfigValue "GitHubBlackBoxDir"
  $GitHubBlackBoxWebSitePath = Join-Path $GitHubBlackBoxDir "WebSite"

  CopyDevPublishedToDestination $GitHubBlackBoxWebSitePath

  Log "GitHub WorkingContent files updated from Live"
  return $true
}

###########################################################################
# Copy files from Live ImplFiles to GitHub

function CopyLiveImplFilesToGitHub
{
  ## which GitHub destination?
  $GitHubBlackBoxDir = GetConfigValue "GitHubBlackBoxDir"
  $GitHubBlackBoxImplFilesPath = Join-Path $GitHubBlackBoxDir "ImplFiles"

  CopyLiveImplFilesToDestination $GitHubBlackBoxImplFilesPath

  Log "GitHub ImplFiles files updated from Live"
  return $true
}

###########################################################################
# Copy files from Live WorkingContent to GitHub

function CopyLiveWorkingContentToGitHub
{
  ## which GitHub destination?
  $GitHubBlackBoxDir = GetConfigValue "GitHubBlackBoxDir"
  $GitHubBlackBoxWorkingContentPath = Join-Path $GitHubBlackBoxDir "WorkingContent"

  CopyLiveWorkingContentToDestination $GitHubBlackBoxWorkingContentPath

  Log "GitHub WorkingContent files updated from Live"
  return $true
}

###########################################################################
###########################################################################
# Copy files from DEV published to GitHubCrayon

function CopyDevPublishedToGitHubCrayon
{
  ## which GitHub destination?
  $GitHubBlackBoxDir = GetConfigValue "GitHubCrayonBlackBoxDir"
  $GitHubBlackBoxWebSitePath = Join-Path $GitHubBlackBoxDir "WebSite"

  CopyDevPublishedToDestination $GitHubBlackBoxWebSitePath

  Log "CrayonGitHub WorkingContent files updated from Live"
  return $true
}

###########################################################################
# Copy files from Live ImplFiles to GitHubCrayon

function CopyLiveImplFilesToGitHubCrayon
{
  ## which GitHub destination?
  $GitHubBlackBoxDir = GetConfigValue "GitHubCrayonBlackBoxDir"
  $GitHubBlackBoxImplFilesPath = Join-Path $GitHubBlackBoxDir "ImplFiles"

  CopyLiveImplFilesToDestination $GitHubBlackBoxImplFilesPath

  Log "CrayonGitHub ImplFiles files updated from Live"
  return $true
}

###########################################################################
# Copy files from Live WorkingContent to GitHubCrayon

function CopyLiveWorkingContentToGitHubCrayon
{
  ## which GitHub destination?
  $GitHubBlackBoxDir = GetConfigValue "GitHubCrayonBlackBoxDir"
  $GitHubBlackBoxWorkingContentPath = Join-Path $GitHubBlackBoxDir "WorkingContent"

  CopyLiveWorkingContentToDestination $GitHubBlackBoxWorkingContentPath

  Log "CrayonGitHub WorkingContent files updated from Live"
  return $true
}

