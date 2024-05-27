<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="Staging.master" CodeBehind="Uploads.aspx.cs" Inherits="BlackBox.AllUploadsPage" Title="BlackBox" %>

<%@ Register assembly="System.Web.DataVisualization, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" namespace="System.Web.UI.DataVisualization.Charting" tagprefix="asp" %>

<%@ Register assembly="DevExpress.Web.v22.2, Version=22.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" namespace="DevExpress.Web" tagprefix="dx" %>
<%@ Register assembly="DevExpress.XtraCharts.v22.2.Web, Version=22.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" namespace="DevExpress.XtraCharts.Web" tagprefix="dx" %>
<%@ Register assembly="DevExpress.XtraCharts.v22.2, Version=22.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" namespace="DevExpress.XtraCharts" tagprefix="dx" %>

<%--
**** HEADER CONTENT
--%>

<asp:Content runat="server" ContentPlaceHolderID="ContentPlaceHolderHead">  
  <script type="text/javascript">
 
  // ///////////////////////
  // page functions
  // ///////////////////////
  
  // main page control
  function OnPageControlInit(s, e) 
  { 
  }
        
  // page toolbar
  function updateToolbarButtonsState() 
  {
    var enabled = cardView.GetSelectedCardCount() > 0;
    //pageToolbar.GetItemByName("Delete").SetEnabled(enabled);
    //pageToolbar.GetItemByName("Edit").SetEnabled(cardView.GetFocusedRowIndex() !== -1);
  }

  // page toolbar click
  function OnPageToolbarItemClick(s, e) 
  {
    switch(e.item.name) 
    {
      case "Details":
          break;
    }
  }

  // dataDataSourceComboBox events
  function OnDataSourceComboBoxSelectionChanged(s, e) 
  {
    var source = dataSourceComboBox.GetText();
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
    gridViewUploadedFiles.Refresh();
  }
 
  // ///////////////////////
  // imports grid functions
  // ///////////////////////

  // imports grid toolbar functions  
  function OnGridViewImportsToolbarItemClick(s, e) 
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

  // imports gridview functions
  function OnGridViewImportsInit(s, e) 
  { 
    var toolbar = gridViewUploadedFiles.GetToolbar(0);  
    if (toolbar != null) 
    {  
      //var btSubmit = toolbar.Items["CustomSubmitStaged"];  btSubmit.enabled = false;
    }
  }
    
  function OnGridViewImportsSelectionChanged(s, e) 
  {
    e.processOnServer=true;
    e.usePostBack=true;
  }
 
  function OnGridViewImportsFocusedRowChanged(s, e)
  {
    var fri = gridViewUploadedFiles.GetFocusedRowIndex();
    gridViewUploadedFiles.GetRowValues(fri, 'Location;Datasets', OnGetImportsFocusedRowValues);
    gridViewUploadedFiles.Refresh();    
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

  // ///////////////////////
  // popup functions
  // ///////////////////////

  // show the popup
  function ShowModalInspectPopup() 
  {
    pcInspectSelect.Show();
    gridViewUploadedFiles.Refresh();
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
    
  window.OnPageToolbarItemClick = OnPageToolbarItemClick;

  window.OnDataSourceComboBoxSelectionChanged = OnDataSourceComboBoxSelectionChanged;

  window.OnPcInspectSubmitButtonClick = OnPcInspectSubmitButtonClick;

  window.OnGridViewImportsInit = OnGridViewImportsInit;
  window.OnGridViewImportsSelectionChanged = OnGridViewImportsSelectionChanged;
  window.OnGridViewImportsFocusedRowChanged = OnGridViewImportsFocusedRowChanged;  
  window.OnGridViewImportsToolbarItemClick = OnGridViewImportsToolbarItemClick;    

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
                           <dx:ASPxHyperLink ID="BreadcrumbsHyperLink" runat="server" NavigateUrl="~/Default.aspx" Text="Home" Font-Bold="True" Font-Size="Large" Border-BorderStyle="None" Border-BorderWidth="8px" />
                           <dx:ASPxLabel ID="BreadcrumbsSpacer" runat="server" Text=">"></dx:ASPxLabel>
                           <dx:ASPxLabel ID="BreadcrumbsLabel" ClientIDMode="Static" runat="server" Text="Uploads" Font-Bold="True" Font-Size="Large" Width="300px" />
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
       ItemAutoWidth="false" EnableSubMenuScrolling="true" ShowPopOutImages="true" SeparatorWidth="0" ItemWrap="false"
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
           <Font Bold="true" Size="Medium"></Font>                        
           <SelectedStyle CssClass="selected"></SelectedStyle>
           <HoverStyle CssClass="hovered"></HoverStyle>
       </ItemStyle>
       <LinkStyle>
           <Font Bold="true" Size="Medium"></Font>
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

    <dx:ASPxPageControl ID="TabPagesRightPanel" Width="100%" runat="server" ActiveTabIndex="0" EnableHierarchyRecreation="true" >
       <TabPages>
           <%--
           **** SETTINGS TABPAGE
           --%>

           <dx:TabPage Text="Settings" Visible="true">
              <ContentCollection>
                  <dx:ContentControl ID="RightPanelContentControl1" runat="server">

                  <dx:ASPxGridView runat="server" ID="SettingsGridView" ClientInstanceName="gridViewSettings"
                      KeyFieldName="Group;Name" EnablePagingGestures="false"
                      CssClass="grid-view" Width="95%"
                      DataSourceID="SettingsDataModelSource"
                      OnCustomCallback="SettingsGridView_CustomCallback"
                      OnInitNewRow="SettingsGridView_InitNewRow" AutoGenerateColumns="false">
                      <Columns>
                          <dx:GridViewCommandColumn ShowSelectCheckbox="true" SelectAllCheckboxMode="AllPages" VisibleIndex="0" Width="50"></dx:GridViewCommandColumn>
                          <dx:GridViewDataColumn FieldName="Group" Caption="Group" Width="100px" />                               
                          <dx:GridViewDataColumn FieldName="Name" Caption="Name" Width="150px" />
                          <dx:GridViewDataColumn FieldName="SerializeAs" Caption="Type" Visible="false" />
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
                      <SettingsBehavior AllowFocusedRow="false" AllowSelectByRowClick="true" AllowEllipsisInText="true" AllowDragDrop="false" />
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
                          <FilterControl AutoUpdatePosition="false"></FilterControl>
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
  
   <asp:SqlDataSource ID="SqlBlackBoxJobs" runat="server" 
      ConnectionString="<%$ ConnectionStrings:BlackBoxConnectionString %>" 
      SelectCommand="SELECT TOP(100) [JOBID],[GUID],[Category],[Group],[Description],[Data],[StatusID],[Status],[UserID],[TimeStamp],[Age],[Rank] FROM [dbo].[vBlackBoxJobs] WHERE [Category] like 'Upload' ORDER BY [TimeStamp] DESC" 
      InsertCommand="INSERT INTO [dbo].[BlackBoxJobs] ([GUID],[Category],[Group],[Description],[Data],[StatusID],[UserID],[TimeStamp]) VALUES(@guid,@category,@group,@description,@data,@statusid,@userid,@timestamp)"
      UpdateCommand="UPDATE [dbo].[BlackBoxJobs] SET [GUID]=@guid,[Category]=@category,[Group]=@group,[Description]=@description,[Data]=@data,[StatusID]=@statusid,[UserID]=@userid,[TimeStamp]=@timestamp WHERE [JOBID] = @jobid" 
      DeleteCommand="DELETE FROM [dbo].[BlackBoxJobs] WHERE [JOBID] = @jobid">
      <InsertParameters>
          <asp:QueryStringParameter Name="guid" />
          <asp:QueryStringParameter Name="category" />
          <asp:QueryStringParameter Name="group" />
          <asp:QueryStringParameter Name="description" />
          <asp:QueryStringParameter Name="data" />
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
          <asp:QueryStringParameter Name="data" />
          <asp:QueryStringParameter Name="statusid" />
          <asp:QueryStringParameter Name="userid" />            
          <asp:QueryStringParameter Name="timestamp" />           
      </UpdateParameters>
      <DeleteParameters>
          <asp:QueryStringParameter Name="jobid" />
      </DeleteParameters>
   </asp:SqlDataSource>

   <asp:SqlDataSource ID="SqlBlackBoxFiles" runat="server" 
      ConnectionString="<%$ ConnectionStrings:BlackBoxConnectionString %>" 
      SelectCommand="SELECT TOP(100) [FID],[JOBID],[GUID],[Name],[Location],[TypeID],[Type],[Group],[Description],[DataSource],[DataSourceInstanceID],[Datasets],[StatusID],[Status],[Locked],[UserID],[TimeStamp],[Age],[Rank] FROM [dbo].[vBlackBoxFiles] WHERE [UserID] = @userid ORDER BY [TimeStamp] DESC"
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

   <asp:SqlDataSource ID="SqlBlackBoxDataSourceInstances" runat="server" 
      ConnectionString="<%$ ConnectionStrings:BlackBoxConnectionString %>" 
      SelectCommand="SELECT TOP(100) [ID],[Name],[Group],[Comment],[TypeID],[Type],[Locked],[AllowedDatasets],[ReferenceID],[Source],[Datasets],[Prefix],[JOBID],[GUID],[StatusID],[Status],[TimeStamp],[Age] FROM [dbo].[vBlackBoxDataSourceInstances] ORDER BY [TimeStamp] DESC"
      InsertCommand="INSERT INTO [dbo].[BlackBoxDataSourceInstances] ([ID],[Name],[Group],[Comment],[TypeID],[ReferenceID],[Source],[Datasets],[Prefix],[JOBID],[GUID],[StatusID],[TimeStamp]) VALUES(@name,@group,@comment,@typeid,@refid,@source,@datasets,@prefix,@jobid,@guid,@statusid,@timestamp)"
      UpdateCommand="UPDATE [dbo].[BlackBoxDataSourceInstances] SET [Name]=@name,[Group]=@group,[Comment]=@comment,[TypeID]=@typeid,[ReferenceID]=@refid,[Source]=@source,[Datasets]=@datasets,[Prefix]=@prefix,[JOBID]=@jobid,[GUID]=@guid,[StatusID]=@statusid,[TimeStamp]=@timestamp WHERE [ID] = @id"
      DeleteCommand="DELETE FROM [dbo].[BlackBoxDataSourceInstances] WHERE [ID] = @id">
      <InsertParameters>
          <asp:QueryStringParameter Name="id" />
          <asp:QueryStringParameter Name="name" />
          <asp:QueryStringParameter Name="group" />
          <asp:QueryStringParameter Name="comment" />
          <asp:QueryStringParameter Name="typeid" />
          <asp:QueryStringParameter Name="refid" />
          <asp:QueryStringParameter Name="source" />
          <asp:QueryStringParameter Name="datasets" />
          <asp:QueryStringParameter Name="prefix" />
          <asp:QueryStringParameter Name="jobid" />
          <asp:QueryStringParameter Name="guid" />
          <asp:QueryStringParameter Name="statusid" />
          <asp:QueryStringParameter Name="timestamp" />
      </InsertParameters>
      <UpdateParameters>
          <asp:QueryStringParameter Name="id" />
          <asp:QueryStringParameter Name="name" />
          <asp:QueryStringParameter Name="group" />
          <asp:QueryStringParameter Name="comment" />
          <asp:QueryStringParameter Name="typeid" />
          <asp:QueryStringParameter Name="refid" />
          <asp:QueryStringParameter Name="source" />
          <asp:QueryStringParameter Name="datasets" />
          <asp:QueryStringParameter Name="prefix" />
          <asp:QueryStringParameter Name="jobid" />
          <asp:QueryStringParameter Name="guid" />
          <asp:QueryStringParameter Name="statusid" />
          <asp:QueryStringParameter Name="timestamp" />
      </UpdateParameters>
      <DeleteParameters>
          <asp:QueryStringParameter Name="id" />
      </DeleteParameters>
   </asp:SqlDataSource>
  
   <asp:SqlDataSource ID="SqlBlackBoxDatasets" runat="server" 
      ConnectionString="<%$ ConnectionStrings:BlackBoxConnectionString %>" 
      SelectCommand="SELECT [ID],[Name],[Group],[TableName],[Flags],[Comment],[JOBID],[GUID],[DataSourceInstanceID],[DataSource],[Rows],[StatusID],[Status],[TimeStamp],[Age],[Rank] FROM [dbo].[vBlackBoxDatasetUpdates] ORDER BY [TimeStamp] DESC, [ID] DESC"
      DeleteCommand="DELETE FROM [dbo].[BlackBoxDatasetUpdates] WHERE ID = @id">
      <DeleteParameters>
          <asp:QueryStringParameter Name="id" />
      </DeleteParameters>
   </asp:SqlDataSource>
        
   <%--
   **** TABBED PAGES
   --%>

   <dx:ASPxPageControl ID="mainTabPages" Width="100%" ClientInstanceName="mainTabPages" runat="server" ActiveTabIndex="0" EnableHierarchyRecreation="True" >
       <TabPages>
        
           <%--
           **** UPLOADED FILES TABPAGE
           --%>
                                                                                                                              
           <dx:TabPage Text="Uploaded Files">
              <ContentCollection>
                  <dx:ContentControl ID="MainContentControl1" runat="server">    

                  <table>
                    <tr style="vertical-align: middle">
                      <td style="width: 200px">
                        <fieldset>
                           <legend>Data Source</legend>
                           <dx:ASPxComboBox ID="dataSourceComboBox" ClientInstanceName="dataSourceComboBox" runat="server" AutoPostBack="True" Width="90%" SelectedIndex="0" ClientIDMode="Static"
                              OnSelectedIndexChanged="ASPxComboBoxSource_SelectedIndexChanged">                             
                              <Items>
                                   <dx:ListEditItem Value="" Text="Not Set" />
                                   <dx:ListEditItem Value="Assets" Text="Assets" />
                                   <dx:ListEditItem Value="Purchases" Text="Purchases" />
                                   <dx:ListEditItem Value="Metrics" Text="Metrics" />
                                   <dx:ListEditItem Value="AssetCriticality" Text="Criticality" />
                                   <dx:ListEditItem Value="SiteAssetApplications" Text="SIDA" />
                                   <dx:ListEditItem Value="%" Text="All" />                                   	
                               </Items>
                               <ClientSideEvents SelectedIndexChanged="OnDataSourceComboBoxSelectionChanged" />                               
                           </dx:ASPxComboBox>
                        </fieldset>          
                      </td>
                      <td style="width: 20px">&nbsp;
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

                  <dx:ASPxGridView ID="UploadedFilesGridView" runat="server" ClientInstanceName="gridViewUploadedFiles" DataSourceID="SqlBlackBoxFiles" KeyFieldName="FID"
                    OnRowCommand="UploadedFilesGridView_RowCommand" OnSelectionChanged="UploadedFilesGridView_SelectionChanged"
                    OnInitNewRow="UploadedFilesGridView_InitNewRow" OnRowInserting="UploadedFilesGridView_RowInserting" OnRowUpdating="UploadedFilesGridView_RowUpdating" OnRowDeleting="UploadedFilesGridView_RowDeleting"
                    OnCustomCallback="UploadedFilesGridView_CustomCallback" OnToolbarItemClick="UploadedFilesGridView_ToolbarItemClick"
                    EnableTheming="True" EnableViewState="False" AutoGenerateColumns="False" Width="95%">
                    <Toolbars>
                        <dx:GridViewToolbar>
                            <SettingsAdaptivity Enabled="true" EnableCollapseRootItemsToIcons="true" />
                            <Items>
                                <dx:GridViewToolbarItem Command="Refresh" />
                                <dx:GridViewToolbarItem Command="Edit" />                                	
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
                          <dx:GridViewDataTextColumn FieldName="Locked" VisibleIndex="15" Width="90px" Visible="true" />                          	
                          <dx:GridViewDataTextColumn FieldName="UserID" VisibleIndex="16" Width="80px" Visible="true" />                          	
                          <dx:GridViewDataDateColumn FieldName="TimeStamp" VisibleIndex="17" Width="120px" Visible="true" />
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

                                      <dx:GridViewColumnLayoutItem ColumnName="Locked" Caption="Locked">
                                        <Template>
                                           <%--<dx:ASPxTextBox ID="fileLockedTextBox" runat="server" Width="30%" Text='<%# Bind("Locked") %>' />--%>
                                           <dx:ASPxComboBox ID="fileLockedComboBox" runat="server" AutoPostBack="false" Width="50%" Value='<%# Bind("Locked") %>'>
                                              <Items>
                                                   <dx:ListEditItem Value=true Text="true" />
                                                   <dx:ListEditItem Value=false Text="false" />
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
                      <ClientSideEvents Init="OnGridViewImportsInit" SelectionChanged="OnGridViewImportsSelectionChanged" FocusedRowChanged="OnGridViewImportsFocusedRowChanged" 
                        ToolbarItemClick="OnGridViewImportsToolbarItemClick" />
                  </dx:ASPxGridView>

                  </dx:ContentControl>
             </ContentCollection>                                    
           </dx:TabPage>
        
           <%--
           **** VALIDATION RESULTS TABPAGE
           --%>

           <dx:TabPage Text="Validation Results">
              <ContentCollection>
                  <dx:ContentControl ID="MainContentControl2" runat="server">
                  <br/>

                  </dx:ContentControl>
             </ContentCollection>                                    
           </dx:TabPage>
           
       </TabPages>
       <ClientSideEvents Init="OnPageControlInit" />
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
             <dx:ASPxPanel ID="pcInspectPanel" runat="server" DefaultButton="btCreate">
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
   **** LOADING PANEL  
   --%>

   <dx:ASPxLoadingPanel ID="ASPxLoadingPanelMain" ClientInstanceName="ASPxLoadingPanelMain" runat="server" Modal="True" Text="Processing&amp;hellip;" ValidateRequestMode="Disabled">
   </dx:ASPxLoadingPanel>
     
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
   **** CONTENT DATA SOURCES
   --%>
       
       
       
</asp:Content>
