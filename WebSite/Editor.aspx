<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="Root.master" CodeBehind="Editor.aspx.cs" Inherits="BlackBox.EditorPage" Title="BlackBox" %>

<%@ Register assembly="DevExpress.Web.v22.2, Version=22.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" namespace="DevExpress.Web" tagprefix="dx" %>
<%@ Register assembly="DevExpress.Web.ASPxRichEdit.v22.2, Version=22.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" namespace="DevExpress.Web.ASPxRichEdit" tagprefix="dx" %>

<%--
**** HEADER CONTENT
--%>

<asp:Content runat="server" ContentPlaceHolderID="ContentPlaceHolderHead">    
  <script type="text/javascript">
 
  // ///////////////////////
  // page functions
  // ///////////////////////

	//var urlParams = window.location.href
  //var getQuery = urlParams.split('?')[1]
  //var params = getQuery.split('&')
  
  // main page control
  function OnPageControlInit(s, e) 
  { 
  }
          
  // page toolbar
  function updateToolbarButtonsState() 
  {
    //var enabled = false;
  }
    
  // page toolbar click
  function OnPageToolbarItemClick(s, e) 
  {
    switch(e.item.name) 
    {
      case "PageMenuDataFiles":
          openUrlFromPage("./DataFiles.aspx", false);
          break;
    }
  }
 
  // ///////////////////////////
  // file manager functions
  // //////////////////////////

  var postponedCallbackRequired = false;
    
  function OnFileManagerInit(s, e) 
  { 
  }
  
  function OnCustomFileManagerCommand(s, e)
  {
    switch(e.commandName) 
    {
      case "Thumbnails":
          s.PerformCallback("Thumbnails");
          break;
    }
  }  

  function OnSelectedFileChanged(s, e) 
  {
    if (e.file) 
    {
      if (!RichEditSelected.InCallback())
        RichEditSelected.PerformCallback();
      else
        postponedCallbackRequired = true;
    }
  }

  // ///////////////////////////
  // richedit control functions
  // //////////////////////////
 
 
  function OnRichEditEndCallback(s, e) 
  {
    if (postponedCallbackRequired) 
    {
      RichEditSelected.PerformCallback();
      postponedCallbackRequired = false;
    }
  }
 
  // /////////////////////
  // common functions
  // /////////////////////
  
  //function OnToolbarUpdating(s, e) 
  //{
  //}
 
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
  // exceptions
  // /////////////////////

  // handle exceptions  
  function OnExceptionOccurred(s, e) 
  {
    e.handled = true;
    alert(e.message);
    window.location.reload();
  }

  // /////////////////////
  // events  
  // /////////////////////

  window.OnPageToolbarItemClick = OnPageToolbarItemClick;

  window.OnFileManagerInit = OnFileManagerInit;
  window.OnCustomFileManagerCommand = OnCustomFileManagerCommand;
  window.OnSelectedFileChanged = OnSelectedFileChanged;   
  window.OnExceptionOccurred = OnExceptionOccurred;
  
  window.OnRichEditEndCallback = OnRichEditEndCallback;
   
  //window.OnToolbarUpdating = OnToolbarUpdating;  
 
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
                           <dx:ASPxHyperLink ID="BreadcrumbsHyperLink" runat="server" NavigateUrl="~/Default.aspx" Text="Root" Font-Bold="True" Font-Size="Large" Border-BorderStyle="None" Border-BorderWidth="8px" />
                           <dx:ASPxLabel ID="BreadcrumbsSpacer" runat="server" Text=">"></dx:ASPxLabel>
                           <dx:ASPxLabel ID="BreadcrumbsLabel" ClientIDMode="Static" runat="server" Text="Editor" Font-Bold="True" Font-Size="Large" Width="300px" />
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
          <dx:MenuItem Name="PageMenuDataFiles" Text="Data Files" Alignment="Right" AdaptivePriority="1">
               <Image IconID="format_listbullets_svg_dark_16x16" />
          </dx:MenuItem>               	
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
  
</asp:Content>

<%--
**** RIGHT PANEL
--%>

<asp:Content runat="server" ContentPlaceHolderID="ContentPlaceHolderRightPanelContent">  
    <%--
    **** RIGHT PANEL DATA SOURCES
    --%>    


    <%--
    **** RIGHT PANEL CONTENT
    --%>    
                
    <dx:ASPxPageControl ID="TabPagesRightPanel" Width="100%" runat="server" ActiveTabIndex="0" EnableHierarchyRecreation="True" >
       <TabPages>
           <%--
           **** FILE MANAGER TABPAGE
           --%>
    
           <dx:TabPage Text="File Manager" Visible="true">
              <ContentCollection>
                  <dx:ContentControl ID="ContentControlRight1" runat="server">

                  <dx:ASPxFileManager ID="FileManager" ClientInstanceName="FileManager" runat="server" Width="95%" Height="750px"
                      OnCustomCallback="FileManager_CustomCallback" OnCustomThumbnail="OnFileManagerCustomThumbnails"
                      OnItemDeleting="FileManager_ItemDeleting" OnItemMoving="FileManager_ItemMoving" OnItemsDeleted="FileManager_ItemsDeleted" OnItemMoved="FileManager_ItemMoved"
                      OnItemRenaming="FileManager_ItemRenaming" OnItemCopying="FileManager_ItemCopying" OnItemRenamed="FileManager_ItemRenamed" OnItemsCopied="FileManager_ItemsCopied"
                      OnFileUploading="FileManager_FileUploading" OnFolderCreating="FileManager_FolderCreating">
                      <Settings RootFolder="~/Jobs" ThumbnailFolder="~/Resources/Thumbnails"
                          AllowedFileExtensions=".txt,.xml,.html,.log,.csv,.sql"
                          InitialFolder="~/Jobs" />
                      <SettingsEditing AllowCreate="true" AllowDelete="true" AllowMove="true" AllowRename="true" AllowCopy="true" AllowDownload="true" />
                      <SettingsPermissions>
                          <AccessRules>
                              <dx:FileManagerFolderAccessRule Path="system" Edit="Deny" />
                              <dx:FileManagerFileAccessRule Path="system\*" Download="Deny" />
                          </AccessRules>
                      </SettingsPermissions>
                      <SettingsFolders Visible="true" />                          
                      <SettingsFileList View="Thumbnails" ShowFolders="true" ShowParentFolder="true">
                         <DetailsViewSettings AllowColumnResize="true" AllowColumnDragDrop="true" AllowColumnSort="true" ShowHeaderFilterButton="true" />
                      </SettingsFileList>                                 
                      <SettingsBreadcrumbs Visible="true" ShowParentFolderButton="true" Position="Top" />
                      <SettingsUpload UseAdvancedUploadMode="true">
                          <AdvancedModeSettings EnableMultiSelect="true" />
                      </SettingsUpload>
                      <SettingsAdaptivity Enabled="true" /> 
                      <SettingsToolbar>
                          <Items>
                              <dx:FileManagerToolbarCustomButton CommandName="Properties" BeginGroup="true">
                                  <Image IconID="setup_properties_32x32" />
                              </dx:FileManagerToolbarCustomButton>
                              <dx:FileManagerToolbarCreateButton BeginGroup="true" />                           
                              <dx:FileManagerToolbarRenameButton BeginGroup="true" />                           
                              <dx:FileManagerToolbarMoveButton />
                              <dx:FileManagerToolbarCopyButton />
                              <dx:FileManagerToolbarDeleteButton />
                              <dx:FileManagerToolbarRefreshButton BeginGroup="true" />
                              <dx:FileManagerToolbarDownloadButton />
                          </Items>
                      </SettingsToolbar>
                      <ClientSideEvents Init="OnFileManagerInit" CustomCommand="OnCustomFileManagerCommand" SelectedFileChanged="OnSelectedFileChanged" CallbackError="OnExceptionOccurred"/>
                  </dx:ASPxFileManager>
    
                  </dx:ContentControl>
             </ContentCollection>
           </dx:TabPage>

           <%--
           **** SETTINGS TABPAGE
           --%>
    
           <dx:TabPage Text="Settings" Visible="false">
              <ContentCollection>
                  <dx:ContentControl ID="ContentControlRight2" runat="server">
     
    
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
   **** CONTENT PANEL DATA SOURCES
   --%>


   <%--
   **** CONTENT TABS
   --%>

   <dx:ASPxRichEdit ID="RichEditSelected" runat="server" ClientInstanceName="RichEditSelected" Height="800" Width="100%"
       OnCallback="RichEditSelected_Callback" ActiveTabIndex="0" RibbonMode="OneLineRibbon"
       ShowConfirmOnLosingChanges="false" OnPreRender="RichEditSelected_PreRender">
       <RibbonTabs>
           <dx:RERHomeTab>
               <Groups>
                   <dx:RERFileCommonGroup>
                       <Items>
                           <dx:REROpenCommand Size="Large" Text="Open" ToolTip="Ctrl + O" />                       	
                           <dx:RERSaveCommand Size="Large" Text="Save" ToolTip="Ctrl + S" />
                           <dx:RERSaveAsCommand Size="Large" Text="SaveAs" ToolTip="Ctrl + Z" />
                       </Items>
                   </dx:RERFileCommonGroup>
                   <dx:RERUndoGroup>
                       <Items>
                           <dx:RERUndoCommand Size="Large" Text="Undo" ToolTip="Ctrl + Z" />
                           <dx:RERRedoCommand Size="Large" Text="Redo" ToolTip="Ctrl + Y" />
                       </Items>
                   </dx:RERUndoGroup>
                   <dx:RERClipboardGroup>
                       <Items>
                           <dx:RERPasteCommand Size="Large" Text="Paste" ToolTip="Ctrl + P" />
                           <dx:RERCopyCommand Size="Small" Text="Copy" ToolTip="Ctrl + C" />
                           <dx:RERCutCommand Size="Small" Text="Cut" ToolTip="Ctrl + X" />                                                            	
                       </Items>
                   </dx:RERClipboardGroup>
                   <dx:REREditingGroup>
                       <Items>
                           <dx:RERFindCommand Size="Large" Text="Find" ToolTip="Ctrl + F" />
                           <dx:RERReplaceCommand Size="Large" Text="Replace" ToolTip="Ctrl + R" />
                           <dx:RERSelectAllCommand Size="Large" Text="SelectAll" ToolTip="Ctrl + A" />                                                            	
                       </Items>
                   </dx:REREditingGroup>
                   <dx:RERViewGroup>
                       <Items>
                           <dx:RERToggleFullScreenCommand ToolTip="F11" />
                       </Items>
                   </dx:RERViewGroup>
               </Groups>
           </dx:RERHomeTab>
       </RibbonTabs>                                        
       <Settings>                                        
           <Views ViewType="Simple">
               <SimpleView>
                   <Paddings Top="10" Left="10"/>
               </SimpleView>
           </Views>
       </Settings>
       <ClientSideEvents EndCallback="OnRichEditEndCallback"></ClientSideEvents>
   </dx:ASPxRichEdit>                  

   <%--
   **** POPUP PANEL
   --%>


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

</asp:Content>
