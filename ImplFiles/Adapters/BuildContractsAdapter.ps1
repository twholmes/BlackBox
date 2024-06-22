##-------------------------------------------------------------------------
## Copyright (C) 2024 Crayon Australia
## This script runs a PowerShell procedure to build a Contracts adapter
## Updated: 21/06/2024 14:15
##-------------------------------------------------------------------------

## Get this script name and path
$ScriptName = Split-Path (Get-Variable MyInvocation -Scope 0).Value.MyCommand.Name
$ScriptPath = Split-Path (Get-Variable MyInvocation -Scope 0).Value.MyCommand.Path

############################################################
# Build a Contracts adapter

function BuildContractsAdapter
{
  ## set key web site config variables
	$WebSite = GetConfigValue "WebSiteName"
	$AppPoolName = GetConfigValue "WebAppPool"
	$WebApp = GetConfigValue "WebApplication"

	$WebSitePath = GetConfigValue "WebSitePath"
	$WorkingContentPath = GetConfigValue "WorkingContentPath"
  $BusinessAdaptersDir = Join-Path $WorkingContentPath "BusinessAdapter"
  
  $AdapterFileName = "Contract.XML"
 
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
    <Import Type="SqlServer" Name="Contract" Template="Contract" Enabled="True" Description="select * from Contracts"
"@
  Out-File -FilePath (Join-Path $BusinessAdaptersDir $AdapterFileName) -InputObject $block2 -Encoding ASCII -Append

  # configure the connection string
  $password = GetConfigValue "AdapterConnectionStringPassword"
  $userid = GetConfigValue "AdapterConnectionStringUserID"
  $database = GetConfigValue "StagingDatabase"
  $cshost = GetConfigValue "AdapterConnectionStringHost" ## fnms-nprd-sql-mi.3bfe2199f719.database.windows.net

  $block3format = @"
      ConnectionString="Password={0};Persist Security Info=True;User ID={1};Initial Catalog={2};Data Source={3}" 
"@
  $block3 = ($block3format -f $password, $userid, $database, $cshost)
  Out-File -FilePath (Join-Path $BusinessAdaptersDir $AdapterFileName) -InputObject $block3 -Encoding ASCII -Append

  ## configure the adapter username and password
  $user = GetConfigValue "AdapterImpersonateUser"
  $userpassword = GetConfigValue "AdapterImpersonateUserPassword"

  $block4format = @"
      Query="select * from Contracts" 
      TimeOut="0" 
      TraceActions="rejected" tracelifetime="1 Month(s)" 
      Impersonate="true" 
      Username="{0}" 
      Password="{1}"
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
      <Object Type="Vendor" Name="Vendor" Update="False" Create="True" UpdateRule="RejectDuplicateRecords" OutputField="Vendor_ID">
        <Property Type="vendorname" Name="Name" Update="Never" ValueType="Field Value" Value="Vendor" UseForMatching="True" Length="64" />
      </Object>
      <Object Type="Contract" Name="Contract" Update="False" Create="True" OutputField="Contract_ID">
        <Property Type="contractno" Name="Contract No" Update="Do not blank" ValueType="Field Value" Value="Contract Number" UseForMatching="True" Length="60" />
      </Object>
      <Object Type="Vendor" Name="Publisher" Update="False" Create="True" UpdateRule="RejectDuplicateRecords" OutputField="Publisher_ID">
        <Property Type="vendorname" Name="Name" Update="Never" ValueType="Field Value" Value="Publisher" UseForMatching="True" Length="64" OnMissingFieldValue="Remove Object" />
      </Object>
      <Object Type="Location" Name="Location" Update="False" Create="True" OutputField="Location_ID">
        <Property Type="groupcn" Name="Name" Update="Never" ValueType="Field Value" Value="Location" UseForMatching="True" Length="128" RegexSplit="/" />
        <Property Type="groupexid" Name="ID" Update="Never" ValueType="Field Value" Value="Location_ID" UseForMatching="True" MatchingMode="like" DataType="Integer" UseNullValueForMatching="RemoveProperty" />
      </Object>
      <Object Type="CorporateUnit" Name="Corporate Unit" Update="False" Create="True" OutputField="CorporateUnit_ID">
        <Property Type="groupcn" Name="Name" Update="Never" ValueType="Field Value" Value="Corporate Unit" UseForMatching="True" Length="128" RegexSplit="/" />
        <Property Type="groupexid" Name="ID" Update="Never" ValueType="Field Value" Value="CorporateUnit_ID" UseForMatching="True" MatchingMode="like" DataType="Integer" UseNullValueForMatching="RemoveProperty" />
      </Object>
      <Object Type="CostCenter" Name="Cost Center" Update="False" Create="True" OutputField="CostCenter_ID">
        <Property Type="groupcn" Name="Name" Update="Never" ValueType="Field Value" Value="Cost Center" UseForMatching="True" Length="128" RegexSplit="/" />
        <Property Type="groupexid" Name="ID" Update="Never" ValueType="Field Value" Value="CostCenter_ID" UseForMatching="True" MatchingMode="like" DataType="Integer" UseNullValueForMatching="RemoveProperty" />
      </Object>
      <Object Type="PurchaseOrder" Name="Purchase Order" Update="True" Create="True" UpdateRule="RejectDuplicateRecords" OutputField="PurchaseOrder_ID">
        <Property Type="purchaseorderno" Name="Purchase Order No" Update="Never" ValueType="Field Value" Value="PO Number" UseForMatching="True" Length="50" />
        <Property Type="purchaseorderdate" Name="Purchase Date" ValueType="Field Value" Value="Effective Date" DataType="Date" OnMissingFieldValue="Remove Property" />
        <Property Type="vendorid" Name="Vendor ID" Update="Do not blank" ValueType="Field Value" Value="Vendor_ID" DataType="Integer" OnMissingFieldValue="Remove Property" />
      </Object>
      <Object Type="PurchaseOrderLine" Name="Purchase Order Line" Update="True" Create="True" UpdateRule="RejectDuplicateRecords" OutputField="PurchaseOrderLine_ID">
        <Property Type="purchaseorderid" Name="Purchase Order ID" Update="Do not blank" ValueType="Field Value" Value="PurchaseOrder_ID" UseForMatching="True" DataType="Integer" />
        <Property Type="sequencenumber" Name="Purchase Order Line Sequence" Update="Do not blank" ValueType="Field Value" Value="PO Line Number" UseForMatching="True" DataType="Integer" />
        <Property Type="purchaseorderdetailtype" Name="Purchase Type" Update="Do not blank" ValueType="Field Value" Value="Purchase Type" OnMissingFieldValue="Remove Object" />
        <Property Type="itemdescription" Name="Description" Update="Do not blank" ValueType="Field Value" Value="Description" Length="250" OnMissingFieldValue="Remove Property" />
        <Property Type="licensepartno" Name="Part No/SKU" Update="Do not blank" ValueType="Field Value" Value="SKU" Length="100" OnMissingFieldValue="Remove Property" />
        <Property Type="quantity" Name="Purchase Quantity" Update="Do not blank" ValueType="Field Value" Value="Qty" DataType="Integer" OnMissingFieldValue="Remove Property" />
        <Property Type="publisherid" Name="Publisher ID" Update="Do not blank" ValueType="Field Value" Value="Publisher_ID" DataType="Integer" OnMissingFieldValue="Remove Property" />
        <Property Type="unitprice" Name="Unit Price" Update="Do not blank" ValueType="Field Value" Value="Unit Price" DataType="Float" OnMissingFieldValue="Remove Property" />
        <Property Type="requestno" Name="Request Number" Update="Do not blank" ValueType="Field Value" Value="Request Number" Length="120" OnMissingFieldValue="Remove Property" />
        <Property Type="invoicedate" Name="Invoice Date" Update="Do not blank" ValueType="Field Value" Value="Invoice Date" DataType="Date" OnMissingFieldValue="Remove Property" />
        <Property Type="invoiceno" Name="Invoice Number" Update="Do not blank" ValueType="Field Value" Value="Invoice Number" Length="50" OnMissingFieldValue="Remove Property" />
        <Property Type="comments" Name="Comments" Update="Do not blank" ValueType="Field Value" Value="Comments" OnMissingFieldValue="Remove Property" />
        <Property Type="effectivedate" Name="Effective Date" Update="Do not blank" ValueType="Field Value" Value="Effective Date" DataType="Date" />
        <Property Type="expirydate" Name="Expiry Date" Update="Do not blank" ValueType="Field Value" Value="Expiry Date" DataType="Date" />
        <Property Type="requestdate" Name="Request Date" Update="Do not blank" ValueType="Field Value" Value="Request Date" DataType="Date" />
        <Property Type="contractid" Name="Contract ID" Update="Do not blank" ValueType="Field Value" Value="Contract_ID" DataType="Integer" />
        <Property Type="locationid" Name="Location ID" Update="Do not blank" ValueType="Field Value" Value="Location_ID" Length="128" />
        <Property Type="businessunitid" Name="Corporate Unit ID" Update="Do not blank" ValueType="Field Value" Value="CorporateUnit_ID" Length="128" />
        <Property Type="costcenterid" Name="Cost Center ID" Update="Do not blank" ValueType="Field Value" Value="CostCenter_ID" Length="128" />
      </Object>
    </Import>
  </Imports>
</root>
"@
  Out-File -FilePath (Join-Path $BusinessAdaptersDir $AdapterFileName) -InputObject $block6 -Encoding ASCII -Append

  Log "Contract.XML written"

  return $true
}

