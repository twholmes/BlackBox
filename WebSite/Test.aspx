<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Test.aspx.cs" Inherits="BlackBox.TestPage" Title="BlackBox" %>

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
 
  // ***    
  // *** event function declarations
  // ***

  window.OnMenuItemClick = OnMenuItemClick; 
  window.OnPageToolbarItemClick = OnPageToolbarItemClick;
  

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
       CssClass="left-panel" Paddings-Padding="0" BackColor="#000066">
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

           <%-- this is an user level menu --%>                              
           <dx:ASPxMenu ID="ASPxMenuTop" runat="server" ClientInstanceName="topMenu" Orientation="Vertical" 
               BackColor="#000066" Font-Bold="True" Font-Size="X-Large" ForeColor="White" HorizontalAlign="Left" VerticalAlign="Middle" 
               Width="100%" AllowSelectItem="True" AppearAfter="10" ItemWrap="False" MaximumDisplayLevels="1" LinkStyle-HoverColor="#6699FF">
               <Border BorderColor="#000066" />
               <BorderBottom BorderColor="#000066" BorderWidth="20px" />
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
               BackColor="#000066" Font-Bold="False" Font-Size="Large" ForeColor="White" HorizontalAlign="Left" VerticalAlign="Middle" 
               Width="100%" AllowSelectItem="True" AppearAfter="10" ItemWrap="False" MaximumDisplayLevels="1" LinkStyle-HoverColor="#6699FF">
               <Border BorderColor="#000066" />
               <BorderBottom BorderColor="#000066" BorderWidth="20px" />                        
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
           
           <%-- this is an administrator level menu --%>
           <dx:ASPxMenu ID="ASPxMenuAdministrator" runat="server" ClientInstanceName="mainMenu" Orientation="Vertical" 
               BackColor="#000066" Font-Bold="False" Font-Size="Large" ForeColor="White" HorizontalAlign="Left" VerticalAlign="Middle" 
               Width="100%" AllowSelectItem="True" AppearAfter="10" ItemWrap="False" MaximumDisplayLevels="1" LinkStyle-HoverColor="#6699FF">
               <Border BorderColor="#000066" />
               <BorderBottom BorderColor="#000066" BorderWidth="20px" />                     
               <SettingsAdaptivity Enabled="true" EnableAutoHideRootItems="False" EnableCollapseRootItemsToIcons="true" CollapseRootItemsToIconsAtWindowInnerWidth="200" />
               <Items>
                  <dx:MenuItem Name="MainMenuSystem" Text="System" NavigateUrl="~/Super/Uploads.aspx">
                      <Image IconID="dashboards_servermode_svg_white_32x32" />
                  </dx:MenuItem>               	
                  <dx:MenuItem Name="MainMenuSettings" Text="Settings" NavigateUrl="~/Super/Settings.aspx">
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
           
           <%-- this is an administrator level menu --%>
           <dx:ASPxMenu ID="ASPxMenuBottom" runat="server" ClientInstanceName="bottomMenu" Orientation="Vertical"
               BackColor="#000066" Font-Bold="False" Font-Size="Large" ForeColor="White" HorizontalAlign="Left" VerticalAlign="Bottom" 
               Width="100%" AllowSelectItem="True" AppearAfter="10" ItemWrap="False" MaximumDisplayLevels="1" LinkStyle-HoverColor="#6699FF">
               <Border BorderColor="#000066" />
               <BorderBottom BorderColor="#000066" BorderWidth="20px" />                        
               <SettingsAdaptivity Enabled="true" EnableAutoHideRootItems="False" EnableCollapseRootItemsToIcons="true" CollapseRootItemsToIconsAtWindowInnerWidth="200" />                        
               <Items>
                      <dx:MenuItem Name="MainMenuTest" NavigateUrl="~/Test.aspx" Text="Test">
                          <Image IconID="xaf_actiongroup_easytestrecorder_svg_white_32x32" />
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
                                               <dx:ASPxButton ID="btAdminPages" runat="server" Text="Admin Pages" Width="80px" AutoPostBack="False" Style="float: left; margin-right: 8px">
                                                   <ClientSideEvents Click="function(s, e) { pcSystem.Hide(); window.open('admin.aspx','_self'); }" />
                                               </dx:ASPxButton>
                                               <dx:ASPxLabel ID="SpacerLabel2" runat="server" Text="  " />
                                               <dx:ASPxButton ID="btMgrPages" runat="server" Text="Manager Pages" Width="80px" AutoPostBack="False" Style="float: left; margin-right: 8px">
                                                   <ClientSideEvents Click="function(s, e) { pcSystem.Hide(); window.open('manager.aspx','_self'); }" />
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
               
   <div style="max-width:1100px;margin-left:auto; margin-right:auto;">
   <br/>
   <dx:ASPxLabel ID="WelcomeLabel" runat="server" ClientIDMode="Static" Text="BlackBox TEST PAGE" Font-Bold="True" Font-Size="32px" ForeColor="Red" Width="1200px" />
   <br/><br/><br/>                
        
   <table>
     <tr>
     	<%--
       <td Width="550px" style="height: 40px; font-weight: normal; font-size: 9pt; font-family: 'Microsoft Sans Serif'; background-color: #F5F5F5;">
          <dx:WebChartControl ID="WebChartControl1" runat="server" AutoLayout="True" BackColor="#F2F2F2" CrosshairEnabled="True" DataSourceID="SqlDataSourceCharts"
            OnObjectSelected="WebChartControl1_ObjectSelected" OnSelectedItemsChanged="WebChartControl1_SelectedItemsChanged" OnSelectedItemsChanging="WebChartControl1_SelectedItemsChanging" 
            SelectionMode="Single" SeriesSelectionMode="Point" Height="300px" Width="500px">
              <DiagramSerializable>
                  <dx:XYDiagram>
                      <axisx minorcount="6" visibleinpanesserializable="-1">
                      </axisx>
                      <axisy visibleinpanesserializable="-1">
                      </axisy>
                  </dx:XYDiagram>
              </DiagramSerializable>
              <Legend Name="Default Legend"></Legend>
              <SeriesSerializable>
                  <dx:Series ArgumentDataMember="Name" Name="Record Counts" ValueDataMembersSerializable="Rows">
                  </dx:Series>
              </SeriesSerializable>
              <Titles>
                  <dx:ChartTitle Font="Tahoma, 12pt" Indent="4" Text="Dataset Record Counts" />
              </Titles>
              <%-- <ClientSideEvents ObjectSelected="SetConsumed" /> --%>
          </dx:WebChartControl>                   
       </td>
       <td Width="50px">
         &nbsp;
       </td>
       --%>
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
       <td Width="650px">             
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
   </table>
  
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

   <asp:SqlDataSource ID="SqlDataSourceCharts" runat="server" 
     ConnectionString="<%$ ConnectionStrings:BlackBoxConnectionString %>" 
     ProviderName="<%$ ConnectionStrings:BlackBoxConnectionString.ProviderName %>" 
     SelectCommand="SELECT [Group],[Name],[DataSourceInstanceID],[Rows],[Age],[Rank] FROM [dbo].[vStagedRecordCounts] WHERE [Group] = 'RIOTINTO' AND [Rank] < 5 ORDER BY [Name], [Rank] desc">
   </asp:SqlDataSource>
   
   <asp:SqlDataSource ID="SqlDataSourceCharts1" runat="server" 
     ConnectionString="<%$ ConnectionStrings:BlackBoxConnectionString %>" 
     ProviderName="<%$ ConnectionStrings:BlackBoxConnectionString.ProviderName %>" 
     SelectCommand="SELECT [Group],[Name],[DataSourceInstanceID],[Rows],[Age],[Rank] FROM [dbo].[vStagedRecordCounts] WHERE [Name] = 'SiteAuditAssetList' ORDER BY [Rank] desc">
   </asp:SqlDataSource>

   <asp:SqlDataSource ID="SqlDataSourceCharts2" runat="server" 
     ConnectionString="<%$ ConnectionStrings:BlackBoxConnectionString %>" 
     ProviderName="<%$ ConnectionStrings:BlackBoxConnectionString.ProviderName %>" 
     SelectCommand="SELECT [Group],[Name],[DataSourceInstanceID],[Rows],[Age],[Rank] FROM [dbo].[vStagedRecordCounts] WHERE [Name] = 'SIA' ORDER BY [Rank] desc">
   </asp:SqlDataSource>

   <asp:SqlDataSource ID="SqlDataSourceCharts3" runat="server" 
     ConnectionString="<%$ ConnectionStrings:BlackBoxConnectionString %>" 
     ProviderName="<%$ ConnectionStrings:BlackBoxConnectionString.ProviderName %>" 
     SelectCommand="SELECT [Group],[Name],[DataSourceInstanceID],[Rows],[Age],[Rank] FROM [dbo].[vStagedRecordCounts] WHERE [Name] = 'SIDA' ORDER BY [Rank] desc">
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