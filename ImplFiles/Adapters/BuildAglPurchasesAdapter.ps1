##-------------------------------------------------------------------------
## Copyright (C) 2024 Crayon Australia
## This script runs a PowerShell procedure to build a AglPurchases adapter
## Updated: 21/06/2024 14:15
##-------------------------------------------------------------------------

## Get this script name and path
$ScriptName = Split-Path (Get-Variable MyInvocation -Scope 0).Value.MyCommand.Name
$ScriptPath = Split-Path (Get-Variable MyInvocation -Scope 0).Value.MyCommand.Path

############################################################
# Build a AglPurchases adapter

function BuildAglPurchasesAdapter
{
  ## set key web site config variables
  $WebSite = GetConfigValue "WebSiteName"
  $AppPoolName = GetConfigValue "WebAppPool"
  $WebApp = GetConfigValue "WebApplication"

  $WebSitePath = GetConfigValue "WebSitePath"
  $WorkingContentPath = GetConfigValue "WorkingContentPath"
  $BusinessAdaptersDir = Join-Path $WorkingContentPath "BusinessAdapter"
  
  $AdapterFileName = "AglPurchases.XML"
 
  if (Test-Path $BusinessAdaptersDir) 
  {
    Log "BusinessAdapter directory $BusinessAdaptersDir already exists"
  }
  else
  {
    New-Item -Path $WorkingContentPath -Name "BusinessAdapter" -ItemType "directory" | Out-Null  
  }
 
  ## assemble config file parts
  $block1 = @"
<?xml version="1.0" encoding="UTF-8"?>
<configuration>
"@
Out-File -FilePath (Join-Path $BusinessAdaptersDir $AdapterFileName) -InputObject $block1 -Encoding ASCII

  $block2 = @"
<root>
  <ManageSoft connectiontype="default" runintransaction="False" />
  <Imports>
    <Import Type="SqlServer" Name="AglPurchases" Template="Purchase Order" Enabled="True" 
"@
  Out-File -FilePath (Join-Path $BusinessAdaptersDir $AdapterFileName) -InputObject $block2 -Encoding ASCII -Append

  # configure the connection string
  $password = GetConfigValue "AdapterConnectionStringPassword"
  $userid = GetConfigValue "AdapterConnectionStringUserID"
  $database = GetConfigValue "StagingDatabase"
  $cshost = GetConfigValue "AdapterConnectionStringHost"

  $block3format = @"
      ConnectionString="Integrated Security=SSPI;Persist Security Info=False;User ID={1};Initial Catalog={2};Data Source={3}"           
"@
  $block3 = ($block3format -f $password, $userid, $database, $cshost)
  Out-File -FilePath (Join-Path $BusinessAdaptersDir $AdapterFileName) -InputObject $block3 -Encoding ASCII -Append

  ## configure the adapter username and password
  $user = GetConfigValue "AdapterImpersonateUser"
  $userpassword = GetConfigValue "AdapterImpersonateUserPassword"

  $block4format = @"
      Query="
SELECT 
  [ID]
  ,[JobID]
  ,[DataSourceInstanceID]
  ,[LineNumber]
  ,[FlexeraID]
  ,[PO Number]
  ,[PO Line Number]
  ,[Description]
  ,[Date]
  ,[Qty]
  ,[Qty Per Unit]
  ,[Unit Price]
  ,[Unit Price Currency]
  ,[SKU]
  ,[Invoice Number]
  ,[Invoice Date]
  ,[Maintenance]
  ,[Effective Date]
  ,[Expiry Date]
  ,[Contract Number]
  ,[Publisher]
  ,[Vendor]
  ,[Location]
  ,[Cost Center]
  ,[Corporate Unit]
  ,[Purchase Type]
  ,[Request Number]
  ,[Request Date]
  ,[Requestor]
  ,[Authorized by]
  ,[Processed by]
  ,[Comments]
FROM [dbo].[stagedAglPurchases]
  "     
      TimeOut="0" 
      TraceActions="rejected" 
      tracelifetime="1 Month(s)" 
      UsePhysicalTable="True"
      >
"@
  $block4 = ($block4format -f $user, $userpassword)
  Out-File -FilePath (Join-Path $BusinessAdaptersDir $AdapterFileName) -InputObject $block4 -Encoding ASCII -Append

  # configure the log entry
  $logfilesdir = GetConfigValue "LogDir"
  $block5format = @"
      <Log Name="Log" Output="File" LogLevel="Debug" Content="All" FileName="{0}\[DATE][TIME][IMPORT NAME].Log.txt" /> 
"@
  $block5 = ($block5format -f $logfilesdir)
  Out-File -FilePath (Join-Path $BusinessAdaptersDir $AdapterFileName) -InputObject $block5 -Encoding ASCII -Append

  ## configure the body of the adapter
  $block6 = @"
      <Object Type="Vendor" Name="Vendor" Update="False" Create="True" OutputField="vendoroutid">
        <Property Type="vendorname" Name="Name" Update="Never" ValueType="Field Value" Value="Vendor" UseForMatching="True" />
      </Object>
      <Object Type="Contract" Name="Contract_1" Update="True" Create="True" OutputField="Contract_1_ID">
        <Property Type="contractno" Name="Contract No" Update="Do not blank" ValueType="Field Value" Value="MasterContractNumber" UseForMatching="True" Length="60" />
        <Property Type="contractname" Name="Contract Description" Update="Do not blank" ValueType="Field Value" Value="MasterContractName" Length="100" />
        <Property Type="contracttype" Name="Contract Type" Update="Do not blank" ValueType="Field Value" Value="MasterContractType" Length="1000" />
      </Object>
      <Object Type="Location" Name="Location" Update="True" Create="True" OutputField="Location_ID">
        <Property Type="groupcn" Name="Name" Update="Never" ValueType="Field Value" Value="Location" UseForMatching="True" Length="128" RegexSplit="/" />
        <Property Type="groupexid" Name="ID" Update="Never" ValueType="Field Value" Value="Location_ID" UseForMatching="True" MatchingMode="like" DataType="Integer" UseNullValueForMatching="RemoveProperty" />
      </Object>
      <Object Type="CorporateUnit" Name="Corporate Unit" Update="True" Create="True" OutputField="CorporateUnit_ID">
        <Property Type="groupcn" Name="Name" Update="Never" ValueType="Field Value" Value="CorporateStructure" UseForMatching="True" Length="128" RegexSplit="/" />
        <Property Type="groupexid" Name="ID" Update="Never" ValueType="Field Value" Value="CorporateUnit_ID" UseForMatching="True" MatchingMode="like" DataType="Integer" UseNullValueForMatching="RemoveProperty" />
      </Object>
      <Object Type="CostCenter" Name="Cost Center" Update="True" Create="True" OutputField="CostCenter_ID">
        <Property Type="groupcn" Name="Name" Update="Never" ValueType="Field Value" Value="CostCenter" UseForMatching="True" Length="128" RegexSplit="/" />
        <Property Type="groupexid" Name="ID" Update="Never" ValueType="Field Value" Value="CostCenter_ID" UseForMatching="True" MatchingMode="like" DataType="Integer" UseNullValueForMatching="RemoveProperty" />
      </Object>
      <Object Type="Category" Name="Category" Update="True" Create="True" OutputField="Category_ID">
        <Property Type="groupcn" Name="Name" Update="Never" ValueType="Field Value" Value="Category" UseForMatching="True" Length="128" RegexSplit="/" />
        <Property Type="groupexid" Name="ID" Update="Never" ValueType="Field Value" Value="Category_ID" UseForMatching="True" MatchingMode="like" DataType="Integer" UseNullValueForMatching="RemoveProperty" />
      </Object>
      <Object Type="Contract" Name="Contract" Update="True" Create="True" OutputField="Contract_ID">
        <Property Type="contractno" Name="Contract No" Update="Do not blank" ValueType="Field Value" Value="ContractNumber" UseForMatching="True" Length="60" />
        <Property Type="contractname" Name="Contract Description" Update="Do not blank" ValueType="Field Value" Value="ContractName" Length="100" />
        <Property Type="contracttype" Name="Contract Type" Update="Do not blank" ValueType="Field Value" Value="ContractType" Length="1000" />
        <Property Type="contractstatus" Name="Contract Status" Update="Do not blank" ValueType="Field Value" Value="ContractStatus" Length="1000" OnMissingFieldValue="Remove Property" />
        <Property Type="startdate" Name="Start Date" Update="Do not blank" ValueType="Field Value" Value="StartDate" DataType="Date" />
        <Property Type="enddate" Name="Expiry Date" Update="Do not blank" ValueType="Field Value" Value="EndDate" DataType="Date" />
        <Property Type="neverexpires" Name="Evergreen" Update="Do not blank" ValueType="Field Value" Value="NeverExpires" />
        <Property Type="preexpirydate" Name="Review Date" Update="Do not blank" ValueType="Field Value" Value="PreExpiryDate" DataType="Date" />
        <Property Type="renewaldate" Name="Next Renewal Date" Update="Do not blank" ValueType="Field Value" Value="RenewalDate" DataType="Date" />
        <Property Type="monthlyvalue" Name="Monthly Amount" Update="Do not blank" ValueType="Field Value" Value="Monthly amount" DataType="Float" />
        <Property Type="totalvalue" Name="Global Amount" Update="Do not blank" ValueType="Field Value" Value="Global amount" DataType="Float" />
        <Property Type="vendorid" Name="Vendor ID" Update="Do not blank" ValueType="Field Value" Value="vendoroutid" DataType="Integer" />
        <Property Type="comments" Name="Comments" Update="Do not blank" ValueType="Field Value" Value="Comments" />
        <Property Type="lastreneweddate" Name="Last Renewed Date" Update="Do not blank" ValueType="Field Value" Value="Last renewed date" DataType="Date" />
        <Property Type="mastercontractid" Name="Master Contract ID" Update="Do not blank" ValueType="Field Value" Value="Contract_1_ID" DataType="Integer" />
        <Property Type="locationid" Name="Location ID" Update="Do not blank" ValueType="Field Value" Value="Location_ID" Length="128" />
        <Property Type="businessunitid" Name="Corporate Unit ID" Update="Do not blank" ValueType="Field Value" Value="CorporateUnit_ID" Length="128" />
        <Property Type="costcenterid" Name="Cost Center ID" Update="Do not blank" ValueType="Field Value" Value="CostCenter_ID" Length="128" />
        <Property Type="categoryid" Name="Category ID" Update="Do not blank" ValueType="Field Value" Value="Category_ID" Length="128" />
      </Object>
    </Import>
  </Imports>
</root>
"@
  Out-File -FilePath (Join-Path $BusinessAdaptersDir $AdapterFileName) -InputObject $block6 -Encoding ASCII -Append

  Log "Contract.XML written"

  return $true
}

