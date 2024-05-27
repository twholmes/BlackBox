<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Legacy.aspx.cs" Inherits="BlackBox.LegacyDefaultPage" Title="BlackBox" %>

<%@ Register assembly="DevExpress.Web.v22.2, Version=22.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" namespace="DevExpress.Web" tagprefix="dx" %>

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

  function OnPageToolbarItemClick(s, e) 
  {
    switch(e.item.name) 
    {
      case "Dummy":
          break;
    }
  }    

  // ///////////////////////////
  // contacts grid functions
  // ///////////////////////////

  // files grid toolbar functions  
  function OnGridViewContactsToolbarItemClick(s, e) 
  {
    if (e.item.name == 'CustomInspectStaged')
    {
      ShowModalInspectPopup();
    }
    else
    {
      if (IsCustomGridViewToolbarCommand(e.item.name)) 
      {
        e.processOnServer=true;
        e.usePostBack=true;
      }
    }
  }

  // files gridview functions
  function OnGridViewContactsInit(s, e) 
  { 
    var toolbar = gridViewContacts.GetToolbar(0);  
    if (toolbar != null) 
    {
    }
  }
 
  function OnGridViewContactsSelectionChanged(s, e) 
  {
    e.processOnServer=true;
    e.usePostBack=true;
  }
 
  function OnGridViewContactsFocusedRowChanged(s, e)
  {
    var fri = gridViewContacts.GetFocusedRowIndex();
    gridViewContacts.GetRowValues(fri, 'Domain;SAMAccountName', OnGetContactsFocusedRowValues);
    gridViewContacts.Refresh();    
  }

  function OnGetContactsFocusedRowValues(values)
  {
    //var domain = values[0];
    //var sam = values[1];
    
    //split to array trim elements and update popup combo box
    //var datasets = datasets.split(",")
  }
      
  // /////////////////////
  // common functions
  // /////////////////////
  
  // is the toolbar command custom or standard
  function IsCustomGridViewToolbarCommand(command) 
  {
    var isCustom = false;
    switch(command) 
    {      
      case "CustomImpersonate":
          isCustom = true;
          break;
    }
    return isCustom;
  }
 
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
 
  // ***    
  // *** event function declarations
  // ***

  window.OnMenuItemClick = OnMenuItemClick; 
  window.OnPageToolbarItemClick = OnPageToolbarItemClick;
  window.OnGridViewContactsInit = OnGridViewContactsInit;
  
  window.OnGridViewContactsSelectionChanged = OnGridViewContactsSelectionChanged;
  window.OnGridViewContactsFocusedRowChanged = OnGridViewContactsFocusedRowChanged;  
  window.OnGridViewContactsToolbarItemClick = OnGridViewContactsToolbarItemClick;  

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

   <%-- COLOR SCHEMES: USER=#616161, ADMIN=#003300, ADMIN=#660033, DEV=#660033 --%>

   <dx:ASPxPanel runat="server" ID="LeftPanel" ClientInstanceName="leftPanel"
       Collapsible="true" ScrollBars="Auto" FixedPosition="WindowLeft" FixedPositionOverlap="true" Width="220px"
       CssClass="left-panel" Paddings-Padding="0" BackColor="#616161">
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
           <%--<Image IconID="setup_properties_svg_white_32x32" />--%>
           <%--<Image IconID="dashboards_servermode_svg_white_32x32" />--%>

           <%--<Image IconID="businessobjects_bo_contact_svg_white_32x32" />--%>
           <%--<Image IconID="format_listbullets_svg_white_32x32" />--%>
           <%--<Image IconID="iconbuilder_actions_settings_svg_white_32x32" />--%>
           <%--<Image IconID="page_documentmap_32x32white" />--%>

           <%-- this is an user level menu --%>                              
           <dx:ASPxMenu ID="ASPxMenuTop" runat="server" ClientInstanceName="topMenu" Orientation="Vertical" 
               BackColor="#616161" Font-Bold="True" Font-Size="X-Large" ForeColor="White" HorizontalAlign="Left" VerticalAlign="Middle" 
               Width="100%" AllowSelectItem="True" AppearAfter="10" ItemWrap="False" MaximumDisplayLevels="1" LinkStyle-HoverColor="#6699FF">
               <Border BorderColor="#616161" />
               <BorderBottom BorderColor="#616161" BorderWidth="20px" />
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
               BackColor="#616161" Font-Bold="False" Font-Size="Large" ForeColor="White" HorizontalAlign="Left" VerticalAlign="Middle" 
               Width="100%" AllowSelectItem="True" AppearAfter="10" ItemWrap="False" MaximumDisplayLevels="1" LinkStyle-HoverColor="#6699FF">
               <Border BorderColor="#616161" />
               <BorderBottom BorderColor="#616161" BorderWidth="20px" />                        
               <SettingsAdaptivity Enabled="true" EnableAutoHideRootItems="False" EnableCollapseRootItemsToIcons="true" CollapseRootItemsToIconsAtWindowInnerWidth="200" />                        
               <Items>
                   <dx:MenuItem Name="HomeMenuLanding" NavigateUrl="~/Home.aspx" Text="Home">
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
           <dx:ASPxMenu ID="ASPxMenuITAM" runat="server" ClientInstanceName="itamMenu" Orientation="Vertical" 
               BackColor="#616161" Font-Bold="False" Font-Size="Large" ForeColor="White" HorizontalAlign="Left" VerticalAlign="Middle" 
               Width="100%" AllowSelectItem="True" AppearAfter="10" ItemWrap="False" MaximumDisplayLevels="1" LinkStyle-HoverColor="#6699FF">
               <Border BorderColor="#616161" />
               <BorderBottom BorderColor="#616161" BorderWidth="20px" />                        
               <SettingsAdaptivity Enabled="true" EnableAutoHideRootItems="False" EnableCollapseRootItemsToIcons="true" CollapseRootItemsToIconsAtWindowInnerWidth="200" />                        
               <Items> 
                   <dx:MenuItem Name="MainMenuAssets" NavigateUrl="~/Imports/AssetUploads.aspx?group=ITAM&source=Assets" Text="Assets">
                       <Image IconID="businessobjects_bo_order_svg_white_32x32" />
                   </dx:MenuItem>
                   <dx:MenuItem Name="MainMenuPurchases" NavigateUrl="~/Imports/PurchaseUploads.aspx?group=ITAM&source=Purchases" Text="Purchases">
                       <Image IconID="businessobjects_bo_price_svg_white_32x32" />
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
           <dx:ASPxMenu ID="ASPxMenuRioTinto" runat="server" ClientInstanceName="rioMenu" Orientation="Vertical" 
               BackColor="#616161" Font-Bold="False" Font-Size="Large" ForeColor="White" HorizontalAlign="Left" VerticalAlign="Middle" 
               Width="100%" AllowSelectItem="True" AppearAfter="10" ItemWrap="False" MaximumDisplayLevels="1" LinkStyle-HoverColor="#6699FF">
               <Border BorderColor="#616161" />
               <BorderBottom BorderColor="#616161" BorderWidth="20px" />                        
               <SettingsAdaptivity Enabled="true" EnableAutoHideRootItems="False" EnableCollapseRootItemsToIcons="true" CollapseRootItemsToIconsAtWindowInnerWidth="200" />                        
               <Items> 
                   <dx:MenuItem Name="MainMenuCriticality" NavigateUrl="~/RioTinto/CriticalityUploads.aspx?group=RIOTINTO&source=AssetCriticality" Text="Criticality">
                       <Image IconID="businessobjects_bo_opportunity_svg_white_32x32" />
                   </dx:MenuItem>
                   <dx:MenuItem Name="MainMenuSIDA" NavigateUrl="~/RioTinto/SIDAUploads.aspx?group=RIOTINTO&source=SiteAssetApplications" Text="SIDA">
                       <Image IconID="dashboards_editrules_svg_white_32x32" />
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
           <dx:ASPxMenu ID="ASPxMenuAnalysis" runat="server" ClientInstanceName="analysisMenu" Orientation="Vertical" 
               BackColor="#616161" Font-Bold="False" Font-Size="Large" ForeColor="White" HorizontalAlign="Left" VerticalAlign="Middle" 
               Width="100%" AllowSelectItem="True" AppearAfter="10" ItemWrap="False" MaximumDisplayLevels="1" LinkStyle-HoverColor="#6699FF">
               <Border BorderColor="#616161" />
               <BorderBottom BorderColor="#616161" BorderWidth="20px" />                        
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
               BackColor="#616161" Font-Bold="False" Font-Size="Large" ForeColor="White" HorizontalAlign="Left" VerticalAlign="Middle" 
               Width="100%" AllowSelectItem="True" AppearAfter="10" ItemWrap="False" MaximumDisplayLevels="1" LinkStyle-HoverColor="#6699FF">
               <Border BorderColor="#616161" />
               <BorderBottom BorderColor="#616161" BorderWidth="20px" />                        
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
               BackColor="#616161" Font-Bold="False" Font-Size="Large" ForeColor="White" HorizontalAlign="Left" VerticalAlign="Middle" 
               Width="100%" AllowSelectItem="True" AppearAfter="10" ItemWrap="False" MaximumDisplayLevels="1" LinkStyle-HoverColor="#6699FF">
               <Border BorderColor="#616161" />
               <BorderBottom BorderColor="#616161" BorderWidth="20px" />                        
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
           <dx:ASPxMenu ID="ASPxMenuBase" runat="server" ClientInstanceName="systemMenu" Orientation="Vertical" 
               BackColor="#616161" Font-Bold="False" Font-Size="Large" ForeColor="White" HorizontalAlign="Left" VerticalAlign="Middle" 
               Width="100%" AllowSelectItem="True" AppearAfter="10" ItemWrap="False" MaximumDisplayLevels="1" LinkStyle-HoverColor="#6699FF">
               <Border BorderColor="#616161" />
               <BorderBottom BorderColor="#616161" BorderWidth="20px" />                        
               <SettingsAdaptivity Enabled="true" EnableAutoHideRootItems="False" EnableCollapseRootItemsToIcons="true" CollapseRootItemsToIconsAtWindowInnerWidth="200" />                        
               <Items> 
                   <dx:MenuItem Name="MainMenuFileManager" Text="File Manager" BeginGroup="true" NavigateUrl="~/System/FileManager.aspx">
                       <Image IconID="actions_open2_svg_white_32x32" />
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

           <%-- this is an administrator level menu --%>
           <dx:ASPxMenu ID="ASPxMenuSystem" runat="server" ClientInstanceName="systemMenu" Orientation="Vertical" 
               BackColor="#616161" Font-Bold="False" Font-Size="Large" ForeColor="White" HorizontalAlign="Left" VerticalAlign="Middle" 
               Width="100%" AllowSelectItem="True" AppearAfter="10" ItemWrap="False" MaximumDisplayLevels="1" LinkStyle-HoverColor="#6699FF">
               <Border BorderColor="#616161" />
               <BorderBottom BorderColor="#616161" BorderWidth="20px" />                        
               <SettingsAdaptivity Enabled="true" EnableAutoHideRootItems="False" EnableCollapseRootItemsToIcons="true" CollapseRootItemsToIconsAtWindowInnerWidth="200" />                        
               <Items> 
                   <dx:MenuItem Name="MainMenuJobs" Text="Jobs" BeginGroup="true" NavigateUrl="~/System/Jobs.aspx">
                       <Image IconID="outlookinspired_tasklist_svg_white_32x32" />
                   </dx:MenuItem>
                   <dx:MenuItem Name="MainMenuDatasets" Text="Datasets" BeginGroup="true" NavigateUrl="~/System/Datasets.aspx">
                       <Image IconID="dashboards_updatedataextract_svg_white_32x32" />
                   </dx:MenuItem>
                   <dx:MenuItem Name="MainMenuDataSources" Text="DataSources" NavigateUrl="~/System/DataSources.aspx">
                       <Image IconID="spreadsheet_selectdatasource_svg_white_32x32" />
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
               BackColor="#616161" Font-Bold="False" Font-Size="Large" ForeColor="White" HorizontalAlign="Left" VerticalAlign="Middle" 
               Width="100%" AllowSelectItem="True" AppearAfter="10" ItemWrap="False" MaximumDisplayLevels="1" LinkStyle-HoverColor="#6699FF">
               <Border BorderColor="#616161" />
               <BorderBottom BorderColor="#616161" BorderWidth="20px" />                     
               <SettingsAdaptivity Enabled="true" EnableAutoHideRootItems="False" EnableCollapseRootItemsToIcons="true" CollapseRootItemsToIconsAtWindowInnerWidth="200" />
               <Items>
                  <dx:MenuItem Name="MainMenuSystem" Text="System" NavigateUrl="~/Admin/Uploads.aspx">
                      <Image IconID="scheduling_import_svg_white_32x32" />
                  </dx:MenuItem>               	  
                  <dx:MenuItem Name="MainMenuSettings" Text="Settings" NavigateUrl="~/Admin/Settings.aspx">
                      <Image IconID="setup_properties_svg_white_32x32" />
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
           <dx:ASPxMenu ID="ASPxMenuSupport" runat="server" ClientInstanceName="supportMenu" Orientation="Vertical"
               BackColor="#616161" Font-Bold="False" Font-Size="Large" ForeColor="White" HorizontalAlign="Left" VerticalAlign="Bottom" 
               Width="100%" AllowSelectItem="True" AppearAfter="10" ItemWrap="False" MaximumDisplayLevels="1" LinkStyle-HoverColor="#6699FF">
               <Border BorderColor="#616161" />
               <BorderBottom BorderColor="#616161" BorderWidth="20px" />                        
               <SettingsAdaptivity Enabled="true" EnableAutoHideRootItems="False" EnableCollapseRootItemsToIcons="true" CollapseRootItemsToIconsAtWindowInnerWidth="200" />                        
               <Items>
                   <dx:MenuItem Name="MainMenuLogs" NavigateUrl="~/Support/Logs.aspx" Text="Logs">
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
           <dx:ASPxMenu ID="ASPxMenuBottom" runat="server" ClientInstanceName="bottomMenu" Orientation="Vertical"
               BackColor="#616161" Font-Bold="False" Font-Size="Large" ForeColor="White" HorizontalAlign="Left" VerticalAlign="Bottom" 
               Width="100%" AllowSelectItem="True" AppearAfter="10" ItemWrap="False" MaximumDisplayLevels="1" LinkStyle-HoverColor="#6699FF">
               <Border BorderColor="#616161" />
               <BorderBottom BorderColor="#616161" BorderWidth="20px" />                        
               <SettingsAdaptivity Enabled="true" EnableAutoHideRootItems="False" EnableCollapseRootItemsToIcons="true" CollapseRootItemsToIconsAtWindowInnerWidth="200" />                        
               <Items>
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
                      **** PROFILE TABPAGE
                      --%>

                      <dx:TabPage Text="My Profile">
                         <ContentCollection>
                             <dx:ContentControl ID="RightPanelContentControl1" runat="server">    

                             <dx:ASPxFormLayout ID="UserFormLayout" runat="server" DataSourceID="ContactsDataSource" AlignItemCaptionsInAllGroups="True" UseDefaultPaddings="False">
                                <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="700" />
                                <Items>        
                                    <dx:LayoutGroup Caption="User Information" ShowCaption="false" ColCount="2" SettingsItems-HorizontalAlign="Left" HorizontalAlign="Left" Width="600">
                                        <Items>
                                            <dx:LayoutItem Caption="User Name" ShowCaption="false" VerticalAlign="Top" HorizontalAlign="Left" CaptionSettings-VerticalAlign="Middle" ColumnSpan="2">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                                       <dx:ASPxLabel ID="FormUserNameLabel" runat="server" Font-Size="30px" Font-Bold="True"></dx:ASPxLabel> 
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Photo" ShowCaption="false" HorizontalAlign="Left" Width="100px" CaptionSettings-VerticalAlign="Middle" RowSpan="5">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                                       <dx:ASPxImage ID="FormUserImage" runat="server" Height=150 Width=150 ImageAlign="Left" /> 
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Cohort" FieldName="Cohort">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                                        <dx:ASPxTextBox ID="cohortTextBox" runat="server" Width="95%" ReadOnly="True" />
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Account Name" FieldName="SAMAccountName">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                                        <dx:ASPxTextBox ID="FormAccountTextBox" runat="server" Width="95%" ReadOnly="True" />
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Domain Name" FieldName="Domain">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                                        <dx:ASPxTextBox ID="FormDomainTextBox" runat="server" Width="95%" ReadOnly="True" />
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                         
                                            <%--
                                            <dx:LayoutItem Caption="Birth Date" FieldName="Birthday">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                                        <dx:ASPxDateEdit ID="birthdateEdit" runat="server" EditFormat="Date" Width="95%" ReadOnly="False" />
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Address Book" FieldName="AddressBook">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                                        <dx:ASPxTextBox ID="addressbookTextBox" runat="server" Width="95%" ReadOnly="True" />
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            --%>
                         
                                            <%--                         
                                            <dx:LayoutItem Caption="Memberships" FieldName="Memberships" HorizontalAlign="Right" ColumnSpan="1">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                                        <dx:ASPxTextBox ID="membershipsTextBox" ClientIDMode="Static" runat="server" Width="95%" ReadOnly="False" />
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            --%>
                                            
                                           <dx:EmptyLayoutItem />
                                        </Items>
                                    </dx:LayoutGroup>           
                                    <%--<dx:EmptyLayoutItem />--%>
                         
                                    <dx:LayoutGroup Caption="Names" ShowCaption="true" ColCount="2" SettingsItems-HorizontalAlign="Left" HorizontalAlign="Left" Width="600">
                                        <Items>
                                            <dx:LayoutItem Caption="First Name" FieldName="FirstName">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                                        <%-- <dx:ASPxLabel ID="firstNameLabel" runat="server" /> --%>
                                                        <dx:ASPxTextBox ID="firstTextBox" runat="server" Width="90%" ReadOnly="False" />
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Last Name" FieldName="LastName">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                                        <%-- <dx:ASPxLabel ID="lastNameLabel" runat="server" />  --%>
                                                        <dx:ASPxTextBox ID="lastTextBox" runat="server" Width="95%" ReadOnly="False" />
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <%--
                                            <dx:LayoutItem Caption="Birth Date" FieldName="Birthday">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                                        <dx:ASPxDateEdit ID="birthdateEdit" runat="server" EditFormat="Date" Width="95%" ReadOnly="False" />
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            --%>
                                        </Items>
                                    </dx:LayoutGroup>           
                         
                                    <dx:LayoutGroup Caption="Home" ShowCaption="true" ColCount="2" SettingsItems-HorizontalAlign="Left" HorizontalAlign="Left" Width="600">
                                        <Items>
                                            <dx:LayoutItem Caption="Site" FieldName="Site">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                                        <dx:ASPxTextBox ID="siteTextBox" runat="server" Width="95%" ReadOnly="False" />
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <dx:LayoutItem Caption="Business" FieldName="Business">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                                        <dx:ASPxTextBox ID="businessTextBox" runat="server" Width="95%" ReadOnly="False" />
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            <%--
                                            <dx:LayoutItem Caption="Job" FieldName="Job">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                                        <dx:ASPxTextBox ID="jobTextBox" runat="server" Width="95%" ReadOnly="False" />
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                            --%>
                                        </Items>
                                    </dx:LayoutGroup>    
                                    <%--<dx:EmptyLayoutItem />--%>
                             
                                    <dx:LayoutGroup Caption="Roles" ShowCaption="true" ColCount="3" SettingsItems-HorizontalAlign="Left" HorizontalAlign="Left" Width="600">
                                        <Items>
                                           <dx:LayoutItem Caption="Guest" ColumnSpan="1">
                                               <LayoutItemNestedControlCollection>
                                                   <dx:LayoutItemNestedControlContainer>
                                                       <dx:ASPxCheckBox ID="cbUserGuest" runat="server" AutoPostBack="False" Width="50" Checked="True" />
                                                   </dx:LayoutItemNestedControlContainer>
                                               </LayoutItemNestedControlCollection>
                                           </dx:LayoutItem>
                                          
                                           <dx:LayoutItem Caption="Site Auditor">
                                               <LayoutItemNestedControlCollection>
                                                   <dx:LayoutItemNestedControlContainer>
                                                       <dx:ASPxCheckBox ID="cbUserOperator" runat="server" AutoPostBack="False" Width="50" Checked="False" />
                                                   </dx:LayoutItemNestedControlContainer>
                                               </LayoutItemNestedControlCollection>
                                           </dx:LayoutItem>
                         
                                           <dx:LayoutItem Caption="Asset Manager" ColumnSpan="1">
                                               <LayoutItemNestedControlCollection>
                                                   <dx:LayoutItemNestedControlContainer>
                                                       <dx:ASPxCheckBox ID="cbUserManager" runat="server" AutoPostBack="False" Width="50" Checked="False" />
                                                   </dx:LayoutItemNestedControlContainer>
                                               </LayoutItemNestedControlCollection>
                                           </dx:LayoutItem>
                                           
                                           <dx:LayoutItem Caption="Administrator" ColumnSpan="1">
                                               <LayoutItemNestedControlCollection>
                                                   <dx:LayoutItemNestedControlContainer>
                                                       <dx:ASPxCheckBox ID="cbUserAdmin" runat="server" AutoPostBack="False" Width="50" Checked="False" />
                                                   </dx:LayoutItemNestedControlContainer>
                                               </LayoutItemNestedControlCollection>
                                           </dx:LayoutItem>                                                  
                                        </Items>
                                    </dx:LayoutGroup>    
                                    <dx:EmptyLayoutItem />
                                    
                                    <dx:LayoutItem ShowCaption="False" CssClass="buttonAlign" Width="100%">
                                        <LayoutItemNestedControlCollection>
                                            <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                                <dx:ASPxButton ID="UpdateUserButton" runat="server" Text="Update" OnClick="UpdateUserButtonClick" Width="100" />
                                            </dx:LayoutItemNestedControlContainer>
                                        </LayoutItemNestedControlCollection>
                                    </dx:LayoutItem>
                                </Items>
                             </dx:ASPxFormLayout>
                                         
                             </dx:ContentControl>
                        </ContentCollection>
                      </dx:TabPage>

                      <%--
                      **** USERS TAB
                      --%>
                                                                                                                                                                                 
                      <dx:TabPage Text="Users">
                         <ContentCollection>                              
                             <dx:ContentControl ID="ContentControl2" runat="server">

                             <dx:ASPxGridView ID="ContactsGridView" runat="server" ClientInstanceName="gridViewContacts" DataSourceID="SqlSysContacts" KeyFieldName="ID"
                               OnRowCommand="ContactsGridView_RowCommand" OnSelectionChanged="ContactsGridView_SelectionChanged"
                               OnInitNewRow="ContactsGridView_InitNewRow" OnRowInserting="ContactsGridView_RowInserting" OnRowUpdating="ContactsGridView_RowUpdating" OnRowDeleting="ContactsGridView_RowDeleting"
                               OnCustomCallback="ContactsGridView_CustomCallback" OnToolbarItemClick="ContactsGridView_ToolbarItemClick"
                               EnableTheming="True" EnableViewState="False" AutoGenerateColumns="False" Width="95%">
                               <Toolbars>
                                   <dx:GridViewToolbar>
                                       <SettingsAdaptivity Enabled="true" EnableCollapseRootItemsToIcons="true" />
                                       <Items>
                                           <dx:GridViewToolbarItem Command="Refresh" AdaptivePriority="1" />
                                           <dx:GridViewToolbarItem Name="New" Command="New" BeginGroup="true" AdaptivePriority="6" />
                                           <dx:GridViewToolbarItem Name="Edit" Command="Edit" Enabled="true" AdaptivePriority="5" />                                        
                                           <dx:GridViewToolbarItem Name="Delete" Command="Delete" Enabled="true" AdaptivePriority="7" />                                  
                                           <dx:GridViewToolbarItem Name="ShowFilterRow" Command="ShowFilterRow" BeginGroup="true" AdaptivePriority="2"/>
                                           <dx:GridViewToolbarItem Name="ShowCustomizationWindow" Command="ShowCustomizationWindow" AdaptivePriority="3"/>  
                                           <%--
                                           <dx:GridViewToolbarItem Text="Export to" Image-IconID="actions_download_16x16office2013" BeginGroup="true" AdaptivePriority="4">
                                               <Items>
                                                   <dx:GridViewToolbarItem Command="ExportToCsv" />
                                                   <dx:GridViewToolbarItem Command="ExportToXlsx" Text="Export to XLSX" />
                                               </Items>
                                               <Image IconID="actions_download_16x16office2013"></Image>
                                           </dx:GridViewToolbarItem>
                                           --%>
                                           <dx:GridViewToolbarItem Name="CustomImpersonate" Text="Impersonate" BeginGroup="true" AdaptivePriority="4" Enabled="false" />
                          
                                           <%--                                
                                           <dx:GridViewToolbarItem Alignment="Right" BeginGroup="true" AdaptivePriority="5">
                                               <Template>
                                                   <dx:ASPxButtonEdit ID="tbToolbarSearch" runat="server" NullText="Search..." Height="100%">
                                                       <Buttons>
                                                           <dx:SpinButtonExtended Image-IconID="find_find_16x16gray" />
                                                       </Buttons>
                                                   </dx:ASPxButtonEdit>
                                               </Template>
                                           </dx:GridViewToolbarItem>
                                           --%>
                                       </Items>
                                   </dx:GridViewToolbar>
                               </Toolbars>                     
                               <SettingsPopup>
                                 <HeaderFilter MinHeight="140px"></HeaderFilter>
                               </SettingsPopup>
                               <Columns>                   
                                     <dx:GridViewCommandColumn VisibleIndex="0" SelectAllCheckboxMode="AllPages" ShowSelectCheckbox="True" Width="50px" Visible="true" />
                                     <dx:GridViewDataTextColumn FieldName="ID" VisibleIndex="1" Width="60px" Visible="true" />
                                     <dx:GridViewDataTextColumn FieldName="Cohort" VisibleIndex="2" Width="100px" Visible="false" />
                                     <dx:GridViewDataTextColumn FieldName="UID" VisibleIndex="3" Width="200px" Visible="false" />
                                     <dx:GridViewDataTextColumn FieldName="FullName" VisibleIndex="4" Width="120px" Visible="true" />                                          
                                     <dx:GridViewDataTextColumn FieldName="FirstName" VisibleIndex="5" Width="120px" Visible="false" />
                                     <dx:GridViewDataTextColumn FieldName="LastName" VisibleIndex="6" Width="140px" Visible="false" />
                                     <%--<dx:GridViewDataTextColumn FieldName="AddressBook" VisibleIndex="7" Width="120px" Visible="false" />--%>
                                     <dx:GridViewDataTextColumn FieldName="Domain" VisibleIndex="8" Width="140px" Visible="true" />
                                     <dx:GridViewDataTextColumn FieldName="SAMAccountName" VisibleIndex="9" Width="140px" Visible="true" />
                                     <dx:GridViewDataTextColumn FieldName="Email" VisibleIndex="10" Width="200px" Visible="false" />
                                     <dx:GridViewDataTextColumn FieldName="PhotoFileName" VisibleIndex="11" Width="180px" Visible="false" />
                                     <dx:GridViewDataTextColumn FieldName="Country" VisibleIndex="12" Width="140px" Visible="false" />
                                     <dx:GridViewDataTextColumn FieldName="City" VisibleIndex="13" Width="140px" Visible="false" />
                                     <dx:GridViewDataTextColumn FieldName="Address" VisibleIndex="14" Width="260px" Visible="false" />
                                     <dx:GridViewDataTextColumn FieldName="Phone" VisibleIndex="15" Width="120px" Visible="false" />
                                     <%--<dx:GridViewDataTextColumn FieldName="Birthday" VisibleIndex="16" Width="90px" Visible="false" />--%>
                                     <dx:GridViewDataTextColumn FieldName="Site" VisibleIndex="17" Width="140px" Visible="false" />      
                                     <dx:GridViewDataTextColumn FieldName="Business" VisibleIndex="18" Width="140px" Visible="false" />
                                     <dx:GridViewDataTextColumn FieldName="Job" VisibleIndex="19" Width="140px" Visible="false" />
                                     <dx:GridViewDataTextColumn FieldName="Memberships" VisibleIndex="20" Width="200px" Visible="false" />
                                     <dx:GridViewDataTextColumn FieldName="Guest" VisibleIndex="21" Width="80px" Visible="false" />
                                     <dx:GridViewDataTextColumn FieldName="Operator" VisibleIndex="22" Width="100px" Visible="false" />
                                     <dx:GridViewDataTextColumn FieldName="Manager" VisibleIndex="23" Width="100px" Visible="false" />
                                     <dx:GridViewDataTextColumn FieldName="Administrator" VisibleIndex="24" Width="100px" Visible="false" />                                                                                                                 
                                     <%--<dx:GridViewDataTextColumn FieldName="Password" VisibleIndex="25" Width="150px" Visible="false" />
                                     <%--<dx:GridViewDataTextColumn FieldName="Credits" VisibleIndex="26" Width="90px" Visible="false" />--%>
                                     <dx:GridViewDataTextColumn FieldName="Status" VisibleIndex="27" Width="90px" Visible="false" />
                                     <dx:GridViewDataTextColumn FieldName="UpdatedBy" VisibleIndex="28" Width="120px" Visible="false" />
                                     <dx:GridViewDataTextColumn FieldName="Updated" VisibleIndex="29" Width="140px" Visible="false" />
                                 </Columns>
                                 <SettingsPager PageSize="10" AlwaysShowPager="True" EllipsisMode="OutsideNumeric" EnableAdaptivity="True">
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
                                 <EditFormLayoutProperties UseDefaultPaddings="false">
                                     <Styles LayoutItem-Paddings-PaddingBottom="8" >
                                        <LayoutItem>
                                           <Paddings PaddingBottom="8px"></Paddings>
                                        </LayoutItem>
                                     </Styles>
                                     <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="600">
                                     </SettingsAdaptivity>
                                     <Items>                           
                                         <dx:GridViewLayoutGroup ColCount="2" GroupBoxDecoration="None">
                                             <Items>                       
                                                 <dx:GridViewColumnLayoutItem ColumnName="ID" Caption="ID">
                                                   <Template>
                                                      <dx:ASPxLabel ID="idLabel" runat="server" Width="40%" Text='<%# Bind("ID") %>' />
                                                   </Template>
                                                 </dx:GridViewColumnLayoutItem>
                                                 <dx:GridViewColumnLayoutItem ColumnName="UID" Caption="UID" ColumnSpan="1">
                                                   <Template>
                                                      <dx:ASPxLabel ID="uidLabel" runat="server" Width="90%" Text='<%# Bind("UID") %>' />
                                                   </Template>
                                                 </dx:GridViewColumnLayoutItem>
                             
                                                 <dx:GridViewColumnLayoutItem ColumnName="Cohort" Caption="Cohort" ColumnSpan="1">
                                                   <Template>
                                                      <dx:ASPxTextBox ID="cohortTextBox" runat="server" Width="80%" Text='<%# Bind("Cohort") %>' />
                                                   </Template>
                                                 </dx:GridViewColumnLayoutItem>                   

                                                 <%--
                                                 <dx:GridViewColumnLayoutItem ColumnName="AddressBook" Caption="Book" ColumnSpan="1">
                                                   <Template>
                                                      <dx:ASPxTextBox ID="bookTextBox" runat="server" Width="80%" Text='<%# Bind("AddressBook") %>' />
                                                   </Template>
                                                 </dx:GridViewColumnLayoutItem>
                                                 --%>

                                                 <dx:GridViewColumnLayoutItem ColumnName="Status" Caption="Status" ColumnSpan="1">
                                                   <Template>
                                                      <dx:ASPxTextBox ID="statusTextBox" runat="server" Width="80%" Text='<%# Bind("Status") %>' />
                                                   </Template>
                                                 </dx:GridViewColumnLayoutItem>
                          
                                                 <dx:GridViewColumnLayoutItem ColumnName="FullName" Caption="FullName" ColumnSpan="2">
                                                   <Template>
                                                      <dx:ASPxTextBox ID="fullNameTextBox" runat="server" Width="80%" Text='<%# Bind("FullName") %>' />
                                                   </Template>
                                                 </dx:GridViewColumnLayoutItem>
                          
                                                 <dx:GridViewColumnLayoutItem ColumnName="FirstName" Caption="Name" ColumnSpan="1">
                                                   <Template>
                                                      <dx:ASPxTextBox ID="firstNameTextBox" runat="server" Width="80%" Text='<%# Bind("FirstName") %>' />
                                                   </Template>
                                                 </dx:GridViewColumnLayoutItem>
                                                 <dx:GridViewColumnLayoutItem ColumnName="LastName" Caption="LastName" ColumnSpan="1">
                                                   <Template>
                                                      <dx:ASPxTextBox ID="lastNameTextBox" runat="server" Width="80%" Text='<%# Bind("LastName") %>' />
                                                   </Template>
                                                 </dx:GridViewColumnLayoutItem>
                          
                                                 <dx:GridViewColumnLayoutItem ColumnName="Domain" Caption="Domain" ColumnSpan="1">
                                                   <Template>
                                                      <dx:ASPxTextBox ID="domainTextBox" runat="server" Width="80%" Text='<%# Bind("Domain") %>' />
                                                   </Template>
                                                 </dx:GridViewColumnLayoutItem>
                                                 <dx:GridViewColumnLayoutItem ColumnName="SAMAccountName" Caption="Account" ColumnSpan="1">
                                                   <Template>
                                                      <dx:ASPxTextBox ID="samTextBox" runat="server" Width="80%" Text='<%# Bind("SAMAccountName") %>' />
                                                   </Template>
                                                 </dx:GridViewColumnLayoutItem>
                          
                                                 <dx:GridViewColumnLayoutItem ColumnName="Email" Caption="Email" ColumnSpan="1">
                                                   <Template>
                                                      <dx:ASPxTextBox ID="emailTextBox" runat="server" Width="80%" Text='<%# Bind("Email") %>' />
                                                   </Template>
                                                 </dx:GridViewColumnLayoutItem>
                          
                                                 <dx:GridViewColumnLayoutItem ColumnName="PhotoFileName" Caption="PhotoFileName" ColumnSpan="1">
                                                   <Template>
                                                      <%--<dx:ASPxTextBox ID="photoTextBox" runat="server" Width="80%" Text='<%# Bind("PhotoFileName") %>' />--%>
                                                      <dx:ASPxComboBox ID="photoComboBox" DropDownStyle="DropDown" runat="server" Width="50%" Value='<%# Bind("PhotoFileName") %>'>
                                                         <Items>
                                                             <dx:ListEditItem Value="guest.jpg" Text="guest.jpg" />
                                                             <dx:ListEditItem Value="User.png" Text="user.png" />                                                   	
                                                             <dx:ListEditItem Value="boss.png" Text="boss.png" />
                                                             <dx:ListEditItem Value="student.png" Text="student.png" />
                                                             <dx:ListEditItem Value="supervisor.png" Text="supervisor.png" />
                                                             <dx:ListEditItem Value="businessman.png" Text="businessman.png" />
                                                             <dx:ListEditItem Value="medical.png" Text="medical.png" />
                                                             <dx:ListEditItem Value="captain.png" Text="captain.png" />                                                   	
                                                             <dx:ListEditItem Value="armyofficer.png" Text="officer.png" />
                                                             <dx:ListEditItem Value="superman.png" Text="superman.png" />
                                                             <dx:ListEditItem Value="devil.png" Text="devil.png" />
                                                          </Items>
                                                      </dx:ASPxComboBox>                                            	
                                                   </Template>
                                                 </dx:GridViewColumnLayoutItem>
                          
                                                 <dx:GridViewColumnLayoutItem ColumnName="Country" Caption="Country" ColumnSpan="1">
                                                   <Template>
                                                      <dx:ASPxTextBox ID="countryTextBox" runat="server" Width="80%" Text='<%# Bind("Country") %>' />
                                                   </Template>
                                                 </dx:GridViewColumnLayoutItem>
                          
                                                 <dx:GridViewColumnLayoutItem ColumnName="City" Caption="City" ColumnSpan="1">
                                                   <Template>
                                                      <dx:ASPxTextBox ID="cityTextBox" runat="server" Width="80%" Text='<%# Bind("City") %>' />
                                                   </Template>
                                                 </dx:GridViewColumnLayoutItem>
                          
                                                 <dx:GridViewColumnLayoutItem ColumnName="Address" Caption="Address" ColumnSpan="1">
                                                   <Template>
                                                      <dx:ASPxTextBox ID="addressTextBox" runat="server" Width="80%" Text='<%# Bind("Address") %>' />
                                                   </Template>
                                                 </dx:GridViewColumnLayoutItem>
                          
                                                 <dx:GridViewColumnLayoutItem ColumnName="Phone" Caption="Phone" ColumnSpan="1">
                                                   <Template>
                                                      <dx:ASPxTextBox ID="phoneTextBox" runat="server" Width="80%" Text='<%# Bind("Phone") %>' />
                                                   </Template>
                                                 </dx:GridViewColumnLayoutItem>

                                                 <%--                             
                                                 <dx:GridViewColumnLayoutItem ColumnName="Birthday" Caption="Birthday" ColumnSpan="1">
                                                   <Template>
                                                      <dx:ASPxDateEdit ID="birthdateEdit" runat="server" EditFormat="Date" Width="95%" ReadOnly="False" Value='<%# Bind("Birthday") %>' />
                                                   </Template>
                                                 </dx:GridViewColumnLayoutItem>
                                                 --%>
                          
                                                 <dx:GridViewColumnLayoutItem ColumnName="Site" Caption="Site" ColumnSpan="1">
                                                   <Template>
                                                      <dx:ASPxTextBox ID="siteTextBox" runat="server" Width="80%" Text='<%# Bind("Site") %>' />
                                                   </Template>
                                                 </dx:GridViewColumnLayoutItem>
                          
                                                 <dx:GridViewColumnLayoutItem ColumnName="Business" Caption="Business" ColumnSpan="1">
                                                   <Template>
                                                      <dx:ASPxTextBox ID="businessTextBox" runat="server" Width="80%" Text='<%# Bind("Business") %>' />
                                                   </Template>
                                                 </dx:GridViewColumnLayoutItem>
                          
                                                 <dx:GridViewColumnLayoutItem ColumnName="Job" Caption="Job" ColumnSpan="1">
                                                   <Template>
                                                      <dx:ASPxTextBox ID="jobTextBox" runat="server" Width="80%" Text='<%# Bind("Job") %>' />
                                                   </Template>
                                                 </dx:GridViewColumnLayoutItem>
                          
                                                 <dx:GridViewColumnLayoutItem ColumnName="Memberships" Caption="Memberships" ColumnSpan="1">
                                                   <Template>
                                                      <dx:ASPxTextBox ID="memberTextBox" runat="server" Width="80%" Text='<%# Bind("Memberships") %>' />
                                                   </Template>
                                                 </dx:GridViewColumnLayoutItem>
                          
                                                 <dx:GridViewColumnLayoutItem ColumnName="Guest" Caption="IsGuest" ColumnSpan="1">
                                                   <Template>
                                                      <dx:ASPxCheckBox ID="guestCheckBox" runat="server" Width="80%" Value='<%# Bind("Guest") %>' />
                                                   </Template>
                                                 </dx:GridViewColumnLayoutItem>
                          
                                                 <dx:GridViewColumnLayoutItem ColumnName="Operator" Caption="IsOperator" ColumnSpan="1">
                                                   <Template>
                                                      <dx:ASPxCheckBox ID="saCheckBox" runat="server" Width="80%" Value='<%# Bind("Operator") %>' />
                                                   </Template>
                                                 </dx:GridViewColumnLayoutItem>
                          
                                                 <dx:GridViewColumnLayoutItem ColumnName="Manager" Caption="IsManager" ColumnSpan="1">
                                                   <Template>
                                                      <dx:ASPxCheckBox ID="amCheckBox" runat="server" Width="80%" Value='<%# Bind("Manager") %>' />
                                                   </Template>
                                                 </dx:GridViewColumnLayoutItem>
                          
                                                 <dx:GridViewColumnLayoutItem ColumnName="Administrator" Caption="IsAdministrator" ColumnSpan="1">
                                                   <Template>
                                                      <dx:ASPxCheckBox ID="adminCheckBox" runat="server" Width="80%" Value='<%# Bind("Administrator") %>' />
                                                   </Template>
                                                 </dx:GridViewColumnLayoutItem>

                                                 <%--
                                                 <dx:GridViewColumnLayoutItem ColumnName="Password" Caption="Password" ColumnSpan="1">
                                                   <Template>
                                                      <dx:ASPxTextBox ID="passwordTextBox" runat="server" Width="80%" Text='<%# Bind("Password") %>' />
                                                   </Template>
                                                 </dx:GridViewColumnLayoutItem>
                                                 --%>
                          
                                                 <%--
                                                 <dx:GridViewColumnLayoutItem ColumnName="Credits" Caption="Credits" ColumnSpan="1">
                                                   <Template>
                                                      <dx:ASPxTextBox ID="creditsTextBox" runat="server" Width="80%" Text='<%# Bind("Credits") %>' />
                                                   </Template>
                                                 </dx:GridViewColumnLayoutItem>
                                                 --%>
                                                       
                                                 <dx:GridViewColumnLayoutItem ColumnName="UpdatedBy" Caption="UpdatedBy" ColumnSpan="1">
                                                   <Template>
                                                      <dx:ASPxTextBox ID="updatedbyTextBox" runat="server" Width="80%" Text='<%# Bind("UpdatedBy") %>' />
                                                   </Template>
                                                 </dx:GridViewColumnLayoutItem>
                          
                                                 <%--
                                                 <dx:GridViewColumnLayoutItem ColumnName="Updated" Caption="Updated" ColumnSpan="2">
                                                --%>
                          
                                                 <dx:EditModeCommandLayoutItem Width="100%" HorizontalAlign="Right" />                                                                                                                                
                                             </Items>
                                         </dx:GridViewLayoutGroup>
                                     </Items>
                                 </EditFormLayoutProperties>
                                 <Styles>
                                     <Header BackColor="#CCCCCC" Font-Bold="True" Font-Names="Calibri" Font-Size="Small" ForeColor="#333333">
                                     </Header>
                                     <Row Font-Names="Calibri" Font-Size="Small">
                                     </Row>
                                     <FocusedRow ForeColor="Black">
                                     </FocusedRow>
                                 </Styles>
                                 <ClientSideEvents Init="OnGridViewContactsInit" SelectionChanged="OnGridViewContactsSelectionChanged" FocusedRowChanged="OnGridViewContactsFocusedRowChanged" 
                                   ToolbarItemClick="OnGridViewContactsToolbarItemClick" />
                             </dx:ASPxGridView>
                            
                             <br/>
                             <dx:ASPxButton ID="SyncButton" runat="server" Text="Sync-AD" OnClick="SyncButtonClick" Width="100" Visible="false">
                                 <ClientSideEvents Click="function(s, e) { LoadingPanel.Show(); }" />
                             </dx:ASPxButton>
                             <br/>
              
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
                                                   <img runat="server" id="AvatarUrl" src="~/Resources/Images/User.png" />
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
               
   <div style="max-width:700px;margin-left:auto; margin-right:auto;">
   <br/>
   <dx:ASPxLabel ID="WelcomeLabel" runat="server" ClientIDMode="Static" Text="Welcome to BlackBox" Font-Bold="True" Font-Size="32px" ForeColor="Red" Width="700px" />
   <br/>
     
   <dx:ASPxFormLayout ID="LoginFormLayout" runat="server" DataSourceID="ContactsDataSource" AlignItemCaptionsInAllGroups="True" UseDefaultPaddings="True">
      <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="700" />
      <Items>
          <dx:LayoutGroup Caption="User Information" ShowCaption="false" ColCount="2" SettingsItems-HorizontalAlign="Left" HorizontalAlign="Left" Width="500">
              <Items>
                  <dx:LayoutItem Caption="User Name" ShowCaption="false" VerticalAlign="Top" HorizontalAlign="Left" CaptionSettings-VerticalAlign="Middle" ColumnSpan="2">
                      <LayoutItemNestedControlCollection>
                          <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                             <dx:ASPxLabel ID="LoginFormUserNameLabel" runat="server" Font-Size="24px" Font-Bold="True"></dx:ASPxLabel> 
                          </dx:LayoutItemNestedControlContainer>
                      </LayoutItemNestedControlCollection>
                  </dx:LayoutItem>
                  <dx:LayoutItem Caption="Photo" ShowCaption="false" HorizontalAlign="Left" Width="100px" CaptionSettings-VerticalAlign="Middle" RowSpan="5">
                      <LayoutItemNestedControlCollection>
                          <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                             <dx:ASPxImage ID="LoginFormUserImage" runat="server" Height=150 Width=150 ImageAlign="Left" /> 
                          </dx:LayoutItemNestedControlContainer>
                      </LayoutItemNestedControlCollection>
                  </dx:LayoutItem>
                  <dx:LayoutItem Caption="Account Name" FieldName="SAMAccountName" ShowCaption="False">
                      <LayoutItemNestedControlCollection>
                          <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                              <dx:ASPxTextBox ID="LoginFormAccountTextBox" runat="server" Width="100%" ReadOnly="True" />
                          </dx:LayoutItemNestedControlContainer>
                      </LayoutItemNestedControlCollection>
                  </dx:LayoutItem>
                  <dx:LayoutItem Caption="Domain Name" FieldName="Domain" ShowCaption="False">
                      <LayoutItemNestedControlCollection>
                          <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                              <dx:ASPxTextBox ID="LoginFormDomainTextBox" runat="server" Width="100%" ReadOnly="True" />
                          </dx:LayoutItemNestedControlContainer>
                      </LayoutItemNestedControlCollection>
                  </dx:LayoutItem>
                   <dx:LayoutItem Caption="ID" FieldName="ID" ShowCaption="False">
                      <LayoutItemNestedControlCollection>
                          <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                              <dx:ASPxTextBox ID="LoginFormIDTextBox" runat="server" Width="100%" ReadOnly="True" />
                          </dx:LayoutItemNestedControlContainer>
                      </LayoutItemNestedControlCollection>
                  </dx:LayoutItem>
                  <dx:EmptyLayoutItem />
                  <dx:EmptyLayoutItem />
              </Items>
          </dx:LayoutGroup>

          <dx:LayoutGroup Name="RefreshButton" Caption="Reauthenticate" ShowCaption="false" ColCount="1" SettingsItems-HorizontalAlign="Left" HorizontalAlign="Left" Width="500">
              <Items>
                  <dx:LayoutItem ShowCaption="False" CssClass="buttonAlign" Width="100%">
                      <LayoutItemNestedControlCollection>
                          <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                              <dx:ASPxButton ID="ReauthenticateButton" runat="server" Text="Refresh" OnClick="ReauthenticateButtonClick" Width="100" />                                   
                          </dx:LayoutItemNestedControlContainer>
                      </LayoutItemNestedControlCollection>
                  </dx:LayoutItem>
              </Items>
          </dx:LayoutGroup>           

      </Items>
   </dx:ASPxFormLayout>
     
   </div>
                      
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
  
   <asp:ObjectDataSource ID="ContactsDataSource" runat="server" TypeName="BlackBox.Model.DataProvider" 
       SelectMethod="GetContact" UpdateMethod="UpdateContact" OldValuesParameterFormatString="original_{0}"
       OnSelecting="ContactsDataSource_Selecting" OnUpdating="ContactsDataSource_Updating" >
       <SelectParameters>
           <asp:QueryStringParameter DefaultValue="1" Name="id" QueryStringField="id" Type="Int64" />
       </SelectParameters>
       <UpdateParameters>
           <asp:QueryStringParameter DefaultValue="0" Name="id" QueryStringField="id" Type="Int64" />
           <asp:Parameter Name="uid" Type="String" />
           <asp:Parameter Name="full" Type="String" />               
           <asp:Parameter Name="first" Type="String" />
           <asp:Parameter Name="last" Type="String" />
           <asp:Parameter Name="birth" Type="DateTime" />
           <asp:Parameter Name="phone" Type="String" />
           <asp:Parameter Name="email" Type="String" />            
           <asp:Parameter Name="country" Type="String" />
           <asp:Parameter Name="city" Type="String" />
           <asp:Parameter Name="address" Type="String" />
           <asp:Parameter Name="dom" Type="String" />
           <asp:Parameter Name="sam" Type="String" />
           <asp:Parameter Name="site" Type="String" />
           <asp:Parameter Name="business" Type="String" />
           <asp:Parameter Name="job" Type="String" />
           <asp:Parameter Name="memberships" Type="String" />
           <asp:Parameter Name="guest" Type="Boolean" />
           <asp:Parameter Name="Operator" Type="Boolean" />
           <asp:Parameter Name="assetmanager" Type="Boolean" />
           <asp:Parameter Name="administrator" Type="Boolean" />                                               
       </UpdateParameters>
       <InsertParameters>
           <asp:QueryStringParameter DefaultValue="0" Name="ID" QueryStringField="id" Type="Int64" />
           <asp:ControlParameter ControlID="uidLabel" Name="UID" PropertyName="Text" Type="String" />
           <asp:ControlParameter ControlID="fullNameTextBox" Name="FullName" PropertyName="Text" Type="String" />                
           <asp:ControlParameter ControlID="firstNameTextBox" Name="FirstName" PropertyName="Text" Type="String" />
           <asp:ControlParameter ControlID="lastNameTextBox" Name="LastName" PropertyName="Text" Type="String" />
           <asp:ControlParameter ControlID="birthDateEdit" Name="Birthday" PropertyName="Value" Type="DateTime" />
           <asp:ControlParameter ControlID="phoneTextBox" Name="Phone" PropertyName="Text" Type="String" />
           <asp:ControlParameter ControlID="emailTextBox" Name="Email" PropertyName="Text" Type="String" />
           <asp:ControlParameter ControlID="countryTextBox" Name="Country" PropertyName="Text" Type="String" />
           <asp:ControlParameter ControlID="cityTextBox" Name="City" PropertyName="Text" Type="String" />
           <asp:ControlParameter ControlID="addressTextBox" Name="Address" PropertyName="Text" Type="String" />
       </InsertParameters>
   </asp:ObjectDataSource>   
   
   <asp:SqlDataSource ID="SqlSysContacts" runat="server" 
       ConnectionString="<%$ ConnectionStrings:BlackBoxConnectionString %>" 
    
       SelectCommand="SELECT [ID],[Cohort],[UID],[FullName],[FirstName],[LastName],[AddressBook],[Domain],[SAMAccountName],[Email],[PhotoFileName],[Country],[City],
                        [Address],[Phone],[Birthday],[Site],[Business],[Job],[Memberships],[Guest],[Operator],[Manager],[Administrator],[Password],[Credits],
                        [Status],[UpdatedBy],[Updated] FROM [dbo].[sysContacts] ORDER BY [Updated] DESC"
       
       InsertCommand="INSERT INTO [dbo].[sysContacts] ([Cohort],[UID],[FullName],[FirstName],[LastName],[AddressBook],[Domain],[SAMAccountName],[Email],[PhotoFileName],
                         [Country],[City],[Address],[Phone],[Birthday],[Site],[Business],[Job],[Memberships],[Guest],[Operator],[Manager],[Administrator],
                         [Password],[Credits],[Status],[UpdatedBy],[Updated])
                      VALUES(@cohort,CONVERT(nvarchar(36),NEWID()),@full,@first,@last,@book,@domain,@sam,@email,@photo,@country,@city,@address,@phone,@birthday,@site,@business,@job,@memberships,
                         @guest,@sa,@am,@admin,@password,@credits,@status,@updatedby,GetDate())"
       
       UpdateCommand="UPDATE [dbo].[sysContacts] SET [Cohort]=@cohort,[UID]=@uid,[FullName]=@full,[FirstName]=@first,[LastName]=@last,[AddressBook]=@book,[Domain]=@domain,[SAMAccountName]=@sam
                         ,[Email]=@email,[PhotoFileName]=@photo,[Country]=@country,[City]=@city,[Address]=@address,[Phone]=@phone,[Birthday]=@birthday,[Site]=@site,[Business]=@business
                         ,[Job]=@job,[Memberships]=@memberships,[Guest]=@guest,[Operator]=@sa,[Manager]=@am,[Administrator]=@admin
                         ,[Password]=@password,[Credits]=@credits,[Status]=@status,[UpdatedBy]=@updatedby,[Updated]=GetDate() WHERE [ID] = @id"
       
       DeleteCommand="DELETE FROM [dbo].[sysContacts] WHERE [ID] = @id">
       <InsertParameters>
           <asp:QueryStringParameter Name="cohort" />
           <asp:QueryStringParameter Name="uid" />
           <asp:QueryStringParameter Name="full" />             
           <asp:QueryStringParameter Name="first" />
           <asp:QueryStringParameter Name="last" />
           <asp:QueryStringParameter Name="book" />
           <asp:QueryStringParameter Name="domain" />
           <asp:QueryStringParameter Name="sam" />
           <asp:QueryStringParameter Name="email" />
           <asp:QueryStringParameter Name="photo" />
           <asp:QueryStringParameter Name="country" />
           <asp:QueryStringParameter Name="city" />
           <asp:QueryStringParameter Name="address" />
           <asp:QueryStringParameter Name="phone" />
           <asp:QueryStringParameter Name="birthday" />
           <asp:QueryStringParameter Name="site" />
           <asp:QueryStringParameter Name="business" />
           <asp:QueryStringParameter Name="job" />
           <asp:QueryStringParameter Name="memberships" />
           <asp:QueryStringParameter Name="guest" />
           <asp:QueryStringParameter Name="sa" />
           <asp:QueryStringParameter Name="am" />
           <asp:QueryStringParameter Name="admin" />
           <asp:QueryStringParameter Name="password" />
           <asp:QueryStringParameter Name="credits" />
           <asp:QueryStringParameter Name="status" />
           <asp:QueryStringParameter Name="updatedby" />
       </InsertParameters>
       <UpdateParameters>
           <asp:QueryStringParameter Name="id" />         
           <asp:QueryStringParameter Name="cohort" />
           <asp:QueryStringParameter Name="uid" />
           <asp:QueryStringParameter Name="full" />             
           <asp:QueryStringParameter Name="first" />
           <asp:QueryStringParameter Name="last" />
           <asp:QueryStringParameter Name="book" />
           <asp:QueryStringParameter Name="domain" />
           <asp:QueryStringParameter Name="sam" />
           <asp:QueryStringParameter Name="email" />
           <asp:QueryStringParameter Name="photo" />
           <asp:QueryStringParameter Name="country" />
           <asp:QueryStringParameter Name="city" />
           <asp:QueryStringParameter Name="address" />
           <asp:QueryStringParameter Name="phone" />
           <asp:QueryStringParameter Name="birthday" />
           <asp:QueryStringParameter Name="site" />
           <asp:QueryStringParameter Name="business" />
           <asp:QueryStringParameter Name="job" />
           <asp:QueryStringParameter Name="memberships" />
           <asp:QueryStringParameter Name="guest" />
           <asp:QueryStringParameter Name="sa" />
           <asp:QueryStringParameter Name="am" />
           <asp:QueryStringParameter Name="admin" />
           <asp:QueryStringParameter Name="password" />
           <asp:QueryStringParameter Name="credits" />
           <asp:QueryStringParameter Name="status" />
           <asp:QueryStringParameter Name="updatedby" />
       </UpdateParameters>

       <DeleteParameters>
           <asp:QueryStringParameter Name="id" />
       </DeleteParameters>
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