##-------------------------------------------------------------------------
## Copyright (C) 2024 Crayon Australia
## This script runs a PowerShell procedure to setup IIS for Blackbox
## Updated: 24/05/2024 8:15
##-------------------------------------------------------------------------

## Get this script name and path
$Global:ScriptName = $MyInvocation.MyCommand.Name
$Global:ScriptPath = $MyInvocation.MyCommand.Path

################################################################################################
## GENERIC CODE - DONT EDIT THIS SECTION ##
#Import-Module -Force (Join-Path  (Split-Path $script:MyInvocation.MyCommand.Path) 'blackbox.psm1')

Import-Module WebAdministration

############################################################
# Mainline

# set key web site config variables
$WebSite = "Default Web Site"
$AppPoolName = "AppPoolBlackBoxUsr"
$WebApp = "BlackBoxUsr"

# announce configuration
Write-Host "Configure IIS for WebApp $WebApp"
Write-Host ""

# check it an AppPool already exists
if (Test-Path IIS:\AppPools\$AppPoolName)
{
  Write-Host "AppPool $AppPoolName already exists"
  #Get-ItemProperty IIS:\AppPools\$AppPoolName | Select-Object *  
}
else
{
  Write-Host "Creating new AppPool $AppPoolName"
  New-WebAppPool -Force -Name $AppPoolName  
}

# set AppPool properties
$AppPoolPath = "IIS:\AppPools\$AppPoolName"
Set-ItemProperty -Path $AppPoolPath -Name managedRuntimeVersion -Value "v4.0"
Set-ItemProperty -Path $AppPoolPath -Name managedPipeLineMode -Value "Integrated"
Set-ItemProperty -Path $AppPoolPath -Name enable32BitAppOnWin64 -Value $true
Set-ItemProperty -Path $AppPoolPath -Name autoStart -Value $true

Set-ItemProperty -Path $AppPoolPath -Name processmodel.identityType -Value 3
Set-ItemProperty -Path $AppPoolPath -Name processmodel.userName -Value "TOYWORLDS\svc-blackbox"
Set-ItemProperty -Path $AppPoolPath -Name processmodel.password -Value "password"

# create WebApplication
Write-Host ""
Write-Host "Recreate WebApplication Configure $WebApp"
New-WebApplication -Force -Name $WebApp -Site $WebSite -PhysicalPath "D:\DevOps\Workspace\BlackBox\BlackBoxWeb" -ApplicationPool $AppPoolName

Write-Host ""
Write-Host "Set web site properties"
$WebSitePath = "IIS:\Sites\$WebSite"

Write-Host ""
Write-Host "Set web app properties"
$WebAppPath = "IIS:\Sites\$WebSite\$WebApp"

#Set-ItemProperty $WebAppPath -Name defaultDocument -Value "Default.aspx"

#Start-IISCommitDelay
Set-ItemProperty $WebAppPath -Name applicationPool -Value $AppPoolName
#Stop-IISCommitDelay

# add virtual directories to WebApplication
Write-Host ""
Write-Host "Configure virtual directories"
New-WebVirtualDirectory -Force -Site $WebSite -Application $WebApp -Name "Adapters" -PhysicalPath "C:\ProgramData\Crayon\BlackBox\Adapters\"
New-WebVirtualDirectory -Force -Site $WebSite -Application $WebApp -Name "Content" -PhysicalPath "C:\ProgramData\Crayon\BlackBox\Content\"
New-WebVirtualDirectory -Force -Site $WebSite -Application $WebApp -Name "Data" -PhysicalPath "C:\ProgramData\Crayon\BlackBox\Data\"
New-WebVirtualDirectory -Force -Site $WebSite -Application $WebApp -Name "Images" -PhysicalPath "C:\ProgramData\Crayon\BlackBox\Images\"
New-WebVirtualDirectory -Force -Site $WebSite -Application $WebApp -Name "Jobs" -PhysicalPath "C:\ProgramData\Crayon\BlackBox\Jobs\"
New-WebVirtualDirectory -Force -Site $WebSite -Application $WebApp -Name "Logs" -PhysicalPath "C:\ProgramData\Crayon\BlackBox\Logs\"
New-WebVirtualDirectory -Force -Site $WebSite -Application $WebApp -Name "Photos" -PhysicalPath "C:\ProgramData\Crayon\BlackBox\Photos\"
New-WebVirtualDirectory -Force -Site $WebSite -Application $WebApp -Name "Scripts" -PhysicalPath "C:\ProgramData\Crayon\BlackBox\Scripts\"
New-WebVirtualDirectory -Force -Site $WebSite -Application $WebApp -Name "Tasks" -PhysicalPath "C:\ProgramData\Crayon\BlackBox\Tasks\"
New-WebVirtualDirectory -Force -Site $WebSite -Application $WebApp -Name "Templates" -PhysicalPath "C:\ProgramData\Crayon\BlackBox\Templates\"

Write-Host "Disable anonymous authentication"
Set-WebConfigurationProperty -Filter '/system.webServer/security/authentication/anonymousAuthentication' -Name 'enabled' -Value 'false' -PSPath 'IIS:\' -Location "$WebSite/$WebApp"

Write-Host "Enable windows authentication"
Set-WebConfigurationProperty -Filter '/system.webServer/security/authentication/windowsAuthentication' -Name 'enabled' -Value 'true' -PSPath 'IIS:\' -Location "$WebSite/$WebApp"

