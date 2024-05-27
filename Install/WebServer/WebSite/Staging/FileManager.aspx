<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="Staging.Master" CodeBehind="FileManager.aspx.cs" Inherits="BlackBox.ImportFileManagerPage" Title="BlackBox" %>

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
    var enabled = cardView.GetSelectedCardCount() > 0;
  }
    
  function onPageToolbarItemClick(s, e) 
  {
    switch(e.item.name) 
    {
      case "Grid":
          cardView.GetRowValues(cardView.GetFocusedRowIndex(), 'ID', onSwitchToGridView); 
          break;
      case "Cards":
          cardView.GetRowValues(cardView.GetFocusedRowIndex(), 'ID', onSwitchToCardsView); 
          break;
      case "Details":
          cardView.GetRowValues(cardView.GetFocusedRowIndex(), 'ID', onGridRowDrillDown); 
          break;
    }
  }

  function onSwitchToGridView(value) 
  {
    var url = "Contact.aspx?id=" + value;  
    window.open(url,"_self");            
  }
        
  function onSwitchToCardsView(value) 
  {
    var url = "ContactCards.aspx?id=" + value;  
    window.open(url,"_self");            
  }

  function onGridRowDrillDown(value) 
  {
    var url = "ContactDetails.aspx?id=" + value;  
    window.open(url,"_self");            
  }
 
  // ///////////////////////////
  // file manager functions
  // //////////////////////////
  
  function OnCustomCommand(s, e) 
  {
    switch(e.commandName) 
    {
      case "Thumbnails":
          fileManager.PerformCallback("Thumbnails");      
          break;
      case "Details":
          fileManager.PerformCallback("Details");      
          break;
          
      case "DataFolder":
          fmcp.PerformCallback("DataFolder");      
          //fileManager.SetCurrentFolderPath("~/Data");
          break;
      case "LogsFolder":
          fmcp.PerformCallback("LogsFolder");
          //fileManager.SetCurrentFolderPath("~/Logs");
          break;
      case "PhotosFolder":
          fmcp.PerformCallback("PhotosFolder");
          //fileManager.SetCurrentFolderPath("~/Photos");          
          break;
    }
    //fileManager.Refresh();
  }  
  
  function OnToolbarUpdating(s, e) 
  {
    //var enabled = (e.activeAreaName == "Folders" || fileManager.GetSelectedItems().length > 0) && e.activeAreaName != "None";
    //FileManager.GetToolbarItemByCommandName("Properties").SetEnabled(enabled);
    //FileManager.GetContextMenuItemByCommandName("Properties").SetEnabled(enabled);
  }
  
  // ///////////////////////
  // popup functions
  // ///////////////////////

  // show the popup
  function ShowModalInspectPopup() 
  {
    pcInspectSelect.Show();
    gridViewFiles.Refresh();
  }
 
  // popup submit button click
  function OnPcInspectSubmitButtonClick(s, e) 
  {
    var dataset = pcDatasetComboBox.GetText();
    pcInspectSelect.Hide();
    if (dataset == "Assets")
      openUrlFromPage("Assets.aspx", true); 
    else if (dataset == "SiteAuditAssetList")
      openUrlFromPage("SiteAudit.aspx", true);      
    else if (dataset == "AssetRiskAssessment")
      openUrlFromPage("AssetRisk.aspx", true);      
    else if (dataset == "SIA")
      openUrlFromPage("SIA.aspx", true); 
    else if (dataset == "SIDA")
      openUrlFromPage("SIDA.aspx", true); 
    else
    {
      openUrlFromPage("Inspect.aspx?dataset="+dataset, true);     
    }
  }
 
  // /////////////////////////////
  // settings gridview functions
  // /////////////////////////////
 
  function OnGridViewSettingsInit(s, e) 
  {
  }
    
  function OnGridViewSettingsSelectionChanged(s, e) 
  {
  }
  
  function OnGridViewSettingsToolbarItemClick(s, e) 
  {
    if (IsCustomGridViewToolbarCommand(e.item.name)) 
    {
      e.processOnServer=true;
      e.usePostBack=true;
    }
  }

  // ///////////////////////////
  // common gridview functions
  // ///////////////////////////
  
  // is the toolbar command custom or standard
  function IsCustomGridViewToolbarCommand(command) 
  {
  	var isCustom = false;
    switch(command) 
    {
      case "CustomExportToXLS":
      case "CustomExportToXLSX":
          isCustom = true;
          break;
      
      case "CustomValidateFile":
      case "CustomSubmitStaged":
      case "CustomRecallStaged":      
          isCustom = true;
          break;
      
      case "CustomInspectStaged":
      case "CustomStageSource":
      case "CustomProcessStaged":      
      case "CustomArchiveSource":
          isCustom = true;
          break;
      
      case "CustomRejectStaged":
      case "CustomApproveStaged":
          isCustom = true;
          break;
      
      case "CustomExcludeRecord":
      case "CustomIncludeRecord":
          isCustom = true;
          break;
      
      case "CustomExportToSQL":
          isCustom = true;
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
 

  // /////////////////////
  // events  
  // /////////////////////

  window.onPageToolbarItemClick = onPageToolbarItemClick;
  
  window.onCustomCommand = OnCustomCommand;  
  window.onToolbarUpdating = OnToolbarUpdating;  

  window.OnGridViewSettingsInit = OnGridViewSettingsInit;
  window.OnGridViewSettingsSelectionChanged = OnGridViewSettingsSelectionChanged;
  window.OnGridViewSettingsToolbarItemClick = OnGridViewSettingsToolbarItemClick;
 
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
                           <dx:ASPxHyperLink ID="TopHelpHyperLink" runat="server" NavigateUrl="~/Default.aspx" Text="Home" Font-Bold="True" Font-Size="Large" Border-BorderStyle="None" Border-BorderWidth="8px" />
                           <dx:ASPxLabel ID="ASPxLabel1" runat="server" Text=">"></dx:ASPxLabel>
                           <dx:ASPxLabel ID="BreadcrumbsLabel" runat="server" Text="File Manager" Font-Bold="True" Font-Size="Large" Width="280px" />
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
          <dx:MenuItem Name="PageMenuFolders" Text="Folders" Alignment="Right" AdaptivePriority="1">
              <Image IconID="actions_open2_svg_dark_16x16" />
              <Items>
                 <dx:MenuItem Name="PageMenuGridFolderData" Text="Data" NavigateUrl="~/Admin/FileManager.aspx?folder=data">
                     <Image IconID="actions_open2_svg_dark_16x16" />
                 </dx:MenuItem>
                 <dx:MenuItem Name="PageMenuGridFolderUploads" Text="Uploads" NavigateUrl="~/Admin/FileManager.aspx?folder=uploads">
                     <Image IconID="actions_open2_svg_dark_16x16" />
                 </dx:MenuItem>
                 <dx:MenuItem Name="PageMenuGridFolderLogs" Text="Logs" NavigateUrl="~/Admin/FileManager.aspx?folder=logs">
                     <Image IconID="actions_open2_svg_dark_16x16" />
                 </dx:MenuItem>
                 <dx:MenuItem Name="PageMenuGridFolderPhotos" Text="Photos" NavigateUrl="~/Admin/FileManager.aspx?folder=photos">
                     <Image IconID="actions_open2_svg_dark_16x16" />
                 </dx:MenuItem>
              </Items>              	
          </dx:MenuItem>
          <dx:MenuItem Name="PageMenuGridView" Text="GridView" NavigateUrl="~/Admin/Files.aspx" Alignment="Right" AdaptivePriority="1">
              <Image IconID="actions_open2_svg_dark_16x16" />
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
       <ClientSideEvents ItemClick="onPageToolbarItemClick" />        
    </dx:ASPxMenu>
  
</asp:Content>

<%--
**** RIGHT PANEL CONTENT
--%>

<asp:Content runat="server" ContentPlaceHolderID="ContentPlaceHolderRightPanelContent">  

    <%--
    **** RIGHT PANEL DATA SOURCES
    --%>    

    <asp:ObjectDataSource ID="SettingsDataModelSource" runat="server" TypeName="BlackBox.Model.SettingsProvider"
        SelectMethod="GetSettingsGroupList" InsertMethod="AddNewSetting" UpdateMethod="SetSetting" DeleteMethod="DeleteSetting" 
        OnSelecting="SettingsDataModelSource_Selecting" >
       <SelectParameters>
           <asp:QueryStringParameter DefaultValue="FileManager" Name="Group" QueryStringField="Group" Type="String" />
       </SelectParameters>
    </asp:ObjectDataSource>
                
    <dx:ASPxPageControl ID="TabPagesRightPanel" Width="100%" runat="server" ActiveTabIndex="0" EnableHierarchyRecreation="True" >
       <TabPages>
           <%--
           **** SETTINGS TABPAGE
           --%>
    
           <dx:TabPage Text="Settings" Visible="true">
              <ContentCollection>
                  <dx:ContentControl ID="ContentControlRight1" runat="server">
     
                  <dx:ASPxGridView runat="server" ID="SettingsGridView" ClientInstanceName="gridViewSettings"
                      KeyFieldName="Group;Name" EnablePagingGestures="False"
                      CssClass="grid-view" Width="100%"
                      DataSourceID="SettingsDataModelSource"
                      OnCustomCallback="SettingsGridView_CustomCallback"
                      OnInitNewRow="SettingsGridView_InitNewRow" AutoGenerateColumns="False">
                      <Columns>
                          <dx:GridViewCommandColumn ShowSelectCheckbox="True" SelectAllCheckboxMode="AllPages" VisibleIndex="0" Width="50"></dx:GridViewCommandColumn>
                          <dx:GridViewDataColumn FieldName="Group" Caption="Group" Width="100px" />                               
                          <dx:GridViewDataColumn FieldName="Name" Caption="Name" Width="150px" />
                          <dx:GridViewDataColumn FieldName="SerializeAs" Caption="Type" Visible="False" />
                          <dx:GridViewDataColumn FieldName="Value" Caption="Value" Width="250px" />
                      </Columns>
                      <Toolbars>
                          <dx:GridViewToolbar>
                              <SettingsAdaptivity Enabled="true" EnableCollapseRootItemsToIcons="true" />
                              <Items>
                                  <dx:GridViewToolbarItem Command="Refresh" />
                                  <dx:GridViewToolbarItem Command="New" BeginGroup="true" AdaptivePriority="2"/>
                                  <dx:GridViewToolbarItem Command="Edit" />
                                  <dx:GridViewToolbarItem Command="Delete" />
                                  <dx:GridViewToolbarItem Alignment="Right" BeginGroup="true" AdaptivePriority="4">
                                      <Template>
                                          <dx:ASPxButtonEdit ID="tbToolbarSearch" runat="server" NullText="Search..." Height="100%">
                                              <Buttons>
                                                  <dx:SpinButtonExtended Image-IconID="find_find_16x16gray" />
                                              </Buttons>
                                          </dx:ASPxButtonEdit>
                                      </Template>
                                  </dx:GridViewToolbarItem>
                              </Items>
                          </dx:GridViewToolbar>
                      </Toolbars>                                                
                      <SettingsBehavior AllowFocusedRow="true" AllowSelectByRowClick="true" AllowEllipsisInText="true" AllowDragDrop="false" />
                      <SettingsEditing Mode="PopupEditForm" EditFormColumnCount="2" />
                      <SettingsSearchPanel CustomEditorID="SearchButtonEdit" />
                      <Settings VerticalScrollBarMode="Hidden" HorizontalScrollBarMode="Auto" ShowHeaderFilterButton="true" />
                      <SettingsPager PageSize="15" EnableAdaptivity="true">
                          <PageSizeItemSettings Visible="true"></PageSizeItemSettings>
                      </SettingsPager>
                      <SettingsExport EnableClientSideExportAPI="true" ExportSelectedRowsOnly="true" />
                      <SettingsPopup>
                          <EditForm>
                              <SettingsAdaptivity MaxWidth="800" Mode="Always" VerticalAlign="WindowCenter" />
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
                              <dx:GridViewLayoutGroup ColCount="1" GroupBoxDecoration="None">
                                  <Items>                       
                                      <dx:GridViewColumnLayoutItem ColumnName="Group">
                                        <Template>
                                           <dx:ASPxTextBox ID="groupTextBox" runat="server" Width="80%" Text='<%# Bind("Group") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>
                 
                                      <dx:GridViewColumnLayoutItem ColumnName="Name">
                                        <Template>
                                           <dx:ASPxTextBox ID="nameTextBox" runat="server" Width="80%" Text='<%# Bind("Name") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>
                  
                                      <dx:GridViewColumnLayoutItem ColumnName="Type" Caption="Type">
                                        <Template>
                                           <dx:ASPxTextBox ID="typeTextBox" runat="server" Width="60%" Text='<%# Bind("SerializeAs") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>
                                      
                                      <dx:GridViewColumnLayoutItem ColumnName="Value">
                                        <Template>
                                           <dx:ASPxTextBox ID="valueTextBox" runat="server" Width="80%" Text='<%# Bind("Value") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>
                                      <dx:EditModeCommandLayoutItem Width="100%" HorizontalAlign="Right" />                                                                                                                                
                                  </Items>
                              </dx:GridViewLayoutGroup>
                          </Items>
                      </EditFormLayoutProperties>
                      <Styles>
                          <Cell Wrap="false" />
                          <PagerBottomPanel CssClass="pager" />
                          <FocusedRow CssClass="focused" />
                      </Styles>
                      <ClientSideEvents Init="OnGridViewSettingsInit" SelectionChanged="OnGridViewSettingsSelectionChanged" ToolbarItemClick="OnGridViewSettingsToolbarItemClick" />
                  </dx:ASPxGridView>
    
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

   <asp:SqlDataSource ID="SqlSettingsDataSource" runat="server"
     ConnectionString="<%$ ConnectionStrings:BlackBoxConnectionString %>" 
     SelectCommand="SELECT [Group],[Name],[SerializeAs],[Value],[UpdatedBy],[Updated] FROM [dbo].[BlackBoxSettings] ORDER BY [group] DESC, [name]"
     UpdateCommand="UPDATE [dbo].[BlackBoxSettings] SET [SerializeAs]=@serializeAs, [Value]=@value, [UpdatedBy]=@updatedBy WHERE [Group]=@group AND [Name]=@name"
     DeleteCommand="DELETE FROM [BlackBoxSettings] WHERE [Group]=@group AND [Name]=@name">
     <SelectParameters>
        <asp:QueryStringParameter Name="group" />
        <asp:QueryStringParameter Name="name" />
     </SelectParameters>
     <UpdateParameters>
         <asp:QueryStringParameter Name="group" />
         <asp:QueryStringParameter Name="name" />
         <asp:QueryStringParameter Name="serializeAs" />
         <asp:QueryStringParameter Name="value" />
         <asp:QueryStringParameter Name="updatedBy" />                                    
     </UpdateParameters>  
     <DeleteParameters>
        <asp:QueryStringParameter Name="group" />
        <asp:QueryStringParameter Name="name" />
     </DeleteParameters>
   </asp:SqlDataSource>
  
    <%--
    **** CONTENT TABS
    --%>
   
    <dx:ASPxPageControl ID="TabPagesMainPanel" Width="100%" runat="server" ActiveTabIndex="0" EnableHierarchyRecreation="True" >
        <TabPages>  
           <%--
           **** FILE MANAGER TABPAGE
           --%>

           <dx:TabPage Text="File Manager">
              <ContentCollection>
                  <dx:ContentControl ID="MainContentControl1" runat="server">
                  	
                  <dx:ASPxFileManager ID="fileManager" ClientInstanceName="fileManager" runat="server" Width="95%"
                      OnCustomCallback="FileManager_CustomCallback" OnCustomThumbnail="OnFileManagerCustomThumbnails"
                      OnItemDeleting="FileManager_ItemDeleting" OnItemMoving="FileManager_ItemMoving" OnItemsDeleted="FileManager_ItemsDeleted" OnItemMoved="FileManager_ItemMoved"
                      OnItemRenaming="FileManager_ItemRenaming" OnItemCopying="FileManager_ItemCopying" OnItemRenamed="FileManager_ItemRenamed" OnItemsCopied="FileManager_ItemsCopied"
                      OnFileUploading="FileManager_FileUploading" OnFolderCreating="FileManager_FolderCreating">
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
                      <SettingsFolders Visible="true" />                          
                      <SettingsFileList View="Thumbnails" ShowFolders="true" ShowParentFolder="true">
                         <DetailsViewSettings AllowColumnResize="true" AllowColumnDragDrop="true" AllowColumnSort="true" ShowHeaderFilterButton="false" />
                      </SettingsFileList>                               	
                      <SettingsBreadcrumbs Visible="true" ShowParentFolderButton="true" Position="Top" />
                      <SettingsUpload UseAdvancedUploadMode="true">
                          <AdvancedModeSettings EnableMultiSelect="true" />
                      </SettingsUpload>
                      <SettingsAdaptivity Enabled="true" /> 
                  
                      <ClientSideEvents CustomCommand="onCustomCommand" />                      	
                      <SettingsToolbar>
                          <Items>
                              <dx:FileManagerToolbarCustomButton CommandName="Properties" BeginGroup="true">
                                  <Image IconID="setup_properties_32x32" />
                              </dx:FileManagerToolbarCustomButton>
                              <dx:FileManagerToolbarCustomDropDownButton Visible="false">
                                  <Image IconID="actions_open2_svg_gray_32x32" />
                                  <Items>
                                     <dx:FileManagerToolbarCustomButton Text="Data" CommandName="DataFolder">
                                         <Image IconID="actions_open2_svg_dark_16x16" />
                                     </dx:FileManagerToolbarCustomButton>
                                     <dx:FileManagerToolbarCustomButton Text="Logs" CommandName="LogsFolder">
                                         <Image IconID="actions_open2_svg_dark_16x16" />
                                     </dx:FileManagerToolbarCustomButton>
                                     <dx:FileManagerToolbarCustomButton Text="Photos" CommandName="PhotosFolder">
                                         <Image IconID="actions_open2_svg_dark_16x16" />
                                     </dx:FileManagerToolbarCustomButton>
                                  </Items>                                     	
                              </dx:FileManagerToolbarCustomDropDownButton>
                              <dx:FileManagerToolbarCreateButton BeginGroup="true" />                          	
                              <dx:FileManagerToolbarRenameButton BeginGroup="true" />                          	
                              <dx:FileManagerToolbarMoveButton />
                              <dx:FileManagerToolbarCopyButton />
                              <dx:FileManagerToolbarDeleteButton />
                              <dx:FileManagerToolbarRefreshButton BeginGroup="true" />
                              <dx:FileManagerToolbarDownloadButton />
                          </Items>
                      </SettingsToolbar>
                                    	                      
                  </dx:ASPxFileManager>
                  
                  </dx:ContentControl>
             </ContentCollection>                                    
           </dx:TabPage>

           <%--
           **** FILE MANAGER SETTING TABPAGE
           --%>
           
           <dx:TabPage Text="File Manager Settings" Visible="true">
              <ContentCollection>                              
                  <dx:ContentControl ID="ContentControl2" runat="server">
                      <table>
                        <tr>
                          <td>
                            <p style="font-weight: bold; font-size: medium; font-family: Arial, Helvetica, sans-serif">File Manager Layout</p>
                          </td>
                          <td style="width: 80px">&nbsp;
                          </td>
                          <td>
                            <asp:Button ID="SubmitSettingsButton" runat="server" AutoPostBack="false" OnClick="SubmitSettingsButton_Click" Text="Submit" />                            
                          </td>
                       </tr>
                      </table>
                                             
                      <dx:ASPxFormLayout runat="server" ID="OptionsFormLayout">
                          <Items>
                              <dx:LayoutGroup Caption="Editing Settings">
                                  <Items>
                                      <dx:LayoutItem Caption="AllowMove">
                                          <LayoutItemNestedControlCollection>
                                              <dx:LayoutItemNestedControlContainer>
                                                  <dx:ASPxCheckBox ID="cbAllowMove" runat="server" AutoPostBack="False" Checked="True" />
                                              </dx:LayoutItemNestedControlContainer>
                                          </LayoutItemNestedControlCollection>
                                      </dx:LayoutItem>
                                      <dx:LayoutItem Caption="AllowDelete">
                                          <LayoutItemNestedControlCollection>
                                              <dx:LayoutItemNestedControlContainer>
                                                  <dx:ASPxCheckBox ID="cbAllowDelete" runat="server" AutoPostBack="False" Checked="True" />
                                              </dx:LayoutItemNestedControlContainer>
                                          </LayoutItemNestedControlCollection>
                                      </dx:LayoutItem>
                                      <dx:LayoutItem Caption="AllowRename">
                                          <LayoutItemNestedControlCollection>
                                              <dx:LayoutItemNestedControlContainer>
                                                  <dx:ASPxCheckBox ID="cbAllowRename" runat="server" AutoPostBack="False" Checked="True" />
                                              </dx:LayoutItemNestedControlContainer>
                                          </LayoutItemNestedControlCollection>
                                      </dx:LayoutItem>
                                      <dx:LayoutItem Caption="AllowCreate">
                                          <LayoutItemNestedControlCollection>
                                              <dx:LayoutItemNestedControlContainer>
                                                  <dx:ASPxCheckBox ID="cbAllowCreate" runat="server" AutoPostBack="False" Checked="True" />
                                              </dx:LayoutItemNestedControlContainer>
                                          </LayoutItemNestedControlCollection>
                                      </dx:LayoutItem>
                                      <dx:LayoutItem Caption="AllowCopy">
                                          <LayoutItemNestedControlCollection>
                                              <dx:LayoutItemNestedControlContainer>
                                                  <dx:ASPxCheckBox ID="cbAllowCopy" runat="server" AutoPostBack="False" Checked="True" />
                                              </dx:LayoutItemNestedControlContainer>
                                          </LayoutItemNestedControlCollection>
                                      </dx:LayoutItem>
                                      <dx:LayoutItem Caption="AllowDownload">
                                          <LayoutItemNestedControlCollection>
                                              <dx:LayoutItemNestedControlContainer>
                                                  <dx:ASPxCheckBox ID="cbAllowDownload" runat="server" AutoPostBack="False" Checked="True" />
                                              </dx:LayoutItemNestedControlContainer>
                                          </LayoutItemNestedControlCollection>
                                      </dx:LayoutItem>
                                  </Items>
                              </dx:LayoutGroup>
                              <dx:LayoutGroup Caption="Toolbar Settings">
                                  <Items>
                                      <dx:LayoutItem Caption="ShowPath">
                                          <LayoutItemNestedControlCollection>
                                              <dx:LayoutItemNestedControlContainer>
                                                  <dx:ASPxCheckBox ID="cbShowPath" runat="server" AutoPostBack="False" Checked="True" />
                                              </dx:LayoutItemNestedControlContainer>
                                          </LayoutItemNestedControlCollection>
                                      </dx:LayoutItem>
                                      <dx:LayoutItem Caption="ShowFilterBox">
                                          <LayoutItemNestedControlCollection>
                                              <dx:LayoutItemNestedControlContainer>
                                                  <dx:ASPxCheckBox ID="cbShowFilterBox" runat="server" AutoPostBack="False" Checked="True" />
                                              </dx:LayoutItemNestedControlContainer>
                                          </LayoutItemNestedControlCollection>
                                      </dx:LayoutItem>
                                  </Items>
                              </dx:LayoutGroup>
                              <dx:LayoutGroup Caption="Breadcrumbs Settings">
                                  <Items>
                                      <dx:LayoutItem Caption="Visible">
                                          <LayoutItemNestedControlCollection>
                                              <dx:LayoutItemNestedControlContainer>
                                                  <dx:ASPxCheckBox ID="cbBreadcrumbsVisible" runat="server" AutoPostBack="False" Checked="True" />
                                              </dx:LayoutItemNestedControlContainer>
                                          </LayoutItemNestedControlCollection>
                                      </dx:LayoutItem>
                                      <dx:LayoutItem Caption="ShowParentFolderButton">
                                          <LayoutItemNestedControlCollection>
                                              <dx:LayoutItemNestedControlContainer>
                                                  <dx:ASPxCheckBox ID="cbBreadcrumbsShowParentFolderButton" runat="server" AutoPostBack="False" Checked="True" />
                                              </dx:LayoutItemNestedControlContainer>
                                          </LayoutItemNestedControlCollection>
                                      </dx:LayoutItem>
                                      <dx:LayoutItem Caption="Position">
                                          <LayoutItemNestedControlCollection>
                                              <dx:LayoutItemNestedControlContainer>
                                                  <dx:ASPxComboBox ID="cmbBreadcrumbsPosition" runat="server" SelectedIndex="0" AutoPostBack="False">
                                                      <Items>
                                                          <dx:ListEditItem Value="Top" Text="Top" />
                                                          <dx:ListEditItem Value="Bottom" Text="Bottom" />
                                                      </Items>
                                                  </dx:ASPxComboBox>
                                              </dx:LayoutItemNestedControlContainer>
                                          </LayoutItemNestedControlCollection>
                                      </dx:LayoutItem>
                                  </Items>
                              </dx:LayoutGroup>
                              <dx:LayoutGroup Caption="Upload Settings">
                                  <Items>
                                      <dx:LayoutItem Caption="Enabled">
                                          <LayoutItemNestedControlCollection>
                                              <dx:LayoutItemNestedControlContainer>
                                                  <dx:ASPxCheckBox ID="cbUploadEnabled" runat="server" AutoPostBack="False" Checked="True" />
                                              </dx:LayoutItemNestedControlContainer>
                                          </LayoutItemNestedControlCollection>
                                      </dx:LayoutItem>
                                      <dx:LayoutItem Caption="EnableMultiSelect">
                                          <LayoutItemNestedControlCollection>
                                              <dx:LayoutItemNestedControlContainer>
                                                  <dx:ASPxCheckBox ID="cbUploadMultiSelect" runat="server" AutoPostBack="False" Checked="True" />
                                              </dx:LayoutItemNestedControlContainer>
                                          </LayoutItemNestedControlCollection>
                                      </dx:LayoutItem>
                                  </Items>
                              </dx:LayoutGroup>
                              <dx:LayoutGroup Caption="File List Settings">
                                  <Items>
                                      <dx:LayoutItem Caption="ShowFolders">
                                          <LayoutItemNestedControlCollection>
                                              <dx:LayoutItemNestedControlContainer>
                                                  <dx:ASPxCheckBox ID="cbFileListShowFolders" runat="server" AutoPostBack="False" Checked="True" />
                                              </dx:LayoutItemNestedControlContainer>
                                          </LayoutItemNestedControlCollection>
                                      </dx:LayoutItem>
                                      <dx:LayoutItem Caption="ShowParentFolder">
                                          <LayoutItemNestedControlCollection>
                                              <dx:LayoutItemNestedControlContainer>
                                                  <dx:ASPxCheckBox ID="cbFileListShowParentFolder" runat="server" AutoPostBack="False" Checked="True" Text="" />
                                              </dx:LayoutItemNestedControlContainer>
                                          </LayoutItemNestedControlCollection>
                                      </dx:LayoutItem>
                                  </Items>
                              </dx:LayoutGroup>
                              <dx:LayoutGroup Caption="Folder Settings">
                                  <Items>
                                      <dx:LayoutItem Caption="Visible">
                                          <LayoutItemNestedControlCollection>
                                              <dx:LayoutItemNestedControlContainer>
                                                  <dx:ASPxCheckBox ID="cbFoldersVisible" runat="server" AutoPostBack="False" Checked="True" />
                                              </dx:LayoutItemNestedControlContainer>
                                          </LayoutItemNestedControlCollection>
                                      </dx:LayoutItem>
                                      <dx:LayoutItem Caption="EnableCallBacks">
                                          <LayoutItemNestedControlCollection>
                                              <dx:LayoutItemNestedControlContainer>
                                                  <dx:ASPxCheckBox ID="cbFoldersEnableCallBacks" runat="server" AutoPostBack="False" Checked="True" />
                                              </dx:LayoutItemNestedControlContainer>
                                          </LayoutItemNestedControlCollection>
                                      </dx:LayoutItem>
                                      <dx:LayoutItem Caption="ShowFolderIcons">
                                          <LayoutItemNestedControlCollection>
                                              <dx:LayoutItemNestedControlContainer>
                                                  <dx:ASPxCheckBox ID="cbShowFolderIcons" runat="server" AutoPostBack="False" Checked="True" />
                                              </dx:LayoutItemNestedControlContainer>
                                          </LayoutItemNestedControlCollection>
                                      </dx:LayoutItem>
                                      <dx:LayoutItem Caption="ShowLockedFolderIcons">
                                          <LayoutItemNestedControlCollection>
                                              <dx:LayoutItemNestedControlContainer>
                                                  <dx:ASPxCheckBox ID="cbShowLockedFolderIcons" runat="server" AutoPostBack="False" Checked="True" />
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
            
        </TabPages>
        
    </dx:ASPxPageControl>
        
   <%--
   **** POPUP PANEL
   --%>

   <dx:ASPxPopupControl ID="pcInspectSelect" runat="server" ClientInstanceName="pcInspectSelect" EnableViewState="False" Width="500px" HeaderText="Select Dataset to Inspect"
     PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" PopupHorizontalOffset="40" PopupVerticalOffset="40" AutoUpdatePosition="true"
     CloseAction="CloseButton" CloseOnEscape="true" AllowDragging="True" Modal="True" PopupAnimationType="Fade" >
     <ClientSideEvents PopUp="function(s, e) {  }" />
     <SizeGripImage Width="11px" />
     <ContentCollection>
         <dx:PopupControlContentControl runat="server">
             <dx:ASPxPanel ID="Panel2" runat="server" DefaultButton="btCreate">
                 <PanelCollection>
                     <dx:PanelContent runat="server">
                         <dx:ASPxFormLayout runat="server" ID="InspectSelectFormLayout" Width="100%" Height="100%">
                             <Items>
                                 <dx:LayoutItem Caption="File Details">
                                     <LayoutItemNestedControlCollection>
                                         <dx:LayoutItemNestedControlContainer>
                                             <dx:ASPxComboBox ID="pcDatasetComboBox" ClientInstanceName="pcDatasetComboBox" runat="server" ClientIDMode="Static" AutoPostBack="False" Width="90%" SelectedIndex="0">
                                                <Items>
                                                     <dx:ListEditItem Value="Guest" Text="Guest" />
                                                 </Items>
                                             </dx:ASPxComboBox>
                                         </dx:LayoutItemNestedControlContainer>
                                     </LayoutItemNestedControlCollection>
                                 </dx:LayoutItem>
                                 <dx:LayoutItem ShowCaption="False">
                                     <LayoutItemNestedControlCollection>
                                         <dx:LayoutItemNestedControlContainer>
                                             <dx:ASPxButton ID="pcSubmitButton" ClientInstanceName="pcSubmitButton" runat="server" Text="OK" Width="80px" AutoPostBack="False" Style="float: left; margin-right: 8px" OnClick="OnButtonPopupSubmitClick">
                                                 <ClientSideEvents Click="OnPcInspectSubmitButtonClick" />
                                             </dx:ASPxButton>
                                             <dx:ASPxButton ID="pcCancelButton" runat="server" Text="Cancel" Width="80px" AutoPostBack="False" Style="float: left; margin-right: 8px">
                                                 <ClientSideEvents Click="function(s, e) { pcInspectSelect.Hide(); }" />
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
   **** ADDITIONAL DATA SOURCES
   --%>

   <asp:SqlDataSource ID="SqlBlackBoxFiles" runat="server" 
      ConnectionString="<%$ ConnectionStrings:BlackBoxConnectionString %>" 
      SelectCommand="SELECT TOP(100) [FID],[JOBID],[GUID],[Name],[Location],[TypeID],[Type],[Group],[Description],[DataSource],[DataSourceInstanceID],[Datasets],[StatusID],[Status],[UserID],[TimeStamp],[Age],[Rank] FROM [dbo].[vBlackBoxFiles] WHERE [UserID] = @userid ORDER BY [TimeStamp] DESC"
      InsertCommand="INSERT INTO [dbo].[BlackBoxFiles] ([JOBID],[GUID],[Name],[Location],[TypeID],[Group],[Description],[DataSource],[DataSourceInstanceID],[Datasets],[StatusID],[TimeStamp]) VALUES(@jobid,@guid,@name,@location,@typeid,@group,@description,@datasource,@dsiid,@datasets,@statusid,@timestamp)"
      UpdateCommand="UPDATE [dbo].[BlackBoxFiles] SET [JOBID]=@jobid,[GUID]=@guid,[Name]=@name,[Location]=@location,[TypeID]=@typeid,[Group]=@group,[Description]=@description,[DataSource]=@datasource,[DataSourceInstanceID]=@dsiid,[Datasets]=@datasets,[StatusID]=@statusid,[TimeStamp]=@timestamp WHERE [FID] = @fid"
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
          <asp:QueryStringParameter Name="timestamp" />
      </UpdateParameters>
      <DeleteParameters>
          <asp:QueryStringParameter Name="fid" />
      </DeleteParameters>
   </asp:SqlDataSource>
  

</asp:Content>
