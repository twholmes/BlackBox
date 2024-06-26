##-------------------------------------------------------------------------
## Copyright (C) 2024 Crayon Australia
## This script runs a PowerShell procedure to setup IIS for Blackbox
## Updated: 31/05/2024 21:15
##-------------------------------------------------------------------------

############################################################
# Build a BlackBox Web.config file

function BuildWebConfig
{
  # set key web site config variables
	$WebSite = GetConfigValue "WebSiteName"
	$AppPoolName = GetConfigValue "WebAppPool"
	$WebApp = GetConfigValue "WebApplication"

	$WebSitePath = GetConfigValue "WebSitePath"
	$WebSiteContentPath = GetConfigValue "WebSiteContentPath"	

	$WorkerPath = GetConfigValue "WorkerAppPath"

  $WebConfileFileName = "Web.config"
  
  $block1 = @"
<?xml version="1.0" encoding="UTF-8"?>
<configuration>
"@
Out-File -FilePath (Join-Path $WebSitePath $WebConfileFileName) -InputObject $block1 -Encoding ASCII

  $block2 = @"
  <configSections>
    <sectionGroup name="devExpress">
      <section name="themes" type="DevExpress.Web.ThemesConfigurationSection, DevExpress.Web.v22.2, Version=22.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" requirePermission="false" />
      <section name="compression" type="DevExpress.Web.CompressionConfigurationSection, DevExpress.Web.v22.2, Version=22.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" requirePermission="false" />
      <section name="settings" type="DevExpress.Web.SettingsConfigurationSection, DevExpress.Web.v22.2, Version=22.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" requirePermission="false" />
      <section name="errors" type="DevExpress.Web.ErrorsConfigurationSection, DevExpress.Web.v22.2, Version=22.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" requirePermission="false" />
      <section name="resources" type="DevExpress.Web.ResourcesConfigurationSection, DevExpress.Web.v22.2, Version=22.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" requirePermission="false" />
    </sectionGroup>
    <sectionGroup name="applicationSettings" type="System.Configuration.ApplicationSettingsGroup, System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089">
      <section name="BlackBox.Properties.Settings" type="System.Configuration.ClientSettingsSection, System, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089" requirePermission="false" />
    </sectionGroup>
  </configSections>
"@
Out-File -FilePath (Join-Path $WebSitePath $WebConfileFileName) -InputObject $block2 -Encoding ASCII -Append

  ## configure the connection scrings
  $block3 = @"
  <connectionStrings>
    <add name="FnmsConnectionString" connectionString="XpoProvider=MSSqlServer;data source=localhost;integrated security=SSPI;initial catalog=FNMSCompliance" />
    <add name="BlackBoxConnectionString" connectionString="Data Source=localhost;Initial Catalog=FNMSStaging;Integrated Security=True" providerName="System.Data.SqlClient" />
    <add name="FlexeraConnectionString" connectionString="Data Source=localhost;Initial Catalog=FNMSCompliance;Integrated Security=True" providerName="System.Data.SqlClient" />
    <add name="FNMSComplianceConnectionString" connectionString="Data Source=localhost;Initial Catalog=FNMSCompliance;Integrated Security=True" providerName="System.Data.SqlClient" />
  </connectionStrings>
"@
  $block3A = @"
  <connectionStrings>
"@
  Out-File -FilePath (Join-Path $WebSitePath $WebConfileFileName) -InputObject $block3A -Encoding ASCII -Append

  $csn = "BlackBoxConnectionString"
  $cshost = "localhost"
  $database = GetConfigValue "BlackBoxDBName"
  $cs = ("    <add name=`"{0}`" connectionString=`"Data Source={1};Initial Catalog={2};Integrated Security=True`" providerName=`"System.Data.SqlClient`" />" -f $csn, $cshost, $database)
  Out-File -FilePath (Join-Path $WebSitePath $WebConfileFileName) -InputObject $cs -Encoding ASCII -Append

  $csn = "BlackBoxStagingConnectionString"
  $cshost = "localhost"
  $database = GetConfigValue "StagingDatabase"
  $cs = ("    <add name=`"{0}`" connectionString=`"Data Source={1};Initial Catalog={2};Integrated Security=True`" providerName=`"System.Data.SqlClient`" />" -f $csn, $cshost, $database)
  Out-File -FilePath (Join-Path $WebSitePath $WebConfileFileName) -InputObject $cs -Encoding ASCII -Append

  $csn = "FnmsConnectionString"
  $cshost = "localhost"
  $database = GetConfigValue "FNMSComplianceDatabase"
  $cs = ("    <add name=`"{0}`" connectionString=`"XpoProvider=MSSqlServer;data source={1};integrated security=SSPI;initial catalog={2}`" />" -f $csn, $cshost, $database)
  Out-File -FilePath (Join-Path $WebSitePath $WebConfileFileName) -InputObject $cs -Encoding ASCII -Append

  $csn = "FlexeraConnectionString"
  $cshost = "localhost"
  $database = GetConfigValue "FNMSComplianceDatabase"
  $cs = ("    <add name=`"{0}`" connectionString=`"Data Source={1};Initial Catalog={2};Integrated Security=True`" providerName=`"System.Data.SqlClient`" />" -f $csn, $cshost, $database)
  Out-File -FilePath (Join-Path $WebSitePath $WebConfileFileName) -InputObject $cs -Encoding ASCII -Append

  $csn = "FNMSComplianceConnectionString"
  $cshost = "localhost"
  $database = GetConfigValue "FNMSComplianceDatabase"
  $cs = ("    <add name=`"{0}`" connectionString=`"Data Source={1};Initial Catalog={2};Integrated Security=True`" providerName=`"System.Data.SqlClient`" />" -f $csn, $cshost, $database)
  Out-File -FilePath (Join-Path $WebSitePath $WebConfileFileName) -InputObject $cs -Encoding ASCII -Append

  $block3B = @"
  </connectionStrings>
"@
  Out-File -FilePath (Join-Path $WebSitePath $WebConfileFileName) -InputObject $block3B -Encoding ASCII -Append

  $block4 = @"
  <system.web>
  	<sessionState timeout="480">
  	</sessionState>
    <compilation debug="true" targetFramework="4.7.2">
      <assemblies>
        <add assembly="DevExpress.Data.v22.2, Version=22.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" />
        <add assembly="DevExpress.Drawing.v22.2, Version=22.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" />
        <add assembly="DevExpress.Web.ASPxThemes.v22.2, Version=22.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" />
        <add assembly="DevExpress.RichEdit.v22.2.Core, Version=22.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" />
        <add assembly="DevExpress.RichEdit.v22.2.Export, Version=22.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" />
        <add assembly="DevExpress.Printing.v22.2.Core, Version=22.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" />
        <add assembly="DevExpress.Web.v22.2, Version=22.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" />
        <add assembly="DevExpress.Spreadsheet.v22.2.Core, Version=22.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" />
        <add assembly="DevExpress.Web.ASPxSpreadsheet.v22.2, Version=22.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" />
        <add assembly="DevExpress.Charts.v22.2.Core, Version=22.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" />
        <add assembly="DevExpress.XtraCharts.v22.2, Version=22.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" />
        <add assembly="DevExpress.XtraCharts.v22.2.Web, Version=22.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" />
        <add assembly="DevExpress.Web.Resources.v22.2, Version=22.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" />
        <add assembly="DevExpress.XtraReports.v22.2.Web, Version=22.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" />
        <add assembly="DevExpress.XtraReports.v22.2.Web.WebForms, Version=22.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" />
        <add assembly="DevExpress.Web.Resources.v22.2, Version=22.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" />
        <add assembly="DevExpress.DataAccess.v22.2, Version=22.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" />
        <add assembly="System.Design, Version=4.0.0.0, Culture=neutral, PublicKeyToken=B03F5F7F11D50A3A" />
      </assemblies>
    </compilation>
    <!-- mode=[Windows|Forms|Passport|None] -->
    <authentication mode="Windows" />
    <authorization>
      <deny users="?" />
      <allow users="*" />
    </authorization>
    <profile>
      <providers>
        <clear />
        <add name="AspNetSqlProfileProvider" type="System.Web.Profile.SqlProfileProvider" connectionStringName="ApplicationServices" applicationName="/" />
      </providers>
    </profile>
    <roleManager enabled="false">
      <providers>
        <clear />
        <add name="AspNetSqlRoleProvider" type="System.Web.Security.SqlRoleProvider" connectionStringName="ApplicationServices" applicationName="/" />
        <add name="AspNetWindowsTokenRoleProvider" type="System.Web.Security.WindowsTokenRoleProvider" applicationName="/" />
      </providers>
    </roleManager>
    <httpHandlers>
      <add type="DevExpress.Web.ASPxUploadProgressHttpHandler, DevExpress.Web.v22.2, Version=22.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" verb="GET,POST" path="ASPxUploadProgressHandlerPage.ashx" validate="false" />
      <add type="DevExpress.Web.ASPxHttpHandlerModule, DevExpress.Web.v22.2, Version=22.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" verb="GET,POST" path="DX.ashx" validate="false" />
    </httpHandlers>
    <httpModules>
      <add type="DevExpress.Web.ASPxHttpHandlerModule, DevExpress.Web.v22.2, Version=22.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" name="ASPxHttpHandlerModule" />
    </httpModules>
    <httpRuntime maxRequestLength="4096" requestValidationMode="4.0" executionTimeout="110" targetFramework="4.7.2" />
    <pages validateRequest="true" clientIDMode="Predictable">
      <controls>
        <add tagPrefix="dx" namespace="DevExpress.Web" assembly="DevExpress.Web.v22.2, Version=22.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" />
      </controls>
    </pages>
    <globalization culture="" uiCulture="" />
  </system.web>
"@
Out-File -FilePath (Join-Path $WebSitePath $WebConfileFileName) -InputObject $block4 -Encoding ASCII -Append

  $block5 = @"
  <system.webServer>
    <modules runAllManagedModulesForAllRequests="true">
      <add type="DevExpress.Web.ASPxHttpHandlerModule, DevExpress.Web.v22.2, Version=22.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" name="ASPxHttpHandlerModule" />
    </modules>
    <handlers>
      <add type="DevExpress.Web.ASPxUploadProgressHttpHandler, DevExpress.Web.v22.2, Version=22.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" verb="GET,POST" path="ASPxUploadProgressHandlerPage.ashx" name="ASPxUploadProgressHandler" preCondition="integratedMode" />
      <add type="DevExpress.Web.ASPxHttpHandlerModule, DevExpress.Web.v22.2, Version=22.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" verb="GET,POST" path="DX.ashx" name="ASPxHttpHandlerModule" preCondition="integratedMode" />
    </handlers>
    <validation validateIntegratedModeConfiguration="false" />
    <security>
      <requestFiltering>
        <requestLimits maxAllowedContentLength="30000000" />
      </requestFiltering>
    </security>
        <defaultDocument>
            <files>
                <clear />
                <add value="Default.htm" />
                <add value="Default.asp" />
                <add value="index.htm" />
                <add value="index.html" />
                <add value="iisstart.htm" />
                <add value="default.aspx" />
            </files>
        </defaultDocument>
  </system.webServer>
  <devExpress>
    <resources>
      <add type="ThirdParty" />
      <add type="DevExtreme" />
    </resources>
    <themes enableThemesAssembly="true" styleSheetTheme="" theme="Office365" customThemeAssemblies="" baseColor="#F87C1D" font="14px 'Segoe UI', Helvetica, 'Droid Sans', Tahoma, Geneva, sans-serif" />
    <compression enableHtmlCompression="false" enableCallbackCompression="true" enableResourceCompression="true" enableResourceMerging="true" />
    <settings accessibilityCompliant="false" doctypeMode="Html5" rightToLeft="false" checkReferencesToExternalScripts="true" protectControlState="true" ieCompatibilityVersion="edge" />
    <errors callbackErrorRedirectUrl="" />
  </devExpress>
"@
Out-File -FilePath (Join-Path $WebSitePath $WebConfileFileName) -InputObject $block5 -Encoding ASCII -Append

  $block6 = @"
  <appSettings>
    <add key="vs:EnableBrowserLink" value="false" />
    <add key="Administrator" value="Administrator" />
    <add key="AdminSecurityGroup" value="Administrators" />
    <add key="LogFileName" value="BlackBox.log" />
    <add key="LogFilesDir" value="C:\\ProgramData\\Crayon\BlackBox\Logs" />
    <add key="DataProvider" value="sql" />
    <add key="SettingsProvider" value="sql" />
    <add key="WebServiceBlackBoxURL" value="http://localhost/ManageSoftServices/BlackBoxAPIService/BlackBoxAPIService.asmx" />
    <add key="WebServiceFnmsURL" value="http://localhost/ManageSoftServices/ComplianceAPIService/ComplianceAPIService.asmx" />
    <add key="OleDbProvider" value="Microsoft.ACE.OLEDB.12.0" />
    <add key="IssuesXmlFilename" value="Provider=Microsoft.Jet.OLEDB.4.0;Data Source=C:\Program Files (x86)\Crayon Australia\BlackBox\WebSite\App_Data\Issues.xml" />
    <add key="ContactsXmlFilename" value="Provider=Microsoft.Jet.OLEDB.4.0;Data Source=C:\Program Files (x86)\Crayon Australia\BlackBox\WebSite\App_Data\Contacts.xml" />
    <add key="SettingsXmlFilename" value="Provider=Microsoft.Jet.OLEDB.4.0;Data Source=C:\Program Files (x86)\Crayon Australia\BlackBox\WebSite\App_Data\Settings.xml" />
    <add key="JetConnectionString" value="Provider=Microsoft.Jet.OLEDB.4.0;Data Source=C:\Program Files (x86)\Crayon Australia\BlackBox\WebSite\App_Data\BlackBox.accdb" />
    <add key="MdbConnectionString" value="Provider=Microsoft.ACE.OLEDB.12.0;Data Source=C:\Program Files (x86)\Crayon Australia\BlackBox\WebSite\App_Data\BlackBox.accdb" />
    <add key="SqlConnectionString" value="Data Source=localhost;Initial Catalog=FNMSStaging;Integrated Security=True" />
    <add key="FlexeraConnectionString" value="Data Source=localhost;Initial Catalog=FNMSCompliance;Integrated Security=True" />
  </appSettings>
"@
Out-File -FilePath (Join-Path $WebSitePath $WebConfileFileName) -InputObject $block6 -Encoding ASCII -Append

  $block7 = @"
  <applicationSettings>
    <BlackBox.Properties.Settings>
      <setting name="LogFilesDir" serializeAs="String">
        <value>C:\ProgramData\Crayon\BlackBox\Logs</value>
      </setting>
      <setting name="LogFilesVirtualDir" serializeAs="String">
        <value>Logs</value>
      </setting>
      <setting name="LogFilesFilter" serializeAs="String">
        <value>*.log</value>
      </setting>
      <setting name="ScriptFilesVirtialDir" serializeAs="String">
        <value>scripts</value>
      </setting>
      <setting name="ContentFilesType" serializeAs="String">
        <value>*</value>
      </setting>
      <setting name="LogFile" serializeAs="String">
        <value>BlackBox.log</value>
      </setting>
      <setting name="ContentFilesDir" serializeAs="String">
        <value>C:\ProgramData\Crayon\BlackBox\Content</value>
      </setting>
      <setting name="JobsFile" serializeAs="String">
        <value>BlackBox.xml</value>
      </setting>
      <setting name="IISLogFilesDir" serializeAs="String">
        <value>C:\inetpub\logs\LogFiles\W3SVC1</value>
      </setting>
      <setting name="RegSettings" serializeAs="String">
        <value>SOFTWARE\Wow6432Node\Crayon\BlackBox</value>
      </setting>
      <setting name="OleDbEnabled" serializeAs="String">
        <value>True</value>
      </setting>
      <setting name="IsXmlProvider" serializeAs="String">
        <value>True</value>
      </setting>
      <setting name="IsSqlProvider" serializeAs="String">
        <value>False</value>
      </setting>
      <setting name="IsMdbProvider" serializeAs="String">
        <value>True</value>
      </setting>
      <setting name="IsNullProvider" serializeAs="String">
        <value>True</value>
      </setting>
    </BlackBox.Properties.Settings>
  </applicationSettings>
"@
Out-File -FilePath (Join-Path $WebSitePath $WebConfileFileName) -InputObject $block7 -Encoding ASCII -Append

  $block8 = @"
</configuration>
"@
  Out-File -FilePath (Join-Path $WebSitePath $WebConfileFileName) -InputObject $block8 -Encoding ASCII -Append


  Log "New Web.config written"

  return $true
}

