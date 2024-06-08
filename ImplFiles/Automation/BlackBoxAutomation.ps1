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


###########################################################################
# Execute a SOAP request

function Execute-SOAPRequest([String]$action, [String]$fid) 
{ 
  # http://localhost/BlackBoxDev/BlackBoxAPIService.asmx?op=ValidateDataFileByID

  #based on the WSDL, create the request
  $body = '<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">
  <soap12:Body>
    <LoadDataFileByID xmlns="http://tempuri.org/">
      <fid>{1}</fid>
      <userid>0</userid>
    </LoadDataFileByID>
  </soap12:Body>
</soap12:Envelope>
' -f $action, $fid

	$LogsPath = GetConfigValue "LogDir"
	$OutputPath = Join-Path $LogsPath "soapResult.xml"

  #make the web request and save the result to an XML file
  (Invoke-WebRequest -UseBasicParsing -UseDefaultCredentials -method Post -Body $body `
     -uri 'http://localhost/BlackBoxDev/BlackBoxAPIService.asmx' `
     -ContentType "text/xml").content | Out-File -FilePath $OutputPath -Force

  #load the file into an XMLDocument object
  $xmlResult = New-Object System.Xml.XmlDocument
  $fn = Resolve-Path($OutputPath)
  $xmlResult.Load($fn)

}


###########################################################################
# Run the BlackBox Validate action

function DoBlackBoxValidateAction
{ 
  ## *************************
  ## EXECUTE SOAP REQUEST
  ## *************************
  
  Log "Executing BlackBox SOAP Request: ValidateDataFileByID(1001)"
  Execute-SOAPRequest "ValidateDataFileByID" "1001"

	return $true
}