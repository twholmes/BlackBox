<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="Staging.Master" CodeBehind="Files.aspx.cs" Inherits="BlackBox.ImportFilesPage" Title="BlackBox" %>

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

  // /////////////////////
  // uploader functions
  // /////////////////////

  // on start upload
  function OnFileUploadStart(s, e) 
  {
  }

  // on complete single file upload
  function OnFileUploadComplete(s, e) 
  {
  }

  // on complete upload all files
  function OnFilesUploadComplete(s, e) 
  {
    gridViewFiles.Refresh();
  }

  // ///////////////////////
  // files grid functions
  // ///////////////////////

  // dataDataSourceComboBox events
  function OnDataSourceComboBoxSelectionChanged(s, e) 
  {
    //var source = dataSourceComboBox.GetText();
  }

  // files grid toolbar functions  
  function OnGridViewFilesToolbarItemClick(s, e) 
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
  function OnGridViewFilesInit(s, e) 
  { 
    var toolbar = gridViewFiles.GetToolbar(0);  
    if (toolbar != null) 
    {  
      //var btSubmit = toolbar.Items["CustomSubmitStaged"];  btSubmit.enabled = false;
    }
  }
    
  function OnGridViewFilesSelectionChanged(s, e) 
  {
    e.processOnServer=true;
    e.usePostBack=true;
  }
 
  function OnGridViewFilesFocusedRowChanged(s, e)
  {
    var fri = gridViewFiles.GetFocusedRowIndex();
    gridViewFiles.GetRowValues(fri, 'Location;Datasets', OnGetImportsFocusedRowValues);
    gridViewFiles.Refresh();    
  }

  function OnGetImportsFocusedRowValues(values)
  {
    var location = values[0];
    var datasets = values[1];
    
    //split to array trim elements and update popup combo box
    var datasets = datasets.split(",") 
    pcDatasetComboBox.ClearItems();
    datasets.forEach(AddDatasetToPopupComboBox);
    pcDatasetComboBox.SetSelectedIndex(0);
  }

  function AddDatasetToPopupComboBox(value)
  {   
    var name = value.trim()
    pcDatasetComboBox.AddItem(name);
  }

  // ///////////////////////////
  // file manager functions
  // //////////////////////////

  
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
  
  window.OnDataSourceComboBoxSelectionChanged = OnDataSourceComboBoxSelectionChanged;

  window.OnPcInspectSubmitButtonClick = OnPcInspectSubmitButtonClick;

  window.OnGridViewFilesInit = OnGridViewFilesInit;
  window.OnGridViewFilesSelectionChanged = OnGridViewFilesSelectionChanged;
  window.OnGridViewFilesFocusedRowChanged = OnGridViewFilesFocusedRowChanged;  
  window.OnGridViewFilesToolbarItemClick = OnGridViewFilesToolbarItemClick;    

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
                           <dx:ASPxLabel ID="BreadcrumbsLabel" runat="server" Text="Files" Font-Bold="True" Font-Size="Large" Width="280px" />
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
          <dx:MenuItem Name="PageMenuFiles" Text="FileManager" NavigateUrl="~/Admin/FileManager.aspx" Alignment="Right" AdaptivePriority="1">
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

    <%--
    **** RIGHT PANEL TAB PAGES
    --%>    

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
  
    <%--
    **** CONTENT TABS
    --%>
   
    <dx:ASPxPageControl ID="TabPagesMainPanel" Width="100%" runat="server" ActiveTabIndex="0" EnableHierarchyRecreation="True" >
        <TabPages>

           <%--
           **** FILES TABPAGE
           --%>
                                                                                                                              
           <dx:TabPage Text="Files">
              <ContentCollection>
                  <dx:ContentControl ID="MainContentControl1" runat="server">    

                  <table>
                    <tr style="vertical-align: middle">
                      <td style="width: 500px">
                        <fieldset>
                           <legend>Upload</legend>
                           <dx:ASPxUploadControl ID="ASPxUploadControlImports" runat="server"  ViewStateMode="Enabled" Width="460px" 
                              UploadMode="Advanced" UploadStorage="FileSystem" AutoStartUpload="True"
                              CancelButtonHorizontalPosition="Left" ShowProgressPanel="True" ShowClearFileSelectionButton="False" 
                              OnLoad="ASPxUploadControl_Load" OnFileUploadComplete="ASPxUploadControl_FileUploadComplete" OnFilesUploadComplete="ASPxUploadControl_FilesUploadComplete" 
                              OnGenerateFileNameInStorage="ASPxUploadControl_GenerateFileNameInStorage" >
                              <AdvancedModeSettings EnableMultiSelect="True" EnableFileList="True" EnableDragAndDrop="True" />                              
                              <FileSystemSettings UploadFolder="~/Jobs" />
                              <ClientSideEvents FileUploadComplete="OnFileUploadComplete" FilesUploadComplete="OnFilesUploadComplete" FilesUploadStart="OnFileUploadStart" />
                           </dx:ASPxUploadControl>
                        </fieldset>          
                      </td>
                      <td style="width: 50px">&nbsp;
                      </td>
                   </tr>
                  </table>
                  <br/>

                  <dx:ASPxGridView ID="FilesGridView" runat="server" ClientInstanceName="gridViewFiles" DataSourceID="SqlBlackBoxFiles" KeyFieldName="FID"
                    OnRowCommand="FilesGridView_RowCommand" OnSelectionChanged="FilesGridView_SelectionChanged"
                    OnInitNewRow="FilesGridView_InitNewRow" OnRowInserting="FilesGridView_RowInserting" OnRowUpdating="FilesGridView_RowUpdating" OnRowDeleting="FilesGridView_RowDeleting"
                    OnCustomCallback="FilesGridView_CustomCallback" OnToolbarItemClick="FilesGridView_ToolbarItemClick"
                    EnableTheming="True" EnableViewState="False" AutoGenerateColumns="False" Width="95%">
                    <Toolbars>
                        <dx:GridViewToolbar>
                            <SettingsAdaptivity Enabled="true" EnableCollapseRootItemsToIcons="true" />
                            <Items>
                                <dx:GridViewToolbarItem Command="Refresh" />
                                <dx:GridViewToolbarItem Command="Delete" />                                 
                                <dx:GridViewToolbarItem Command="ShowFilterRow" BeginGroup="true" AdaptivePriority="1"/>
                                <dx:GridViewToolbarItem Command="ShowCustomizationWindow" AdaptivePriority="2"/>  
                                <%--
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
                                --%>
                                <dx:GridViewToolbarItem Name="CustomValidateFile" Text="Validate" BeginGroup="true" Enabled="false" />                                
                                <dx:GridViewToolbarItem Name="CustomInspectStaged" Text="Inspect" BeginGroup="true" Enabled="false" />                                
                                <dx:GridViewToolbarItem Name="CustomSubmitStaged" Text="Submit" BeginGroup="true" Enabled="false" />
                                <dx:GridViewToolbarItem Name="CustomRecallStaged" Text="Recall" BeginGroup="false" Enabled="false" /> 
                                <dx:GridViewToolbarItem Name="CustomApproveStaged" Text="Approve" BeginGroup="true" Enabled="false" />
                                <dx:GridViewToolbarItem Name="CustomRejectStaged" Text="Reject" BeginGroup="false" Enabled="false" /> 
                                <dx:GridViewToolbarItem Name="CustomProcessStaged" Text="Process" BeginGroup="true" Enabled="false" /> 
                                <dx:GridViewToolbarItem Name="CustomArchiveStaged" Text="Archive" BeginGroup="true" Enabled="false" />
                                <dx:GridViewToolbarItem Name="CustomWithdrawStaged" Text="Withdraw" BeginGroup="false" Enabled="false" />

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
                          <dx:GridViewDataTextColumn FieldName="FID" VisibleIndex="1" Width="60px" Visible="true" />
                          <dx:GridViewDataTextColumn FieldName="JOBID" VisibleIndex="2" Width="80px" Visible="false" />
                          <dx:GridViewDataTextColumn FieldName="GUID" VisibleIndex="3" Width="290px" Visible="false" />
                          <dx:GridViewDataTextColumn FieldName="Name" VisibleIndex="4" Width="200px" Visible="true" />                            
                          <dx:GridViewDataTextColumn FieldName="Location" VisibleIndex="5" Width="420px" Visible="false" />
                          <dx:GridViewDataTextColumn FieldName="TypeID" VisibleIndex="6" Width="80px" Visible="false" />
                          <dx:GridViewDataTextColumn FieldName="Type" VisibleIndex="7" Width="90px" Visible="true" />
                          <dx:GridViewDataTextColumn FieldName="Group" VisibleIndex="8" Width="150px" Visible="true" />                           
                          <dx:GridViewDataTextColumn FieldName="Description" VisibleIndex="9" Width="330px" Visible="true" />
                          <dx:GridViewDataTextColumn FieldName="DataSource" VisibleIndex="10" Width="200px" Visible="true" />
                          <dx:GridViewDataTextColumn FieldName="DataSourceInstanceID" Caption="DSIID" VisibleIndex="11" Width="90px" Visible="false" />                           
                          <dx:GridViewDataTextColumn FieldName="Datasets" VisibleIndex="12" Width="300px" Visible="false" />                            
                          <dx:GridViewDataTextColumn FieldName="StatusID" VisibleIndex="13" Width="80px" Visible="false" />
                          <dx:GridViewDataTextColumn FieldName="Status" VisibleIndex="14" Width="120px" Visible="true" />
                          <dx:GridViewDataTextColumn FieldName="UserID" VisibleIndex="15" Width="80px" Visible="true" />                            
                          <dx:GridViewDataDateColumn FieldName="TimeStamp" VisibleIndex="16" Width="120px" Visible="true" />
                          <dx:GridViewDataTextColumn FieldName="Age" VisibleIndex="17" Width="90px" Visible="false" />
                          <dx:GridViewDataTextColumn FieldName="Rank" VisibleIndex="18" Width="90px" Visible="false" />
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
                                      <dx:GridViewColumnLayoutItem ColumnName="FID" Caption="FileID">
                                        <Template>
                                           <dx:ASPxLabel ID="fidLabel" runat="server" Width="40%" Text='<%# Bind("FID") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>
                                      <dx:GridViewColumnLayoutItem ColumnName="JOBID" Caption="JobID">
                                        <Template>
                                           <dx:ASPxLabel ID="fileJobIdLabel" runat="server" Width="40%" Text='<%# Bind("JOBID") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>
                                      <dx:GridViewColumnLayoutItem ColumnName="GUID" Caption="GUID" ColumnSpan="2">
                                        <Template>
                                           <dx:ASPxLabel ID="fileGuidLabel" runat="server" Width="40%" Text='<%# Bind("GUID") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>

                                      <dx:GridViewColumnLayoutItem ColumnName="Name" Caption="Name">
                                        <Template>
                                           <dx:ASPxTextBox ID="fileNameTextBox" runat="server" Width="80%" Text='<%# Bind("Name") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>

                                      <dx:GridViewColumnLayoutItem ColumnName="TypeID" Caption="TypeID">
                                        <Template>
                                           <%--<dx:ASPxTextBox ID="fileTypeIdTextBox" runat="server" Width="50%" Text='<%# Bind("TypeID") %>' />--%>
                                           <dx:ASPxComboBox ID="dsxTypeIdComboBox" runat="server" AutoPostBack="False" Width="50%" Value='<%# Bind("TypeID") %>'>
                                              <Items>
                                                   <dx:ListEditItem Value=0 Text="0-Ready" />
                                                   <dx:ListEditItem Value=1 Text="1-SQL" />
                                                   <dx:ListEditItem Value=2 Text="2-PS1" />
                                                   <dx:ListEditItem Value=3 Text="3-JS" />
                                                   <dx:ListEditItem Value=4 Text="4-CSV" />
                                                   <dx:ListEditItem Value=5 Text="5-XSLX" />
                                                   <dx:ListEditItem Value=6 Text="6-XML" />
                                                   <dx:ListEditItem Value=7 Text="7-BlackBox" />
                                                   <dx:ListEditItem Value=8 Text="8-FNMS" />
                                               </Items>
                                           </dx:ASPxComboBox>   
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>

                                      <dx:GridViewColumnLayoutItem ColumnName="Group" Caption="Group">
                                        <Template>
                                           <%--<dx:ASPxTextBox ID="fileGroupTextBox" runat="server" Width="60%" Text='<%# Bind("Group") %>' />--%>
                                           <dx:ASPxComboBox ID="fileGroupComboBox" ClientInstanceName="fileGroupComboBox" runat="server" Width="70%" SelectedIndex="0" ClientIDMode="Static" Value='<%# Bind("Group") %>'>
                                             <Items>
                                                 <dx:ListEditItem Value="" Text="None" />                                               
                                                 <dx:ListEditItem Value="ITAM" Text="ITAM" />
                                                 <dx:ListEditItem Value="Metrics" Text="Metrics" />
                                                 <dx:ListEditItem Value="Inventory" Text="Inventory" />
                                                 <dx:ListEditItem Value="RvTools" Text="RvTools" />
                                                 <dx:ListEditItem Value="Other" Text="Other" />                                     
                                            </Items>
                                           </dx:ASPxComboBox>
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>

                                      <dx:GridViewColumnLayoutItem ColumnName="DataSource" Caption="Data Source">
                                        <Template>
                                           <dx:ASPxTextBox ID="fileSourceTextBox" runat="server" Width="80%" Text='<%# Bind("DataSource") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>
                                      <dx:GridViewColumnLayoutItem ColumnName="DataSourceInstanceID" Caption="DataSourceInstanceID">
                                        <Template>
                                           <dx:ASPxTextBox ID="fileSourceIDTextBox" runat="server" Width="80%" Text='<%# Bind("DataSourceInstanceID") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>

                                      <dx:GridViewColumnLayoutItem ColumnName="Location" Caption="Location" ColumnSpan="2">
                                        <Template>
                                           <dx:ASPxTextBox ID="fileLocationTextBox" runat="server" Width="80%" Text='<%# Bind("Location") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>

                                      <dx:GridViewColumnLayoutItem ColumnName="Description" Caption="Description" ColumnSpan="2">
                                        <Template>
                                           <dx:ASPxTextBox ID="fileDescriptionTextBox" runat="server" Width="90%" Text='<%# Bind("Description") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>

                                      <dx:GridViewColumnLayoutItem ColumnName="Datasets" Caption="Datasets" ColumnSpan="2">
                                        <Template>
                                           <dx:ASPxTextBox ID="fileDatasetsTextBox" runat="server" Width="90%" Text='<%# Bind("Datasets") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>

                                      <dx:GridViewColumnLayoutItem ColumnName="StatusID" Caption="StatusID">
                                        <Template>
                                           <%--<dx:ASPxTextBox ID="fileStatusTextBox" runat="server" Width="50%" Text='<%# Bind("StatusID") %>' />--%>
                                           <dx:ASPxComboBox ID="fileStatusComboBox" runat="server" AutoPostBack="False" Width="50%" Value='<%# Bind("StatusID") %>'>
                                              <Items>
                                                   <dx:ListEditItem Value=0 Text="0-Ready" />
                                                   <dx:ListEditItem Value=1 Text="1-Uploaded" />
                                                   <dx:ListEditItem Value=2 Text="2-Staged" />
                                                   <dx:ListEditItem Value=3 Text="3-Submitted" />
                                                   <dx:ListEditItem Value=4 Text="4-Approved" />
                                                   <dx:ListEditItem Value=5 Text="5-Rejected" />
                                                   <dx:ListEditItem Value=6 Text="6-Processed" />                                                     
                                                   <dx:ListEditItem Value=7 Text="7-Locked" />                                                    
                                                   <dx:ListEditItem Value=8 Text="8-Withdrawn" />  
                                                   <dx:ListEditItem Value=9 Text="9-Archived" />
                                               </Items>
                                           </dx:ASPxComboBox>   
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
                      <ClientSideEvents Init="OnGridViewFilesInit" SelectionChanged="OnGridViewFilesSelectionChanged" FocusedRowChanged="OnGridViewFilesFocusedRowChanged" 
                        ToolbarItemClick="OnGridViewFilesToolbarItemClick" />
                  </dx:ASPxGridView>

                  </dx:ContentControl>
             </ContentCollection>                                    
           </dx:TabPage>
        
           <%--
           **** FILE MANAGER TABPAGE
           --%>

           <dx:TabPage Text="File Manager" Visible="false">
              <ContentCollection>
                  <dx:ContentControl ID="MainContentControl2" runat="server">


                  </dx:ContentControl>
             </ContentCollection>                                    
           </dx:TabPage>
        
           <%--
           **** FILE MANAGER CONFIG TABPAGE
           --%>
           
           <dx:TabPage Text="File Manager Settings" Visible="false">
              <ContentCollection>                              
                  <dx:ContentControl ID="ContentControl3" runat="server">

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
                                 <dx:LayoutItem Caption="Data Source">
                                     <LayoutItemNestedControlCollection>
                                         <dx:LayoutItemNestedControlContainer>
                                             <dx:ASPxComboBox ID="pcDatasetComboBox" ClientInstanceName="pcDatasetComboBox" runat="server" ClientIDMode="Static" AutoPostBack="False" Width="90%" SelectedIndex="0">
                                                <Items>
                                                     <dx:ListEditItem Value="itamPurchases" Text="Purchases" />
                                                     <dx:ListEditItem Value="itamAssets" Text="Assets" />
                                                     <dx:ListEditItem Value="dataMetrics" Text="Metrics" />
                                                     <dx:ListEditItem Value="itamSIA" Text="SIA" />
                                                     <dx:ListEditItem Value="itamAssetRiskAssessment" Text="AssetRiskAssessment" />
                                                     <dx:ListEditItem Value="itamSIDA" Text="SIDA" />
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
