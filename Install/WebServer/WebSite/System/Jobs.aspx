<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="System.Master" CodeBehind="Jobs.aspx.cs" Inherits="BlackBox.JobsSystemPage" Title="BlackBox" %>

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
    
  function onPageToolbarItemClick(s, e) 
  {
    switch(e.item.name) 
    {
      case "Dummy":
          break;
    }
  }

  // ///////////////////////////
  // jobs gridview functions
  // ///////////////////////////

  // jobs grid toolbar functions  
  function OnGridViewJobsToolbarItemClick(s, e) 
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

  // jobs gridview functions
  function OnGridViewJobsInit(s, e) 
  { 
    var toolbar = gridViewJobs.GetToolbar(0);  
    if (toolbar != null) 
    {  
    }
  }
    
  function OnGridViewJobsSelectionChanged(s, e) 
  {
    e.processOnServer=true;
    e.usePostBack=true;
  }
 
  function OnGridViewJobsFocusedRowChanged(s, e)
  {
    var fri = gridViewJobs.GetFocusedRowIndex();
    gridViewJobs.GetRowValues(fri, 'Domain;SAMAccountName', OnGetJobsFocusedRowValues);
    gridViewJobs.Refresh();    
  }

  function OnGetJobsFocusedRowValues(values)
  {
    var domain = values[0];
    var sam = values[1];
    
    //split to array trim elements and update popup combo box
    //var datasets = datasets.split(",") 
    //pcJobComboBox.ClearItems();
    //datasets.forEach(AddJobToPopupComboBox);
    //pcJobComboBox.SetSelectedIndex(0);
  }

  function AddJobToPopupComboBox(value)
  {   
    var name = value.trim()
    pcJobComboBox.AddItem(name);
  }

  // //////////////////////////
  // settings grid functions
  // //////////////////////////

  // settings grid toolbar functions  
  function OnGridViewSettingsToolbarItemClick(s, e) 
  {
    if (e.item.name == 'CustomInspectStaged')
    {
      //ShowModalInspectPopup();
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

  // settings gridview functions
  function OnGridViewSettingsInit(s, e) 
  {
  }
    
  function OnGridViewSettingsSelectionChanged(s, e) 
  {
    e.processOnServer=true;
    e.usePostBack=true;
  }
  
  function OnGridViewSettingsFocusedRowChanged(s, e)
  {
    var fri = gridViewSettings.GetFocusedRowIndex();
    gridViewSettings.GetRowValues(fri, 'Group,Name', OnGetSettingsFocusedRowValues);
    gridViewSettings.Refresh();    
  }

  function OnGetSettingsFocusedRowValues(values)
  {
    var group = values[0];
    var name = values[1];
  }
 
  // ///////////////////////
  // popup functions
  // ///////////////////////

  // show the popup
  function ShowModalInspectPopup() 
  {
    pcInspectSelect.Show();
    gridViewJobs.Refresh();
  }
 
  // popup submit button click
  function OnPcInspectSubmitButtonClick(s, e) 
  {
    var job = pcJobComboBox.GetText();
    pcInspectSelect.Hide();
    if (job == "Guest")
      openUrlFromPage("Jobs.aspx", true); 
    else
    {
      openUrlFromPage("Jobs.aspx?job="+job, true);     
    }
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

  // /////////////////////
  // events  
  // /////////////////////

  window.onPageToolbarItemClick = onPageToolbarItemClick;

  window.OnGridViewJobsInit = OnGridViewJobsInit;
  window.OnGridViewJobsSelectionChanged = OnGridViewJobsSelectionChanged;
  window.OnGridViewJobsFocusedRowChanged = OnGridViewJobsFocusedRowChanged;  
  window.OnGridViewJobsToolbarItemClick = OnGridViewJobsToolbarItemClick;    

  window.OnGridViewSettingsInit = OnGridViewSettingsInit;
  window.OnGridViewSettingsSelectionChanged = OnGridViewSettingsSelectionChanged;
  window.OnGridViewSettingsFocusedRowChanged = OnGridViewSettingsFocusedRowChanged;  
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
                           <dx:ASPxHyperLink ID="BreadcrumbsHyperLink" runat="server" NavigateUrl="~/Admin.aspx" Text="System" Font-Bold="True" Font-Size="Large" Border-BorderStyle="None" Border-BorderWidth="8px" />
                           <dx:ASPxLabel ID="BreadcrumbsSpacer" runat="server" Text=">"></dx:ASPxLabel>
                           <dx:ASPxLabel ID="BreadcrumbsLabel" ClientIDMode="Static" runat="server" Text="Jobs" Font-Bold="True" Font-Size="Large" Width="300px" />
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
          <dx:MenuItem Name="PageMenuUploads" Text="Uploads" NavigateUrl="../Manager/Uploads.aspx" Target="_blank" Alignment="Right" AdaptivePriority="1">
               <Image IconID="snap_datasource_svg_dark_16x16" />
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

    <asp:ObjectDataSource ID="SettingsDataModelSource" runat="server" TypeName="BlackBox.Model.SettingsProvider"
        SelectMethod="GetSettingsGroupList" InsertMethod="AddNewSetting" UpdateMethod="SetSetting" DeleteMethod="DeleteSetting" 
        OnSelecting="SettingsDataModelSource_Selecting" >
       <SelectParameters>
           <asp:QueryStringParameter DefaultValue="Contacts" Name="Group" QueryStringField="Group" Type="String" />
       </SelectParameters>
    </asp:ObjectDataSource>
                
    <dx:ASPxPageControl ID="TabPagesRightPanel" Width="100%" runat="server" ActiveTabIndex="0" EnableHierarchyRecreation="True" >
       <TabPages>                                                                                                                                   
           <%--
           **** FILE MANAGER TABPAGE
           --%>
    
           <dx:TabPage Text="File Manager" Visible="true">
              <ContentCollection>
                  <dx:ContentControl ID="ContentControlRight1" runat="server">
    
                  <dx:ASPxFileManager runat="server" ID="fileManager" ClientInstanceName="fileManager" OnFolderCreating="FileManager_FolderCreating"
                      OnItemDeleting="FileManager_ItemDeleting" OnItemMoving="FileManager_ItemMoving" OnCustomThumbnail="OnFileManagerCustomThumbnails"
                      OnItemRenaming="FileManager_ItemRenaming" OnFileUploading="FileManager_FileUploading" OnItemCopying="FileManager_ItemCopying">
                      <Settings RootFolder="~/Data" ThumbnailFolder="~/Resources/Thumbnails" 
                          AllowedFileExtensions=".jpg,.jpeg,.gif,.rtf,.txt,.avi,.png,.mp3,.xml,.doc,.pdf,.html,.csv,.xls,.xlsx,.xml,.zip"
                          InitialFolder="~/Photos" />
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
    
           <dx:TabPage Text="Settings" Visible="true">
              <ContentCollection>
                  <dx:ContentControl ID="ContentControlRight2" runat="server">
     
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
                                  <dx:GridViewToolbarItem Command="New" BeginGroup="true" AdaptivePriority="2" Visible="false"/>
                                  <dx:GridViewToolbarItem Command="Edit" Visible="false"/>
                                  <dx:GridViewToolbarItem Command="Delete" Visible="false"/>
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
                      <ClientSideEvents Init="onGridViewSettingsInit" SelectionChanged="onGridViewSettingsSelectionChanged" ToolbarItemClick="onGridViewSettingsToolbarItemClick" />
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

   <asp:SqlDataSource ID="SqlBlackBoxJobs" runat="server" 
      ConnectionString="<%$ ConnectionStrings:BlackBoxConnectionString %>" 
      SelectCommand="SELECT [JOBID],[GUID],[Category],[Group],[Description],[StatusID],[Status],[UserID],[TimeStamp],[Age],[Rank] FROM [dbo].[vBlackBoxJobs] WHERE [Category] like @category AND [Group] like @group ORDER BY [TimeStamp] DESC" 
      InsertCommand="INSERT INTO [dbo].[Jobs] ([GUID],[Category],[Group],[Description],[StatusID],[UserID],[TimeStamp]) VALUES(@guid,@category,@group,@description,@statusid,@userid,@timestamp)"
      UpdateCommand="UPDATE [dbo].[Jobs] SET [GUID]=@guid,[Category]=@category,[Group]=@group,[Description]=@description,[StatusID]=@statusid,[UserID]=@userid,[TimeStamp]=@timestamp WHERE [JOBID] = @jobid" 
      DeleteCommand="DELETE FROM [dbo].[Jobs] WHERE [JOBID] = @jobid">
      <SelectParameters>
          <asp:QueryStringParameter Name="category" DefaultValue="%" />       
          <asp:QueryStringParameter Name="group" DefaultValue="%" />
      </SelectParameters>      
      <InsertParameters>
          <asp:QueryStringParameter Name="guid" />
          <asp:QueryStringParameter Name="category" />
          <asp:QueryStringParameter Name="group" />
          <asp:QueryStringParameter Name="description" />
          <asp:QueryStringParameter Name="statusid" />
          <asp:QueryStringParameter Name="userid" />
          <asp:QueryStringParameter Name="timestamp" />           
      </InsertParameters>
      <UpdateParameters>
          <asp:QueryStringParameter Name="jobid" />   
          <asp:QueryStringParameter Name="guid" />
          <asp:QueryStringParameter Name="category" />
          <asp:QueryStringParameter Name="group" />
          <asp:QueryStringParameter Name="description" />
          <asp:QueryStringParameter Name="statusid" />
          <asp:QueryStringParameter Name="userid" />          	
          <asp:QueryStringParameter Name="timestamp" />           
      </UpdateParameters>
      <DeleteParameters>
          <asp:QueryStringParameter Name="jobid" />
      </DeleteParameters>
   </asp:SqlDataSource>   

    <%--
    **** CONTENT TABS
    --%>
   
    <dx:ASPxPageControl ID="TabPagesMainPanel" Width="100%" runat="server" ActiveTabIndex="1" EnableHierarchyRecreation="True" >
        <TabPages>

            <%--
            **** JOBS GRIDVIEW TAB
            --%>
                                                                                                                                                                       
            <dx:TabPage Text="Jobs">
               <ContentCollection>                              
                   <dx:ContentControl ID="ContentControl1" runat="server">

                  <dx:ASPxGridView ID="JobsGridView" runat="server" ClientInstanceName="gridViewJobs" DataSourceID="SqlBlackBoxJobs" 
                    EnableTheming="True" EnableViewState="False" KeyFieldName="JOBID" 
                    OnRowCommand="JobsGridView_RowCommand" OnSelectionChanged="JobsGridView_SelectionChanged"
                    OnInitNewRow="JobsGridView_InitNewRow" 
                    OnCustomCallback="JobsGridView_CustomCallback" OnToolbarItemClick="JobsGridView_ToolbarItemClick" 
                    AutoGenerateColumns="False" Width="95%">                               
                    <Toolbars>
                        <dx:GridViewToolbar>
                            <SettingsAdaptivity Enabled="true" EnableCollapseRootItemsToIcons="true" />
                            <Items>
                                <dx:GridViewToolbarItem Command="Refresh" />
                                <dx:GridViewToolbarItem Command="New" BeginGroup="true" AdaptivePriority="3" Visible="false"/>
                                <dx:GridViewToolbarItem Command="Edit" Visible="false"/>
                                <dx:GridViewToolbarItem Command="Delete" Visible="false"/>
                                <dx:GridViewToolbarItem Command="ShowFilterRow" BeginGroup="true" AdaptivePriority="1"/>
                                <dx:GridViewToolbarItem Command="ShowCustomizationWindow" AdaptivePriority="2"/>  
                                <dx:GridViewToolbarItem Text="Export to" Image-IconID="actions_download_16x16office2013" BeginGroup="true" AdaptivePriority="4">
                                    <Items>
                                        <dx:GridViewToolbarItem Command="ExportToPdf" />
                                        <dx:GridViewToolbarItem Command="ExportToDocx" />
                                        <dx:GridViewToolbarItem Command="ExportToRtf" />
                                        <dx:GridViewToolbarItem Command="ExportToCsv" />
                                        <dx:GridViewToolbarItem Command="ExportToXls" Text="Export to XLS" />
                                        <dx:GridViewToolbarItem Command="ExportToXlsx" Text="Export to XLSX" />
                                        <dx:GridViewToolbarItem Name="CustomExportToXLS" Text="Export to XLS (Custom)" BeginGroup="true" Image-IconID="export_exporttoxls_16x16office2013" >
                                           <Image IconID="export_exporttoxls_16x16office2013"></Image>
                                        </dx:GridViewToolbarItem>
                                        <dx:GridViewToolbarItem Name="CustomExportToXlsx" Text="Export to XLSX (Custom)" Image-IconID="export_exporttoxlsx_16x16office2013" >
                                           <Image IconID="export_exporttoxlsx_16x16office2013"></Image>
                                        </dx:GridViewToolbarItem>
                                    </Items>
                                    <Image IconID="actions_download_16x16office2013"></Image>
                                </dx:GridViewToolbarItem>
                                <dx:GridViewToolbarItem Alignment="Right" BeginGroup="true" AdaptivePriority="5">
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
                    <SettingsPopup>
                      <HeaderFilter MinHeight="140px"></HeaderFilter>
                    </SettingsPopup>
                    <Columns>      
                          <dx:GridViewCommandColumn VisibleIndex="0" SelectAllCheckboxMode="AllPages" ShowSelectCheckbox="True" Width="50px" />
                          <dx:GridViewDataTextColumn FieldName="JOBID" VisibleIndex="1" Width="50px" Visible="true" />                                           
                          <dx:GridViewDataTextColumn FieldName="GUID" VisibleIndex="2" Width="260px" Visible="true" />
                          <dx:GridViewDataTextColumn FieldName="Category" VisibleIndex="3" Width="100px" Visible="true" />
                          <dx:GridViewDataTextColumn FieldName="Group" VisibleIndex="4" Width="90px" Visible="true" />
                          <dx:GridViewDataTextColumn FieldName="Description" VisibleIndex="5" Width="350px" Visible="true" />
                          <dx:GridViewDataTextColumn FieldName="StatusID" VisibleIndex="6" Width="70px" Visible="false" />
                          <dx:GridViewDataTextColumn FieldName="UserID" VisibleIndex="7" Width="90px" Visible="true" />
                          <dx:GridViewDataTextColumn FieldName="Status" VisibleIndex="8" Width="90px" Visible="true" />              	
                          <dx:GridViewDataDateColumn FieldName="TimeStamp" VisibleIndex="9" Width="100px" Visible="true" />
                          <dx:GridViewDataDateColumn FieldName="Age" VisibleIndex="10" Width="100px" Visible="true" />
                          <dx:GridViewDataDateColumn FieldName="Rank" VisibleIndex="11" Width="100px" Visible="true" />              	              	
                      </Columns>
                      <SettingsPager PageSize="15" AlwaysShowPager="True" EllipsisMode="OutsideNumeric" EnableAdaptivity="True">
                          <PageSizeItemSettings Visible="True"></PageSizeItemSettings>
                      </SettingsPager>
                      <Settings ShowFilterBar="Auto" ShowFilterRow="False" ShowFilterRowMenu="True" ShowHeaderFilterButton="False" ShowGroupedColumns="True" ShowPreview="True" VerticalScrollBarMode="Hidden" HorizontalScrollBarMode="Auto" />                        
                      <SettingsBehavior AllowClientEventsOnLoad="False" AllowSelectSingleRowOnly="True" AllowSelectByRowClick="True" AllowFocusedRow="True" EnableCustomizationWindow="true" AllowEllipsisInText="False" AllowDragDrop="True" />
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
                                      <dx:GridViewColumnLayoutItem ColumnName="Category">
                                        <Template>
                                           <dx:ASPxTextBox ID="categoryTextBox" runat="server" Width="80%" Text='<%# Bind("Category") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>
                                      
                                      <dx:GridViewColumnLayoutItem ColumnName="Group">
                                        <Template>
                                           <dx:ASPxTextBox ID="groupTextBox" runat="server" Width="80%" Text='<%# Bind("Group") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>
                      
                                      <dx:GridViewColumnLayoutItem ColumnName="Description" Caption="Comment" ColumnSpan="2">
                                        <Template>
                                           <dx:ASPxTextBox ID="descriptionTextBox" runat="server" Width="95%" Text='<%# Bind("Description") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>
                
                                      <dx:GridViewColumnLayoutItem ColumnName="StatusID" Caption="StatusID">
                                        <Template>
                                           <%--<dx:ASPxTextBox ID="jobStatusTextBox" runat="server" Width="50%" Text='<%# Bind("StatusID") %>' />--%>
                                           <dx:ASPxComboBox ID="statusIDComboBox" runat="server" AutoPostBack="False" Width="50%" Value='<%# Bind("StatusID") %>'>
                                              <Items>
                                                   <dx:ListEditItem Value=0 Text="0-Initialised" />
                                                   <dx:ListEditItem Value=1 Text="1-Ready" />
                                                   <dx:ListEditItem Value=2 Text="2-Blocked" />
                                                   <dx:ListEditItem Value=3 Text="3-Running" />
                                                   <dx:ListEditItem Value=4 Text="4-Paused" />
                                                   <dx:ListEditItem Value=5 Text="5-Completed" />
                                                   <dx:ListEditItem Value=6 Text="6-Archived" />
                                                   <dx:ListEditItem Value=7 Text="7-Other" />                                                   	                                                                                                      
                                               </Items>
                                           </dx:ASPxComboBox>   
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>
                
                                      <dx:GridViewColumnLayoutItem ColumnName="UserID" Caption="UserID">
                                        <Template>
                                           <dx:ASPxTextBox ID="jobUserTextBox" runat="server" Width="50%" Text='<%# Bind("UserID") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>
                
                                      <dx:GridViewColumnLayoutItem ColumnName="TimeStamp" Caption="TimeStamp">
                                        <Template>
                                           <dx:ASPxTextBox ID="jobTimestampTextBox" runat="server" Width="50%" Text='<%# Bind("TimeStamp") %>' />
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
                      <ClientSideEvents Init="OnGridViewJobsInit" SelectionChanged="OnGridViewJobsSelectionChanged" ToolbarItemClick="OnGridViewJobsToolbarItemClick" />
                  </dx:ASPxGridView>
                   
                   <br/>
                   <dx:ASPxButton ID="SyncButton" runat="server" Text="Sync-AD" OnClick="SyncButtonClick" Width="100" Visible="false">
                       <ClientSideEvents Click="function(s, e) { LoadingPanel.Show(); }" />
                   </dx:ASPxButton>
                   <br/>
                                            
                   </dx:ContentControl>
              </ContentCollection>                                    
            </dx:TabPage>

            <%--
            **** TODO TAB
            --%>
                                                                                                                                                                       
            <dx:TabPage Text="TODO" Visible="False">
               <ContentCollection>                              
                   <dx:ContentControl ID="ContentControl2" runat="server">

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
                                 <dx:LayoutItem Caption="Contact Details">
                                     <LayoutItemNestedControlCollection>
                                         <dx:LayoutItemNestedControlContainer>
                                             <dx:ASPxComboBox ID="pcJobComboBox" ClientInstanceName="pcJobComboBox" runat="server" ClientIDMode="Static" AutoPostBack="False" Width="90%" SelectedIndex="0">
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
   **** LOADING PANELS
   --%>

   <dx:ASPxLoadingPanel ID="LoadingPanel" runat="server" ClientInstanceName="LoadingPanel" Modal="True" />   
  
   <%--
   **** DATA SOURCES
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
   **** ADDITIONAL DATA SOURCES
   --%>
  

</asp:Content>
