<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="System.Master" CodeBehind="Datasets.aspx.cs" Inherits="BlackBox.DatasetsSystemPage" Title="BlackBox" %>

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
  // dataset functions
  // ///////////////////////

  // data sources grid toolbar functions
  function OnGridViewDatasetsToolbarItemClick(s, e) 
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
  function OnGridViewDatasetsInit(s, e) 
  {
  }
    
  function OnGridViewDatasetsSelectionChanged(s, e) 
  {
    e.processOnServer=true;
    e.usePostBack=true;
  }

  function OnGridViewDatasetsFocusedRowChanged(s, e)
  {
    var fri = gridViewDatasets.GetFocusedRowIndex();
    //gridViewDatasets.GetRowValues(fri, 'Datasets', OnGetDatasetsFocusedRowValues);
    gridViewDatasets.Refresh();    
  }

  function OnGetDatasetsFocusedRowValues(value)
  {   
    //split to array trim elements and update popup combo box
    //pcDatasetComboBox.ClearItems();
    //value.forEach(AddDatasetToPopupComboBox);
    //pcDatasetComboBox.SetSelectedIndex(0);
  }

  function AddDatasetToPopupComboBox(value)
  {   
    //var name = value.trim()
    //pcDatasetComboBox.AddItem(name);
  }

  // ////////////////////////////////
  // dataset update functions
  // ////////////////////////////////

  // data sources grid toolbar functions
  function OnGridViewDatasetUpdatesToolbarItemClick(s, e) 
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
  function OnGridViewDatasetUpdatesInit(s, e) 
  {
  }
    
  function OnGridViewDatasetUpdatesSelectionChanged(s, e) 
  {
    e.processOnServer=true;
    e.usePostBack=true;
  }

  function OnGridViewDatasetUpdatesFocusedRowChanged(s, e)
  {
    var fri = gridViewDatasetUpdates.GetFocusedRowIndex();
    //gridViewDatasetUpdates.GetRowValues(fri, 'Datasets', OnGetDatasetUpdatesFocusedRowValues);
    gridViewDatasetUpdates.Refresh();    
  }

  function OnGetDatasetUpdatesFocusedRowValues(value)
  {   
    //split to array trim elements and update popup combo box
    //pcDatasetComboBox.ClearItems();
    //value.forEach(AddDatasetToPopupComboBox);
    //pcDatasetComboBox.SetSelectedIndex(0);
  }

  function AddDatasetToPopupComboBox(value)
  {   
    //var name = value.trim()
    //pcDatasetComboBox.AddItem(name);
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

  window.OnGridViewDatasetsInit = OnGridViewDatasetsInit;
  window.OnGridViewDatasetsSelectionChanged = OnGridViewDatasetsSelectionChanged;
  window.OnGridViewDatasetsFocusedRowChanged = OnGridViewDatasetsFocusedRowChanged;
  window.OnGridViewDatasetsToolbarItemClick = OnGridViewDatasetsToolbarItemClick;    

  window.OnGridViewDatasetUpdatesInit = OnGridViewDatasetUpdatesInit;
  window.OnGridViewDatasetUpdatesSelectionChanged = OnGridViewDatasetUpdatesSelectionChanged;
  window.OnGridViewDatasetUpdatesFocusedRowChanged = OnGridViewDatasetUpdatesFocusedRowChanged;
  window.OnGridViewDatasetUpdatesToolbarItemClick = OnGridViewDatasetUpdatesToolbarItemClick;    
 
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
                           <dx:ASPxLabel ID="BreadcrumbsLabel" ClientIDMode="Static" runat="server" Text="Datasets" Font-Bold="True" Font-Size="Large" Width="300px" />
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
                      CssClass="grid-view" Width="95%"
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
                                  <dx:GridViewToolbarItem Command="Refresh"/>
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
    <%--
    **** CONTENT PANEL DATA SOURCES
    --%>    
  
   <asp:SqlDataSource ID="SqlBlackBoxDatasets" runat="server" 
      ConnectionString="<%$ ConnectionStrings:BlackBoxConnectionString %>"     
      SelectCommand="SELECT [Name],[Group],[TableName],[Flags],[Description],[StatusID],[Status],[Icon],[TimeStamp],[Age],[Rank] FROM [dbo].[vBlackBoxDatasets] ORDER BY [TimeStamp] DESC, [Name] DESC"
      InsertCommand="INSERT INTO [dbo].[BlackBoxDatasets] ([Name],[Group],[TableName],[Flags],[Description],[StatusID],[Locked],[TimeStamp]) VALUES(@name,@group,@tablename,@flags,@comment,@jobid,@guid,@dsiid,@source,@rows,@statusid,@timestamp)"
      UpdateCommand="UPDATE [dbo].[BlackBoxDatasets] SET [Name]=@name,[Group]=@group,[TableName]=@tablename,[Flags]=@flags,[Description]=@description,[StatusID]=@sid,[Locked]=@locked,[TimeStamp]=@timestamp WHERE [Name] = @name"
      DeleteCommand="DELETE FROM [dbo].[BlackBoxDatasets] WHERE [Name] = @name">
      <InsertParameters>
          <asp:QueryStringParameter Name="name" />
          <asp:QueryStringParameter Name="group" />
          <asp:QueryStringParameter Name="tablename" />
          <asp:QueryStringParameter Name="flags" />
          <asp:QueryStringParameter Name="description" />
          <asp:QueryStringParameter Name="sid" />
          <asp:QueryStringParameter Name="locked" />
          <asp:QueryStringParameter Name="timestamp" />
      </InsertParameters>
      <UpdateParameters>
          <asp:QueryStringParameter Name="name" />
          <asp:QueryStringParameter Name="group" />
          <asp:QueryStringParameter Name="tablename" />
          <asp:QueryStringParameter Name="flags" />
          <asp:QueryStringParameter Name="description" />
          <asp:QueryStringParameter Name="sid" />
          <asp:QueryStringParameter Name="locked" />
          <asp:QueryStringParameter Name="timestamp" />
      </UpdateParameters>
      <DeleteParameters>
          <asp:QueryStringParameter Name="name" />
      </DeleteParameters>
   </asp:SqlDataSource>
  
   <asp:SqlDataSource ID="SqlBlackBoxDatasetUpdates" runat="server" 
      ConnectionString="<%$ ConnectionStrings:BlackBoxConnectionString %>" 
      SelectCommand="SELECT [ID],[Name],[Group],[TableName],[Flags],[Comment],[JOBID],[GUID],[DataSourceInstanceID],[DataSource],[Sheet],[Rows],[StatusID],[Status],[TimeStamp],[Age],[Rank] FROM [dbo].[vBlackBoxDatasetUpdates] ORDER BY [TimeStamp] DESC, [ID] DESC"
      InsertCommand="INSERT INTO [dbo].[BlackBoxDatasetUpdates] ([Name],[Group],[TableName],[Flags],[Comment],[JOBID],[GUID],[DataSourceInstanceID],[DataSource],[Sheet],[Rows],[StatusID],[TimeStamp]) VALUES(@name,@group,@tablename,@flags,@comment,@jobid,@guid,@dsiid,@source,@sheet,@rows,@statusid,@timestamp)"
      UpdateCommand="UPDATE [dbo].[BlackBoxDatasetUpdates] SET [Name]=@name,[Group]=@group,[TableName]=@tablename,[Flags]=@flags,[Comment]=@comment,[JOBID]=@jobid,[GUID]=@guid,[DataSourceInstanceID]=@dsiid,[DataSource]=@source,[Sheet]=@sheet,[Rows]=@rows,[StatusID]=@statusid,[TimeStamp]=@timestamp WHERE [ID] = @id"
      DeleteCommand="DELETE FROM [dbo].[BlackBoxDatasetUpdates] WHERE ID = @id">
      <InsertParameters>
          <asp:QueryStringParameter Name="id" />
          <asp:QueryStringParameter Name="name" />
          <asp:QueryStringParameter Name="group" />
          <asp:QueryStringParameter Name="tablename" />
          <asp:QueryStringParameter Name="flags" />
          <asp:QueryStringParameter Name="comment" />
          <asp:QueryStringParameter Name="jobid" />
          <asp:QueryStringParameter Name="guid" />
          <asp:QueryStringParameter Name="dsiid" />
          <asp:QueryStringParameter Name="source" />
          <asp:QueryStringParameter Name="sheet" />          	
          <asp:QueryStringParameter Name="rows" />
          <asp:QueryStringParameter Name="sid" />
          <asp:QueryStringParameter Name="timestamp" />
      </InsertParameters>
      <UpdateParameters>
          <asp:QueryStringParameter Name="id" />
          <asp:QueryStringParameter Name="name" />
          <asp:QueryStringParameter Name="group" />
          <asp:QueryStringParameter Name="tablename" />
          <asp:QueryStringParameter Name="flags" />
          <asp:QueryStringParameter Name="comment" />
          <asp:QueryStringParameter Name="jobid" />
          <asp:QueryStringParameter Name="guid" />
          <asp:QueryStringParameter Name="dsiid" />
          <asp:QueryStringParameter Name="source" />
          <asp:QueryStringParameter Name="sheet" />          	
          <asp:QueryStringParameter Name="rows" />
          <asp:QueryStringParameter Name="sid" />
          <asp:QueryStringParameter Name="timestamp" />
      </UpdateParameters>
      <DeleteParameters>
          <asp:QueryStringParameter Name="id" />
      </DeleteParameters>
   </asp:SqlDataSource>
  
    <%--
    **** CONTENT TABS
    --%>
   
    <dx:ASPxPageControl ID="TabPagesMainPanel" Width="100%" runat="server" ActiveTabIndex="0" EnableHierarchyRecreation="True" >
        <TabPages>

           <%--
           **** DATA SOURCES TABPAGE
           --%>
                                                                                                                              
           <dx:TabPage Text="Datasets">
              <ContentCollection>
                  <dx:ContentControl ID="MainContentControl1" runat="server">    

                  <dx:ASPxGridView ID="DatasetsGridView" runat="server" ClientInstanceName="gridViewDatasets" DataSourceID="SqlBlackBoxDatasets" KeyFieldName="Name"                  	
                    OnRowCommand="DatasetsGridView_RowCommand" OnSelectionChanged="DatasetsGridView_SelectionChanged"
                    OnInitNewRow="DatasetsGridView_InitNewRow" OnRowInserting="DatasetsGridView_RowInserting" OnRowUpdating="DatasetsGridView_RowUpdating" OnRowDeleting="DatasetsGridView_RowDeleting"
                    OnCustomCallback="DatasetsGridView_CustomCallback" OnToolbarItemClick="DatasetsGridView_ToolbarItemClick"
                    EnableTheming="True" EnableViewState="False" AutoGenerateColumns="False" Width="95%">
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
                          <dx:GridViewDataTextColumn FieldName="Name" VisibleIndex="1" Width="250px" Visible="true" />
                          <dx:GridViewDataTextColumn FieldName="Group" VisibleIndex="2" Width="150px" Visible="true" />
                          <dx:GridViewDataTextColumn FieldName="TableName" VisibleIndex="3" Width="150px" Visible="true" />
                          <dx:GridViewDataTextColumn FieldName="Flags" VisibleIndex="4" Width="150px" Visible="true" />
                          <dx:GridViewDataTextColumn FieldName="Description" VisibleIndex="5" Width="250px" Visible="true" />                          	
                          <dx:GridViewDataTextColumn FieldName="StatusID" VisibleIndex="6" Width="80px" Visible="false" />
                          <dx:GridViewDataTextColumn FieldName="Status" VisibleIndex="7" Width="90px" Visible="true" />
                          <dx:GridViewDataTextColumn FieldName="Icon" VisibleIndex="8" Width="200px" Visible="false" />
                          <dx:GridViewDataDateColumn FieldName="TimeStamp" VisibleIndex="9" Width="120px" Visible="true" />
                          <dx:GridViewDataTextColumn FieldName="Age" VisibleIndex="10" Width="80px" Visible="false" />
                          <dx:GridViewDataTextColumn FieldName="Rank" VisibleIndex="11" Width="80px" Visible="false" />
                      </Columns>
                      <SettingsPager PageSize="10" AlwaysShowPager="True" EllipsisMode="OutsideNumeric" EnableAdaptivity="True">
                          <PageSizeItemSettings Visible="True"></PageSizeItemSettings>
                      </SettingsPager>
                      <Settings ShowFilterBar="Auto" ShowFilterRow="False" ShowFilterRowMenu="True" ShowHeaderFilterButton="False" ShowGroupedColumns="True" ShowPreview="True" VerticalScrollBarMode="Hidden" HorizontalScrollBarMode="Auto" />
                      <SettingsResizing ColumnResizeMode="Control" />
                      <SettingsBehavior AllowClientEventsOnLoad="False" AllowSelectSingleRowOnly="True" AllowSelectByRowClick="True" AllowFocusedRow="True" EnableCustomizationWindow="True" AllowEllipsisInText="False" AllowDragDrop="True" />
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

                                      <dx:GridViewColumnLayoutItem ColumnName="TableName">
                                        <Template>
                                           <dx:ASPxTextBox ID="dsTableNameTextBox" runat="server" Width="80%" Text='<%# Bind("TableName") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>
                                      
                                      <dx:GridViewColumnLayoutItem ColumnName="Flags">
                                        <Template>
                                           <dx:ASPxTextBox ID="dsFlagsTextBox" runat="server" Width="80%" Text='<%# Bind("Flags") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>
                            
                                      <dx:GridViewColumnLayoutItem ColumnName="Description" Caption="Descriptiont" ColumnSpan="2">
                                        <Template>
                                           <dx:ASPxTextBox ID="dsDescriptionTextBox" runat="server" Width="95%" Text='<%# Bind("Description") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>

                                      <dx:GridViewColumnLayoutItem ColumnName="StatusID" Caption="StatusID">
                                        <Template>
                                           <%--<dx:ASPxTextBox ID="dsStatusTextBox" runat="server" Width="50%" Text='<%# Bind("StatusID") %>' />--%>
                                           <dx:ASPxComboBox ID="dsStatusIdComboBox" runat="server" AutoPostBack="False" Width="50%" Value='<%# Bind("StatusID") %>'>
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
                      
                                      <dx:GridViewColumnLayoutItem ColumnName="Icon" Caption="Icon" ColumnSpan="1">
                                        <Template>
                                           <dx:ASPxTextBox ID="dsIconTextBox" runat="server" Width="95%" Text='<%# Bind("Icon") %>' />
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
                          <Header BackColor="#CCCCCC" Font-Bold="True" Font-Names="Calibri" Font-Size="Small" ForeColor="#333333">
                          </Header>
                          <Row Font-Names="Calibri" Font-Size="Small">
                          </Row>
                          <FocusedRow ForeColor="Black">
                          </FocusedRow>
                      </Styles>
                      <ClientSideEvents Init="OnGridViewDatasetsInit" SelectionChanged="OnGridViewDatasetsSelectionChanged" FocusedRowChanged="OnGridViewDatasetsFocusedRowChanged" 
                        ToolbarItemClick="OnGridViewDatasetsToolbarItemClick" />
                  </dx:ASPxGridView>

                  </dx:ContentControl>
             </ContentCollection>                                    
           </dx:TabPage>
        
           <%--
           **** DATA SOURCE INSTANCES TABPAGE
           --%>

           <dx:TabPage Text="Updates" Visible="true">
              <ContentCollection>
                  <dx:ContentControl ID="MainContentControl2" runat="server">

                  <dx:ASPxGridView ID="DatasetUpdatesGridView" runat="server" ClientInstanceName="gridViewDatasetUpdates" DataSourceID="SqlBlackBoxDatasetUpdates" KeyFieldName="ID"
                    OnRowCommand="DatasetUpdatesGridView_RowCommand" OnSelectionChanged="DatasetUpdatesGridView_SelectionChanged"
                    OnInitNewRow="DatasetUpdatesGridView_InitNewRow" OnRowInserting="DatasetUpdatesGridView_RowInserting" OnRowUpdating="DatasetUpdatesGridView_RowUpdating" OnRowDeleting="DatasetUpdatesGridView_RowDeleting"
                    OnCustomCallback="DatasetUpdatesGridView_CustomCallback" OnToolbarItemClick="DatasetUpdatesGridView_ToolbarItemClick"
                    EnableTheming="True" EnableViewState="False" AutoGenerateColumns="False" Width="95%">
                    <Toolbars>
                        <dx:GridViewToolbar>
                            <SettingsAdaptivity Enabled="true" EnableCollapseRootItemsToIcons="true" />
                            <Items>
                                <dx:GridViewToolbarItem Command="Refresh" />
                                <dx:GridViewToolbarItem Command="New" BeginGroup="true" AdaptivePriority="3" Visible="false"/>
                                <dx:GridViewToolbarItem Command="Edit"  Visible="false"/>
                                <dx:GridViewToolbarItem Command="Delete"  Visible="false"/>                  	
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
                          <dx:GridViewDataTextColumn FieldName="ID" VisibleIndex="1" Width="80px" Visible="true" />
                          <dx:GridViewDataTextColumn FieldName="Name" VisibleIndex="2" Width="150px" Visible="true" />
                          <dx:GridViewDataTextColumn FieldName="Group" VisibleIndex="3" Width="150px" Visible="true" />
                          <dx:GridViewDataTextColumn FieldName="TableName" VisibleIndex="4" Width="150px" Visible="true" />
                          <dx:GridViewDataTextColumn FieldName="Flags" VisibleIndex="5" Width="150px" Visible="true" />
                          <dx:GridViewDataTextColumn FieldName="Comment" VisibleIndex="6" Width="250px" Visible="false" />
                          <dx:GridViewDataTextColumn FieldName="JOBID" VisibleIndex="7" Width="80px" Visible="true" />
                          <dx:GridViewDataTextColumn FieldName="GUID" VisibleIndex="8" Width="150px" Visible="false" />       
                          <dx:GridViewDataTextColumn FieldName="DataSourceInstanceID" Caption="DSIID" VisibleIndex="9" Width="80px" Visible="true" />
                          <dx:GridViewDataTextColumn FieldName="DataSource" VisibleIndex="10" Width="160px" Visible="true" />
                          <dx:GridViewDataTextColumn FieldName="Sheet" VisibleIndex="11" Width="100px" Visible="true" />                          	
                          <dx:GridViewDataTextColumn FieldName="Rows" VisibleIndex="12" Width="100px" Visible="true" />                          	
                          <dx:GridViewDataTextColumn FieldName="StatusID" VisibleIndex="13" Width="80px" Visible="false" />
                          <dx:GridViewDataTextColumn FieldName="Status" VisibleIndex="14" Width="90px" Visible="true" />
                          <dx:GridViewDataDateColumn FieldName="TimeStamp" VisibleIndex="15" Width="120px" Visible="true" />
                          <dx:GridViewDataTextColumn FieldName="Age" VisibleIndex="16" Width="80px" Visible="false" />
                          <dx:GridViewDataTextColumn FieldName="Rank" VisibleIndex="17" Width="80px" Visible="false" />
                      </Columns>
                      <SettingsPager PageSize="10" AlwaysShowPager="True" EllipsisMode="OutsideNumeric" EnableAdaptivity="True">
                          <PageSizeItemSettings Visible="True"></PageSizeItemSettings>
                      </SettingsPager>
                      <Settings ShowFilterBar="Auto" ShowFilterRow="False" ShowFilterRowMenu="True" ShowHeaderFilterButton="False" ShowGroupedColumns="True" ShowPreview="True" VerticalScrollBarMode="Hidden" HorizontalScrollBarMode="Auto" />
                      <SettingsResizing ColumnResizeMode="Control" />
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
                                      <dx:GridViewColumnLayoutItem ColumnName="Name">
                                        <Template>
                                           <dx:ASPxTextBox ID="dsuNameTextBox" runat="server" Width="80%" Text='<%# Bind("Name") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>
                                      
                                      <dx:GridViewColumnLayoutItem ColumnName="Group">
                                        <Template>
                                           <dx:ASPxTextBox ID="dsuGroupTextBox" runat="server" Width="80%" Text='<%# Bind("Group") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>

                                      <dx:GridViewColumnLayoutItem ColumnName="TableName">
                                        <Template>
                                           <dx:ASPxTextBox ID="dsuTableNameTextBox" runat="server" Width="80%" Text='<%# Bind("TableName") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>
                                      
                                      <dx:GridViewColumnLayoutItem ColumnName="Flags">
                                        <Template>
                                           <dx:ASPxTextBox ID="dsuFlagsTextBox" runat="server" Width="80%" Text='<%# Bind("Flags") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>
                      
                                      <dx:GridViewColumnLayoutItem ColumnName="Comment" Caption="Comment" ColumnSpan="2">
                                        <Template>
                                           <dx:ASPxTextBox ID="dsuDescriptionTextBox" runat="server" Width="95%" Text='<%# Bind("Comment") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>
                      
                                      <dx:GridViewColumnLayoutItem ColumnName="JobID" Caption="JobID" ColumnSpan="1">
                                        <Template>
                                           <dx:ASPxTextBox ID="dsuJobTextBox" runat="server" Width="95%" Text='<%# Bind("JobID") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>
                      
                                      <dx:GridViewColumnLayoutItem ColumnName="GUID" Caption="GUID" ColumnSpan="1">
                                        <Template>
                                           <dx:ASPxTextBox ID="dsuGUIDTextBox" runat="server" Width="95%" Text='<%# Bind("GUID") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>

                                      <dx:GridViewColumnLayoutItem ColumnName="DataSourceInstanceID" Caption="DSIID" ColumnSpan="1">
                                        <Template>
                                           <dx:ASPxTextBox ID="dsuDataSourceInstanceIDTextBox" runat="server" Width="95%" Text='<%# Bind("DataSourceInstanceID") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>

                                      <dx:GridViewColumnLayoutItem ColumnName="DataSource" Caption="DataSource" ColumnSpan="2">
                                        <Template>
                                           <dx:ASPxTextBox ID="dsuDataSourceTextBox" runat="server" Width="95%" Text='<%# Bind("DataSource") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>

                                      <dx:GridViewColumnLayoutItem ColumnName="Sheet" Caption="Sheet" ColumnSpan="1">
                                        <Template>
                                           <dx:ASPxTextBox ID="dsuSheetTextBox" runat="server" Width="95%" Text='<%# Bind("Sheet") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>

                                      <dx:GridViewColumnLayoutItem ColumnName="StatusID" Caption="StatusID">
                                        <Template>
                                           <%--<dx:ASPxTextBox ID="dsuStatusTextBox" runat="server" Width="50%" Text='<%# Bind("StatusID") %>' />--%>
                                           <dx:ASPxComboBox ID="dsuStatusIdComboBox" runat="server" AutoPostBack="False" Width="50%" Value='<%# Bind("StatusID") %>'>
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

                                      <dx:GridViewColumnLayoutItem ColumnName="Rows" Caption="Rows">
                                        <Template>
                                           <dx:ASPxTextBox ID="dsuRowsTextBox" runat="server" Width="95%" Text='<%# Bind("Rows") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>

                                      <dx:GridViewColumnLayoutItem ColumnName="TimeStamp" Caption="TimeStamp">
                                        <Template>
                                           <dx:ASPxTextBox ID="dsuTimestampTextBox" runat="server" Width="50%" Text='<%# Bind("TimeStamp") %>' />
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
                      <ClientSideEvents Init="OnGridViewDatasetUpdatesInit" SelectionChanged="OnGridViewDatasetUpdatesSelectionChanged" FocusedRowChanged="OnGridViewDatasetUpdatesFocusedRowChanged" 
                        ToolbarItemClick="OnGridViewDatasetUpdatesToolbarItemClick" />
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
