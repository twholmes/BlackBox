<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Spreadsheet.aspx.cs" Inherits="BlackBox.SpreadsheetPage" Title="BlackBox" %>

<%@ Register assembly="DevExpress.Web.v22.2, Version=22.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" namespace="DevExpress.Web" tagprefix="dx" %>
<%@ Register assembly="DevExpress.Web.ASPxSpreadsheet.v22.2, Version=22.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" namespace="DevExpress.Web.ASPxSpreadsheet" tagprefix="dx" %>

<!DOCTYPE html>

<html>

<%--
**** HEADER CONTENT
--%>

<head runat="server" EnableViewState="false">
  <meta charset="UTF-8" />
  <title></title>
  <meta name="viewport" content="width=device-width, user-scalable=no, maximum-scale=1.0, minimum-scale=1.0" />
  <meta http-equiv='refresh' content='14400;url=~/timeout.aspx' />     
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
          //openURL("~/Help.aspx", false);
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
    var enabled = cardViewDataSources.GetSelectedCardCount() > 0;
    //pageToolbar.GetItemByName("Delete").SetEnabled(enabled);
    //pageToolbar.GetItemByName("Edit").SetEnabled(cardViewDataSources.GetFocusedRowIndex() !== -1);
  }
    
  function OnPageToolbarItemClick(s, e) 
  {
    switch(e.item.name) 
    {
      case "Details":
          break;
    }
  }

  // /////////////////////////////
  // actions callback functions
  // /////////////////////////////
         
  function OnActionsCallbackComplete(s, e) 
  {
    var result = e.result;
    Spreadsheet.Refresh();
    //gridViewUploadedFiles.Refresh();    
    //LoadingPanel.Hide();
  }
 
  // ///////////////////////
  // spreadsheet functions
  // ///////////////////////
           
  // spreadsheet events
  function OnExceptionOccurred(s, e) 
  {
    tbAlertMessage.SetText(e.message);        
    pcAlert.Show();  	
  }

  function OnCustomCommandExecuted(s, e) 
  {
  	s.PerformCallback(e.commandName);    
    //actionsCallback.PerformCallback(e.commandName);  	
    //LoadingPanel.Show();        	
  }
    
  // ***    
  // *** event function declarations
  // ***

  window.OnMenuItemClick = OnMenuItemClick;  
  window.OnPageToolbarItemClick = OnPageToolbarItemClick;

  window.OnExceptionOccurred = OnExceptionOccurred;
  window.OnCustomCommandExecuted = OnCustomCommandExecuted;

  </script>
   
</head>

<body>
<form id="PageForm" runat="server" class="form">
  <%--
  **** SCRIPT MANAGER
  --%>

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
        
          <%-- this is an manager level menu --%>
          <dx:ASPxMenu ID="ASPxMenuMiddle" runat="server" ClientInstanceName="middleMenu" Orientation="Vertical" 
              BackColor="#616161" Font-Bold="False" Font-Size="Large" ForeColor="White" HorizontalAlign="Left" VerticalAlign="Middle" 
              Width="100%" AllowSelectItem="True" AppearAfter="10" ItemWrap="False" MaximumDisplayLevels="1" LinkStyle-HoverColor="#6699FF">
              <Border BorderColor="#616161" />
              <BorderBottom BorderColor="#616161" BorderWidth="20px" />                        
              <SettingsAdaptivity Enabled="true" EnableAutoHideRootItems="False" EnableCollapseRootItemsToIcons="true" CollapseRootItemsToIconsAtWindowInnerWidth="200" />                        
              <Items> 
                  <dx:MenuItem Name="MainMenuLogs" NavigateUrl="~/FileManager.aspx" Text="File Manager">
                      <Image IconID="actions_open2_svg_white_32x32" />                      
                  </dx:MenuItem>                                                 
                  <dx:MenuItem Name="MainMenuLogs" NavigateUrl="~/Logs.aspx" Text="Logs">
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
                  <dx:MenuItem Name="MainMenuHelp" NavigateUrl="~/Help.aspx" Text="Help">
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
                     **** OPTIONS TABPAGE
                     --%>
                   
                     <dx:TabPage Text="Spreadsheet Settings" Visible="true">
                        <ContentCollection>
                            <dx:ContentControl ID="ContentControlRight1" runat="server">
                   
                            <dx:ASPxFormLayout ID="SettingsFormLayout" runat="server" AlignItemCaptionsInAllGroups="True" UseDefaultPaddings="True">
                               <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="700" />
                               <Items>                                      
                                   <dx:LayoutGroup Caption="Ribbon Menu Options" ShowCaption="true" ColCount="2" SettingsItems-HorizontalAlign="Left" HorizontalAlign="Left" Width="500">
                                       <Items>
                                           <dx:LayoutItem Caption="Ribbon View Mode" ShowCaption="True" ColumnSpan="2">
                                               <LayoutItemNestedControlCollection>
                                                   <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">                                            	
                                                       <dx:ASPxComboBox ID="RibbonViewModeComboBox" DropDownStyle="DropDown" runat="server" Width="50%">
                                                          <Items>
                                                             <dx:ListEditItem Value="Reading" Text="Reading" />                                                     
                                                             <dx:ListEditItem Value="Editing" Text="Editing" />
                                                          </Items>
                                                       </dx:ASPxComboBox>
                                                   </dx:LayoutItemNestedControlContainer>
                                               </LayoutItemNestedControlCollection>
                                           </dx:LayoutItem>

                                           <dx:LayoutItem Caption="Show Common File Commands" ShowCaption="True">
                                               <LayoutItemNestedControlCollection>
                                                   <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                                       <dx:ASPxCheckBox ID="cbFilesCommonVisible" runat="server" AutoPostBack="False" Width="50" Checked="False" />
                                                   </dx:LayoutItemNestedControlContainer>
                                               </LayoutItemNestedControlCollection>
                                           </dx:LayoutItem>
                                           
                                           <dx:EmptyLayoutItem />
                                       </Items>
                                   </dx:LayoutGroup>
                            
                                   <dx:LayoutGroup Name="UpdateButtonGroup" Caption="Update" ShowCaption="false" ColCount="1" SettingsItems-HorizontalAlign="Left" HorizontalAlign="Left" Width="500">
                                       <Items>
                                           <dx:LayoutItem ShowCaption="False" CssClass="buttonAlign" Width="100%">
                                               <LayoutItemNestedControlCollection>
                                                   <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                                       <dx:ASPxButton ID="UpdateSettingsButton" runat="server" Text="Update" OnClick="UpdateSettingsButtonClick" Width="100" Visible="true">
                                                           <ClientSideEvents Click="function(s, e) { LoadingPanel.Show(); }" />
                                                       </dx:ASPxButton>                          
                                                   </dx:LayoutItemNestedControlContainer>
                                               </LayoutItemNestedControlCollection>
                                           </dx:LayoutItem>
                                       </Items>
                                   </dx:LayoutGroup>           
                            
                               </Items>
                            </dx:ASPxFormLayout>
                   
                            </dx:ContentControl>
                       </ContentCollection>
                     </dx:TabPage>
                           	
                     <%--
                     **** FILE MANAGER TABPAGE
                     --%>

                     <dx:TabPage Text="File Manager" Visible="true">
                        <ContentCollection>
                            <dx:ContentControl ID="RightPanelContentControl2" runat="server">    
          
                            <dx:ASPxFileManager runat="server" ID="fileManager" ClientInstanceName="fileManager" OnFolderCreating="FileManager_FolderCreating"
                                OnItemDeleting="FileManager_ItemDeleting" OnItemMoving="FileManager_ItemMoving" OnCustomThumbnail="OnFileManagerCustomThumbnails"
                                OnItemRenaming="FileManager_ItemRenaming" OnFileUploading="FileManager_FileUploading" OnItemCopying="FileManager_ItemCopying">
                                <Settings RootFolder="~/Data" ThumbnailFolder="~/Resources/Thumbnails" 
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
                     **** SETTINGS TABPAGE
                     --%>

                     <dx:TabPage Text="Settings" Visible="false">
                        <ContentCollection>
                            <dx:ContentControl ID="RightPanelContentControl3" runat="server">    
              
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
                                         <dx:ASPxLabel ID="BreadcrumbsLabel" runat="server" Text="Open Spreadsheet" Font-Bold="True" Font-Size="Large" Width="850px" />
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
                          <dx:MenuItem Name="PageMenuUploads" Text="Uploads" NavigateUrl="../RioTinto/CriticalityUploads.aspx" Target="_blank" Alignment="Left" AdaptivePriority="2">
                               <Image IconID="snap_datasource_svg_dark_16x16" />
                          </dx:MenuItem>

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
                                  <dx:MenuItem Name="ReauthenticateItem" Text="Reauthentice user" Image-Url="~/Resources/Images/sign-out.svg" Image-Height="16px">
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

   <%--
   **** SPREADSHEET VIEW
   --%>
 
   <dx:ASPxSpreadsheet ID="Spreadsheet" runat="server" ClientInstanceName="Spreadsheet" Width="100%" Height="700px" RibbonMode="Auto" ActiveTabIndex="0" ShowConfirmOnLosingChanges="false"
   	   OnCallback="Spreadsheet_Callback" > 
       <RibbonTabs>
           <dx:SRFileTab>
               <Groups>
                   <dx:SRFileCommonGroup>
                       <Items>
                           <dx:SRFileNewCommand></dx:SRFileNewCommand>
                           <dx:SRFileOpenCommand></dx:SRFileOpenCommand>
                           <dx:SRFileSaveCommand></dx:SRFileSaveCommand>
                           <dx:SRFileSaveAsCommand></dx:SRFileSaveAsCommand>
                           <dx:SRFilePrintCommand></dx:SRFilePrintCommand>
                       </Items>
                   </dx:SRFileCommonGroup>
               </Groups>
           </dx:SRFileTab>
           <dx:SRHomeTab>
               <Groups>
                   <dx:SRUndoGroup>
                       <Items>
                           <dx:SRFileUndoCommand></dx:SRFileUndoCommand>
                           <dx:SRFileRedoCommand></dx:SRFileRedoCommand>
                       </Items>
                   </dx:SRUndoGroup>
                   <dx:SRClipboardGroup>
                       <Items>
                           <dx:SRPasteSelectionCommand></dx:SRPasteSelectionCommand>
                           <dx:SRCutSelectionCommand></dx:SRCutSelectionCommand>
                           <dx:SRCopySelectionCommand></dx:SRCopySelectionCommand>
                       </Items>
                   </dx:SRClipboardGroup>
                   <dx:SRFontGroup>
                       <Items>
                           <dx:SRFormatFontNameCommand>
                               <PropertiesComboBox NullText="(Font Name)"></PropertiesComboBox>
                           </dx:SRFormatFontNameCommand>
                           <dx:SRFormatFontSizeCommand>
                               <PropertiesComboBox DropDownStyle="DropDown" NullText="(Font Size)"></PropertiesComboBox>
                           </dx:SRFormatFontSizeCommand>
                           <dx:SRFormatIncreaseFontSizeCommand></dx:SRFormatIncreaseFontSizeCommand>
                           <dx:SRFormatDecreaseFontSizeCommand></dx:SRFormatDecreaseFontSizeCommand>
                           <dx:SRFormatFontBoldCommand></dx:SRFormatFontBoldCommand>
                           <dx:SRFormatFontItalicCommand></dx:SRFormatFontItalicCommand>
                           <dx:SRFormatFontUnderlineCommand></dx:SRFormatFontUnderlineCommand>
                           <dx:SRFormatFontStrikeoutCommand></dx:SRFormatFontStrikeoutCommand>
                           <dx:SRFormatBordersCommand></dx:SRFormatBordersCommand>
                           <dx:SRFormatFillColorCommand EnableCustomColors="True" EnableAutomaticColorItem="True" AutomaticColorItemCaption="No Fill" AutomaticColor="" AutomaticColorItemValue="16777215"></dx:SRFormatFillColorCommand>
                           <dx:SRFormatFontColorCommand EnableCustomColors="True" EnableAutomaticColorItem="True" AutomaticColorItemCaption="Automatic" AutomaticColorItemValue="0"></dx:SRFormatFontColorCommand>
                           <dx:SRFormatBorderLineColorCommand EnableCustomColors="True" EnableAutomaticColorItem="True" AutomaticColorItemCaption="Automatic" AutomaticColorItemValue="0"></dx:SRFormatBorderLineColorCommand>
                       </Items>
                   </dx:SRFontGroup>
                   <dx:SRAlignmentGroup>
                       <Items>
                           <dx:SRFormatAlignmentTopCommand></dx:SRFormatAlignmentTopCommand>
                           <dx:SRFormatAlignmentMiddleCommand></dx:SRFormatAlignmentMiddleCommand>
                           <dx:SRFormatAlignmentBottomCommand></dx:SRFormatAlignmentBottomCommand>
                           <dx:SRFormatAlignmentLeftCommand></dx:SRFormatAlignmentLeftCommand>
                           <dx:SRFormatAlignmentCenterCommand></dx:SRFormatAlignmentCenterCommand>
                           <dx:SRFormatAlignmentRightCommand></dx:SRFormatAlignmentRightCommand>
                           <dx:SRFormatDecreaseIndentCommand></dx:SRFormatDecreaseIndentCommand>
                           <dx:SRFormatIncreaseIndentCommand></dx:SRFormatIncreaseIndentCommand>
                           <dx:SRFormatWrapTextCommand></dx:SRFormatWrapTextCommand>
                           <dx:SREditingMergeCellsGroupCommand></dx:SREditingMergeCellsGroupCommand>
                       </Items>
                   </dx:SRAlignmentGroup>
                   <dx:SRNumberGroup ShowDialogBoxLauncher="True">
                       <Items>
                           <dx:SRFormatNumberAccountingCommand></dx:SRFormatNumberAccountingCommand>
                           <dx:SRFormatNumberPercentCommand></dx:SRFormatNumberPercentCommand>
                           <dx:SRFormatNumberCommaStyleCommand></dx:SRFormatNumberCommaStyleCommand>
                           <dx:SRFormatNumberIncreaseDecimalCommand></dx:SRFormatNumberIncreaseDecimalCommand>
                           <dx:SRFormatNumberDecreaseDecimalCommand></dx:SRFormatNumberDecreaseDecimalCommand>
                       </Items>
                   </dx:SRNumberGroup>
                   <dx:SRCellsGroup>
                       <Items>
                           <dx:SRFormatInsertCommand></dx:SRFormatInsertCommand>
                           <dx:SRFormatRemoveCommand></dx:SRFormatRemoveCommand>
                           <dx:SRFormatFormatCommand></dx:SRFormatFormatCommand>
                       </Items>
                   </dx:SRCellsGroup>
                   <dx:SREditingGroup>
                       <Items>
                           <dx:SRFormatAutoSumCommand></dx:SRFormatAutoSumCommand>
                           <dx:SRFormatFillCommand></dx:SRFormatFillCommand>
                           <dx:SRFormatClearCommand></dx:SRFormatClearCommand>
                           <dx:SREditingSortAndFilterCommand></dx:SREditingSortAndFilterCommand>
                           <dx:SREditingFindAndSelectCommand></dx:SREditingFindAndSelectCommand>
                       </Items>
                   </dx:SREditingGroup>
                   <dx:SRStylesGroup>
                       <Items>
                           <dx:SRFormatAsTableCommand></dx:SRFormatAsTableCommand>
                       </Items>
                   </dx:SRStylesGroup>
               </Groups>
           </dx:SRHomeTab>
           <dx:SRInsertTab>
               <Groups>
                   <dx:SRTablesGroup>
                       <Items>
                           <dx:SRInsertPivotTableCommand></dx:SRInsertPivotTableCommand>
                           <dx:SRInsertTableCommand></dx:SRInsertTableCommand>
                       </Items>
                   </dx:SRTablesGroup>
                   <dx:SRIllustrationsGroup>
                       <Items>
                           <dx:SRFormatInsertPictureCommand></dx:SRFormatInsertPictureCommand>
                       </Items>
                   </dx:SRIllustrationsGroup>
                   <dx:SRChartsGroup>
                       <Items>
                           <dx:SRInsertChartColumnCommand></dx:SRInsertChartColumnCommand>
                           <dx:SRInsertChartLinesCommand></dx:SRInsertChartLinesCommand>
                           <dx:SRInsertChartPiesCommand></dx:SRInsertChartPiesCommand>
                           <dx:SRInsertChartBarsCommand></dx:SRInsertChartBarsCommand>
                           <dx:SRInsertChartAreasCommand></dx:SRInsertChartAreasCommand>
                           <dx:SRInsertChartScattersCommand></dx:SRInsertChartScattersCommand>
                           <dx:SRInsertChartOthersCommand></dx:SRInsertChartOthersCommand>
                       </Items>
                   </dx:SRChartsGroup>
                   <dx:SRLinksGroup>
                       <Items>
                           <dx:SRFormatInsertHyperlinkCommand></dx:SRFormatInsertHyperlinkCommand>
                       </Items>
                   </dx:SRLinksGroup>
               </Groups>
           </dx:SRInsertTab>
           <dx:SRPageLayoutTab>
               <Groups>
                   <dx:SRPageSetupGroup ShowDialogBoxLauncher="True">
                       <Items>
                           <dx:SRPageSetupMarginsCommand></dx:SRPageSetupMarginsCommand>
                           <dx:SRPageSetupOrientationCommand></dx:SRPageSetupOrientationCommand>
                           <dx:SRPageSetupPaperKindCommand></dx:SRPageSetupPaperKindCommand>
                       </Items>
                   </dx:SRPageSetupGroup>
                   <dx:SRPrintGroup ShowDialogBoxLauncher="True">
                       <Items>
                           <dx:SRPrintGridlinesCommand></dx:SRPrintGridlinesCommand>
                           <dx:SRPrintHeadingsCommand></dx:SRPrintHeadingsCommand>
                       </Items>
                   </dx:SRPrintGroup>
               </Groups>
           </dx:SRPageLayoutTab>
           <dx:SRFormulasTab>
               <Groups>
                   <dx:SRFunctionLibraryGroup>
                       <Items>
                           <dx:SRFunctionsAutoSumCommand></dx:SRFunctionsAutoSumCommand>
                           <dx:SRFunctionsFinancialCommand></dx:SRFunctionsFinancialCommand>
                           <dx:SRFunctionsLogicalCommand></dx:SRFunctionsLogicalCommand>
                           <dx:SRFunctionsTextCommand></dx:SRFunctionsTextCommand>
                           <dx:SRFunctionsDateAndTimeCommand></dx:SRFunctionsDateAndTimeCommand>
                           <dx:SRFunctionsLookupAndReferenceCommand></dx:SRFunctionsLookupAndReferenceCommand>
                           <dx:SRFunctionsMathAndTrigonometryCommand></dx:SRFunctionsMathAndTrigonometryCommand>
                           <dx:SRFunctionsMoreCommand></dx:SRFunctionsMoreCommand>
                       </Items>
                   </dx:SRFunctionLibraryGroup>
                   <dx:SRCalculationGroup>
                       <Items>
                           <dx:SRFunctionsCalculationOptionCommand></dx:SRFunctionsCalculationOptionCommand>
                           <dx:SRFunctionsCalculateNowCommand></dx:SRFunctionsCalculateNowCommand>
                           <dx:SRFunctionsCalculateSheetCommand></dx:SRFunctionsCalculateSheetCommand>
                       </Items>
                   </dx:SRCalculationGroup>
               </Groups>
           </dx:SRFormulasTab>
           <dx:SRDataTab>
               <Groups>
                   <dx:SRDataSortAndFilterGroup>
                       <Items>
                           <dx:SRDataSortAscendingCommand></dx:SRDataSortAscendingCommand>
                           <dx:SRDataSortDescendingCommand></dx:SRDataSortDescendingCommand>
                           <dx:SRDataFilterToggleCommand ShowText="True"></dx:SRDataFilterToggleCommand>
                           <dx:SRDataFilterClearCommand></dx:SRDataFilterClearCommand>
                           <dx:SRDataFilterReApplyCommand></dx:SRDataFilterReApplyCommand>
                       </Items>
                   </dx:SRDataSortAndFilterGroup>
                   <dx:SRDataToolsGroup>
                       <Items>
                           <dx:SRDataToolsDataValidationGroupCommand></dx:SRDataToolsDataValidationGroupCommand>
                       </Items>
                   </dx:SRDataToolsGroup>
                   <dx:RibbonGroup Text="BlackBox" Name="BlackBox">
                       <Items>
                          <dx:RibbonDropDownButtonItem Text="Data Corrections" Name="Fixes" SubGroupName="Fixes" Size="Large">
                              <Items>
                                  <dx:RibbonDropDownButtonItem Text="Trim Data" Name="Fix1" Size="Large">
                                      <LargeImage IconID="dashboards_zoom2_svg_gray_32x32"></LargeImage>
                                      <SmallImage IconID="dashboards_zoom2_svg_gray_16x16"></SmallImage>
                                  </dx:RibbonDropDownButtonItem>                                 
                                  <dx:RibbonDropDownButtonItem Text="Fix Blank Dates" Name="Fix2" Size="Large">
                                      <LargeImage IconID="iconbuilder_actions_calendar_svg_gray_32x32"></LargeImage>
                                      <SmallImage IconID="iconbuilder_actions_calendar_svg_gray_16x16"></SmallImage>
                                  </dx:RibbonDropDownButtonItem>                                 
                                  <dx:RibbonDropDownButtonItem Text="Fix User Names" Name="Fix3" Size="Large">
                                      <LargeImage IconID="businessobjects_bo_department_svg_gray_32x32"></LargeImage>
                                      <SmallImage IconID="businessobjects_bo_department_svg_gray_16x16"></SmallImage>
                                  </dx:RibbonDropDownButtonItem>                                 
                              </Items>                         	
                              <LargeImage IconID="dashboards_editnames_svg_gray_32x32"></LargeImage>                          	
                              <SmallImage IconID="dashboards_editnames_svg_gray_16x16"></SmallImage>
                          </dx:RibbonDropDownButtonItem>
                          <dx:RibbonOptionButtonItem Text="Stage Data" Name="Stage" Size="Large">
                              <LargeImage IconID="iconbuilder_actions_database_svg_gray_32x32"></LargeImage>                          	
                              <SmallImage IconID="iconbuilder_actions_database_svg_gray_16x16"></SmallImage>
                          </dx:RibbonOptionButtonItem>
                          <dx:RibbonOptionButtonItem Text="Run Validations" Name="Validate" ToolTip="Run validation scripts" Size="Large">
                              <LargeImage IconID="dashboards_showallvalue_svg_gray_32x32"></LargeImage>
                              <SmallImage IconID="dashboards_showallvalue_svg_gray_16x16"></SmallImage>
                          </dx:RibbonOptionButtonItem>
                       </Items>
                   </dx:RibbonGroup>
               </Groups>
           </dx:SRDataTab>
           <dx:SRReviewTab>
               <Groups>
                   <dx:SRCommentsGroup>
                       <Items>
                           <dx:SRInsertCommentCommand></dx:SRInsertCommentCommand>
                           <dx:SREditCommentCommand></dx:SREditCommentCommand>
                           <dx:SRDeleteCommentCommand></dx:SRDeleteCommentCommand>
                           <dx:SRShowHideCommentCommand></dx:SRShowHideCommentCommand>
                       </Items>
                   </dx:SRCommentsGroup>
               </Groups>
           </dx:SRReviewTab>
           <dx:SRViewTab>
               <Groups>
                   <dx:SRDocumentViewsGroup>
                       <Items>
                           <dx:SRViewToggleEditingViewCommand></dx:SRViewToggleEditingViewCommand>
                           <dx:SRViewToggleReadingViewCommand></dx:SRViewToggleReadingViewCommand>
                       </Items>
                   </dx:SRDocumentViewsGroup>
                   <dx:SRShowGroup>
                       <Items>
                           <dx:SRViewShowGridlinesCommand></dx:SRViewShowGridlinesCommand>
                           <dx:SRViewShowHeadingsCommand></dx:SRViewShowHeadingsCommand>
                       </Items>
                   </dx:SRShowGroup>
                   <dx:SRViewGroup>
                       <Items>
                           <dx:SRFullScreenCommand></dx:SRFullScreenCommand>
                       </Items>
                   </dx:SRViewGroup>
                   <dx:SRWindowGroup>
                       <Items>
                           <dx:SRViewFreezePanesGroupCommand></dx:SRViewFreezePanesGroupCommand>
                       </Items>
                   </dx:SRWindowGroup>
               </Groups>
           </dx:SRViewTab>
           <dx:SRReadingViewTab>
               <Groups>
                   <dx:SRReadingViewGroup>
                       <Items>
                           <dx:SRViewToggleEditingViewCommand></dx:SRViewToggleEditingViewCommand>
                           <dx:SRFilePrintCommand></dx:SRFilePrintCommand>
                           <dx:SRDownloadCommand></dx:SRDownloadCommand>
                           <dx:SREditingFindAndSelectCommand></dx:SREditingFindAndSelectCommand>
                       </Items>
                   </dx:SRReadingViewGroup>
               </Groups>
           </dx:SRReadingViewTab>
           <dx:RibbonTab Text="BlackBox" Name="BlackBox">
               <Groups>
                   <dx:RibbonGroup Text="Group" Name="Template">
                       <Items>
                           <dx:RibbonComboBoxItem>
                               <Items>
                                   <dx:ListEditItem Text="Criticality" Value="Criticality"></dx:ListEditItem>
                                   <dx:ListEditItem Text="SIDA" Value="SIDA"></dx:ListEditItem>
                               </Items>
                           </dx:RibbonComboBoxItem>
                       </Items>
                   </dx:RibbonGroup>
                   <dx:RibbonGroup Text="Group" Name="Validation">
                       <Items>
                           <dx:RibbonOptionButtonItem Text="Test2" Name="Test2">
                               <SmallImage IconID="dashboards_itemtypestandard_svg_gray_16x16"></SmallImage>
                           </dx:RibbonOptionButtonItem>
                       </Items>
                   </dx:RibbonGroup>
                   <dx:RibbonGroup Text="Group" Name="Processing">
                       <Items>
                           <dx:RibbonToggleButtonItem Text="Test3" Name="Test3">
                               <LargeImage IconID="dashboards_unpinbutton_svg_gray_32x32"></LargeImage>
                           </dx:RibbonToggleButtonItem>
                       </Items>
                   </dx:RibbonGroup>
               </Groups>
           </dx:RibbonTab>
       </RibbonTabs>
       <ClientSideEvents CallbackError="OnExceptionOccurred" CustomCommandExecuted="OnCustomCommandExecuted"  />
   </dx:ASPxSpreadsheet>

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
  
   <%--
   **** DATA SOURCES
   --%>
 
   <asp:SqlDataSource ID="SqlBlackBoxFiles" runat="server" 
      ConnectionString="<%$ ConnectionStrings:BlackBoxConnectionString %>" 
      SelectCommand="SELECT TOP(100) [FID],[JOBID],[GUID],[Name],[Location],[TypeID],[Type],[Group],[Description],[DataSource],[DataSourceInstanceID],[Datasets],[StatusID],[Status],[Validations],[Locked],[UserID],[SAMAccountName],[TimeStamp],[Age],[Rank] FROM [dbo].[vBlackBoxFilesWithValidation] WHERE [UserID] = @userid ORDER BY [TimeStamp] DESC"
      InsertCommand="INSERT INTO [dbo].[BlackBoxFiles] ([JOBID],[GUID],[Name],[Location],[TypeID],[Group],[Description],[DataSource],[DataSourceInstanceID],[Datasets],[StatusID],[Locked],[TimeStamp]) VALUES(@jobid,@guid,@name,@location,@typeid,@group,@description,@datasource,@dsiid,@datasets,@statusid,@locked,@timestamp)"
      UpdateCommand="UPDATE [dbo].[BlackBoxFiles] SET [JOBID]=@jobid,[GUID]=@guid,[Name]=@name,[Location]=@location,[TypeID]=@typeid,[Group]=@group,[Description]=@description,[DataSource]=@datasource,[DataSourceInstanceID]=@dsiid,[Datasets]=@datasets,[StatusID]=@statusid,[Locked]=@locked,[TimeStamp]=@timestamp WHERE [FID] = @fid"
      DeleteCommand="DELETE FROM [dbo].[BlackBoxFiles] WHERE [FID] = @fid">
      <%--OnSelecting="SqlBlackBoxFiles_Selecting">--%>
       <SelectParameters>
           <asp:QueryStringParameter DefaultValue="0" Name="userid" QueryStringField="UserID" Type="Int32" />
       </SelectParameters>
      <InsertParameters>
          <asp:QueryStringParameter Name="jobid" />       
          <asp:QueryStringParameter Name="guid" />
          <asp:QueryStringParameter Name="name" />
          <asp:QueryStringParameter Name="location" />
          <asp:QueryStringParameter Name="typeid" />
          <asp:QueryStringParameter Name="group" />
          <asp:QueryStringParameter Name="description" />
          <asp:QueryStringParameter Name="datasource" />
          <asp:QueryStringParameter Name="dsiid" />
          <asp:QueryStringParameter Name="datasets" />
          <asp:QueryStringParameter Name="statusid" />
          <asp:QueryStringParameter Name="locked" />
          <asp:QueryStringParameter Name="timestamp" />           
      </InsertParameters>
      <UpdateParameters>
          <asp:QueryStringParameter Name="fid" />
          <asp:QueryStringParameter Name="jobid" />                   
          <asp:QueryStringParameter Name="guid" />
          <asp:QueryStringParameter Name="name" />
          <asp:QueryStringParameter Name="location" />
          <asp:QueryStringParameter Name="typeid" />
          <asp:QueryStringParameter Name="group" />
          <asp:QueryStringParameter Name="description" />
          <asp:QueryStringParameter Name="datasource" />
          <asp:QueryStringParameter Name="dsiid" />           
          <asp:QueryStringParameter Name="datasets" />            
          <asp:QueryStringParameter Name="statusid" />
          <asp:QueryStringParameter Name="locked" />
          <asp:QueryStringParameter Name="timestamp" />
      </UpdateParameters>
      <DeleteParameters>
          <asp:QueryStringParameter Name="fid" />
      </DeleteParameters>
   </asp:SqlDataSource>

   <%--
   **** LOADING PANELS
   --%>

   <dx:ASPxLoadingPanel ID="LoadingPanel" runat="server" ClientInstanceName="LoadingPanel" Modal="True" />

  <%--
  **** CALLBACK CONTROLS
  --%>
      
  <dx:ASPxCallback ID="ASPxActionsCallback" runat="server" ClientInstanceName="actionsCallback" OnCallback="ASPxActionsCallback_Callback">
      <ClientSideEvents CallbackComplete="OnActionsCallbackComplete" />
  </dx:ASPxCallback>
  
  <%--
  **** CONTENT DATA SOURCES
  --%>
  
  <dx:ASPxGlobalEvents runat="server">
      <ClientSideEvents ControlsInitialized="onControlsInitialized" BrowserWindowResized="onBrowserWindowResized" />
  </dx:ASPxGlobalEvents>
  
</form>

</body>
</html>