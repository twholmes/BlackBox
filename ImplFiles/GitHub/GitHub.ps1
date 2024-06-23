###########################################################################
# Copyright (C) 2024 Crayon
###########################################################################

###########################################################################
# Copy files from DEV published to GitHub

function CopyDevPublishedToGitHub
{
  ## what is the source?
	$DevPublishedDir = GetConfigValue "DevSourcePublishDir"

  ## which GitHub destination?
	$GitHubBlackBoxDir = GetConfigValue "GitHubBlackBoxDir"
	$GitHubBlackBoxWebSitePath = Join-Path $GitHubBlackBoxDir "WebSite"

  ## remove all existing GitHub website files
  Log ("Cleanup GitHub WebSite folder files {0}" -f $GitHubBlackBoxWebSitePath)
  if (Test-Path $GitHubBlackBoxWebSitePath)
  {  
    Get-ChildItem -Path $GitHubBlackBoxWebSitePath -Include *.* -File -Recurse | foreach { $_.Delete()}
  }  

  ## delete any empty directories left behind after deleting the old files
  #Get-ChildItem -Path $GitHubBlackBoxWebSitePath -Recurse -Force | Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer }) -eq $null } | Remove-Item -Force -Recurse

  ## copy new files from source
  Copy-Item -Path (Join-Path $DevPublishedDir "*") -Recurse -Destination $GitHubBlackBoxWebSitePath -Verbose -Force

	Log "GitHub web site files updated from DEV published"
	return $true
}


###########################################################################
# Copy files from Live ImplFiles to GitHub

function CopyLiveImplFilesToGitHub
{
  ## what is the source?
	$LiveImplFilesDir = GetConfigValue "LiveImplFilesDir"

  ## which GitHub destination?
	$GitHubBlackBoxDir = GetConfigValue "GitHubBlackBoxDir"
	$GitHubBlackBoxImplFilesPath = Join-Path $GitHubBlackBoxDir "ImplFiles"

  ## remove all existing GitHub ImplFiles files
  Log ("Cleanup GitHub ImplFiles folder files {0}" -f $GitHubBlackBoxImplFilesPath)
  if (Test-Path $GitHubBlackBoxImplFilesPath)
  {  
    Get-ChildItem -Path $GitHubBlackBoxImplFilesPath -Include *.* -File -Recurse | foreach { $_.Delete()}
  }  
  
  ## delete any empty directories left behind after deleting the old files
  #Get-ChildItem -Path $GitHubBlackBoxImplFilesPath -Recurse -Force | Where-Object { $_.PSIsContainer -and (Get-ChildItem -Path $_.FullName -Recurse -Force | Where-Object { !$_.PSIsContainer }) -eq $null } | Remove-Item -Force -Recurse

  ## copy ImplFiles from Live
  Copy-Item -Path (Join-Path $LiveImplFilesDir "*") -Recurse -Destination $GitHubBlackBoxImplFilesPath -Verbose -Force

	Log "GitHub ImplFiles files updated from Live"
	return $true
}

