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
# Format XML output

function Format-XML 
{
  [CmdletBinding()]
  Param ([Parameter(ValueFromPipeline=$true,Mandatory=$true)][string]$xmlcontent)
  $xmldoc = New-Object -TypeName System.Xml.XmlDocument
  $xmldoc.LoadXml($xmlcontent)
  $sw = New-Object System.IO.StringWriter
  $writer = New-Object System.Xml.XmlTextwriter($sw)
  $writer.Formatting = [System.XML.Formatting]::Indented
  $xmldoc.WriteContentTo($writer)
  $sw.ToString()
}

###########################################################################
# Execute a SOAP request

function Execute-SOAPRequest([String]$action, [String]$fid) 
{ 
  # http://localhost/BlackBoxDev/BlackBoxAPIService.asmx?op=ValidateDataFileByID

  #based on the WSDL, create the request
  $body = '<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">
  <soap12:Body>
    <{0} xmlns="http://tempuri.org/">
      <fid>{1}</fid>
      <userid>0</userid>
    </{0}>
  </soap12:Body>
</soap12:Envelope>
' -f $action, $fid

  $LogsPath = GetConfigValue "LogDir"
  $OutputPath = Join-Path $LogsPath "soapResult.xml"

  #make the web request and save the result to an XML file
  (Invoke-WebRequest -UseBasicParsing -UseDefaultCredentials -method Post -Body $body `
     -uri 'http://localhost/BlackBoxDev/BlackBoxAPIService.asmx' `
     -ContentType "text/xml").content | Format-XML | Out-File -FilePath $OutputPath -Force

  #load the file into an XMLDocument object
  $xmlResult = [xml](Get-Content $OutputPath)  

  return $xmlResult
}

###########################################################################
# Execute a SOAP request (process)

function Execute-SOAPProcessRequest([String]$fid, [bool]$scheduledOnly)
{ 
  # http://localhost/BlackBoxDev/BlackBoxAPIService.asmx?op=ValidateDataFileByID

  $param = "false"
  if ($scheduledOnly) { $param = "true" }

  #based on the WSDL, create the request
  $body = '<soap12:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap12="http://www.w3.org/2003/05/soap-envelope">
  <soap12:Body>
    <ProcessDataFileByID xmlns="http://tempuri.org/">
      <fid>{0}</fid>
      <scheduledOnly>true</scheduledOnly>      
      <userid>0</userid>
    </ProcessDataFileByID>
  </soap12:Body>
</soap12:Envelope>
' -f $fid, $param

  Write-Host $body

  $LogsPath = GetConfigValue "LogDir"
  $OutputPath = Join-Path $LogsPath "soapResult.xml"

  #make the web request and save the result to an XML file
  (Invoke-WebRequest -UseBasicParsing -UseDefaultCredentials -method Post -Body $body `
     -uri 'http://localhost/BlackBoxDev/BlackBoxAPIService.asmx' `
     -ContentType "text/xml").content | Format-XML | Out-File -FilePath $OutputPath -Force

  #load the file into an XMLDocument object
  $xmlResult = [xml](Get-Content $OutputPath)  

  return $xmlResult
}

###########################################################################
# Run the BlackBox Validate action

function DoBlackBoxValidateAction
{
  ## *************************
  ## EXECUTE SOAP REQUEST
  ## *************************

  Log "Executing BlackBox SOAP Request: ValidateDataFileByID(1001)"
  $xmlResult = Execute-SOAPRequest "ValidateDataFileByID" "1001"

  $result = $xmlResult.envelope.body.ValidateDataFileByIDResponse.ValidateDataFileByIDResult
  Log ("{0} >> {1}" -f "ValidateDataFileByID", $result)

  return $true
}


###########################################################################
# List all uploaded BlackBox files

function ListBlackBoxFiles
{ 
  $DbServer = GetConfigValue "BlackBoxDBServer"
  $DbName = GetConfigValue "BlackBoxDBName"
  
  $query = "SELECT [FID],[JOBID],[GUID],[Name],[Location],[TypeID],[Group],[Description],[DataSource],[DataSourceInstanceID],[Datasets],[StatusID],[Locked],[TimeStamp] FROM [dbo].[BlackBoxFiles]"

  $con = new-object System.Data.SqlClient.SqlConnection
  $con.ConnectionString = "Server=$DbServer;Database=$DbName;Integrated Security=true"
  try
  {
    $con.Open()
    $cmd = $con.CreateCommand()
    $cmd.CommandText = $query 
    $dt = new-object System.Data.DataTable
    $rdr = $cmd.ExecuteReader()
    $dt.Load($rdr)
    Format-Table -AutoSize -InputObject $dt -Property FID,JOBID,GUID,Name,TypeID,Group,DataSource,DataSourceInstanceID,StatusID,TimeStamp | Out-String -Stream | Write-Host
    #$dt.Rows
  }
  finally
  {
    $con.Close()
  }
  return $true
}

###########################################################################
# Process all uploaded and scheduled BlackBox files

function ProcessScheduledBlackBoxFiles
{ 
  $FileID = GetConfigValue "FileID"

  $DbServer = GetConfigValue "BlackBoxDBServer"
  $DbName = GetConfigValue "BlackBoxDBName"
  
  $query = "SELECT [FID],[JOBID],[GUID],[Name],[Location],[TypeID],[Group],[DataSource],[DataSourceInstanceID],[TimeStamp] FROM [dbo].[BlackBoxFiles] WHERE [StatusID] = 3"

  $con = new-object System.Data.SqlClient.SqlConnection
  $con.ConnectionString = "Server=$DbServer;Database=$DbName;Integrated Security=true"
  try
  {
    $con.Open()
    $cmd = $con.CreateCommand()
    $cmd.CommandText = $query 
    $dt = new-object System.Data.DataTable
    $rdr = $cmd.ExecuteReader()
    $dt.Load($rdr)
    Format-Table -AutoSize -InputObject $dt -Property FID,JOBID,GUID,Name,TypeID,Group,DataSource,DataSourceInstanceID,StatusID,TimeStamp | Out-String -Stream | Write-Host
    #$dt.Rows

    Log ""
    foreach ($row in $dt.Rows)
    {    
      Log ("Processing BlackBox scheduled file: ({0}) {1}" -f $row.FID, $row.Name)
      $xmlResult = Execute-SOAPProcessRequest $row.FID $true
      $result = $xmlResult.envelope.body.ProcessDataFileByIDResponse.ProcessDataFileByIDResult
      Log ("  ProcessDataFileByID({1}) = {0})" -f $result, $true)
      if ($result -eq "true")
      {
      }
      Log ""
    }    
  }
  finally
  {
    $con.Close()
  }
  return $true
}


###########################################################################
# Publish the named BlackBox DataSource

function PublishBlackBoxDataSource
{ 
  $FileID = GetConfigValue "FileID"
  $DataSource = GetConfigValue "DataSource"

  $DbServer = GetConfigValue "BlackBoxDBServer"
  $DbName = GetConfigValue "BlackBoxDBName"
  
  $query = "SELECT [FID],[JOBID],[GUID],[Name],[Location],[TypeID],[Group],[DataSource],[DataSourceInstanceID],[TimeStamp] FROM [dbo].[BlackBoxFiles] WHERE [StatusID] = 3"

  $con = new-object System.Data.SqlClient.SqlConnection
  $con.ConnectionString = "Server=$DbServer;Database=$DbName;Integrated Security=true"
  try
  {
    Log ("Publising: DataSource={0}, FileID={1}" -f $FileID, $DataSource)
  }
  finally
  {
    $con.Close()
  }
  return $true
}
