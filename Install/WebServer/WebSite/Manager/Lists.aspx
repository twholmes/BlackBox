<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="Manager.master" CodeBehind="Lists.aspx.cs" Inherits="BlackBox.ListsPage" Title="BlackBox" %>

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

  // //////////////////////////////////
  // validation lists grid functions
  // //////////////////////////////////

  // validation lists grid toolbar functions  
  function OnGridViewValidationListsToolbarItemClick(s, e) 
  {
    if (IsCustomGridViewToolbarCommand(e.item.name)) 
    {
      e.processOnServer=true;
      e.usePostBack=true;
    }
  }

  // validation lists gridview functions
  function OnGridViewValidationListsInit(s, e) 
  { 
    var toolbar = gridViewValidationLists.GetToolbar(0);  
    if (toolbar != null) 
    {  
    }
  }
    
  function OnGridViewValidationListsSelectionChanged(s, e) 
  {
    e.processOnServer=true;
    e.usePostBack=true;
  }
 
  function OnGridViewValidationListsFocusedRowChanged(s, e)
  {
    var fri = gridViewValidationLists.GetFocusedRowIndex();
    //gridViewValidationLists.GetRowValues(fri, 'ID,ListName', OnGetValidationListsFocusedRowValues);
    //gridViewValidationLists.Refresh();    
  }

  function OnGetValidationListsFocusedRowValues(values)
  {
    var id = values[0];
    var col = values[1];
  }
 
  // //////////////////////////////////
  // locations lists grid functions
  // //////////////////////////////////

  // locations lists grid toolbar functions  
  function OnGridViewLocationsListToolbarItemClick(s, e) 
  {
    if (IsCustomGridViewToolbarCommand(e.item.name)) 
    {
      e.processOnServer=true;
      e.usePostBack=true;
    }
  }

  // locations lists gridview functions
  function OnGridViewLocationsListInit(s, e) 
  { 
    var toolbar = gridViewLocationsList.GetToolbar(0);  
    if (toolbar != null) 
    {  
    }
  }
    
  function OnGridViewLocationsListSelectionChanged(s, e) 
  {
    e.processOnServer=true;
    e.usePostBack=true;
  }
 
  function OnGridViewLocationsListFocusedRowChanged(s, e)
  {
    var fri = gridViewLocationsList.GetFocusedRowIndex();
  }

  function OnGetValidationListsFocusedRowValues(values)
  {
    var id = values[0];
    var col = values[1];
  }
 
  // //////////////////////////////////
  // category lists grid functions
  // //////////////////////////////////

  // category lists grid toolbar functions  
  function OnGridViewCategoryListToolbarItemClick(s, e) 
  {
    if (IsCustomGridViewToolbarCommand(e.item.name)) 
    {
      e.processOnServer=true;
      e.usePostBack=true;
    }
  }

  // category lists gridview functions
  function OnGridViewCategoryListInit(s, e) 
  { 
    var toolbar = gridViewCategoryList.GetToolbar(0);  
    if (toolbar != null) 
    {  
    }
  }
    
  function OnGridViewCategoryListSelectionChanged(s, e) 
  {
    e.processOnServer=true;
    e.usePostBack=true;
  }
 
  function OnGridViewCategoryListFocusedRowChanged(s, e)
  {
    var fri = gridViewCategoryList.GetFocusedRowIndex();
  }

  function OnGetValidationListsFocusedRowValues(values)
  {
    var id = values[0];
    var col = values[1];
  }
 
  // //////////////////////////////////
  // users lists grid functions
  // //////////////////////////////////

  // users lists grid toolbar functions  
  function OnGridViewUsersListToolbarItemClick(s, e) 
  {
    if (IsCustomGridViewToolbarCommand(e.item.name)) 
    {
      e.processOnServer=true;
      e.usePostBack=true;
    }
  }

  // users lists gridview functions
  function OnGridViewUsersListInit(s, e) 
  { 
    var toolbar = gridViewUsersList.GetToolbar(0);  
    if (toolbar != null) 
    {  
    }
  }
    
  function OnGridViewUsersListSelectionChanged(s, e) 
  {
    e.processOnServer=true;
    e.usePostBack=true;
  }
 
  function OnGridViewUsersListFocusedRowChanged(s, e)
  {
    var fri = gridViewUsersList.GetFocusedRowIndex();
  }

  function OnGetValidationListsFocusedRowValues(values)
  {
    var id = values[0];
    var col = values[1];
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
      default:
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

  // /////////////////////
  // events  
  // /////////////////////

  window.OnPageToolbarItemClick = OnPageToolbarItemClick;
  
  window.OnGridViewValidationListsInit = OnGridViewValidationListsInit;
  window.OnGridViewValidationListsSelectionChanged = OnGridViewValidationListsSelectionChanged;
  window.OnGridViewValidationListsFocusedRowChanged = OnGridViewValidationListsFocusedRowChanged;  
  window.OnGridViewValidationListsToolbarItemClick = OnGridViewValidationListsToolbarItemClick;    

  window.OnGridViewLocationsListInit = OnGridViewLocationsListInit;
  window.OnGridViewLocationsListSelectionChanged = OnGridViewLocationsListSelectionChanged;
  window.OnGridViewLocationsListFocusedRowChanged = OnGridViewLocationsListFocusedRowChanged;  
  window.OnGridViewLocationsListToolbarItemClick = OnGridViewLocationsListToolbarItemClick;    

  window.OnGridViewCategoryListInit = OnGridViewCategoryListInit;
  window.OnGridViewCategoryListSelectionChanged = OnGridViewCategoryListSelectionChanged;
  window.OnGridViewCategoryListFocusedRowChanged = OnGridViewCategoryListFocusedRowChanged;  
  window.OnGridViewCategoryListToolbarItemClick = OnGridViewCategoryListToolbarItemClick;    

  window.OnGridViewUsersListInit = OnGridViewUsersListInit;
  window.OnGridViewUsersListSelectionChanged = OnGridViewUsersListSelectionChanged;
  window.OnGridViewUsersListFocusedRowChanged = OnGridViewUsersListFocusedRowChanged;  
  window.OnGridViewUsersListToolbarItemClick = OnGridViewUsersListToolbarItemClick;    

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
                           <dx:ASPxHyperLink ID="TopHelpHyperLink" runat="server" NavigateUrl="~/Home.aspx" Text="Support" Font-Bold="True" Font-Size="Large" Border-BorderStyle="None" Border-BorderWidth="8px" />
                           <dx:ASPxLabel ID="ASPxLabel1" runat="server" Text=">"></dx:ASPxLabel>
                           <dx:ASPxLabel ID="BreadcrumbsLabel" runat="server" Text="Inspect Validation Lists" Font-Bold="True" Font-Size="Large" Width="480px" />
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


    <%--
    **** RIGHT PANEL CONTENT
    --%>    
                
    <dx:ASPxPageControl ID="TabPagesRightPanel" Width="100%" runat="server" ActiveTabIndex="0" EnableHierarchyRecreation="True" >
       <TabPages>                                                                                                                                   
           <%--
           **** FNMS IMPORTS TABPAGE
           --%>
    
           <dx:TabPage Text="FNMS Imports" Visible="true">
              <ContentCollection>
                  <dx:ContentControl ID="ContentControlRight1" runat="server">

                  <br/>
                  <dx:ASPxLabel ID="FNMSLabel" runat="server" ClientIDMode="Static" Text="Import FNMS Group Data" Font-Bold="True" Font-Size="16px" ForeColor="Gray" Width="300px" />
                  <br/><br/>
     
                  <dx:ASPxFormLayout ID="FNMSFormLayout" runat="server" AlignItemCaptionsInAllGroups="True" UseDefaultPaddings="False">
                     <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="700" />
                     <Items>
                         <dx:EmptyLayoutItem />
                      
                         <dx:LayoutGroup Caption="FNMS Location Data" ShowCaption="true" ColCount="2" SettingsItems-HorizontalAlign="Left" HorizontalAlign="Left" Width="500">
                             <Items>                    
                                <dx:LayoutItem Caption="Locations" ShowCaption="False" CssClass="buttonAlign" Width="100%">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                            <dx:ASPxButton ID="ImportLocationDataButton" runat="server" Text="Import" OnClick="ImportLocationDataButtonClick" Width="100">
                                               <ClientSideEvents Click="function(s, e) { LoadingPanel.Show(); }" />
                                            </dx:ASPxButton>                                              
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                </dx:LayoutItem>
                             </Items>
                         </dx:LayoutGroup>

                         <dx:EmptyLayoutItem />

                         <dx:LayoutGroup Caption="FNMS Category Data" ShowCaption="true" ColCount="2" SettingsItems-HorizontalAlign="Left" HorizontalAlign="Left" Width="500">
                             <Items>
                                                                  
                                <dx:LayoutItem Caption="Categories" ShowCaption="False" CssClass="buttonAlign" Width="100%">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                            <dx:ASPxButton ID="ImportCategoryDataButton" runat="server" Text="Import" OnClick="ImportCategoryDataButtonClick" Width="100">
                                               <ClientSideEvents Click="function(s, e) { LoadingPanel.Show(); }" />
                                            </dx:ASPxButton>                                              
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                </dx:LayoutItem>
                             </Items>
                         </dx:LayoutGroup>

                         <dx:EmptyLayoutItem />

                         <dx:LayoutGroup Caption="FNMS User Data" ShowCaption="true" ColCount="2" SettingsItems-HorizontalAlign="Left" HorizontalAlign="Left" Width="500">
                             <Items>
                                                                  
                                <dx:LayoutItem Caption="Categories" ShowCaption="False" CssClass="buttonAlign" Width="100%">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                            <dx:ASPxButton ID="ImportUserDataButton" runat="server" Text="Import" OnClick="ImportUserDataButtonClick" Width="100">
                                               <ClientSideEvents Click="function(s, e) { LoadingPanel.Show(); }" />
                                            </dx:ASPxButton>                                              
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                </dx:LayoutItem>
                             </Items>
                         </dx:LayoutGroup>
                                
                         <dx:EmptyLayoutItem />
                     </Items>
                  </dx:ASPxFormLayout>
              
                  </dx:ContentControl>
             </ContentCollection>
           </dx:TabPage>

           <%--
           **** FILE MANAGER TABPAGE
           --%>
    
           <dx:TabPage Text="File Manager" Visible="false">
              <ContentCollection>
                  <dx:ContentControl ID="ContentControlRight2" runat="server">
    
                  <dx:ASPxFileManager runat="server" ID="fileManager" ClientInstanceName="fileManager" OnFolderCreating="FileManager_FolderCreating"
                      OnItemDeleting="FileManager_ItemDeleting" OnItemMoving="FileManager_ItemMoving" OnCustomThumbnail="OnFileManagerCustomThumbnails"
                      OnItemRenaming="FileManager_ItemRenaming" OnFileUploading="FileManager_FileUploading" OnItemCopying="FileManager_ItemCopying">
                      <Settings RootFolder="~/Templates" ThumbnailFolder="~/Resources/Thumbnails" 
                          AllowedFileExtensions=".xls,.xlsx"
                          InitialFolder="~/Templates" />
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
  
   <asp:SqlDataSource ID="SqlSysValidationLists" runat="server" 
     ConnectionString="<%$ ConnectionStrings:BlackBoxConnectionString %>"     
     SelectCommand="SELECT [StagedID],[ID],[JobID],[DataSourceInstanceID],[LineNumber],[FlexeraID],[DataSource],[ListName],[Value],[Status] FROM [dbo].[stagedValidationLists]"
     InsertCommand="INSERT INTO [dbo].[stagedValidationLists] ([ID],[JobID],[DataSourceInstanceID],[LineNumber],[FlexeraID],[DataSource],[ListName],[Value],[Status]) 
        VALUES(@ID,@JobID,@DataSourceInstanceID,@LineNumber,@FlexeraID,@DataSource,@ListName,@Value,@Status)"        
     UpdateCommand="UPDATE [dbo].[stagedValidationLists] SET [ID]=@ID,[JobID]=@JobID,[DataSourceInstanceID]=@DataSourceInstanceID,[LineNumber]=@LineNumber
        ,[FlexeraID]=@FlexeraID,[DataSource]=@DataSource,[ListName]=@ListName,[Value]=@Value,[Status]=@Status WHERE [StagedID]=@StagedID"
     DeleteCommand="DELETE FROM [dbo].[stagedValidationLists] WHERE [StagedID] = @StagedID">
     <InsertParameters>
         <asp:FormParameter FormField="ID" Name="ID" />
         <asp:FormParameter FormField="JobID" Name="JobID" />
         <asp:FormParameter FormField="DataSourceInstanceID" Name="DataSourceInstanceID" />
         <asp:FormParameter FormField="LineNumber" Name="LineNumber" />
         <asp:FormParameter FormField="FlexeraID" Name="FlexeraID" />
         <asp:FormParameter FormField="DataSource" Name="DataSource" />
         <asp:FormParameter FormField="ListName" Name="ListName" />
         <asp:FormParameter FormField="Value" Name="Value" />
         <asp:FormParameter FormField="Status" Name="Status" />
     </InsertParameters>
     <UpdateParameters>
         <asp:FormParameter FormField="StagedID" Name="StagedID" />
         <asp:FormParameter FormField="ID" Name="ID" />
         <asp:FormParameter FormField="JobID" Name="JobID" />
         <asp:FormParameter FormField="DataSourceInstanceID" Name="DataSourceInstanceID" />
         <asp:FormParameter FormField="LineNumber" Name="LineNumber" />
         <asp:FormParameter FormField="FlexeraID" Name="FlexeraID" />
         <asp:FormParameter FormField="DataSource" Name="DataSource" />
         <asp:FormParameter FormField="ListName" Name="ListName" />
         <asp:FormParameter FormField="Value" Name="Value" />
         <asp:FormParameter FormField="Status" Name="Status" />
     </UpdateParameters>
     <DeleteParameters>
         <asp:QueryStringParameter Name="StagedID" />
     </DeleteParameters>
   </asp:SqlDataSource>
  
   <asp:SqlDataSource ID="SqlFNMSLocationsList" runat="server" 
     ConnectionString="<%$ ConnectionStrings:BlackBoxConnectionString %>"     
     SelectCommand="SELECT TOP (2000) [GroupID],[GroupCN],[GroupExID],[Path],[TreeLevel],[Level0],[Level1],[Level2],[Level3],[Level4],[Level5],[Level6],[Level7],[Level8],[Level9] FROM [dbo].[fnmsLocationsExport]">
   </asp:SqlDataSource>

   <asp:SqlDataSource ID="SqlFNMSCategoryList" runat="server" 
     ConnectionString="<%$ ConnectionStrings:BlackBoxConnectionString %>"     
     SelectCommand="SELECT TOP (2000) [GroupID],[GroupCN],[GroupExID],[Path],[TreeLevel],[Level0],[Level1],[Level2],[Level3],[Level4],[Level5],[Level6],[Level7],[Level8],[Level9] FROM [dbo].[fnmsCategoryExport]">
   </asp:SqlDataSource>

   <asp:SqlDataSource ID="SqlFNMSUsersList" runat="server" 
     ConnectionString="<%$ ConnectionStrings:BlackBoxConnectionString %>"     
     SelectCommand="SELECT TOP (5000) [ComplianceUserID],[SAMAccountName] FROM [dbo].[fnmsComplianceUserExport]">
   </asp:SqlDataSource>

    <%--
    **** CONTENT TABS
    --%>
   
    <dx:ASPxPageControl ID="TabPagesMainPanel" Width="100%" runat="server" ActiveTabIndex="0" EnableHierarchyRecreation="True" >
        <TabPages>

            <%--
            **** LISTS GRIDVIEW TAB
            --%>
                                                                                                                                                     
            <dx:TabPage Text="Approved Lists">
               <ContentCollection>                              
                  <dx:ContentControl ID="ContentControl1" runat="server">                    

                  <dx:ASPxGridView ID="ValidationListsGridView" runat="server" ClientInstanceName="gridViewValidationLists" DataSourceID="SqlSysValidationLists" KeyFieldName="StagedID"
                    OnRowCommand="ValidationListsGridView_RowCommand" OnSelectionChanged="ValidationListsGridView_SelectionChanged"
                    OnInitNewRow="ValidationListsGridView_InitNewRow" OnRowInserting="ValidationListsGridView_RowInserting" OnRowUpdating="ValidationListsGridView_RowUpdating" OnRowDeleting="ValidationListsGridView_RowDeleting"
                    OnCustomCallback="ValidationListsGridView_CustomCallback" OnToolbarItemClick="ValidationListsGridView_ToolbarItemClick"
                    EnableTheming="True" EnableViewState="False" AutoGenerateColumns="False" Width="95%">
                    <Columns>                            
                       <dx:GridViewCommandColumn VisibleIndex="0" SelectAllCheckboxMode="AllPages" ShowSelectCheckbox="True" Width="50px" Visible="true" />
                       <dx:GridViewDataColumn FieldName="StagedID" Caption="StagedID" VisibleIndex="1" Width="80px" Visible="true" />                       	
                       <dx:GridViewDataColumn FieldName="ID" Caption="ID" VisibleIndex="2" Width="80px" Visible="true" />
                       <dx:GridViewDataColumn FieldName="JobID" Caption="JobID" VisibleIndex="3" Width="90px" Visible="true" />
                       <dx:GridViewDataColumn FieldName="DataSourceInstanceID" Caption="DSIID" VisibleIndex="4" Width="100px" Visible="true" />
                       <dx:GridViewDataTextColumn FieldName="DataSource" Caption="DataSource" VisibleIndex="5" Width="150px" Visible="true" />
                       <dx:GridViewDataTextColumn FieldName="ListName" Caption="ListName" VisibleIndex="6" Width="250px" Visible="true" />
                       <dx:GridViewDataTextColumn FieldName="Value" VisibleIndex="7" Width="620px" Visible="true" />
                       <dx:GridViewDataColumn FieldName="Status" VisibleIndex="8" Width="90px" Visible="true" />
                    </Columns>
                    <Toolbars>
                       <dx:GridViewToolbar>
                          <SettingsAdaptivity Enabled="true" EnableCollapseRootItemsToIcons="true" />
                          <Items>
                             <dx:GridViewToolbarItem Command="Refresh" BeginGroup="true" AdaptivePriority="1"/>
                             <dx:GridViewToolbarItem Name="New" Command="New" BeginGroup="true" AdaptivePriority="2" Enabled="false"/>
                             <dx:GridViewToolbarItem Name="Edit" Command="Edit" AdaptivePriority="3" Enabled="false"/>
                             <dx:GridViewToolbarItem Name="Delete" Command="Delete" AdaptivePriority="4" Enabled="false"/>

                             <dx:GridViewToolbarItem Command="ShowFilterRow" BeginGroup="true" AdaptivePriority="5"/>
                             <dx:GridViewToolbarItem Command="ShowCustomizationWindow" BeginGroup="true" AdaptivePriority="6"/>
                                  	
                             <dx:GridViewToolbarItem Text="Export to" Image-IconID="actions_download_16x16office2013" BeginGroup="true" AdaptivePriority="6">
                                 <Items>
                                     <dx:GridViewToolbarItem Command="ExportToCsv" />
                                     <dx:GridViewToolbarItem Command="ExportToXlsx" Text="Export to XLSX" />
                                 </Items>
                             </dx:GridViewToolbarItem>                    	

                             <dx:GridViewToolbarItem Name="CustomValidationListItemSearch" Alignment="Right" BeginGroup="true" AdaptivePriority="4">
                                <Template>
                                   <dx:ASPxButtonEdit ID="tbValidationListsToolbarSearch" runat="server" NullText="Search..." Height="100%">
                                      <Buttons>
                                          <dx:SpinButtonExtended Image-IconID="find_find_16x16gray" />
                                      </Buttons>
                                      </dx:ASPxButtonEdit>
                                </Template>
                             </dx:GridViewToolbarItem>
                         </Items>
                       </dx:GridViewToolbar>
                    </Toolbars>                     
                    <SettingsPopup>
                      <HeaderFilter MinHeight="140px"></HeaderFilter>
                    </SettingsPopup>
                    <SettingsSearchPanel Visible="true" ShowApplyButton="True" ShowClearButton="True" CustomEditorID="tbValidationListsToolbarSearch" />
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
                            <dx:GridViewLayoutGroup ColCount="3" GroupBoxDecoration="None">
                                <Items>
                                    <dx:GridViewColumnLayoutItem ColumnName="ID" Caption="ID">
                                      <Template>
                                         <dx:ASPxLabel ID="idLabel" runat="server" Width="40%" Text='<%# Bind("ID") %>' />
                                      </Template>
                                    </dx:GridViewColumnLayoutItem>
                                      
                                    <dx:GridViewColumnLayoutItem ColumnName="JobID" Caption="JobID" ShowCaption="false">
                                      <Template>
                                         <dx:ASPxLabel ID="jobidLabel" runat="server" Width="80%" Text='<%# "JobID: " + Convert.ToString(Eval("JobID")) %>' />
                                      </Template>
                                    </dx:GridViewColumnLayoutItem>
                                    
                                    <dx:GridViewColumnLayoutItem ColumnName="DataSourceInstanceID" Caption="DSIID" ShowCaption="false">
                                      <Template>
                                         <dx:ASPxLabel ID="dsiidLabel" runat="server" Width="80%" Text='<%# "DataSourceInstanceID: " + Convert.ToString(Eval("DataSourceInstanceID")) %>' />
                                      </Template>
                                    </dx:GridViewColumnLayoutItem>

                                    <dx:GridViewColumnLayoutItem ColumnName="DataSource" Caption="DataSource" ColumnSpan="2">
                                      <Template>
                                         <dx:ASPxTextBox ID="listnameTextBox" runat="server" Width="90%" Text='<%# Bind("DataSource") %>' />
                                      </Template>
                                    </dx:GridViewColumnLayoutItem>

                                    <dx:GridViewColumnLayoutItem ColumnName="ListName" Caption="ListName" ColumnSpan="2">
                                      <Template>
                                         <dx:ASPxTextBox ID="colnameTextBox" runat="server" Width="90%" Text='<%# Bind("ListName") %>' />                                             
                                      </Template>
                                    </dx:GridViewColumnLayoutItem>                                     
                                    
                                    <dx:GridViewColumnLayoutItem ColumnName="Status" Caption="Status">
                                      <Template>
                                         <%--<dx:ASPxTextBox ID="statusTextBox" runat="server" Width="50%" Text='<%# Bind("Status") %>' />--%>
                                         <dx:ASPxComboBox ID="statusComboBox" DropDownStyle="DropDown" runat="server" Width="60%" Value='<%# Bind("Status") %>'>
                                            <Items>
                                                <dx:ListEditItem Value="0" Text="0-Loaded" />
                                                <dx:ListEditItem Value="1" Text="1-Static" />                                                     
                                                <dx:ListEditItem Value="2" Text="2-Hidden" />
                                                <dx:ListEditItem Value="3" Text="3-Remove" />
                                             </Items>
                                         </dx:ASPxComboBox>   
                                      </Template>
                                    </dx:GridViewColumnLayoutItem>
                                                                      
                                    <dx:GridViewColumnLayoutItem ColumnName="Value" Caption="Value" ColumnSpan="3">
                                      <Template>
                                         <dx:ASPxTextBox ID="valueTextBox" runat="server" Width="90%" Text='<%# Bind("Value") %>' />
                                      </Template>
                                    </dx:GridViewColumnLayoutItem>

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
                    <ClientSideEvents Init="OnGridViewValidationListsInit" SelectionChanged="OnGridViewValidationListsSelectionChanged" FocusedRowChanged="OnGridViewValidationListsFocusedRowChanged" 
                        ToolbarItemClick="OnGridViewValidationListsToolbarItemClick" />
                  </dx:ASPxGridView>

                  </dx:ContentControl>
               </ContentCollection>                                    
            </dx:TabPage>

            <%--
            **** LOCATIONS LIST GRIDVIEW TAB
            --%>
                                                                                                                                                                       
            <dx:TabPage Text="FNMS Locations" Visible="True">
               <ContentCollection>                              
                   <dx:ContentControl ID="ContentControl2" runat="server">

                  <dx:ASPxGridView ID="LocationsListGridView" runat="server" ClientInstanceName="gridViewLocationsList" DataSourceID="SqlFNMSLocationsList" KeyFieldName="GroupID"
                    OnRowCommand="LocationsListGridView_RowCommand" OnSelectionChanged="LocationsListGridView_SelectionChanged"
                    OnInitNewRow="LocationsListGridView_InitNewRow" OnRowInserting="LocationsListGridView_RowInserting" OnRowUpdating="LocationsListGridView_RowUpdating" OnRowDeleting="LocationsListGridView_RowDeleting"
                    OnCustomCallback="LocationsListGridView_CustomCallback" OnToolbarItemClick="LocationsListGridView_ToolbarItemClick"
                    EnableTheming="True" EnableViewState="False" AutoGenerateColumns="False" Width="95%">
                    <Toolbars>
                        <dx:GridViewToolbar>
                            <SettingsAdaptivity Enabled="true" EnableCollapseRootItemsToIcons="true" />
                            <Items>
                                <dx:GridViewToolbarItem Command="Refresh" BeginGroup="true" AdaptivePriority="1"/>
                                <dx:GridViewToolbarItem Command="ShowFilterRow" BeginGroup="true" AdaptivePriority="5"/>
                                <dx:GridViewToolbarItem Command="ShowCustomizationWindow" BeginGroup="true" AdaptivePriority="6"/>

                                <dx:GridViewToolbarItem Name="CustomLocationsListItemSearch" Alignment="Right" BeginGroup="true" AdaptivePriority="7">
                                   <Template>
                                      <dx:ASPxButtonEdit ID="tbLocationsListsToolbarSearch" runat="server" NullText="Search..." Height="100%">
                                         <Buttons>
                                             <dx:SpinButtonExtended Image-IconID="find_find_16x16gray" />
                                         </Buttons>
                                         </dx:ASPxButtonEdit>
                                   </Template>
                                </dx:GridViewToolbarItem>
                            </Items>
                        </dx:GridViewToolbar>
                    </Toolbars>                     
                    <SettingsPopup>
                      <HeaderFilter MinHeight="140px"></HeaderFilter>
                    </SettingsPopup>
                    <Columns>                            
                          <dx:GridViewCommandColumn VisibleIndex="0" SelectAllCheckboxMode="AllPages" ShowSelectCheckbox="True" Width="50px" Visible="true" />
                          <dx:GridViewDataColumn FieldName="GroupID" Caption="GroupID" VisibleIndex="1" Width="80px" Visible="true" />
                          <dx:GridViewDataColumn FieldName="GroupCN" Caption="GroupCN" VisibleIndex="2" Width="190px" Visible="true" />
                          <dx:GridViewDataColumn FieldName="Path" Caption="Path" VisibleIndex="3" Width="780px" Visible="true" />
                          <dx:GridViewDataColumn FieldName="GroupExID" Caption="GroupExID" VisibleIndex="4" Width="150px" Visible="true" />
                          <dx:GridViewDataColumn FieldName="TreeLevel" Caption="TreeLevel" VisibleIndex="5" Width="80px" Visible="true" />                               
                          <dx:GridViewDataTextColumn FieldName="Level0" Caption="Level0" VisibleIndex="6" Width="200px" Visible="false" />
                          <dx:GridViewDataTextColumn FieldName="Level1" Caption="Level1" VisibleIndex="7" Width="200px" Visible="false" />
                          <dx:GridViewDataTextColumn FieldName="Level2" Caption="Level2" VisibleIndex="8" Width="200px" Visible="false" />
                          <dx:GridViewDataTextColumn FieldName="Level3" Caption="Level3" VisibleIndex="9" Width="200px" Visible="false" />
                          <dx:GridViewDataTextColumn FieldName="Level4" Caption="Level4" VisibleIndex="10" Width="200px" Visible="false" />                                                                                                                
                          <dx:GridViewDataTextColumn FieldName="Level5" Caption="Level5" VisibleIndex="11" Width="200px" Visible="false" />
                          <dx:GridViewDataTextColumn FieldName="Level6" Caption="Level6" VisibleIndex="12" Width="200px" Visible="false" />
                          <dx:GridViewDataTextColumn FieldName="Level7" Caption="Level7" VisibleIndex="13" Width="200px" Visible="false" />
                          <dx:GridViewDataTextColumn FieldName="Level8" Caption="Level8" VisibleIndex="14" Width="200px" Visible="false" />
                          <dx:GridViewDataTextColumn FieldName="Level9" Caption="Level9" VisibleIndex="15" Width="200px" Visible="false" />                                                                                                               
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
                      <SettingsSearchPanel Visible="true" ShowApplyButton="True" ShowClearButton="True" CustomEditorID="tbLocationsListsToolbarSearch" />
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
                      <ClientSideEvents Init="OnGridViewLocationsListInit" SelectionChanged="OnGridViewLocationsListSelectionChanged" FocusedRowChanged="OnGridViewLocationsListFocusedRowChanged" 
                        ToolbarItemClick="OnGridViewLocationsListToolbarItemClick" />
                   </dx:ASPxGridView>
                                            
                   </dx:ContentControl>
              </ContentCollection>                                    
            </dx:TabPage>

            <%--
            **** CATEGORY LIST GRIDVIEW TAB
            --%>
                                                                                                                                                                       
            <dx:TabPage Text="FNMS Categories" Visible="True">
               <ContentCollection>                              
                   <dx:ContentControl ID="ContentControl3" runat="server">
                    
                  <dx:ASPxGridView ID="CategoryListGridView" runat="server" ClientInstanceName="gridViewCategoryList" DataSourceID="SqlFNMSCategoryList" KeyFieldName="GroupID"
                    OnRowCommand="CategoryListGridView_RowCommand" OnSelectionChanged="CategoryListGridView_SelectionChanged"
                    OnInitNewRow="CategoryListGridView_InitNewRow" OnRowInserting="CategoryListGridView_RowInserting" OnRowUpdating="CategoryListGridView_RowUpdating" OnRowDeleting="CategoryListGridView_RowDeleting"
                    OnCustomCallback="CategoryListGridView_CustomCallback" OnToolbarItemClick="CategoryListGridView_ToolbarItemClick"
                    EnableTheming="True" EnableViewState="False" AutoGenerateColumns="False" Width="95%">
                    <Toolbars>
                        <dx:GridViewToolbar>
                            <SettingsAdaptivity Enabled="true" EnableCollapseRootItemsToIcons="true" />
                            <Items>
                                <dx:GridViewToolbarItem Command="Refresh" BeginGroup="true" AdaptivePriority="1"/>
                                <dx:GridViewToolbarItem Command="ShowFilterRow" BeginGroup="true" AdaptivePriority="5"/>
                                <dx:GridViewToolbarItem Command="ShowCustomizationWindow" BeginGroup="true" AdaptivePriority="6"/>

                                <dx:GridViewToolbarItem Name="CustomCategoriesListItemSearch" Alignment="Right" BeginGroup="true" AdaptivePriority="7">
                                   <Template>
                                      <dx:ASPxButtonEdit ID="tbCategoriesListsToolbarSearch" runat="server" NullText="Search..." Height="100%">
                                         <Buttons>
                                             <dx:SpinButtonExtended Image-IconID="find_find_16x16gray" />
                                         </Buttons>
                                         </dx:ASPxButtonEdit>
                                   </Template>
                                </dx:GridViewToolbarItem>
                            </Items>
                        </dx:GridViewToolbar>
                    </Toolbars>                     
                    <SettingsPopup>
                      <HeaderFilter MinHeight="140px"></HeaderFilter>
                    </SettingsPopup>
                    <Columns>                            
                          <dx:GridViewCommandColumn VisibleIndex="0" SelectAllCheckboxMode="AllPages" ShowSelectCheckbox="True" Width="50px" Visible="true" />
                          <dx:GridViewDataColumn FieldName="GroupID" Caption="GroupID" VisibleIndex="1" Width="80px" Visible="true" />
                          <dx:GridViewDataColumn FieldName="GroupCN" Caption="GroupCN" VisibleIndex="2" Width="190px" Visible="true" />
                          <dx:GridViewDataColumn FieldName="Path" Caption="Path" VisibleIndex="3" Width="780px" Visible="true" />
                          <dx:GridViewDataColumn FieldName="GroupExID" Caption="GroupExID" VisibleIndex="4" Width="150px" Visible="true" />
                          <dx:GridViewDataColumn FieldName="TreeLevel" Caption="TreeLevel" VisibleIndex="5" Width="80px" Visible="true" />                               
                          <dx:GridViewDataTextColumn FieldName="Level0" Caption="Level0" VisibleIndex="6" Width="200px" Visible="false" />
                          <dx:GridViewDataTextColumn FieldName="Level1" Caption="Level1" VisibleIndex="7" Width="200px" Visible="false" />
                          <dx:GridViewDataTextColumn FieldName="Level2" Caption="Level2" VisibleIndex="8" Width="200px" Visible="false" />
                          <dx:GridViewDataTextColumn FieldName="Level3" Caption="Level3" VisibleIndex="9" Width="200px" Visible="false" />
                          <dx:GridViewDataTextColumn FieldName="Level4" Caption="Level4" VisibleIndex="10" Width="200px" Visible="false" />                                                                                                                
                          <dx:GridViewDataTextColumn FieldName="Level5" Caption="Level5" VisibleIndex="11" Width="200px" Visible="false" />
                          <dx:GridViewDataTextColumn FieldName="Level6" Caption="Level6" VisibleIndex="12" Width="200px" Visible="false" />
                          <dx:GridViewDataTextColumn FieldName="Level7" Caption="Level7" VisibleIndex="13" Width="200px" Visible="false" />
                          <dx:GridViewDataTextColumn FieldName="Level8" Caption="Level8" VisibleIndex="14" Width="200px" Visible="false" />
                          <dx:GridViewDataTextColumn FieldName="Level9" Caption="Level9" VisibleIndex="15" Width="200px" Visible="false" />                                                                                                               
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
                      <SettingsSearchPanel Visible="true" ShowApplyButton="True" ShowClearButton="True" CustomEditorID="tbCategoriesListsToolbarSearch" />
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
                      <ClientSideEvents Init="OnGridViewCategoryListInit" SelectionChanged="OnGridViewCategoryListSelectionChanged" FocusedRowChanged="OnGridViewCategoryListFocusedRowChanged" 
                        ToolbarItemClick="OnGridViewCategoryListToolbarItemClick" />
                   </dx:ASPxGridView>

                   </dx:ContentControl>
              </ContentCollection>                                    
            </dx:TabPage>

            <%--
            **** USERS LIST GRIDVIEW TAB
            --%>
                                                                                                                                                                       
            <dx:TabPage Text="FNMS Compliance Users" Visible="False">
               <ContentCollection>                              
                   <dx:ContentControl ID="ContentControl4" runat="server">

                  <dx:ASPxGridView ID="UsersListGridView" runat="server" ClientInstanceName="gridViewUsersList" DataSourceID="SqlFNMSUsersList" KeyFieldName="ComplianceUserID"
                    OnRowCommand="UsersListGridView_RowCommand" OnSelectionChanged="UsersListGridView_SelectionChanged"
                    OnInitNewRow="UsersListGridView_InitNewRow" OnRowInserting="UsersListGridView_RowInserting" OnRowUpdating="UsersListGridView_RowUpdating" OnRowDeleting="UsersListGridView_RowDeleting"
                    OnCustomCallback="UsersListGridView_CustomCallback" OnToolbarItemClick="UsersListGridView_ToolbarItemClick"
                    EnableTheming="True" EnableViewState="False" AutoGenerateColumns="False" Width="95%">
                    <Toolbars>
                        <dx:GridViewToolbar>
                            <SettingsAdaptivity Enabled="true" EnableCollapseRootItemsToIcons="true" />
                            <Items>
                                <dx:GridViewToolbarItem Command="Refresh" BeginGroup="true" AdaptivePriority="1"/>
                                <dx:GridViewToolbarItem Command="ShowFilterRow" BeginGroup="true" AdaptivePriority="5"/>
                                <dx:GridViewToolbarItem Command="ShowCustomizationWindow" BeginGroup="true" AdaptivePriority="6"/>

                                <dx:GridViewToolbarItem Name="CustomUsersListItemSearch" Alignment="Right" BeginGroup="true" AdaptivePriority="7">
                                   <Template>
                                      <dx:ASPxButtonEdit ID="tbUsersListsToolbarSearch" runat="server" NullText="Search..." Height="100%">
                                         <Buttons>
                                             <dx:SpinButtonExtended Image-IconID="find_find_16x16gray" />
                                         </Buttons>
                                         </dx:ASPxButtonEdit>
                                   </Template>
                                </dx:GridViewToolbarItem>
                            </Items>
                        </dx:GridViewToolbar>
                    </Toolbars>                     
                    <SettingsPopup>
                      <HeaderFilter MinHeight="140px"></HeaderFilter>
                    </SettingsPopup>
                    <Columns>                            
                          <dx:GridViewCommandColumn VisibleIndex="0" SelectAllCheckboxMode="AllPages" ShowSelectCheckbox="True" Width="50px" Visible="true" />
                          <dx:GridViewDataColumn FieldName="ComplianceUserID" Caption="ComplianceUserID" VisibleIndex="1" Width="150px" Visible="true" />
                          <dx:GridViewDataColumn FieldName="SAMAccountName" Caption="SAMAccountName" VisibleIndex="2" Width="500px" Visible="true" />
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
                      <SettingsSearchPanel Visible="true" ShowApplyButton="True" ShowClearButton="True" CustomEditorID="tbUsersListsToolbarSearch" />
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
                      <ClientSideEvents Init="OnGridViewUsersListInit" SelectionChanged="OnGridViewUsersListSelectionChanged" FocusedRowChanged="OnGridViewUsersListFocusedRowChanged" 
                        ToolbarItemClick="OnGridViewUsersListToolbarItemClick" />
                   </dx:ASPxGridView>
                                            
                   </dx:ContentControl>
              </ContentCollection>                                    
            </dx:TabPage>
            
        </TabPages>
        
    </dx:ASPxPageControl>
        
   <%--
   **** POPUP PANEL
   --%>

     
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
