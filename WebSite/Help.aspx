<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="Root.master" CodeBehind="Help.aspx.cs" Inherits="BlackBox.HelpPage" Title="BlackBox" %>

<%@ Register assembly="DevExpress.Web.v22.2, Version=22.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" namespace="DevExpress.Web" tagprefix="dx" %>

<%--
**** HEADER CONTENT
--%>

<asp:Content runat="server" ContentPlaceHolderID="ContentPlaceHolderHead">
  
  <style type="text/css">

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
  // page functions
  // ///////////////////////
           
  // page toolbar
  function updateToolbarButtonsState() 
  {
  }
    
  function OnPageToolbarItemClick(s, e) 
  {
    switch(e.item.name) 
    {
      case "Dummy":
          break;
    }
  }       
   
  // ///////////////////////
  // popup functions
  // ///////////////////////

 
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

  // /////////////////////
  // events  
  // /////////////////////

  window.OnPageToolbarItemClick = OnPageToolbarItemClick;

  </script>

</asp:Content>


<%--
**** BREADCRUMB MENU CONTENT
--%>

<asp:Content runat="server" ContentPlaceHolderID="ContentPlaceHolderBreadcrumbs">

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
                           <dx:ASPxHyperLink ID="TopHelpHyperLink" runat="server" NavigateUrl="~/Default.aspx" Text="Root" Font-Bold="True" Font-Size="Large" Border-BorderStyle="None" Border-BorderWidth="8px" />
                           <dx:ASPxLabel ID="ASPxLabel1" runat="server" Text=">"></dx:ASPxLabel>
                           <dx:ASPxLabel ID="BreadcrumbsLabel" runat="server" Text="Help" Font-Bold="True" Font-Size="Large" Width="480px" />
                         </td>
                         <td>&nbsp;</td>
                       </tr>
                     </table>
                </Template>
            </dx:MenuItem>
        </Items>
        <ClientSideEvents ItemClick="onLeftMenuItemClick" />
    </dx:ASPxMenu>
  
</asp:Content>

<%--
**** PAGE MENU CONTENT
--%>

<asp:Content runat="server" ContentPlaceHolderID="ContentPlaceHolderMenu">

    <dx:ASPxMenu runat="server" ID="PageToolbar" ClientInstanceName="pageToolbar" 
       ItemAutoWidth="false" EnableSubMenuScrolling="true" ShowPopOutImages="True" SeparatorWidth="0" ItemWrap="false"
       CssClass="header-menu page-menu" Width="100%" HorizontalAlign="Left">
       <SettingsAdaptivity Enabled="true" EnableAutoHideRootItems="true" />
       <AdaptiveMenuImage SpriteProperties-CssClass="adaptive-image" >
          <SpriteProperties CssClass="adaptive-image"></SpriteProperties>
       </AdaptiveMenuImage>
       <Items>
          <dx:MenuItem Alignment="Right" AdaptivePriority="1">  
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
  
</asp:Content>


<%--
**** RIGHT PANEL
--%>

<asp:Content runat="server" ContentPlaceHolderID="ContentPlaceHolderRightPanelContent">
    <%--
    **** RIGHT PANEL DATA SOURCES
    --%>    

    <asp:XmlDataSource ID="NodesDataSource" runat="server" DataFile="~/Content/Overview.xml" XPath="//Nodes/*" />

    <%--
    **** RIGHT PANEL CONTENT
    --%>    
                
    <dx:ASPxPageControl ID="TabPagesRightPanel" Width="100%" runat="server" ActiveTabIndex="0" EnableHierarchyRecreation="True" >
       <TabPages>                                                                                                                                         	
           <%--
           **** CONTENTS INDEX
           --%>
    
           <dx:TabPage Text="Contents" Visible="true">
              <ContentCollection>
                  <dx:ContentControl ID="ContentControlRight1" runat="server">
                   	                             
                       <dx:ASPxTreeView runat="server" ID="TableOfContentsTreeView" ClientInstanceName="tableOfContentsTreeView"
                           EnableNodeTextWrapping="True" ShowTreeLines="True" AllowSelectNode="True" Width="100%" SyncSelectionMode="None"
                           DataSourceID="NodesDataSource" TextField="Text" NavigateUrlField="NavigateUrl" ImageUrlField="ImageUrl"
                           OnNodeDataBound="TableOfContentsTreeView_NodeDataBound">      
                           <Images>
                              <NodeImage Width="20px" Height="20px">
                              </NodeImage>
                           </Images>
                           <Styles>
                              <NodeImage Paddings-PaddingTop="5px">
                                 <Paddings PaddingTop="5px"></Paddings>
                              </NodeImage>
                           </Styles>
                           <ClientSideEvents NodeClick="function (s, e) { HideLeftPanelIfRequired(); }" />        
                       </dx:ASPxTreeView>

                  </dx:ContentControl>
               </ContentCollection>                                    
           </dx:TabPage>
      	
           <%--
           **** FILE MANAGER TABPAGE
           --%>
    
           <dx:TabPage Text="File Manager" Visible="true">
              <ContentCollection>
                  <dx:ContentControl ID="ContentControlRight2" runat="server">
    
                  <dx:ASPxFileManager runat="server" ID="fileManager" ClientInstanceName="fileManager" OnFolderCreating="FileManager_FolderCreating"
                      OnItemDeleting="FileManager_ItemDeleting" OnItemMoving="FileManager_ItemMoving" OnCustomThumbnail="OnFileManagerCustomThumbnails"
                      OnItemRenaming="FileManager_ItemRenaming" OnFileUploading="FileManager_FileUploading" OnItemCopying="FileManager_ItemCopying">
                      <Settings RootFolder="~/Content" ThumbnailFolder="~/Resources/Thumbnails" 
                          AllowedFileExtensions=".jpg,.png,.html,.xls,.xlsx"
                          InitialFolder="~/Content" />
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
    
       </TabPages>
       
    </dx:ASPxPageControl>

</asp:Content>

<%--
**** CONTENT PANE CONTENT
--%>

<asp:Content ID="Content" ContentPlaceHolderID="ContentPlaceHolderPageContent" runat="server">

    <%--
    **** CONTENT BODY
    --%>

    <div class="text-content" runat="server" id="TextContent"></div>
                            
    <%--
    **** CONTENT FOOTER
    --%>
    
    <div class="footer-wrapper" id="footerWrapper">
        <div class="footer">
            <span class="footer-left">&copy; 2023 Crayon &nbsp;&nbsp;
                <a class="footer-link" href="../Content/Index.html" target="_blank">Full-Page Help</a>
            </span>
        </div>
    </div>
        
   <%--
   **** POPUP PANEL
   --%>

      
   <%--
   **** LOADING PANELS
   --%>

   <dx:ASPxLoadingPanel ID="LoadingPanel" runat="server" ClientInstanceName="LoadingPanel" Modal="True" />   
  
   <%--
   **** DATA SOURCES
   --%>


   <%--
   **** ADDITIONAL DATA SOURCES
   --%>
  

</asp:Content>
