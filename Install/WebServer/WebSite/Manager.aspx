<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Manager.aspx.cs" Inherits="BlackBox.ManagerPage" Title="BlackBox" %>

<%@ Register assembly="System.Web.DataVisualization, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" namespace="System.Web.UI.DataVisualization.Charting" tagprefix="asp" %>

<%@ Register assembly="DevExpress.Web.v22.2, Version=22.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" namespace="DevExpress.Web" tagprefix="dx" %>
<%@ Register assembly="DevExpress.XtraCharts.v22.2.Web, Version=22.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" namespace="DevExpress.XtraCharts.Web" tagprefix="dx" %>
<%@ Register assembly="DevExpress.XtraCharts.v22.2, Version=22.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" namespace="DevExpress.XtraCharts" tagprefix="dx" %>

<!DOCTYPE html>

<html>

<%--
**** HEADER CONTENT
--%>

<head runat="server" EnableViewState="false">
  <meta charset="UTF-8" />
  <title></title>
  <meta name="viewport" content="width=device-width, user-scalable=no, maximum-scale=1.0, minimum-scale=1.0" />
  <meta http-equiv='refresh' content='14400;url=timeout.aspx' />     
  <link rel="stylesheet" type="text/css" href='<%# ResolveUrl("~/Resources/Style/Content.css") %>' />
  <link rel="stylesheet" type="text/css" href='<%# ResolveUrl("~/Resources/Style/Root.css") %>' />
   
  <link rel="icon" type="image/x-icon" href="~/logo.ico" >    
   
  <script type="text/javascript" src='<%# ResolveUrl("~/Resources/JavaScript/Script.js") %>'></script>   
  <script type="text/javascript" src='<%# ResolveUrl("~/Resources/JavaScript/Site.js") %>'></script>   
   
  <style type="text/css">

  /* Page Content Layout */
  .page-content
  {
      min-height: 100%;
      max-width: 1200px;
      margin: 10px auto;
      padding: 20px 14px 20px 14px;
  } 
  
  </style>
    
  <script type="text/javascript">

  // ///////////////////////
  // master page menu bar functions
  // ///////////////////////
    
  function OnMenuItemClick(s, e) 
  {
    switch(e.item.name) 
    {
      case "TopMenuBlackBox":
          tbSystemMessage.SetText("BlackBox: Version 0.01.0000\nCopyright Crayon Australia 2023");        
          pcSystem.Show();
          btCancel.Focus(); 
          break;

      case "HomeMenuHelpX":
          tbAlertMessage.SetText("This function is currently not available");        
          pcAlert.Show();
          btConfirm.Focus();
          //openURL("./Support/Help.aspx", false);
          break;
             
      case "MainMenuNewTab":
          openURL(window.location.href, true);
          break;            
    }
  }    

  // ///////////////////////
  // page functions
  // ///////////////////////

  // page toolbar
  function updatePageToolbarButtonsState() 
  {
  }

  function OnPageToolbarItemClick(s, e) 
  {
    switch(e.item.name) 
    {
      default:
         break;
    }
  }
 
  // //////////////////////////////////
  // dataset row count grid functions
  // //////////////////////////////////

  // row count grid toolbar functions  
  function OnGridViewDatasetRowCountToolbarItemClick(s, e) 
  {
    if (IsCustomGridViewToolbarCommand(e.item.name)) 
    {
      e.processOnServer=true;
      e.usePostBack=true;
    }
    else
    {
      var fri = GridViewDatasetRowCount.GetFocusedRowIndex();
      switch(e.item.name) 
      {
        case "CustomOpenFile":
           GridViewDatasetRowCount.GetRowValues(fri, 'FID', OnGetGridViewDatasetRowCountRowValues1);
           break;
           
        case "CustomInspectFile":
           GridViewDatasetRowCount.GetRowValues(fri, 'Name;FID', OnGetGridViewDatasetRowCountRowValues2);
           break;
      }
    }
  }

  function OnGetGridViewDatasetRowCountRowValues1(fid)
  {
    openUrlWithParamFromPage("Spreadsheet.aspx", fid, true);        
  }

  function OnGetGridViewDatasetRowCountRowValues2(values)
  {
    var dataset = values[0];
    var fid = values[1];      
    switch(dataset) 
    {
      case "SiteAuditAssetList":
         openUrlWithParamFromPage("RioTinto/InspectSiteAudit.aspx", fid, true);
         break;

      case "SIA":
         openUrlWithParamFromPage("RioTinto/InspectSIA.aspx", fid, true);
         break;
    }
  }

  // row count gridview functions
  function OnGridViewDatasetRowCountInit(s, e) 
  { 
    var toolbar = GridViewDatasetRowCount.GetToolbar(0);  
    if (toolbar != null) 
    {  
    }
  }

  function OnGridViewDatasetRowCountSelectionChanged(s, e) 
  {
    e.processOnServer=true;
    e.usePostBack=true;
  }

  function OnGridViewDatasetRowCountFocusedRowChanged(s, e)
  {
    var fri = GridViewDatasetRowCount.GetFocusedRowIndex();
  }

  // //////////////////////////////////
  // template row count grid functions
  // //////////////////////////////////

  // row count grid toolbar functions  
  function OnGridViewTemplateRowCountToolbarItemClick(s, e) 
  {
    if (IsCustomGridViewToolbarCommand(e.item.name)) 
    {
      e.processOnServer=true;
      e.usePostBack=true;
    }
  }

  // row count gridview functions
  function OnGridViewTemplateRowCountInit(s, e) 
  { 
    var toolbar = GridViewTemplateRowCount.GetToolbar(0);  
    if (toolbar != null) 
    {  
    }
  }
    
  function OnGridViewTemplateRowCountSelectionChanged(s, e) 
  {
    e.processOnServer=true;
    e.usePostBack=true;
  }
 
  function OnGridViewTemplateRowCountFocusedRowChanged(s, e)
  {
    var fri = GridViewTemplateRowCount.GetFocusedRowIndex();
  }

  // //////////////////////////////////
  // file counts grid functions
  // //////////////////////////////////

  // row count grid toolbar functions  
  function OnGridViewFileCountsToolbarItemClick(s, e) 
  {
    if (IsCustomGridViewToolbarCommand(e.item.name)) 
    {
      e.processOnServer=true;
      e.usePostBack=true;
    }
  }

  // row count gridview functions
  function OnGridViewFileCountsInit(s, e) 
  { 
    var toolbar = GridViewFileCounts.GetToolbar(0);  
    if (toolbar != null) 
    {  
    }
  }
    
  function OnGridViewFileCountsSelectionChanged(s, e) 
  {
    e.processOnServer=true;
    e.usePostBack=true;
  }
 
  function OnGridViewFileCountsFocusedRowChanged(s, e)
  {
    var fri = GridViewFileCounts.GetFocusedRowIndex();
  }

  // ///////////////////////
  // page functions
  // ///////////////////////
           
  // page toolbar
  function updatePageToolbarButtonsState() 
  {
  }
    
  function OnPageToolbarItemClick(s, e) 
  {
    switch(e.item.name) 
    {
      default:
         break;
    }
  }

  // ///////////////////////////
  // common grid functions
  // ///////////////////////////
    
  // is the toolbar command custom or standard
  function IsCustomGridViewToolbarCommand(command) 
  {
    var isCustom = false;
    switch(command) 
    {      
      case "CustomOpenFile":
      case "CustomInspectFile":
          //isCustom = true;
          break;

      default:
          break;
    }
    return isCustom;
  }

  // /////////////////////
  // common functions
  // /////////////////////

  // open url in new tab or existing tab
  function openUrlFromPage(url, newtab) 
  {
    if (newtab)
    {
      window.open(url,"_blank");
    }
    else
    {
      window.location.href = url; 
    }        
  }
 
  // open url in new tab or existing tab
  function openUrlWithParamFromPage(baseurl, fid, newtab) 
  {
    //var fid = hfStateValues.Get("FID")    
    var url = baseurl + "?fid=" + fid
    if (newtab)
    {
      window.open(url,"_blank");
    }
    else
    {
      window.location.href = url; 
    }        
  }

  // ***    
  // *** event function declarations
  // ***

  window.OnMenuItemClick = OnMenuItemClick;  
  window.OnPageToolbarItemClick = OnPageToolbarItemClick;

  window.OnGridViewDatasetRowCountInit = OnGridViewDatasetRowCountInit;
  window.OnGridViewDatasetRowCountSelectionChanged = OnGridViewDatasetRowCountSelectionChanged;
  window.OnGridViewDatasetRowCountFocusedRowChanged = OnGridViewDatasetRowCountFocusedRowChanged;  
  window.OnGridViewDatasetRowCountToolbarItemClick = OnGridViewDatasetRowCountToolbarItemClick;    

  window.OnGridViewTemplateRowCountInit = OnGridViewTemplateRowCountInit;
  window.OnGridViewTemplateRowCountSelectionChanged = OnGridViewTemplateRowCountSelectionChanged;
  window.OnGridViewTemplateRowCountFocusedRowChanged = OnGridViewTemplateRowCountFocusedRowChanged;  
  window.OnGridViewTemplateRowCountToolbarItemClick = OnGridViewTemplateRowCountToolbarItemClick;    

  window.OnGridViewFileCountsInit = OnGridViewFileCountsInit;
  window.OnGridViewFileCountsSelectionChanged = OnGridViewFileCountsSelectionChanged;
  window.OnGridViewFileCountsFocusedRowChanged = OnGridViewFileCountsFocusedRowChanged;  
  window.OnGridViewFileCountsToolbarItemClick = OnGridViewFileCountsToolbarItemClick;    

  
  </script>
   
</head>

<body>
   <form id="PageForm" runat="server" class="form">

      <asp:ScriptManager ID="PageScriptManager" runat="server" EnablePageMethods="true">
        <Scripts>
           <asp:ScriptReference Path="~/Resources/JavaScript/Script.js" />
           <asp:ScriptReference Path="~/Resources/JavaScript/Site.js" />
           <asp:ScriptReference Path="~/Resources/JavaScript/Page.js" />
        </Scripts>    
          
      </asp:ScriptManager>   
   
      <div class="content-wrapper">

      <%--
      **** LEFT PANEL
      --%>

   <%-- COLOR SCHEMES: GREY=#E1E1E1, USER=#616161, SYSTEM=#003300, ADMIN=#660033, SUPER-ADMIN=#000066 --%>

   <dx:ASPxPanel runat="server" ID="LeftPanel" ClientInstanceName="leftPanel"
       Collapsible="true" ScrollBars="Auto" FixedPosition="WindowLeft" FixedPositionOverlap="true" Width="220px"
       CssClass="left-panel" Paddings-Padding="0" BackColor="#003300">
       <Styles>
           <ExpandBar CssClass="expand-bar"></ExpandBar>
       </Styles>
       <SettingsAdaptivity CollapseAtWindowInnerWidth="600" />
       <SettingsCollapsing ExpandButton-Visible="true" ExpandEffect="PopupToRight" AnimationType="Slide" Modal="true" >
           <ExpandButton GlyphType="Strips" Position="Center" />
       </SettingsCollapsing>
       <Paddings Padding="0px"></Paddings>
       <PanelCollection>
           <dx:PanelContent>

           <%--<Image IconID="iconbuilder_shopping_box_svg_white_32x32" />--%>
           <%--<Image IconID="dashboards_servermode_svg_white_32x32" />--%>
           <%--<Image IconID="businessobjects_bo_contact_svg_white_32x32" />--%>
           <%--<Image IconID="outlookinspired_buynow_svg_white_32x32" />--%>
           <%--<Image IconID="businessobjects_bo_organization_svg_white_32x32" />--%>                 
           <%--<Image IconID="businessobjects_bo_order_svg_white_32x32" />--%>
           <%--<Image IconID="businessobjects_bo_opportunity_svg_white_32x32" />--%>
           <%--<Image IconID="spreadsheet_chartverticalaxis_logscale_svg_white_32x32" />--%>
           <%--<Image IconID="setup_pagesetup_svg_white_32x32" />--%>
           <%--<Image IconID="setup_properties_svg_white_32x32" />--%>           	           	
           <%--<Image IconID="dashboards_servermode_svg_white_32x32" />--%>

           <%--<Image IconID="businessobjects_bo_contact_svg_white_32x32" />--%>
           <%--<Image IconID="format_listbullets_svg_white_32x32" />--%>
           <%--<Image IconID="iconbuilder_actions_settings_svg_white_32x32" />--%>
           <%--<Image IconID="page_documentmap_32x32white" />--%>

           <%-- this is an user level menu --%>                              
           <dx:ASPxMenu ID="ASPxMenuTop" runat="server" ClientInstanceName="topMenu" Orientation="Vertical" 
               BackColor="#003300" Font-Bold="True" Font-Size="X-Large" ForeColor="White" HorizontalAlign="Left" VerticalAlign="Middle" 
               Width="100%" AllowSelectItem="True" AppearAfter="10" ItemWrap="False" MaximumDisplayLevels="1" LinkStyle-HoverColor="#6699FF">
               <Border BorderColor="#003300" />
               <BorderBottom BorderColor="#003300" BorderWidth="20px" />
               <SettingsAdaptivity Enabled="true" EnableAutoHideRootItems="False" EnableCollapseRootItemsToIcons="true" CollapseRootItemsToIconsAtWindowInnerWidth="200" />                        
               <Items>
                   <dx:MenuItem Name="TopMenuBlackBox" Text="BlackBox">
                       <Image Url="~/Resources/Images/Crayon/crayon.png" Height="32px" Width="36px" />
                       <ItemStyle Font-Bold="True" Font-Size="X-Large" ForeColor="White" HorizontalAlign="Left" />
                   </dx:MenuItem>
               </Items>
               <ItemStyle VerticalAlign="Middle" ForeColor="White">
                   <Font Bold="True" Size="X-Large"></Font>                        
               </ItemStyle>                        
               <LinkStyle>
                   <Font Bold="True" Size="X-Large"></Font>
               </LinkStyle>
               <ClientSideEvents ItemClick="OnMenuItemClick" />
           </dx:ASPxMenu>

           <%-- this is an user level menu --%>
           <dx:ASPxMenu ID="ASPxMenuHome" runat="server" ClientInstanceName="homeMenu" Orientation="Vertical" 
               BackColor="#003300" Font-Bold="False" Font-Size="Large" ForeColor="White" HorizontalAlign="Left" VerticalAlign="Middle" 
               Width="100%" AllowSelectItem="True" AppearAfter="10" ItemWrap="False" MaximumDisplayLevels="1" LinkStyle-HoverColor="#6699FF">
               <Border BorderColor="#003300" />
               <BorderBottom BorderColor="#003300" BorderWidth="20px" />                        
               <SettingsAdaptivity Enabled="true" EnableAutoHideRootItems="False" EnableCollapseRootItemsToIcons="true" CollapseRootItemsToIconsAtWindowInnerWidth="200" />                        
               <Items>
                   <dx:MenuItem Name="HomeMenuLanding" NavigateUrl="~/Default.aspx" Text="Home">
                       <Image IconID="businessobjects_bo_address_svg_white_32x32" />
                   </dx:MenuItem>
               </Items>
               <ItemStyle VerticalAlign="Middle" ForeColor="White">
                   <Font Bold="True" Size="Large"></Font>                        
               </ItemStyle>
               <LinkStyle>
                   <Font Bold="True" Size="Large"></Font>
               </LinkStyle>
               <ClientSideEvents ItemClick="OnMenuItemClick" /> 
           </dx:ASPxMenu>

           <%-- this is an user level menu --%>
           <dx:ASPxMenu ID="ASPxMenuBase" runat="server" ClientInstanceName="systemMenu" Orientation="Vertical" 
               BackColor="#003300" Font-Bold="False" Font-Size="Large" ForeColor="White" HorizontalAlign="Left" VerticalAlign="Middle" 
               Width="100%" AllowSelectItem="True" AppearAfter="10" ItemWrap="False" MaximumDisplayLevels="1" LinkStyle-HoverColor="#6699FF">
               <Border BorderColor="#003300" />
               <BorderBottom BorderColor="#003300" BorderWidth="20px" />                        
               <SettingsAdaptivity Enabled="true" EnableAutoHideRootItems="False" EnableCollapseRootItemsToIcons="true" CollapseRootItemsToIconsAtWindowInnerWidth="200" />                        
               <Items> 
                   <dx:MenuItem Name="MainMenuImports" NavigateUrl="~/Base/Uploads.aspx" Text="Uploads">
                       <Image IconID="scheduling_import_svg_white_32x32" />
                   </dx:MenuItem>
                   <dx:MenuItem Name="MainMenuFileManager" NavigateUrl="~/Base/FileManager.aspx" Text="File Manager">
                     <Image IconID="actions_open2_svg_white_32x32" />
                   </dx:MenuItem>
               </Items>
               <ItemStyle VerticalAlign="Middle" ForeColor="White">
                   <Font Bold="True" Size="Large"></Font>                        
               </ItemStyle>
               <LinkStyle>
                   <Font Bold="True" Size="Large"></Font>
               </LinkStyle>
           </dx:ASPxMenu>

           <%-- this is an user level menu --%>
           <dx:ASPxMenu ID="ASPxMenuITAM" runat="server" ClientInstanceName="itamMenu" Orientation="Vertical" 
               BackColor="#003300" Font-Bold="False" Font-Size="Large" ForeColor="White" HorizontalAlign="Left" VerticalAlign="Middle" 
               Width="100%" AllowSelectItem="True" AppearAfter="10" ItemWrap="False" MaximumDisplayLevels="1" LinkStyle-HoverColor="#6699FF">
               <Border BorderColor="#003300" />
               <BorderBottom BorderColor="#003300" BorderWidth="20px" />                        
               <SettingsAdaptivity Enabled="true" EnableAutoHideRootItems="False" EnableCollapseRootItemsToIcons="true" CollapseRootItemsToIconsAtWindowInnerWidth="200" />                        
               <Items> 
                   <%--
                   <dx:MenuItem Name="MainMenuAssets" NavigateUrl="~/Imports/AssetUploads.aspx?group=ITAM&source=Assets" Text="Assets">
                       <Image IconID="businessobjects_bo_order_svg_white_32x32" />
                   </dx:MenuItem>
                   <dx:MenuItem Name="MainMenuPurchases" NavigateUrl="~/Imports/PurchaseUploads.aspx?group=ITAM&source=Purchases" Text="Purchases">
                       <Image IconID="businessobjects_bo_price_svg_white_32x32" />
                   </dx:MenuItem>
                   --%>
               </Items>
               <ItemStyle VerticalAlign="Middle" ForeColor="White">
                   <Font Bold="True" Size="Large"></Font>                        
               </ItemStyle>
               <LinkStyle>
                   <Font Bold="True" Size="Large"></Font>
               </LinkStyle>
           </dx:ASPxMenu>

           <%-- this is an manager level menu --%>
           <dx:ASPxMenu ID="ASPxMenuAnalysis" runat="server" ClientInstanceName="analysisMenu" Orientation="Vertical" 
               BackColor="#003300" Font-Bold="False" Font-Size="Large" ForeColor="White" HorizontalAlign="Left" VerticalAlign="Middle" 
               Width="100%" AllowSelectItem="True" AppearAfter="10" ItemWrap="False" MaximumDisplayLevels="1" LinkStyle-HoverColor="#6699FF">
               <Border BorderColor="#003300" />
               <BorderBottom BorderColor="#003300" BorderWidth="20px" />                        
               <SettingsAdaptivity Enabled="true" EnableAutoHideRootItems="False" EnableCollapseRootItemsToIcons="true" CollapseRootItemsToIconsAtWindowInnerWidth="200" />                        
               <Items> 
                   <dx:MenuItem Name="MainMenuMetrics" NavigateUrl="~/Imports/Metrics.aspx?group=ITAM&source=Metrics" Text="Metrics">
                       <Image IconID="iconbuilder_business_calculator_svg_white_32x32" />
                   </dx:MenuItem>
               </Items>
               <ItemStyle VerticalAlign="Middle" ForeColor="White">
                   <Font Bold="True" Size="Large"></Font>                        
               </ItemStyle>
               <LinkStyle>
                   <Font Bold="True" Size="Large"></Font>
               </LinkStyle>
           </dx:ASPxMenu>

           <%-- this is an manager level menu --%>
           <dx:ASPxMenu ID="ASPxMenuMiddle" runat="server" ClientInstanceName="middleMenu" Orientation="Vertical" 
               BackColor="#003300" Font-Bold="False" Font-Size="Large" ForeColor="White" HorizontalAlign="Left" VerticalAlign="Middle" 
               Width="100%" AllowSelectItem="True" AppearAfter="10" ItemWrap="False" MaximumDisplayLevels="1" LinkStyle-HoverColor="#6699FF">
               <Border BorderColor="#003300" />
               <BorderBottom BorderColor="#003300" BorderWidth="20px" />                        
               <SettingsAdaptivity Enabled="true" EnableAutoHideRootItems="False" EnableCollapseRootItemsToIcons="true" CollapseRootItemsToIconsAtWindowInnerWidth="200" />                        
               <Items> 
                   <dx:MenuItem Name="MainMenuDummy" NavigateUrl="~/Manager.aspx" Text="Users">
                       <Image IconID="iconbuilder_shopping_box_svg_white_32x32" />
                   </dx:MenuItem>
               </Items>
               <ItemStyle VerticalAlign="Middle" ForeColor="White">
                   <Font Bold="True" Size="Large"></Font>                        
               </ItemStyle>
               <LinkStyle>
                   <Font Bold="True" Size="Large"></Font>
               </LinkStyle>
           </dx:ASPxMenu>
          
           <%-- this is an manager level menu --%>                 
           <dx:ASPxMenu ID="ASPxMenuManager" runat="server" ClientInstanceName="managerMenu" Orientation="Vertical" 
               BackColor="#003300" Font-Bold="False" Font-Size="Large" ForeColor="White" HorizontalAlign="Left" VerticalAlign="Middle" 
               Width="100%" AllowSelectItem="True" AppearAfter="10" ItemWrap="False" MaximumDisplayLevels="1" LinkStyle-HoverColor="#6699FF">
               <Border BorderColor="#003300" />
               <BorderBottom BorderColor="#003300" BorderWidth="20px" />                        
               <SettingsAdaptivity Enabled="true" EnableAutoHideRootItems="False" EnableCollapseRootItemsToIcons="true" CollapseRootItemsToIconsAtWindowInnerWidth="200" />                        
               <Items> 
                   <dx:MenuItem Name="MainMenuTemplates" Text="Templates" NavigateUrl="~/Manager/TemplateUploads.aspx">
                       <Image IconID="scheduling_import_svg_white_32x32" />
                   </dx:MenuItem>       
                   <dx:MenuItem Name="MainMenuContacts" NavigateUrl="~/Manager/Users.aspx" Text="Users">
                       <Image IconID="businessobjects_bo_contact_svg_white_32x32" />
                   </dx:MenuItem>                                     
                   <dx:MenuItem Name="MainMenuLists" NavigateUrl="~/Manager/Lists.aspx" Text="Lists">
                       <Image IconID="format_listbullets_svg_white_32x32" />          	
                   </dx:MenuItem>                                                 
               </Items>
               <ItemStyle VerticalAlign="Middle" ForeColor="White">
                   <Font Bold="True" Size="Large"></Font>                        
               </ItemStyle>
               <LinkStyle>
                   <Font Bold="True" Size="Large"></Font>
               </LinkStyle>
           </dx:ASPxMenu>
           
           <%-- this is an administrator level menu --%>
           <dx:ASPxMenu ID="ASPxMenuAdministrator" runat="server" ClientInstanceName="mainMenu" Orientation="Vertical" 
               BackColor="#003300" Font-Bold="False" Font-Size="Large" ForeColor="White" HorizontalAlign="Left" VerticalAlign="Middle" 
               Width="100%" AllowSelectItem="True" AppearAfter="10" ItemWrap="False" MaximumDisplayLevels="1" LinkStyle-HoverColor="#6699FF">
               <Border BorderColor="#003300" />
               <BorderBottom BorderColor="#003300" BorderWidth="20px" />                     
               <SettingsAdaptivity Enabled="true" EnableAutoHideRootItems="False" EnableCollapseRootItemsToIcons="true" CollapseRootItemsToIconsAtWindowInnerWidth="200" />
               <Items>
                  <dx:MenuItem Name="MainMenuSettings" NavigateUrl="~/Admin/Settings.aspx" Text="Settings">
                      <Image IconID="setup_properties_svg_white_32x32" />
                  </dx:MenuItem>                            
                  <dx:MenuItem Name="MainMenuSystem" NavigateUrl="~/Admin/Logs.aspx" Text="Logs">
                      <Image IconID="scheduling_import_svg_white_32x32" />
                  </dx:MenuItem>
               </Items>
               <ItemStyle VerticalAlign="Middle" ForeColor="White">
                   <Font Bold="True" Size="Large"></Font>                        
               </ItemStyle>
               <LinkStyle>
                   <Font Bold="True" Size="Large"></Font>
               </LinkStyle>
               <ClientSideEvents ItemClick="OnMenuItemClick" />                     
           </dx:ASPxMenu>

           <%-- this is an administrator level menu --%>
           <dx:ASPxMenu ID="ASPxMenuSystem" runat="server" ClientInstanceName="systemMenu" Orientation="Vertical" 
               BackColor="#003300" Font-Bold="False" Font-Size="Large" ForeColor="White" HorizontalAlign="Left" VerticalAlign="Middle" 
               Width="100%" AllowSelectItem="True" AppearAfter="10" ItemWrap="False" MaximumDisplayLevels="1" LinkStyle-HoverColor="#6699FF">
               <Border BorderColor="#003300" />
               <BorderBottom BorderColor="#003300" BorderWidth="20px" />                        
               <SettingsAdaptivity Enabled="true" EnableAutoHideRootItems="False" EnableCollapseRootItemsToIcons="true" CollapseRootItemsToIconsAtWindowInnerWidth="200" />                        
               <Items> 
                   <dx:MenuItem Name="MainMenuFileManager" Text="File Manager" BeginGroup="true" NavigateUrl="~/System/FileManager.aspx">
                       <Image IconID="actions_open2_svg_white_32x32" />
                   </dx:MenuItem>
               	
                   <dx:MenuItem Name="MainMenuJobs" Text="Jobs" BeginGroup="true" NavigateUrl="~/System/Jobs.aspx">
                       <Image IconID="outlookinspired_tasklist_svg_white_32x32" />
                   </dx:MenuItem>
                   <dx:MenuItem Name="MainMenuDatasets" Text="Datasets" BeginGroup="true" NavigateUrl="~/System/Datasets.aspx">
                       <Image IconID="dashboards_updatedataextract_svg_white_32x32" />
                   </dx:MenuItem>
                   <dx:MenuItem Name="MainMenuDataSources" Text="DataSources" NavigateUrl="~/System/DataSources.aspx">
                       <Image IconID="spreadsheet_selectdatasource_svg_white_32x32" />
                   </dx:MenuItem>

                   <dx:MenuItem Name="MainMenuProcessLogs" NavigateUrl="~/System/Logs.aspx" Text="Process Logs">
                       <Image IconID="diagramicons_showprintpreview_svg_white_32x32" />
                   </dx:MenuItem>               
               </Items>
               <ItemStyle VerticalAlign="Middle" ForeColor="White">
                   <Font Bold="True" Size="Large"></Font>                        
               </ItemStyle>
               <LinkStyle>
                   <Font Bold="True" Size="Large"></Font>
               </LinkStyle>
           </dx:ASPxMenu>
                               
           <%-- this is an user level menu --%>                                     
           <dx:ASPxMenu ID="ASPxMenuSupport" runat="server" ClientInstanceName="supportMenu" Orientation="Vertical"
               BackColor="#003300" Font-Bold="False" Font-Size="Large" ForeColor="White" HorizontalAlign="Left" VerticalAlign="Bottom" 
               Width="100%" AllowSelectItem="True" AppearAfter="10" ItemWrap="False" MaximumDisplayLevels="1" LinkStyle-HoverColor="#6699FF">
               <Border BorderColor="#003300" />
               <BorderBottom BorderColor="#003300" BorderWidth="20px" />                        
               <SettingsAdaptivity Enabled="true" EnableAutoHideRootItems="False" EnableCollapseRootItemsToIcons="true" CollapseRootItemsToIconsAtWindowInnerWidth="200" />                        
               <Items>
                   <%--
                   <dx:MenuItem Name="MainMenuNewTab" Text="New Tab">
                       <Image IconID="actions_new_svg_white_32x32" />
                   </dx:MenuItem>
                   --%>
               </Items>
               <ItemStyle VerticalAlign="Middle" ForeColor="White">
                   <Font Bold="True" Size="Large"></Font>                        
               </ItemStyle>
               <LinkStyle>
                   <Font Bold="True" Size="Large"></Font>
               </LinkStyle>
           </dx:ASPxMenu>

           <%-- this is an administrator level menu --%>
           <dx:ASPxMenu ID="ASPxMenuJump" runat="server" ClientInstanceName="jumpMenu" Orientation="Vertical" 
               BackColor="#003300" Font-Bold="False" Font-Size="Large" ForeColor="White" HorizontalAlign="Left" VerticalAlign="Middle" 
               Width="100%" AllowSelectItem="True" AppearAfter="10" ItemWrap="False" MaximumDisplayLevels="1" LinkStyle-HoverColor="#6699FF">
               <Border BorderColor="#003300" />
               <BorderBottom BorderColor="#003300" BorderWidth="20px" />                     
               <SettingsAdaptivity Enabled="true" EnableAutoHideRootItems="False" EnableCollapseRootItemsToIcons="true" CollapseRootItemsToIconsAtWindowInnerWidth="200" />
               <Items>
                  <dx:MenuItem Name="MainMenuManager" Text="Manager" NavigateUrl="~/Manager.aspx">
                          <Image IconID="iconbuilder_shopping_box_svg_white_32x32" />
                  </dx:MenuItem>                            
                  <dx:MenuItem Name="MainMenuAdmin" Text="Admin" NavigateUrl="~/Admin.aspx">
                      <Image IconID="setup_pagesetup_svg_white_32x32" />
                  </dx:MenuItem>                            
               </Items>
               <ItemStyle VerticalAlign="Middle" ForeColor="White">
                   <Font Bold="True" Size="Large"></Font>                        
               </ItemStyle>
               <LinkStyle>
                   <Font Bold="True" Size="Large"></Font>
               </LinkStyle>
               <ClientSideEvents ItemClick="OnMenuItemClick" />                     
           </dx:ASPxMenu>

           <%-- this is an user level menu --%>                                     
           <dx:ASPxMenu ID="ASPxMenuBottom" runat="server" ClientInstanceName="bottomMenu" Orientation="Vertical"
               BackColor="#003300" Font-Bold="False" Font-Size="Large" ForeColor="White" HorizontalAlign="Left" VerticalAlign="Bottom" 
               Width="100%" AllowSelectItem="True" AppearAfter="10" ItemWrap="False" MaximumDisplayLevels="1" LinkStyle-HoverColor="#6699FF">
               <Border BorderColor="#003300" />
               <BorderBottom BorderColor="#003300" BorderWidth="20px" />                        
               <SettingsAdaptivity Enabled="true" EnableAutoHideRootItems="False" EnableCollapseRootItemsToIcons="true" CollapseRootItemsToIconsAtWindowInnerWidth="200" />                        
               <Items>
                   <dx:MenuItem Name="MainMenuLogs" NavigateUrl="~/Support/Logs.aspx" Text="Logs">
                       <Image IconID="diagramicons_showprintpreview_svg_white_32x32" />
                   </dx:MenuItem>                                                 
                   <dx:MenuItem Name="MainMenuHelp" NavigateUrl="~/Help/Content.aspx" Text="Help">
                       <Image IconID="iconbuilder_actions_question_svg_white_32x32" />
                   </dx:MenuItem>                       
                   <%--
                   <dx:MenuItem Name="MainMenuNewTab" Text="New Tab">
                       <Image IconID="actions_new_svg_white_32x32" />
                   </dx:MenuItem>
                   --%>
               </Items>
               <ItemStyle VerticalAlign="Middle" ForeColor="White">
                   <Font Bold="True" Size="Large"></Font>                        
               </ItemStyle>
               <LinkStyle>
                   <Font Bold="True" Size="Large"></Font>
               </LinkStyle>
               <ClientSideEvents ItemClick="OnMenuItemClick" />
           </dx:ASPxMenu>
            
              <table>
                 <tr>
                    <td style="width: 18px">&nbsp&nbsp</td>
                    <td>                           
                    </td>
                 </tr>
              </table>
            
              </dx:PanelContent>
          </PanelCollection>
          <ClientSideEvents Init="onLeftPanelInit" Collapsed="onLeftPanelCollapsed" />
      </dx:ASPxPanel>

      <%--
      **** RIGHT PANEL
      --%>
      
      <dx:ASPxPanel runat="server" ID="RightPanel" ClientInstanceName="rightPanel"
          FixedPosition="WindowRight" FixedPositionOverlap="false" Collapsible="true" Paddings-Padding="0"
          ScrollBars="Auto" Width="650px" CssClass="right-panel" Styles-ExpandBar-CssClass="expand-bar">
          <Styles>
             <ExpandBar CssClass="expand-bar"></ExpandBar>
          </Styles>
          <SettingsCollapsing ExpandButton-Visible="false" ExpandEffect="PopupToLeft" AnimationType="Slide" Modal="true" ExpandOnPageLoad="False" >
             <ExpandButton Visible="False"></ExpandButton>
          </SettingsCollapsing>
          <Paddings Padding="0px"></Paddings>
          <PanelCollection>
              <dx:PanelContent>
                
                  <dx:ASPxPageControl ID="RightPanelPageControl" Width="100%" runat="server" ActiveTabIndex="0" EnableHierarchyRecreation="True" >
                     <TabPages>
                      
                     <%--
                     **** FILE MANAGER TABPAGE
                     --%>

                     <dx:TabPage Text="File Manager" Visible="false">
                        <ContentCollection>
                            <dx:ContentControl ID="RightPanelContentControl1" runat="server">    
              
                            <dx:ASPxFileManager runat="server" ID="fileManager" ClientInstanceName="fileManager" OnFolderCreating="FileManager_FolderCreating"
                                OnItemDeleting="FileManager_ItemDeleting" OnItemMoving="FileManager_ItemMoving" OnCustomThumbnail="OnFileManagerCustomThumbnails"
                                OnItemRenaming="FileManager_ItemRenaming" OnFileUploading="FileManager_FileUploading" OnItemCopying="FileManager_ItemCopying">
                                <Settings RootFolder="~/Jobs" ThumbnailFolder="~/Resources/Thumbnails" 
                                    AllowedFileExtensions=".jpg,.jpeg,.gif,.rtf,.txt,.avi,.png,.mp3,.xml,.doc,.pdf,.html,.csv,.xls,.xlsx,.xml,.zip"
                                    InitialFolder="~/Jobs" />
                                <SettingsEditing AllowCreate="true" AllowDelete="true" AllowMove="true" AllowRename="true" AllowCopy="true" AllowDownload="true" />
                                <SettingsPermissions>
                                    <AccessRules>
                                        <dx:FileManagerFolderAccessRule Path="system" Edit="Deny" />
                                        <dx:FileManagerFileAccessRule Path="system\*" Download="Deny" />
                                    </AccessRules>
                                </SettingsPermissions>
                                <SettingsFolders Visible="False" />                                    
                                <SettingsFileList ShowFolders="true" ShowParentFolder="true" />
                                <SettingsBreadcrumbs Visible="true" ShowParentFolderButton="true" Position="Top" />
                                <SettingsUpload UseAdvancedUploadMode="true">
                                    <AdvancedModeSettings EnableMultiSelect="true" />
                                </SettingsUpload>
                                <SettingsAdaptivity Enabled="true" />
                            </dx:ASPxFileManager>                  
                        
                            </dx:ContentControl>
                       </ContentCollection>
                     </dx:TabPage>

                     <%--
                     **** PAGE SETTINGS TABPAGE
                     --%>

                     <dx:TabPage Text="Page" Visible="false">
                        <ContentCollection>
                            <dx:ContentControl ID="RightPanelContentControl2" runat="server">    
                                                             
                            </dx:ContentControl>
                       </ContentCollection>
                     </dx:TabPage>
  
                     </TabPages>
                     
                  </dx:ASPxPageControl>
                 
              </dx:PanelContent>
          </PanelCollection>
          <ClientSideEvents Init="onRightPanelInit" Collapsed="onRightPanelCollapsed" />
      </dx:ASPxPanel>

      <%--
      **** HEADER PANEL
      --%>
              
      <dx:ASPxPanel runat="server" ID="HeaderPanel" ClientInstanceName="headerPanel" FixedPosition="WindowTop"
          FixedPositionOverlap="false" CssClass="app-header">
          <PanelCollection>
              <dx:PanelContent runat="server">

                  <div class="left-block">
                      <dx:ASPxMenu runat="server" ID="LeftAreaMenu" ClientInstanceName="leftAreaMenu"
                          ItemAutoWidth="false" ItemWrap="false" SeparatorWidth="0" EnableHotTrack="false"
                          Width="100%" CssClass="header-menu" SyncSelectionMode="None">
                          <ItemStyle VerticalAlign="Middle" CssClass="item" />
                          <Items>
                              <dx:MenuItem Text="" Name="ToggleLeftPanel" GroupName="LeftPanel">
                                  <ItemStyle CssClass="toggle-item vertically-aligned" CheckedStyle-CssClass="checked selected" >
                                     <CheckedStyle CssClass="checked selected"></CheckedStyle>
                                  </ItemStyle>
                                  <Image Url="~/Resources/Images/menu.svg" Height="18px" Width="18px" />
                              </dx:MenuItem>
                          </Items>
                          <ClientSideEvents ItemClick="onLeftMenuItemClick" />
                      </dx:ASPxMenu>
                  </div>
                  
                  <div class="left-block">
                      <dx:ASPxMenu runat="server" ID="BreadcrumbMenu" ClientInstanceName="breadcrumbAreaMenu"
                          ItemAutoWidth="false" ItemWrap="false" SeparatorWidth="0" EnableHotTrack="false"
                          Width="100%" CssClass="header-menu" SyncSelectionMode="None">
                          <ItemStyle VerticalAlign="Middle" CssClass="item" />
                          <Items>
                              <dx:MenuItem Name="Breadcrumb">
                                  <Template>
                                       <table>
                                         <tr style="padding: inherit; margin: 2px 2px 2px 2px; vertical-align: middle; height: 46px; text-indent: 8px;">
                                           <td>
                                             <dx:ASPxLabel ID="BreadcrumbsLabel" runat="server" Text="Manager Page" Font-Bold="True" Font-Size="Large" Width="750px" />
                                           </td>
                                           <td>&nbsp;</td>
                                         </tr>
                                       </table>
                                  </Template>
                              </dx:MenuItem>
                          </Items>
                          <ClientSideEvents ItemClick="onLeftMenuItemClick" />
                      </dx:ASPxMenu>                        
                  </div>
                  
                  <div class="right-block">
                      <dx:ASPxMenu runat="server" ID="RightAreaMenu" ClientInstanceName="rightAreaMenu"
                          ItemAutoWidth="false" ItemWrap="false" ShowPopOutImages="False"
                          SeparatorWidth="0" ApplyItemStyleToTemplates="true"
                          Width="100%" CssClass="header-menu" OnItemClick="RightAreaMenu_ItemClick">
                          <Items>                                                                 
                              <dx:MenuItem Name="AccountItem" ItemStyle-CssClass="image-item" AdaptivePriority="2">
                                  <ItemStyle CssClass="image-item"></ItemStyle>
                                  <TextTemplate>
                                      <div class="account-background">
                                          <div runat="server" id="AccountImage" class="empty-image" />
                                      </div>
                                  </TextTemplate>
                                  <Items>
                                      <dx:MenuItem Name="SignInItem" Text="Sign in" NavigateUrl="~/Account/SignIn.aspx"></dx:MenuItem>
                                      <dx:MenuItem Name="RegisterItem" Text="Register" NavigateUrl="~/Account/Register.aspx"></dx:MenuItem>
                                      <dx:MenuItem Name="MyAccountItem" Text="My account" ItemStyle-CssClass="myaccount-item">
                                          <ItemStyle CssClass="myaccount-item"></ItemStyle>
                                          <TextTemplate>
                                              <div class="user-info">
                                                  <div class="avatar">
                                                      <img runat="server" id="AvatarUrl" src="~/Resources/Images/user.svg" />
                                                  </div>
                                                  <div class="text-container">
                                                      <dx:ASPxLabel ID="UserNameLabel" runat="server" CssClass="user-name"></dx:ASPxLabel>
                                                      <dx:ASPxLabel ID="EmailLabel" runat="server" CssClass="email"></dx:ASPxLabel>
                                                  </div>
                                              </div>
                                          </TextTemplate>
                                      </dx:MenuItem>
                                      <dx:MenuItem Name="ReauthenticateItem" Text="Reauthentice user" NavigateUrl="~/Default.aspx?fx=reauthenticate" Image-Url="~/Resources/Images/sign-out.svg" Image-Height="16px">
                                         <Image Height="16px" Url="~/Resources/Images/sign-out.svg"></Image>
                                      </dx:MenuItem>
                                  </Items>
                              </dx:MenuItem>
                              <dx:MenuItem Text="" Name="ToggleRightPanel" GroupName="RightPanel">
                                  <ItemStyle CssClass="toggle-item vertically-aligned" CheckedStyle-CssClass="checked selected" >
                                     <CheckedStyle CssClass="checked selected"></CheckedStyle>
                                  </ItemStyle>
                                  <Image Url="~/Resources/Images/menu.svg" Height="18px" Width="18px" />
                              </dx:MenuItem>
                          </Items>
                          <ItemStyle VerticalAlign="Middle" ForeColor="Gray" CssClass="item" SelectedStyle-CssClass="selected" HoverStyle-CssClass="hovered">
                              <Font Bold="True" Size="Medium"></Font>                        
                              <SelectedStyle CssClass="selected"></SelectedStyle>
                              <HoverStyle CssClass="hovered"></HoverStyle>
                          </ItemStyle>
                          <LinkStyle>
                              <Font Bold="True" Size="Medium"></Font>
                          </LinkStyle>       
                          <ItemImage Width="16" Height="16" />
                          <SubMenuStyle CssClass="header-sub-menu" />                            
                          <SubMenuItemStyle CssClass="item" />
                          <ClientSideEvents ItemClick="onHeaderPanelRightMenuItemClick" />
                      </dx:ASPxMenu>
                  </div>

                  <div id="PageMenuContainer" class="menu-container">
                      <div>                             
                           <dx:ASPxMenu runat="server" ID="PageToolbar" ClientInstanceName="pageToolbar" 
                              ItemAutoWidth="false" EnableSubMenuScrolling="true" ShowPopOutImages="True" SeparatorWidth="0" ItemWrap="false"
                              CssClass="header-menu page-menu" Width="100%" HorizontalAlign="Left">
                              <SettingsAdaptivity Enabled="true" EnableAutoHideRootItems="true" />
                              <AdaptiveMenuImage SpriteProperties-CssClass="adaptive-image" >
                                 <SpriteProperties CssClass="adaptive-image"></SpriteProperties>
                              </AdaptiveMenuImage>
                              <Items>
                                 <dx:MenuItem Alignment="Right" AdaptivePriority="2">  
                                     <ItemStyle BackColor="White" />  
                                     <TextTemplate>  
                                         <div style="width: 25px;height:32px"></div>  
                                     </TextTemplate>  
                                 </dx:MenuItem>                                                                                       
                              </Items>
                              <ItemStyle VerticalAlign="Middle" ForeColor="Gray" CssClass="item" SelectedStyle-CssClass="selected" HoverStyle-CssClass="hovered">
                                  <Font Bold="True" Size="Medium"></Font>                        
                                  <SelectedStyle CssClass="selected"></SelectedStyle>
                                  <HoverStyle CssClass="hovered"></HoverStyle>
                              </ItemStyle>
                              <LinkStyle>
                                  <Font Bold="True" Size="Medium"></Font>
                              </LinkStyle>       
                              <ItemImage Width="16" Height="16" />
                              <SubMenuStyle CssClass="header-sub-menu" />
                              <ClientSideEvents ItemClick="OnPageToolbarItemClick" />         
                           </dx:ASPxMenu>                             
                      </div>
                  </div>
                  <div class="dx-clear"></div>

              </dx:PanelContent>
          </PanelCollection>
      </dx:ASPxPanel>

      <%--
      **** POPUP CONTROLS
      --%>

      <dx:ASPxPopupControl ID="pcAlert" runat="server" Width="500" CloseAction="CloseButton" CloseOnEscape="true"
          PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" ClientInstanceName="pcAlert"
          HeaderText="Alert" AllowDragging="True" Modal="True" PopupAnimationType="Fade"
          EnableViewState="False" PopupHorizontalOffset="40" PopupVerticalOffset="40" AutoUpdatePosition="true">
          <ClientSideEvents PopUp="function(s, e) { }" CloseButtonClick="function(s, e) { window.location.reload(); }" />
          <SizeGripImage Width="11px" />
          <ContentCollection>
              <dx:PopupControlContentControl runat="server">
                  <dx:ASPxPanel ID="pcAlertPanel" runat="server" DefaultButton="btConfirm">
                      <PanelCollection>
                          <dx:PanelContent runat="server">
                              <dx:ASPxFormLayout runat="server" ID="AlertFormLayout" Width="100%" Height="100%">
                                  <Items>
                                      <dx:LayoutItem Caption="Message">
                                          <LayoutItemNestedControlCollection>
                                              <dx:LayoutItemNestedControlContainer>
                                                  <dx:ASPxMemo ID="tbAlertMessage" runat="server" Width="350px" Height="100px" MaxLength="200" ReadOnly="True" ClientInstanceName="tbAlertMessage"/>
                                              </dx:LayoutItemNestedControlContainer>
                                          </LayoutItemNestedControlCollection>
                                      </dx:LayoutItem>
                                      <dx:LayoutItem ShowCaption="False">
                                          <LayoutItemNestedControlCollection>
                                              <dx:LayoutItemNestedControlContainer>
                                                  <dx:ASPxButton ID="btConfirm" runat="server" Text="OK" Width="80px" AutoPostBack="False" Style="float: left; margin-right: 8px">
                                                      <ClientSideEvents Click="function(s, e) { pcAlert.Hide(); }" />
                                                  </dx:ASPxButton>
                                              </dx:LayoutItemNestedControlContainer>
                                          </LayoutItemNestedControlCollection>
                                      </dx:LayoutItem>
                                  </Items>
                              </dx:ASPxFormLayout>
                          </dx:PanelContent>
                      </PanelCollection>
                  </dx:ASPxPanel>
              </dx:PopupControlContentControl>
          </ContentCollection>
      </dx:ASPxPopupControl>                                 

      <dx:ASPxPopupControl ID="pcSystem" runat="server" Width="510" CloseAction="CloseButton" CloseOnEscape="true"
          PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" ClientInstanceName="pcSystem"
          HeaderText="BlackBox" AllowDragging="True" Modal="True" PopupAnimationType="Fade"
          EnableViewState="False" PopupHorizontalOffset="40" PopupVerticalOffset="40" AutoUpdatePosition="true">
          <ClientSideEvents PopUp="function(s, e) { }" CloseButtonClick="function(s, e) { pcSystem.Hide(); window.location.reload(); }" />
          <SizeGripImage Width="11px" />
          <ContentCollection>
              <dx:PopupControlContentControl runat="server">
                  <dx:ASPxPanel ID="pcSystemPanel" runat="server" DefaultButton="btCancel">
                      <PanelCollection>
                          <dx:PanelContent runat="server">
                              <dx:ASPxFormLayout runat="server" ID="pcSystemFormLayout" Width="100%" Height="100%">
                                  <Items>
                                      <dx:LayoutItem Caption="Message" ShowCaption="false">
                                          <LayoutItemNestedControlCollection>
                                              <dx:LayoutItemNestedControlContainer>
                                                  <dx:ASPxMemo ID="tbSystemMessage" runat="server" Width="450px" Height="100px" MaxLength="200" ReadOnly="True" ClientInstanceName="tbSystemMessage"/>
                                              </dx:LayoutItemNestedControlContainer>
                                          </LayoutItemNestedControlCollection>
                                      </dx:LayoutItem>
                                      <dx:LayoutItem ShowCaption="False">
                                          <LayoutItemNestedControlCollection>
                                              <dx:LayoutItemNestedControlContainer>
                                                  <dx:ASPxButton ID="btCancel" runat="server" Text="Cancel" Width="80px" AutoPostBack="False" ClientInstanceName="btCancel" Style="float: left; margin-right: 8px">
                                                      <ClientSideEvents Click="function(s, e) { pcSystem.Hide(); }" />
                                                  </dx:ASPxButton>
                                                  <dx:ASPxLabel ID="SpacerLabel1" runat="server" Text="  " />
                                                  <dx:ASPxButton ID="btMgrPages" runat="server" Text="Manager Pages" Width="80px" AutoPostBack="False" Style="float: left; margin-right: 8px">
                                                      <ClientSideEvents Click="function(s, e) { pcSystem.Hide(); window.open('manager.aspx','_self'); }" />
                                                  </dx:ASPxButton>
                                                  <dx:ASPxLabel ID="SpacerLabel2" runat="server" Text="  " />
                                                  <dx:ASPxButton ID="btAdminPages" runat="server" Text="Admin Pages" Width="80px" AutoPostBack="False" Style="float: left; margin-right: 8px">
                                                      <ClientSideEvents Click="function(s, e) { pcSystem.Hide(); window.open('admin.aspx','_self'); }" />
                                                  </dx:ASPxButton>
                                                  <dx:ASPxLabel ID="SpacerLabel3" runat="server" Text=" " />
                                                  <dx:ASPxButton ID="btLog" runat="server" Text="System Log" Width="80px" AutoPostBack="False" Style="float: left; margin-right: 8px">
                                                      <ClientSideEvents Click="function(s, e) { pcSystem.Hide(); window.open('Examine.ashx','_blank'); }" />
                                                  </dx:ASPxButton>
                                              </dx:LayoutItemNestedControlContainer>
                                          </LayoutItemNestedControlCollection>
                                      </dx:LayoutItem>
                                  </Items>
                              </dx:ASPxFormLayout>
                          </dx:PanelContent>
                      </PanelCollection>
                  </dx:ASPxPanel>
              </dx:PopupControlContentControl>
          </ContentCollection>
      </dx:ASPxPopupControl>                                 

      <dx:ASPxPopupControl ID="pcBlock" runat="server" Width="500" ClientInstanceName="pcBlock" HeaderText="Assess Rights Check"
          CloseAction="CloseButton" CloseOnEscape="true" Modal="True" EnableViewState="False" AllowDragging="True"
          PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" PopupAnimationType="Fade"
          PopupHorizontalOffset="40" PopupVerticalOffset="40" AutoUpdatePosition="true">
          <ClientSideEvents PopUp="function(s, e) { }" CloseButtonClick="function(s, e) { window.location.reload(); }" />
          <SizeGripImage Width="11px" />
          <ContentCollection>
              <dx:PopupControlContentControl runat="server">
                  <dx:ASPxPanel ID="BlockPanel" runat="server" DefaultButton="btBlockConfirm">
                      <PanelCollection>
                          <dx:PanelContent runat="server">
                              <dx:ASPxFormLayout runat="server" ID="BlockFormLayout" Width="100%" Height="100%">
                                  <Items>
                                      <dx:LayoutItem Caption="BlackBox">
                                          <LayoutItemNestedControlCollection>
                                              <dx:LayoutItemNestedControlContainer>
                                                  <dx:ASPxMemo ID="tbReason" runat="server" Width="350px" Height="100px" MaxLength="200" ReadOnly="True" ClientInstanceName="tbReason"/>
                                              </dx:LayoutItemNestedControlContainer>
                                          </LayoutItemNestedControlCollection>
                                      </dx:LayoutItem>
                                      <dx:LayoutItem ShowCaption="False">
                                          <LayoutItemNestedControlCollection>
                                              <dx:LayoutItemNestedControlContainer>
                                                  <dx:ASPxButton ID="btBlockConfirm" runat="server" Text="OK" Width="80px" AutoPostBack="False" Style="float: left; margin-right: 8px">
                                                      <ClientSideEvents Click="function(s, e) { pcBlock.Hide(); window.open('./User.aspx','_self'); }" />
                                                  </dx:ASPxButton>
                                              </dx:LayoutItemNestedControlContainer>
                                          </LayoutItemNestedControlCollection>
                                      </dx:LayoutItem>
                                  </Items>
                              </dx:ASPxFormLayout>
                          </dx:PanelContent>
                      </PanelCollection>
                  </dx:ASPxPanel>
              </dx:PopupControlContentControl>
          </ContentCollection>
      </dx:ASPxPopupControl>  

      <%--
      **** MAIN CONTENT PANEL
      --%>
      
      <div class="content" ID="ContentPlaceHolderContent">

        <dx:ASPxPageControl ID="tabPageProperties" Width="100%" runat="server" ActiveTabIndex="2" EnableHierarchyRecreation="True" >
            <TabPages>

            <%--
            **** DATA DASHBOARD TABPAGE
            --%>
                                                                                                                                                                       
            <dx:TabPage Text="Data Dashboard" Visible="true">
               <ContentCollection>                              
                   <dx:ContentControl ID="ContentControl1" runat="server">

                   <br/>
                   <table>
                     <tr>
                       <td Width="550px" style="height: 40px; font-weight: normal; font-size: 9pt; font-family: 'Microsoft Sans Serif'; background-color: #F5F5F5;">
                          <dx:WebChartControl ID="WebChartControl1" runat="server" ClientInstanceName="chart" AutoLayout="True" BackColor="#F2F2F2" Height="300px" Width="500px"
                              CrosshairEnabled="True" SelectionMode="Single" SeriesSelectionMode="Point" EnableClientSideAPI="True" ToolTipEnabled="False" RenderFormat="Svg"
                              SeriesDataMember = "Name" DataSourceID="SqlDataSourceCharts"
                              OnObjectSelected="WebChartControl1_ObjectSelected" OnSelectedItemsChanged="WebChartControl1_SelectedItemsChanged" OnSelectedItemsChanging="WebChartControl1_SelectedItemsChanging">
                              <SeriesTemplate ArgumentDataMember="Rank" ValueDataMembersSerializable="Rows" LabelsVisibility="False"
                                  CrosshairLabelPattern="Dataset: {S}<br/>Rows: {V}">
                                  <LabelSerializable>
                                      <dx:SideBySideBarSeriesLabel TextPattern="{V}">
                                      </dx:SideBySideBarSeriesLabel>
                                  </LabelSerializable>
                              </SeriesTemplate>
                              <BorderOptions Visibility="False" />
                              <Titles>
                                  <dx:ChartTitle Font="Tahoma, 12pt" Indent="4" Text="AssetCriticality Record Counts" />
                              </Titles>
                              <Legend AlignmentHorizontal="Right" MarkerMode="CheckBox"/>
                              <DiagramSerializable>
                                  <dx:XYDiagram>
                                      <AxisX Title-Text="Recent Uploads (Ranked)" Title-Visibility="True" VisibleInPanesSerializable="-1" Interlaced="False" MinorCount="4" >
                                          <NumericScaleOptions AutoGrid="False" GridSpacing="1"/>
                                      </AxisX>
                                      <AxisY Title-Text="Rows" Title-Visibility="True" VisibleInPanesSerializable="-1" Interlaced="False">
                                          <NumericScaleOptions AutoGrid="False" GridSpacing="100"/>
                                      </AxisY>
                                  </dx:XYDiagram>
                              </DiagramSerializable>
                          </dx:WebChartControl>          
                       </td>
                       <td Width="50px">
                         &nbsp;
                       </td>
                       <td Width="550px">             
                          <dx:WebChartControl ID="WebChartControl2" runat="server" ClientInstanceName="chart" AutoLayout="True" BackColor="#F2F2F2" Height="300px" Width="500px"
                              CrosshairEnabled="True" SelectionMode="Single" SeriesSelectionMode="Point" EnableClientSideAPI="True" ToolTipEnabled="False" RenderFormat="Svg"
                              SeriesDataMember = "Name" DataSourceID="SqlDataSourceCharts"
                              OnObjectSelected="WebChartControl2_ObjectSelected" OnSelectedItemsChanged="WebChartControl2_SelectedItemsChanged" OnSelectedItemsChanging="WebChartControl2_SelectedItemsChanging">
                              <SeriesTemplate ArgumentDataMember="Rank" ValueDataMembersSerializable="Rows" LabelsVisibility="False"
                                  CrosshairLabelPattern="Dataset: {S}<br/>Rows: {V}">
                                  <LabelSerializable>
                                      <dx:SideBySideBarSeriesLabel TextPattern="{V}">
                                      </dx:SideBySideBarSeriesLabel>
                                  </LabelSerializable>
                              </SeriesTemplate>
                              <BorderOptions Visibility="False" />
                              <Titles>
                                  <dx:ChartTitle Font="Tahoma, 12pt" Indent="4" Text="SIDA Record Counts" />
                              </Titles>
                              <Legend AlignmentHorizontal="Right" MarkerMode="CheckBox"/>
                              <DiagramSerializable>
                                  <dx:XYDiagram>
                                      <AxisX Title-Text="Recent Uploads (Ranked)" Title-Visibility="True" VisibleInPanesSerializable="-1" Interlaced="False" MinorCount="4" >
                                          <NumericScaleOptions AutoGrid="False" GridSpacing="1"/>
                                      </AxisX>
                                      <AxisY Title-Text="Rows" Title-Visibility="True" VisibleInPanesSerializable="-1" Interlaced="False">
                                          <NumericScaleOptions AutoGrid="False" GridSpacing="100"/>
                                      </AxisY>
                                  </dx:XYDiagram>
                              </DiagramSerializable>
                          </dx:WebChartControl>          
                       </td>
                     </tr>
                     <tr>
                       <td Width="1200px" style="height: 40px; font-weight: normal; font-size: 9pt; font-family: 'Microsoft Sans Serif'; background-color: #F5F5F5;" colspan="3">
                     
                       <dx:ASPxGridView ID="GridViewDatasetRowCount" runat="server" ClientInstanceName="GridViewDatasetRowCount" DataSourceID="SqlDataSourceCharts" KeyFieldName="Name"
                         OnRowCommand="GridViewDatasetRowCount_RowCommand" OnSelectionChanged="GridViewDatasetRowCount_SelectionChanged"
                         OnInitNewRow="GridViewDatasetRowCount_InitNewRow" OnRowInserting="GridViewDatasetRowCount_RowInserting" 
                         OnRowUpdating="GridViewDatasetRowCount_RowUpdating" OnRowDeleting="GridViewDatasetRowCount_RowDeleting"
                         OnCustomCallback="GridViewDatasetRowCount_CustomCallback" OnToolbarItemClick="GridViewDatasetRowCount_ToolbarItemClick"
                         EnableTheming="True" EnableViewState="False" AutoGenerateColumns="False" Width="95%">
                         <Toolbars>
                             <dx:GridViewToolbar>
                                 <SettingsAdaptivity Enabled="true" EnableCollapseRootItemsToIcons="true" />
                                 <Items>
                                     <dx:GridViewToolbarItem Command="Refresh" BeginGroup="true" AdaptivePriority="1"/>
                                     <dx:GridViewToolbarItem Command="ShowFilterRow" BeginGroup="true" AdaptivePriority="2"/>
                                     <dx:GridViewToolbarItem Command="ShowCustomizationWindow" BeginGroup="true" AdaptivePriority="3"/>
                                      
                                     <dx:GridViewToolbarItem Name="CustomOpenFile" Text="Open" BeginGroup="true" AdaptivePriority="4" Enabled="false" />
                                     <dx:GridViewToolbarItem Name="CustomInspectFile" Text="Inspect" BeginGroup="false" AdaptivePriority="5" Enabled="false" />                    
                                 </Items>
                             </dx:GridViewToolbar>
                         </Toolbars>                     
                         <SettingsPopup>
                           <HeaderFilter MinHeight="140px"></HeaderFilter>
                         </SettingsPopup>
                         <Columns>                            
                               <dx:GridViewCommandColumn VisibleIndex="0" SelectAllCheckboxMode="AllPages" ShowSelectCheckbox="True" Width="50px" Visible="true" />                                 
                               <dx:GridViewDataTextColumn FieldName="Group" Caption="Group" VisibleIndex="1" Width="120px" Visible="true" />
                               <dx:GridViewDataTextColumn FieldName="Name" Caption="Dataset" VisibleIndex="2" Width="180px" Visible="true" />
                               <dx:GridViewDataTextColumn FieldName="DataSourceInstanceID" Caption="DSIID" VisibleIndex="3" Width="80px" Visible="true" />
                               <dx:GridViewDataTextColumn FieldName="FID" Caption="FID" VisibleIndex="4" Width="80px" Visible="true" />                                 
                               <dx:GridViewDataTextColumn FieldName="Rows" Caption="Rows" VisibleIndex="5" Width="80px" Visible="true" />
                               <dx:GridViewDataTextColumn FieldName="UserID" Caption="UserID" VisibleIndex="6" Width="80px" Visible="true" />
                               <dx:GridViewDataTextColumn FieldName="FullName" Caption="UserName" VisibleIndex="7" Width="150px" Visible="true" />
                               <dx:GridViewDataTextColumn FieldName="TimeStamp" Caption="TimeStamp" VisibleIndex="8" Width="170px" Visible="true" />
                               <dx:GridViewDataTextColumn FieldName="Age" Caption="Age" VisibleIndex="9" Width="70px" Visible="true" />
                               <dx:GridViewDataTextColumn FieldName="Rank" Caption="Rank" VisibleIndex="10" Width="70px" Visible="true" />
                           </Columns>
                           <SettingsPager PageSize="4" AlwaysShowPager="True" EllipsisMode="OutsideNumeric" EnableAdaptivity="True">
                               <PageSizeItemSettings Visible="True"></PageSizeItemSettings>
                           </SettingsPager>
                           <Settings ShowFilterBar="Auto" ShowFilterRow="False" ShowFilterRowMenu="True" ShowHeaderFilterButton="False" 
                             ShowGroupedColumns="True" ShowPreview="True" VerticalScrollBarMode="Hidden" HorizontalScrollBarMode="Auto" /> 
                           <SettingsResizing ColumnResizeMode="Control" />                                               
                           <SettingsBehavior AllowClientEventsOnLoad="False"  AllowSelectSingleRowOnly="True" AllowSelectByRowClick="True" AllowFocusedRow="True" 
                           	   EnableCustomizationWindow="true" AllowEllipsisInText="False" AllowDragDrop="True" />
                           <SettingsExport EnableClientSideExportAPI="true" ExportSelectedRowsOnly="False" />
                           <SettingsEditing Mode="PopupEditForm" EditFormColumnCount="2" />
                           <SettingsPopup>
                               <EditForm>
                                   <SettingsAdaptivity MaxWidth="1000" Mode="Always" VerticalAlign="WindowCenter" />
                               </EditForm>
                               <FilterControl AutoUpdatePosition="False"></FilterControl>
                           </SettingsPopup>
                           <Styles>
                               <Header BackColor="#CCCCCC" Font-Bold="True" Font-Names="Calibri" Font-Size="Small" ForeColor="#333333">
                               </Header>
                               <Row Font-Names="Calibri" Font-Size="Small">
                               </Row>
                               <FocusedRow ForeColor="Black">
                               </FocusedRow>
                           </Styles>
                           <ClientSideEvents Init="OnGridViewDatasetRowCountInit" SelectionChanged="OnGridViewDatasetRowCountSelectionChanged" 
                           	 FocusedRowChanged="OnGridViewDatasetRowCountFocusedRowChanged" ToolbarItemClick="OnGridViewDatasetRowCountToolbarItemClick" />
                        </dx:ASPxGridView>
                     
                       </td>
                     </tr>                     
                   </table>

                   </dx:ContentControl>
              </ContentCollection>                                    
            </dx:TabPage>

            <%--
            **** TEMPLATES DASHBOARD TABPAGE
            --%>

            <dx:TabPage Text="Templates Dashboard" Visible="true">
               <ContentCollection>                              
                   <dx:ContentControl ID="ContentControl2" runat="server">

                   <br/>
                   <table>
                     <tr>
                       <td Width="1200px" style="height: 40px; font-weight: normal; font-size: 9pt; font-family: 'Microsoft Sans Serif'; background-color: #F5F5F5;">
                          <dx:WebChartControl ID="WebChartControl3" runat="server" ClientInstanceName="chart" AutoLayout="True" BackColor="#F2F2F2" Height="300px" Width="1100px"
                              CrosshairEnabled="True" SelectionMode="Single" SeriesSelectionMode="Point" EnableClientSideAPI="True" ToolTipEnabled="False" RenderFormat="Svg"
                              SeriesDataMember = "Name" DataSourceID="SqlTemplateCharts"
                              OnObjectSelected="WebChartControl3_ObjectSelected" OnSelectedItemsChanged="WebChartControl3_SelectedItemsChanged" OnSelectedItemsChanging="WebChartControl3_SelectedItemsChanging">
                              <SeriesTemplate ArgumentDataMember="Rank" ValueDataMembersSerializable="Rows" LabelsVisibility="False"
                                  CrosshairLabelPattern="Dataset: {S}<br/>Rows: {V}">
                                  <LabelSerializable>
                                      <dx:SideBySideBarSeriesLabel TextPattern="{V}">
                                      </dx:SideBySideBarSeriesLabel>
                                  </LabelSerializable>
                              </SeriesTemplate>
                              <BorderOptions Visibility="False" />
                              <Titles>
                                  <dx:ChartTitle Font="Tahoma, 12pt" Indent="4" Text="Template Data Record Counts" />
                              </Titles>
                              <Legend AlignmentHorizontal="Right" MarkerMode="CheckBox"/>
                              <DiagramSerializable>
                                  <dx:XYDiagram>
                                      <AxisX Title-Text="Recent Uploads (Ranked)" Title-Visibility="True" VisibleInPanesSerializable="-1" Interlaced="False" MinorCount="4" >
                                          <NumericScaleOptions AutoGrid="False" GridSpacing="1"/>
                                      </AxisX>
                                      <AxisY Title-Text="Rows" Title-Visibility="True" VisibleInPanesSerializable="-1" Interlaced="False">
                                          <NumericScaleOptions AutoGrid="False" GridSpacing="100"/>
                                      </AxisY>
                                  </dx:XYDiagram>
                              </DiagramSerializable>
                          </dx:WebChartControl>          
                       </td>
                     </tr>
                     <tr>
                       <td Width="1100px" style="height: 40px; font-weight: normal; font-size: 9pt; font-family: 'Microsoft Sans Serif'; background-color: #F5F5F5;" colspan="3">
                     
                       <dx:ASPxGridView ID="GridViewTemplateRowCount" runat="server" ClientInstanceName="GridViewTemplateRowCount" DataSourceID="SqlTemplateCharts" KeyFieldName="Name"
                         OnRowCommand="GridViewTemplateRowCount_RowCommand" OnSelectionChanged="GridViewTemplateRowCount_SelectionChanged"
                         OnInitNewRow="GridViewTemplateRowCount_InitNewRow" OnRowInserting="GridViewTemplateRowCount_RowInserting" OnRowUpdating="GridViewTemplateRowCount_RowUpdating" OnRowDeleting="GridViewTemplateRowCount_RowDeleting"
                         OnCustomCallback="GridViewTemplateRowCount_CustomCallback" OnToolbarItemClick="GridViewTemplateRowCount_ToolbarItemClick"
                         EnableTheming="True" EnableViewState="False" AutoGenerateColumns="False" Width="95%">
                         <Toolbars>
                             <dx:GridViewToolbar>
                                 <SettingsAdaptivity Enabled="true" EnableCollapseRootItemsToIcons="true" />
                                 <Items>
                                     <dx:GridViewToolbarItem Command="Refresh" BeginGroup="true" AdaptivePriority="1"/>
                                     <dx:GridViewToolbarItem Command="ShowFilterRow" BeginGroup="true" AdaptivePriority="2"/>
                                     <dx:GridViewToolbarItem Command="ShowCustomizationWindow" BeginGroup="true" AdaptivePriority="3"/>
                                      
                                     <dx:GridViewToolbarItem Name="CustomOpenFile" Text="Open" BeginGroup="true" AdaptivePriority="4" Enabled="false" />                    
                                 </Items>
                             </dx:GridViewToolbar>
                         </Toolbars>                     
                         <SettingsPopup>
                           <HeaderFilter MinHeight="140px"></HeaderFilter>
                         </SettingsPopup>
                         <Columns>                            
                               <dx:GridViewCommandColumn VisibleIndex="0" SelectAllCheckboxMode="AllPages" ShowSelectCheckbox="True" Width="50px" Visible="true" />                                 
                               <dx:GridViewDataTextColumn FieldName="Name" Caption="Dataset" VisibleIndex="1" Width="200px" Visible="true" />
                               <dx:GridViewDataTextColumn FieldName="DataSourceInstanceID" Caption="DSIID" VisibleIndex="2" Width="80px" Visible="true" />
                               <dx:GridViewDataTextColumn FieldName="FID" Caption="FID" VisibleIndex="3" Width="80px" Visible="true" />
                               <dx:GridViewDataTextColumn FieldName="Rows" Caption="Rows" VisibleIndex="4" Width="80px" Visible="true" />
                               <dx:GridViewDataTextColumn FieldName="UserID" Caption="UserID" VisibleIndex="5" Width="80px" Visible="true" />
                               <dx:GridViewDataTextColumn FieldName="FullName" Caption="UserName" VisibleIndex="6" Width="160px" Visible="true" />
                               <dx:GridViewDataTextColumn FieldName="TimeStamp" Caption="TimeStamp" VisibleIndex="7" Width="170px" Visible="true" />
                               <dx:GridViewDataTextColumn FieldName="Age" Caption="Age" VisibleIndex="8" Width="80px" Visible="true" />
                               <dx:GridViewDataTextColumn FieldName="Rank" Caption="Rank" VisibleIndex="9" Width="80px" Visible="true" />
                           </Columns>
                           <SettingsPager PageSize="4" AlwaysShowPager="True" EllipsisMode="OutsideNumeric" EnableAdaptivity="True">
                               <PageSizeItemSettings Visible="True"></PageSizeItemSettings>
                           </SettingsPager>
                           <Settings ShowFilterBar="Auto" ShowFilterRow="False" ShowFilterRowMenu="True" ShowHeaderFilterButton="False" 
                             ShowGroupedColumns="True" ShowPreview="True" VerticalScrollBarMode="Hidden" HorizontalScrollBarMode="Auto" /> 
                           <SettingsResizing ColumnResizeMode="Control" />                                               
                           <SettingsBehavior AllowClientEventsOnLoad="False"  AllowSelectSingleRowOnly="True" AllowSelectByRowClick="True" AllowFocusedRow="True" EnableCustomizationWindow="true" AllowEllipsisInText="False" AllowDragDrop="True" />
                           <SettingsExport EnableClientSideExportAPI="true" ExportSelectedRowsOnly="False" />
                           <SettingsEditing Mode="PopupEditForm" EditFormColumnCount="2" />
                           <SettingsPopup>
                               <EditForm>
                                   <SettingsAdaptivity MaxWidth="1000" Mode="Always" VerticalAlign="WindowCenter" />
                               </EditForm>
                               <FilterControl AutoUpdatePosition="False"></FilterControl>
                           </SettingsPopup>
                           <Styles>
                               <Header BackColor="#CCCCCC" Font-Bold="True" Font-Names="Calibri" Font-Size="Small" ForeColor="#333333">
                               </Header>
                               <Row Font-Names="Calibri" Font-Size="Small">
                               </Row>
                               <FocusedRow ForeColor="Black">
                               </FocusedRow>
                           </Styles>
                           <ClientSideEvents Init="OnGridViewTemplateRowCountInit" SelectionChanged="OnGridViewTemplateRowCountSelectionChanged" FocusedRowChanged="OnGridViewTemplateRowCountFocusedRowChanged" 
                             ToolbarItemClick="OnGridViewTemplateRowCountToolbarItemClick" />
                        </dx:ASPxGridView>
                     
                       </td>
                     </tr>                     
                   </table>

                   </dx:ContentControl>
              </ContentCollection>                                    
            </dx:TabPage>               

            <%--
            **** UPLOADS TABPAGE
            --%>

            <dx:TabPage Text="Uploads Dashboard" Visible="true">
               <ContentCollection>                              
                   <dx:ContentControl ID="ContentControl3" runat="server"> 
                   <br/>
                   <table>
                     <tr>
                       <td Width="800px" style="height: 40px; font-weight: normal; font-size: 9pt; font-family: 'Microsoft Sans Serif'; background-color: #F5F5F5;">
                          <dx:WebChartControl ID="WebChartControl4" runat="server" AutoLayout="True" BackColor="#F2F2F2" CrosshairEnabled="True" DataSourceID="SqlFileCountCharts"
                            OnObjectSelected="WebChartControl4_ObjectSelected" OnSelectedItemsChanged="WebChartControl4_SelectedItemsChanged" OnSelectedItemsChanging="WebChartControl4_SelectedItemsChanging"                          	
                            SelectionMode="None" SeriesSelectionMode="Series" Height="300px" Width="800px">
                              <DiagramSerializable>
                                  <dx:XYDiagram>
                                      <AxisX Title-Text="DataSources" Title-Visibility="True" VisibleInPanesSerializable="-1" Interlaced="False" MinorCount="6" >
                                          <NumericScaleOptions AutoGrid="True" GridSpacing="1"/>
                                      </AxisX>
                                      <AxisY Title-Text="Files" Title-Visibility="True" VisibleInPanesSerializable="-1" Interlaced="False" MinorCount="10" >
                                          <NumericScaleOptions AutoGrid="True" GridSpacing="10"/>
                                      </AxisY>
                                  </dx:XYDiagram>
                              </DiagramSerializable>
                              <Legend Name="Default Legend"></Legend>
                              <SeriesSerializable>
                                  <dx:Series ArgumentDataMember="Name" Name="Last Week" ValueDataMembersSerializable="LastWeek">
                                  </dx:Series>
                                  <dx:Series ArgumentDataMember="Name" Name="Last Month" ValueDataMembersSerializable="LastMonth">
                                  </dx:Series>
                                  <dx:Series ArgumentDataMember="Name" Name="Last Year" ValueDataMembersSerializable="LastYear">
                                  </dx:Series>
                              </SeriesSerializable>
                              <Titles>
                                  <dx:ChartTitle Font="Tahoma, 12pt" Indent="4" Text="Uploaded File Counts" />
                              </Titles>
                              <%-- <ClientSideEvents ObjectSelected="SetConsumed" /> --%>
                          </dx:WebChartControl>                   
                       </td>
                     </tr>
                     <tr>
                       <td Width="800px" style="font-weight: normal; font-size: 9pt; font-family: 'Microsoft Sans Serif'; background-color: #F5F5F5;" colspan="1">
                     
                       <dx:ASPxGridView ID="GridViewFileCounts" runat="server" ClientInstanceName="GridViewFileCounts" DataSourceID="SqlFileCountCharts" KeyFieldName="Name"
                         OnRowCommand="GridViewFileCounts_RowCommand" OnSelectionChanged="GridViewFileCounts_SelectionChanged"
                         OnInitNewRow="GridViewFileCounts_InitNewRow" OnRowInserting="GridViewFileCounts_RowInserting" OnRowUpdating="GridViewFileCounts_RowUpdating" OnRowDeleting="GridViewFileCounts_RowDeleting"
                         OnCustomCallback="GridViewFileCounts_CustomCallback" OnToolbarItemClick="GridViewFileCounts_ToolbarItemClick"
                         EnableTheming="True" EnableViewState="False" AutoGenerateColumns="False" Width="100%">
                         <Toolbars>
                             <dx:GridViewToolbar>
                                 <SettingsAdaptivity Enabled="true" EnableCollapseRootItemsToIcons="true" />
                                 <Items>
                                     <dx:GridViewToolbarItem Command="Refresh" BeginGroup="true" AdaptivePriority="1"/>
                                     <dx:GridViewToolbarItem Command="ShowFilterRow" BeginGroup="true" AdaptivePriority="2"/>
                                 </Items>
                             </dx:GridViewToolbar>
                         </Toolbars>                     
                         <SettingsPopup>
                           <HeaderFilter MinHeight="120px"></HeaderFilter>
                         </SettingsPopup>
                         <Columns>                            
                               <dx:GridViewCommandColumn VisibleIndex="0" SelectAllCheckboxMode="AllPages" ShowSelectCheckbox="True" Width="50px" Visible="true" />                                 
                               <dx:GridViewDataTextColumn FieldName="Name" Caption="Dataset" VisibleIndex="1" Width="298px" Visible="true" />
                               <dx:GridViewDataTextColumn FieldName="LastWeek" Caption="Last Week" VisibleIndex="2" Width="150px" Visible="true" />
                               <dx:GridViewDataTextColumn FieldName="LastMonth" Caption="Last Month" VisibleIndex="3" Width="150px" Visible="true" />
                               <dx:GridViewDataTextColumn FieldName="LastYear" Caption="Last Year" VisibleIndex="4" Width="150px" Visible="true" />
                           </Columns>
                           <SettingsPager PageSize="4" AlwaysShowPager="True" EllipsisMode="OutsideNumeric" EnableAdaptivity="True">
                               <PageSizeItemSettings Visible="True"></PageSizeItemSettings>
                           </SettingsPager>
                           <Settings ShowFilterBar="Auto" ShowFilterRow="False" ShowFilterRowMenu="True" ShowHeaderFilterButton="False" 
                             ShowGroupedColumns="True" ShowPreview="True" VerticalScrollBarMode="Hidden" HorizontalScrollBarMode="Auto" /> 
                           <SettingsResizing ColumnResizeMode="Control" />                                               
                           <SettingsBehavior AllowClientEventsOnLoad="False"  AllowSelectSingleRowOnly="True" AllowSelectByRowClick="True" AllowFocusedRow="True" EnableCustomizationWindow="true" AllowEllipsisInText="False" AllowDragDrop="True" />
                           <SettingsExport EnableClientSideExportAPI="true" ExportSelectedRowsOnly="False" />
                           <SettingsEditing Mode="PopupEditForm" EditFormColumnCount="2" />
                           <SettingsPopup>
                               <EditForm>
                                   <SettingsAdaptivity MaxWidth="1000" Mode="Always" VerticalAlign="WindowCenter" />
                               </EditForm>
                               <FilterControl AutoUpdatePosition="False"></FilterControl>
                           </SettingsPopup>
                           <Styles>
                               <Header BackColor="#CCCCCC" Font-Bold="True" Font-Names="Calibri" Font-Size="Small" ForeColor="#333333">
                               </Header>
                               <Row Font-Names="Calibri" Font-Size="Small">
                               </Row>
                               <FocusedRow ForeColor="Black">
                               </FocusedRow>
                           </Styles>
                           <ClientSideEvents Init="OnGridViewFileCountsInit" SelectionChanged="OnGridViewFileCountsSelectionChanged" FocusedRowChanged="OnGridViewFileCountsFocusedRowChanged" 
                             ToolbarItemClick="OnGridViewFileCountsToolbarItemClick" />
                        </dx:ASPxGridView>
                     
                       </td>
                     </tr>                     
                   </table>
                   </dx:ContentControl>
              </ContentCollection>                                    
            </dx:TabPage>
               
            </TabPages>
            
        </dx:ASPxPageControl>
                          
       <%--
       **** CONTENT FOOTER
       --%>
       
       <%--<div class="footer-wrapper" id="footerWrapper"> --%>
       <%--    <div class="footer"> --%>
       <%--       <br/> --%>
       <%--        <span class="footer-left">&copy; 2021 BlackBox --%>
       <%--            <a class="footer-link" href="#">Privacy Policy</a> --%>
       <%--            <a class="footer-link" href="#">Terms of Service</a> --%>
       <%--        </span> --%>
       <%--    </div> --%>
       <%--</div> --%>
           
      </div>               
             
      </div>

      <%--
      **** LOADING PANELS
      --%>

      <dx:ASPxLoadingPanel ID="LoadingPanel" runat="server" ClientInstanceName="LoadingPanel" Modal="True" />  

      <%--
      **** DATA SOURCES
      --%>


      <%--
      **** CONTENT DATA SOURCES
      --%>

     <asp:SqlDataSource ID="SqlDataSourceCharts" runat="server" 
       ConnectionString="<%$ ConnectionStrings:BlackBoxConnectionString %>" 
       ProviderName="<%$ ConnectionStrings:BlackBoxConnectionString.ProviderName %>" 
       SelectCommand="SELECT [Group],[Name],[DataSourceInstanceID],[Rows],[Age],[Rank] FROM [dbo].[vStagedRecordCounts] WHERE [Rank] < 5 ORDER BY [Name], [Rank] desc">
     </asp:SqlDataSource>
    
     <asp:SqlDataSource ID="SqlTemplateCharts" runat="server" 
       ConnectionString="<%$ ConnectionStrings:BlackBoxConnectionString %>" 
       ProviderName="<%$ ConnectionStrings:BlackBoxConnectionString.ProviderName %>" 
       SelectCommand="SELECT [Name],[DataSourceInstanceID],[Rows],[Age],[Rank] FROM [dbo].[vTemplateRecordCounts] WHERE [Rank] < 5 ORDER BY [Name], [Rank] desc">
     </asp:SqlDataSource>

     <asp:SqlDataSource ID="SqlFileCountCharts" runat="server" 
       ConnectionString="<%$ ConnectionStrings:BlackBoxConnectionString %>" 
       ProviderName="<%$ ConnectionStrings:BlackBoxConnectionString.ProviderName %>" 
       SelectCommand="SELECT [Name],[LastWeek],[LastMonth],[LastYear] FROM [dbo].[vUploadedFileCounts] ORDER BY [Name] desc">
     </asp:SqlDataSource>

      <%--
      **** GLOBAL EVENTS
      --%>
        
      <dx:ASPxGlobalEvents runat="server">
          <ClientSideEvents ControlsInitialized="onControlsInitialized" BrowserWindowResized="onBrowserWindowResized" />
      </dx:ASPxGlobalEvents>
      
   </form>
</body>
</html>