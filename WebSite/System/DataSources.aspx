<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="System.Master" CodeBehind="DataSources.aspx.cs" Inherits="BlackBox.DataSourcesSystemPage" Title="BlackBox" %>

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

  // ///////////////////////
  // data source functions
  // ///////////////////////

  // data sources grid toolbar functions
  function OnGridViewDataSourcesToolbarItemClick(s, e) 
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

  // data sources gridview functions
  function OnGridViewDataSourcesInit(s, e) 
  {
  }
    
  function OnGridViewDataSourcesSelectionChanged(s, e) 
  {
    e.processOnServer=true;
    e.usePostBack=true;
  }

  function OnGridViewDataSourcesFocusedRowChanged(s, e)
  {
    var fri = gridViewDataSources.GetFocusedRowIndex();
    gridViewDataSources.GetRowValues(fri, 'Datasets', OnGetDataSourcesFocusedRowValues);
    gridViewDataSources.Refresh();    
  }

  function OnGetDataSourcesFocusedRowValues(value)
  {   
    //split to array trim elements and update popup combo box
    var datasets = value.split(",") 
    pcDatasetComboBox.ClearItems();
    datasets.forEach(AddDatasetToPopupComboBox);
    pcDatasetComboBox.SetSelectedIndex(0);
  }

  function AddDatasetToPopupComboBox(value)
  {   
    var name = value.trim()
    pcDatasetComboBox.AddItem(name);
  }

  // ////////////////////////////////
  // data source instance functions
  // ////////////////////////////////

  // data sources grid toolbar functions
  function OnGridViewDataSourceInstancesToolbarItemClick(s, e) 
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

  // data sources gridview functions
  function OnGridViewDataSourceInstancesInit(s, e) 
  {
  }
    
  function OnGridViewDataSourceInstancesSelectionChanged(s, e) 
  {
    e.processOnServer=true;
    e.usePostBack=true;
  }

  function OnGridViewDataSourceInstancesFocusedRowChanged(s, e)
  {
    var fri = gridViewDataSourceInstances.GetFocusedRowIndex();
    gridViewDataSourceInstances.GetRowValues(fri, 'Datasets', OnGetDataSourceInstancesFocusedRowValues);
    gridViewDataSourceInstances.Refresh();    
  }

  function OnGetDataSourceInstancesFocusedRowValues(value)
  {   
    var datasets = value.split(",") 
    pcDatasetComboBox.ClearItems();
    datasets.forEach(AddDatasetToPopupComboBox);
    pcDatasetComboBox.SetSelectedIndex(0);
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
 
  // /////////////////////
  // common functions
  // /////////////////////
  
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
      
      case "CustomExportToSQL":
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
  
  window.OnPcInspectSubmitButtonClick = OnPcInspectSubmitButtonClick;

  window.OnGridViewDataSourcesInit = OnGridViewDataSourcesInit;
  window.OnGridViewDataSourcesSelectionChanged = OnGridViewDataSourcesSelectionChanged;
  window.OnGridViewDataSourcesFocusedRowChanged = OnGridViewDataSourcesFocusedRowChanged;
  window.OnGridViewDataSourcesToolbarItemClick = OnGridViewDataSourcesToolbarItemClick;    

  window.OnGridViewDataSourceInstancesInit = OnGridViewDataSourceInstancesInit;
  window.OnGridViewDataSourceInstancesSelectionChanged = OnGridViewDataSourceInstancesSelectionChanged;
  window.OnGridViewDataSourceInstancesFocusedRowChanged = OnGridViewDataSourceInstancesFocusedRowChanged;
  window.OnGridViewDataSourceInstancesToolbarItemClick = OnGridViewDataSourceInstancesToolbarItemClick;    
 
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
                           <dx:ASPxLabel ID="BreadcrumbsLabel" ClientIDMode="Static" runat="server" Text="Data Sources" Font-Bold="True" Font-Size="Large" Width="300px" />
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
                  <dx:ContentControl ID="ContentControlRight1" runat="server">

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
    <%--
    **** CONTENT PANEL DATA SOURCES
    --%>    

   <asp:SqlDataSource ID="SqlBlackBoxDataSources" runat="server" 
      ConnectionString="<%$ ConnectionStrings:BlackBoxConnectionString %>" 
      SelectCommand="SELECT [Name],[Group],[Description],[TypeID],[Type],[Template],[Datasets],[Prefix],[StatusID],[Status],[Locked],[Icon],[TimeStamp],[Age] FROM [dbo].[vBlackBoxDataSources] WHERE [Group] like @group ORDER BY [Name] DESC"
      InsertCommand="INSERT INTO [dbo].[BlackBoxDataSources] ([Name],[Group],[Description],[TypeID],[Template],[Datasets],[Prefix],[StatusID],[Locked],[TimeStamp]) VALUES(@name,@group,@description,@typeid,@template,@datasets,@prefix,@statusid,@locked,@timestamp)"
      UpdateCommand="UPDATE [dbo].[BlackBoxDataSources] SET [Group]=@group,[Description]=@description,[TypeID]=@typeid,[Template]=@template],[Datasets]=@datasets,[Prefix]=@prefix,[StatusID]=@statusid,[Locked]=@locked,[TimeStamp]=@timestamp WHERE [Name] = @name"
      DeleteCommand="DELETE FROM [dbo].[BlackBoxDataSources] WHERE [Name] like @name">
      <SelectParameters>
          <asp:QueryStringParameter Name="group" DefaultValue="%" />
      </SelectParameters>
      <InsertParameters>
          <asp:QueryStringParameter Name="name" />
          <asp:QueryStringParameter Name="group" />
          <asp:QueryStringParameter Name="description" />
          <asp:QueryStringParameter Name="typeid" />
          <asp:QueryStringParameter Name="template" />          	
          <asp:QueryStringParameter Name="datasets" />
          <asp:QueryStringParameter Name="prefix" />
          <asp:QueryStringParameter Name="statusid" />
          <asp:QueryStringParameter Name="locked" />          	
          <asp:QueryStringParameter Name="timestamp" />
      </InsertParameters>
      <UpdateParameters>
          <asp:QueryStringParameter Name="name" />
          <asp:QueryStringParameter Name="group" />
          <asp:QueryStringParameter Name="description" />
          <asp:QueryStringParameter Name="typeid" />
          <asp:QueryStringParameter Name="template" />          	
          <asp:QueryStringParameter Name="datasets" />
          <asp:QueryStringParameter Name="prefix" />
          <asp:QueryStringParameter Name="statusid" />
          <asp:QueryStringParameter Name="locked" />          	
          <asp:QueryStringParameter Name="timestamp" />
      </UpdateParameters>
      <DeleteParameters>
          <asp:QueryStringParameter Name="name" />
      </DeleteParameters>
   </asp:SqlDataSource>

   <asp:SqlDataSource ID="SqlBlackBoxDataSourceInstances" runat="server" 
      ConnectionString="<%$ ConnectionStrings:BlackBoxConnectionString %>" 
      SelectCommand="SELECT TOP(100) [ID],[Name],[Group],[Comment],[TypeID],[Type],[Template],[AllowedDatasets],[ReferenceID],[Source],[Datasets],[Prefix],[JOBID],[GUID],[StatusID],[Status],[Validations],[Locked],[TimeStamp],[Age] FROM [dbo].[vBlackBoxDataSourceInstances] ORDER BY [TimeStamp] DESC"
      InsertCommand="INSERT INTO [dbo].[BlackBoxDataSourceInstances] ([ID],[Name],[Group],[Comment],[TypeID],[ReferenceID],[Source],[Datasets],[Prefix],[JOBID],[GUID],[StatusID],[Validations],[Locked],[TimeStamp]) VALUES(@name,@group,@comment,@typeid,@refid,@source,@datasets,@prefix,@jobid,@guid,@statusid,@validations,@locked,@timestamp)"
      UpdateCommand="UPDATE [dbo].[BlackBoxDataSourceInstances] SET [Name]=@name,[Group]=@group,[Comment]=@comment,[TypeID]=@typeid,[ReferenceID]=@refid,[Source]=@source,[Datasets]=@datasets,[Prefix]=@prefix,[JOBID]=@jobid,[GUID]=@guid,[StatusID]=@statusid,[Validations]=@validations,[Locked]=@locked,[TimeStamp]=@timestamp WHERE [ID] = @id"
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
          <asp:QueryStringParameter Name="validations" />          	
          <asp:QueryStringParameter Name="locked" />          	
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
          <asp:QueryStringParameter Name="validations" />          	
          <asp:QueryStringParameter Name="locked" />          	
          <asp:QueryStringParameter Name="timestamp" />
      </UpdateParameters>
      <DeleteParameters>
          <asp:QueryStringParameter Name="id" />
      </DeleteParameters>
   </asp:SqlDataSource>
  
    <%--
    **** CONTENT TABS
    --%>
   
    <dx:ASPxPageControl ID="TabPagesMainPanel" Width="100%" runat="server" ActiveTabIndex="0" EnableHierarchyRecreation="true" >
        <TabPages>

           <%--
           **** DATA SOURCES TABPAGE
           --%>
                                                                                                                              
           <dx:TabPage Text="Data Sources">
              <ContentCollection>
                  <dx:ContentControl ID="MainContentControl1" runat="server">    

                  <dx:ASPxGridView ID="DataSourcesGridView" runat="server" ClientInstanceName="gridViewDataSources" DataSourceID="SqlBlackBoxDataSources" KeyFieldName="Name"                  	
                    OnRowCommand="DataSourcesGridView_RowCommand" OnSelectionChanged="DataSourcesGridView_SelectionChanged"
                    OnInitNewRow="DataSourcesGridView_InitNewRow" OnRowInserting="DataSourcesGridView_RowInserting" OnRowUpdating="DataSourcesGridView_RowUpdating" OnRowDeleting="DataSourcesGridView_RowDeleting"
                    OnCustomCallback="DataSourcesGridView_CustomCallback" OnToolbarItemClick="DataSourcesGridView_ToolbarItemClick"
                    EnableTheming="true" EnableViewState="false" AutoGenerateColumns="false" Width="95%">
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
                                <%--                                
                                <dx:GridViewToolbarItem Name="CustomInspectStaged" Text="Inspect" BeginGroup="true" />
                                <dx:GridViewToolbarItem Name="CustomRejectStaged" Text="Reject" BeginGroup="false" />
                                <dx:GridViewToolbarItem Name="CustomApproveStaged" Text="Approve" BeginGroup="false" />
                                <dx:GridViewToolbarItem Name="CustomProcessStaged" Text="Process" BeginGroup="false" />
                                <dx:GridViewToolbarItem Name="CustomArchiveStaged" Text="Archive" BeginGroup="false" />
                                --%>                                  
                            </Items>
                        </dx:GridViewToolbar>
                    </Toolbars>                     
                    <SettingsPopup>
                      <HeaderFilter MinHeight="140px"></HeaderFilter>
                    </SettingsPopup>
                    <Columns>
                          <dx:GridViewCommandColumn VisibleIndex="0" SelectAllCheckboxMode="AllPages" ShowSelectCheckbox="true" Width="50px" Visible="true" />
                          <dx:GridViewDataTextColumn FieldName="Name" VisibleIndex="1" Width="200px" Visible="true" />
                          <dx:GridViewDataTextColumn FieldName="Group" VisibleIndex="2" Width="140px" Visible="true" />
                          <dx:GridViewDataTextColumn FieldName="Description" VisibleIndex="3" Width="200px" Visible="true" />
                          <dx:GridViewDataTextColumn FieldName="TypeID" VisibleIndex="4" Width="80px" Visible="false" />
                          <dx:GridViewDataTextColumn FieldName="Type" VisibleIndex="5" Width="90px" Visible="true" />
                          <dx:GridViewDataTextColumn FieldName="Template" VisibleIndex="6" Width="260px" Visible="true" />                          	
                          <dx:GridViewDataTextColumn FieldName="Datasets" VisibleIndex="7" Width="200px" Visible="true" />
                          <dx:GridViewDataTextColumn FieldName="Prefix" VisibleIndex="8" Width="100px" Visible="true" />
                          <dx:GridViewDataTextColumn FieldName="StatusID" VisibleIndex="9" Width="80px" Visible="false" />
                          <dx:GridViewDataTextColumn FieldName="Status" VisibleIndex="10" Width="90px" Visible="true" />
                          <dx:GridViewDataTextColumn FieldName="Locked" VisibleIndex="11" Width="100px" Visible="true" />                          	
                          <dx:GridViewDataTextColumn FieldName="Icon" VisibleIndex="12" Width="200px" Visible="false" />
                          <dx:GridViewDataDateColumn FieldName="TimeStamp" VisibleIndex="13" Width="120px" Visible="true" />
                          <dx:GridViewDataTextColumn FieldName="Age" VisibleIndex="14" Width="80px" Visible="false" />                            
                      </Columns>
                      <SettingsPager PageSize="10" AlwaysShowPager="true" EllipsisMode="OutsideNumeric" EnableAdaptivity="true">
                          <PageSizeItemSettings Visible="true"></PageSizeItemSettings>
                      </SettingsPager>
                      <Settings ShowFilterBar="Auto" ShowFilterRow="false" ShowFilterRowMenu="true" ShowHeaderFilterButton="false" ShowGroupedColumns="true" ShowPreview="true" VerticalScrollBarMode="Hidden" HorizontalScrollBarMode="Auto" />
                      <SettingsResizing ColumnResizeMode="Control" />
                      <SettingsBehavior AllowClientEventsOnLoad="false" AllowSelectSingleRowOnly="true" AllowSelectByRowClick="true" AllowFocusedRow="true" EnableCustomizationWindow="true" AllowEllipsisInText="false" AllowDragDrop="true" />
                      <SettingsExport EnableClientSideExportAPI="true" ExportSelectedRowsOnly="false" />
                      <SettingsEditing Mode="PopupEditForm" EditFormColumnCount="2" />
                      <SettingsPopup>
                          <EditForm>
                              <SettingsAdaptivity MaxWidth="1000" Mode="Always" VerticalAlign="WindowCenter" />
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
                              <dx:GridViewLayoutGroup ColCount="2" GroupBoxDecoration="None">
                                  <Items>
                                      <dx:GridViewColumnLayoutItem ColumnName="Name">
                                        <Template>
                                           <dx:ASPxTextBox ID="dsNameTextBox" runat="server" Width="80%" Text='<%# Bind("Name") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>
                                      
                                      <dx:GridViewColumnLayoutItem ColumnName="Group">
                                        <Template>
                                           <dx:ASPxTextBox ID="dsGroupTextBox" runat="server" Width="80%" Text='<%# Bind("Group") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>
                            
                                      <dx:GridViewColumnLayoutItem ColumnName="Description" Caption="Description" ColumnSpan="2">
                                        <Template>
                                           <dx:ASPxTextBox ID="dsDescriptionTextBox" runat="server" Width="95%" Text='<%# Bind("Description") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>

                                      <dx:GridViewColumnLayoutItem ColumnName="TypeID" Caption="TypeID">
                                        <Template>
                                           <%--<dx:ASPxTextBox ID="dsTypeIdTextBox" runat="server" Width="50%" Text='<%# Bind("TypeID") %>' />--%>
                                           <dx:ASPxComboBox ID="dsTypeIdComboBox" runat="server" AutoPostBack="false" Width="50%" Value='<%# Bind("TypeID") %>'>
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

                                      <dx:GridViewColumnLayoutItem ColumnName="StatusID" Caption="StatusID">
                                        <Template>
                                           <%--<dx:ASPxTextBox ID="dsStatusTextBox" runat="server" Width="50%" Text='<%# Bind("StatusID") %>' />--%>
                                           <dx:ASPxComboBox ID="dsStatusIdComboBox" runat="server" AutoPostBack="false" Width="50%" Value='<%# Bind("StatusID") %>'>
                                              <Items>
                                                   <dx:ListEditItem Value=0 Text="0-Ready" />
                                                   <dx:ListEditItem Value=1 Text="1-Staged" />
                                                   <dx:ListEditItem Value=2 Text="2-Rejected" />
                                                   <dx:ListEditItem Value=3 Text="3-Approved" />
                                                   <dx:ListEditItem Value=4 Text="4-Pending" />
                                                   <dx:ListEditItem Value=5 Text="5-Processed" />
                                                   <dx:ListEditItem Value=6 Text="6-Archived" />
                                                   <dx:ListEditItem Value=7 Text="7-Other" />                                                                                                       
                                               </Items>
                                           </dx:ASPxComboBox>   
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>
                            
                                      <dx:GridViewColumnLayoutItem ColumnName="Template" Caption="Template" ColumnSpan="2">
                                        <Template>
                                           <dx:ASPxTextBox ID="dsTemplateTextBox" runat="server" Width="95%" Text='<%# Bind("Template") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>

                                      <dx:GridViewColumnLayoutItem ColumnName="Datasets" Caption="Datasets" ColumnSpan="2">
                                        <Template>
                                           <dx:ASPxTextBox ID="dsDatasetsTextBox" runat="server" Width="95%" Text='<%# Bind("Datasets") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>

                                      <dx:GridViewColumnLayoutItem ColumnName="Prefix" Caption="Prefix">
                                        <Template>
                                           <dx:ASPxTextBox ID="dsPrefixTextBox" runat="server" Width="95%" Text='<%# Bind("Prefix") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>
                      
                                      <dx:GridViewColumnLayoutItem ColumnName="Icon" Caption="Icon" ColumnSpan="1">
                                        <Template>
                                           <dx:ASPxTextBox ID="dsIconTextBox" runat="server" Width="95%" Text='<%# Bind("Icon") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>

                                      <dx:GridViewColumnLayoutItem ColumnName="Locked" Caption="Locked">
                                        <Template>
                                           <%--<dx:ASPxTextBox ID="dsLockedTextBox" runat="server" Width="30%" Text='<%# Bind("Locked") %>' />--%>
                                           <dx:ASPxComboBox ID="dsLockedComboBox" runat="server" AutoPostBack="false" Width="50%" Value='<%# Bind("Locked") %>'>
                                              <Items>
                                                   <dx:ListEditItem Value=true Text="true" />
                                                   <dx:ListEditItem Value=false Text="false" />
                                               </Items>
                                           </dx:ASPxComboBox>   
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>

                                      <dx:GridViewColumnLayoutItem ColumnName="TimeStamp" Caption="TimeStamp">
                                        <Template>
                                           <dx:ASPxTextBox ID="dsTimestampTextBox" runat="server" Width="50%" Text='<%# Bind("TimeStamp") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>

                                      <dx:EditModeCommandLayoutItem Width="100%" HorizontalAlign="Right" />                                                                                                                                
                                  </Items>
                              </dx:GridViewLayoutGroup>
                          </Items>
                      </EditFormLayoutProperties>
                      <Styles>
                          <Header BackColor="#CCCCCC" Font-Bold="true" Font-Names="Calibri" Font-Size="Small" ForeColor="#333333">
                          </Header>
                          <Row Font-Names="Calibri" Font-Size="Small">
                          </Row>
                          <FocusedRow ForeColor="Black">
                          </FocusedRow>
                      </Styles>
                      <ClientSideEvents Init="OnGridViewDataSourcesInit" SelectionChanged="OnGridViewDataSourcesSelectionChanged" FocusedRowChanged="OnGridViewDataSourcesFocusedRowChanged" 
                        ToolbarItemClick="OnGridViewDataSourcesToolbarItemClick" />
                  </dx:ASPxGridView>

                  </dx:ContentControl>
             </ContentCollection>                                    
           </dx:TabPage>
        
           <%--
           **** DATA SOURCE INSTANCES TABPAGE
           --%>

           <dx:TabPage Text="Instances" Visible="true">
              <ContentCollection>
                  <dx:ContentControl ID="MainContentControl2" runat="server">

                  <dx:ASPxGridView ID="DataSourceInstancesGridView" runat="server" ClientInstanceName="gridViewDataSourceInstances" DataSourceID="SqlBlackBoxDataSourceInstances" KeyFieldName="ID"
                    OnRowCommand="DataSourceInstancesGridView_RowCommand" OnSelectionChanged="DataSourceInstancesGridView_SelectionChanged" OnInitNewRow="DataSourceInstancesGridView_InitNewRow"
                    OnRowInserting="DataSourceInstancesGridView_RowInserting" OnRowUpdating="DataSourceInstancesGridView_RowUpdating" OnRowDeleting="DataSourceInstancesGridView_RowDeleting"
                    OnCustomCallback="DataSourceInstancesGridView_CustomCallback" OnToolbarItemClick="DataSourceInstancesGridView_ToolbarItemClick"
                    EnableTheming="true" EnableViewState="false" AutoGenerateColumns="false" Width="95%">
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
                                <dx:GridViewToolbarItem Name="CustomValidateStaged" Text="Validate" BeginGroup="true" Enabled="false" />                            
                                <dx:GridViewToolbarItem Name="CustomInspectStaged" Text="Inspect" BeginGroup="true" Enabled="false" />
                                <dx:GridViewToolbarItem Name="CustomSubmitStaged" Text="Submit" BeginGroup="false" Enabled="false" />
                                <dx:GridViewToolbarItem Name="CustomRecallStaged" Text="Recall" BeginGroup="false" Enabled="false" />                                 	 
                                <dx:GridViewToolbarItem Name="CustomRejectStaged" Text="Reject" BeginGroup="true" Enabled="false" /> 
                                <dx:GridViewToolbarItem Name="CustomApproveStaged" Text="Approve" BeginGroup="false" Enabled="false" /> 
                                <dx:GridViewToolbarItem Name="CustomProcessStaged" Text="Process" BeginGroup="true" Enabled="false" /> 
                                <dx:GridViewToolbarItem Name="CustomArchiveStaged" Text="Archive" BeginGroup="true" Enabled="false" />  
                                <dx:GridViewToolbarItem Name="CustomWithdrawStaged" Text="Withdraw" BeginGroup="false" Enabled="false" />                                	                  
                            </Items>
                        </dx:GridViewToolbar>
                    </Toolbars>                     
                    <SettingsPopup>
                      <HeaderFilter MinHeight="140px"></HeaderFilter>
                    </SettingsPopup>
                    <Columns>
                          <dx:GridViewCommandColumn VisibleIndex="0" SelectAllCheckboxMode="AllPages" ShowSelectCheckbox="true" Width="50px" Visible="true" />
                          <dx:GridViewDataTextColumn FieldName="ID" VisibleIndex="1" Width="80px" Visible="true" />     
                          <dx:GridViewDataTextColumn FieldName="Name" VisibleIndex="2" Width="150px" Visible="true" />
                          <dx:GridViewDataTextColumn FieldName="Group" VisibleIndex="3" Width="130px" Visible="true" />
                          <dx:GridViewDataTextColumn FieldName="Comment" VisibleIndex="4" Width="250px" Visible="false" />
                          <dx:GridViewDataTextColumn FieldName="TypeID" VisibleIndex="5" Width="80px" Visible="false" />
                          <dx:GridViewDataTextColumn FieldName="Type" VisibleIndex="6" Width="90px" Visible="true" />
                          <dx:GridViewDataTextColumn FieldName="AllowedDatasets" VisibleIndex="7" Width="260px" Visible="false" />
                          <dx:GridViewDataTextColumn FieldName="ReferenceID" Caption="Ref ID" VisibleIndex="8" Width="80px" Visible="true" />
                          <dx:GridViewDataTextColumn FieldName="Datasets" VisibleIndex="9" Width="300px" Visible="true" />
                          <dx:GridViewDataTextColumn FieldName="Prefix" VisibleIndex="10" Width="100px" Visible="false" />
                          <dx:GridViewDataTextColumn FieldName="JOBID" VisibleIndex="11" Width="80px" Visible="false" />
                          <dx:GridViewDataTextColumn FieldName="GUID" VisibleIndex="12" Width="150px" Visible="false" />                            
                          <dx:GridViewDataTextColumn FieldName="StatusID" VisibleIndex="13" Width="80px" Visible="false" />
                          <dx:GridViewDataTextColumn FieldName="Status" VisibleIndex="14" Width="90px" Visible="true" />
                          <dx:GridViewDataTextColumn FieldName="Validations" VisibleIndex="15" Width="200px" Visible="true" />                          	
                          <dx:GridViewDataTextColumn FieldName="Locked" VisibleIndex="16" Width="100px" Visible="false" />
                          <dx:GridViewDataTextColumn FieldName="Source" VisibleIndex="17" Width="1200px" Visible="true" />
                          <dx:GridViewDataDateColumn FieldName="TimeStamp" VisibleIndex="18" Width="120px" Visible="false" />
                          <dx:GridViewDataTextColumn FieldName="Age" VisibleIndex="19" Width="80px" Visible="false" />                            
                      </Columns>
                      <SettingsPager PageSize="10" AlwaysShowPager="true" EllipsisMode="OutsideNumeric" EnableAdaptivity="true">
                          <PageSizeItemSettings Visible="true"></PageSizeItemSettings>
                      </SettingsPager>
                      <Settings ShowFilterBar="Auto" ShowFilterRow="false" ShowFilterRowMenu="true" ShowHeaderFilterButton="false" ShowGroupedColumns="true" ShowPreview="true" VerticalScrollBarMode="Hidden" HorizontalScrollBarMode="Auto" />
                      <SettingsResizing ColumnResizeMode="Control" />
                      <SettingsBehavior AllowClientEventsOnLoad="false" AllowSelectSingleRowOnly="true" AllowSelectByRowClick="true" AllowFocusedRow="true" EnableCustomizationWindow="true" AllowEllipsisInText="false" AllowDragDrop="true" />
                      <SettingsExport EnableClientSideExportAPI="true" ExportSelectedRowsOnly="false" />
                      <SettingsEditing Mode="PopupEditForm" EditFormColumnCount="2" />
                      <SettingsPopup>
                          <EditForm>
                              <SettingsAdaptivity MaxWidth="1000" Mode="Always" VerticalAlign="WindowCenter" />
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
                              <dx:GridViewLayoutGroup ColCount="2" GroupBoxDecoration="None">
                                  <Items>
                                      <dx:GridViewColumnLayoutItem ColumnName="Name">
                                        <Template>
                                           <dx:ASPxTextBox ID="dsiNameTextBox" runat="server" Width="80%" Text='<%# Bind("Name") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>
                                      
                                      <dx:GridViewColumnLayoutItem ColumnName="Group">
                                        <Template>
                                           <dx:ASPxTextBox ID="dsiGroupTextBox" runat="server" Width="80%" Text='<%# Bind("Group") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>
                      
                                      <dx:GridViewColumnLayoutItem ColumnName="Comment" Caption="Comment" ColumnSpan="2">
                                        <Template>
                                           <dx:ASPxTextBox ID="dsiDescriptionTextBox" runat="server" Width="95%" Text='<%# Bind("Comment") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>

                                      <dx:GridViewColumnLayoutItem ColumnName="TypeID" Caption="TypeID">
                                        <Template>
                                           <%--<dx:ASPxTextBox ID="dsiTypeIdTextBox" runat="server" Width="50%" Text='<%# Bind("TypeID") %>' />--%>
                                           <dx:ASPxComboBox ID="dsiTypeIdComboBox" runat="server" AutoPostBack="false" Width="50%" Value='<%# Bind("TypeID") %>'>
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

                                      <dx:GridViewColumnLayoutItem ColumnName="StatusID" Caption="StatusID">
                                        <Template>
                                           <%--<dx:ASPxTextBox ID="dsiStatusTextBox" runat="server" Width="50%" Text='<%# Bind("StatusID") %>' />--%>
                                           <dx:ASPxComboBox ID="dsiStatusIdComboBox" runat="server" AutoPostBack="false" Width="50%" Value='<%# Bind("StatusID") %>'>
                                              <Items>
                                                   <dx:ListEditItem Value=0 Text="0-Ready" />
                                                   <dx:ListEditItem Value=1 Text="1-Staged" />
                                                   <dx:ListEditItem Value=2 Text="2-Rejected" />
                                                   <dx:ListEditItem Value=3 Text="3-Approved" />
                                                   <dx:ListEditItem Value=4 Text="4-Pending" />
                                                   <dx:ListEditItem Value=5 Text="5-Processed" />
                                                   <dx:ListEditItem Value=6 Text="6-Archived" />
                                                   <dx:ListEditItem Value=7 Text="7-Other" />                                                                                                       
                                               </Items>
                                           </dx:ASPxComboBox>   
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>
                      
                                      <dx:GridViewColumnLayoutItem ColumnName="Source" Caption="Source" ColumnSpan="2">
                                        <Template>
                                           <dx:ASPxTextBox ID="dsiSourceTextBox" runat="server" Width="95%" Text='<%# Bind("Source") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>

                                      <dx:GridViewColumnLayoutItem ColumnName="Datasets" Caption="Datasets" ColumnSpan="2">
                                        <Template>
                                           <dx:ASPxTextBox ID="dsiDatasetsTextBox" runat="server" Width="95%" Text='<%# Bind("Datasets") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>

                                      <dx:GridViewColumnLayoutItem ColumnName="Prefix" Caption="Prefix">
                                        <Template>
                                           <dx:ASPxTextBox ID="dsiPrefixTextBox" runat="server" Width="95%" Text='<%# Bind("Prefix") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>

                                      <dx:GridViewColumnLayoutItem ColumnName="Validations" Caption="Validations" ColumnSpan="2">
                                        <Template>
                                           <dx:ASPxTextBox ID="dsiValidationsTextBox" runat="server" Width="95%" Text='<%# Bind("Validations") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>

                                      <dx:GridViewColumnLayoutItem ColumnName="Locked" Caption="Locked">
                                        <Template>
                                           <%--<dx:ASPxTextBox ID="dsiLockedTextBox" runat="server" Width="30%" Text='<%# Bind("Locked") %>' />--%>
                                           <dx:ASPxComboBox ID="dsiLockedComboBox" runat="server" AutoPostBack="false" Width="50%" Value='<%# Bind("Locked") %>'>
                                              <Items>
                                                   <dx:ListEditItem Value=true Text="true" />
                                                   <dx:ListEditItem Value=false Text="false" />
                                               </Items>
                                           </dx:ASPxComboBox>   
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>

                                      <dx:GridViewColumnLayoutItem ColumnName="TimeStamp" Caption="TimeStamp">
                                        <Template>
                                           <dx:ASPxTextBox ID="dsiTimestampTextBox" runat="server" Width="50%" Text='<%# Bind("TimeStamp") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>

                                      <dx:EditModeCommandLayoutItem Width="100%" HorizontalAlign="Right" />                                                                                                                                
                                  </Items>
                              </dx:GridViewLayoutGroup>
                          </Items>
                      </EditFormLayoutProperties>
                      <Styles>
                          <Header BackColor="#CCCCCC" Font-Bold="true" Font-Names="Calibri" Font-Size="Small" ForeColor="#333333">
                          </Header>
                          <Row Font-Names="Calibri" Font-Size="Small">
                          </Row>
                          <FocusedRow ForeColor="Black">
                          </FocusedRow>
                      </Styles>
                      <ClientSideEvents Init="OnGridViewDataSourceInstancesInit" SelectionChanged="OnGridViewDataSourceInstancesSelectionChanged" FocusedRowChanged="OnGridViewDataSourceInstancesFocusedRowChanged" 
                        ToolbarItemClick="OnGridViewDataSourceInstancesToolbarItemClick" />
                  </dx:ASPxGridView>

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

   <dx:ASPxPopupControl ID="pcInspectSelect" runat="server" ClientInstanceName="pcInspectSelect" EnableViewState="false" Width="500px" HeaderText="Select Dataset to Inspect"
     PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" PopupHorizontalOffset="40" PopupVerticalOffset="40" AutoUpdatePosition="true"
     CloseAction="CloseButton" CloseOnEscape="true" AllowDragging="true" Modal="true" PopupAnimationType="Fade" >
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
                                             <dx:ASPxComboBox ID="pcDatasetComboBox" ClientInstanceName="pcDatasetComboBox" runat="server" ClientIDMode="Static" AutoPostBack="false" Width="90%" SelectedIndex="0">
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
                                 <dx:LayoutItem ShowCaption="false">
                                     <LayoutItemNestedControlCollection>
                                         <dx:LayoutItemNestedControlContainer>
                                             <dx:ASPxButton ID="pcSubmitButton" ClientInstanceName="pcSubmitButton" runat="server" Text="OK" Width="80px" AutoPostBack="false" Style="float: left; margin-right: 8px" OnClick="OnButtonPopupSubmitClick">
                                                 <ClientSideEvents Click="OnPcInspectSubmitButtonClick" />
                                             </dx:ASPxButton>
                                             <dx:ASPxButton ID="pcCancelButton" runat="server" Text="Cancel" Width="80px" AutoPostBack="false" Style="float: left; margin-right: 8px">
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
  

   <%--
   **** ADDITIONAL DATA SOURCES
   --%>

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


</asp:Content>
