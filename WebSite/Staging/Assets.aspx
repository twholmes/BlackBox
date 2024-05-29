<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="Staging.Master" CodeBehind="Assets.aspx.cs" Inherits="BlackBox.InspectAssetsSupportPage" Title="BlackBox" %>

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

  // page toolbar
  function updateToolbarButtonsState() 
  {
    var enabled = cardView.GetSelectedCardCount() > 0;
    //pageToolbar.GetItemByName("Delete").SetEnabled(enabled);
    //pageToolbar.GetItemByName("Edit").SetEnabled(cardView.GetFocusedRowIndex() !== -1);
  }

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
 
 
  // ///////////////////////
  // popup functions
  // ///////////////////////

  // show the popup
  function ShowModalInspectPopup() 
  {
    //var source = dataSourceComboBox.GetText();
    //pcDatasetComboBox.SetText(source);    
    
    pcInspectSelect.Show();
    //gridViewDatasetFiles.Refresh();
    //gridViewDataSources.Refresh();

    //pcDatasetComboBox.Focus();
  }
 
  // popup submit button click
  function OnPcInspectSubmitButtonClick(s, e) 
  {
  	var dataset = pcDatasetComboBox.GetText();
    pcInspectSelect.Hide();
    openUrlFromPage("Assets.aspx", true);    
  }

  // ///////////////////////
  // dataset grid functions
  // ///////////////////////

  // dataset grid toolbar functions  
  function OnGridViewDatasetToolbarItemClick(s, e) 
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

  // dataset gridview functions
  function OnGridViewDatasetInit(s, e) 
  {
  }
    
  function OnGridViewDatasetSelectionChanged(s, e) 
  {
    e.processOnServer=true;
    e.usePostBack=true;
  }
  
  function OnGridViewDatasetFocusedRowChanged(s, e)
  {
    var fri = gridViewDataset.GetFocusedRowIndex();
    gridViewDataset.GetRowValues(fri, 'Location;Datasets', OnGetDatasetFocusedRowValues);
    gridViewDataset.Refresh();    
  }

  function OnGetDatasetFocusedRowValues(values)
  {
  	var location = values[0];
  	var datasets = values[1];
  	
    //split to array trim elements and update popup combo box
    var datasets = datasets.split(",") 
  	pcDatasetComboBox.ClearItems();
    datasets.forEach(AddDatasetToPopupBomboBox);
    pcDatasetComboBox.SetSelectedIndex(0);
  }

  function AddDatasetToPopupBomboBox(value)
  {  	
  	var name = value.trim()
  	pcDatasetComboBox.AddItem(name);
  }
 
  // ///////////////////////
  // merged grid functions
  // ///////////////////////

  // merged grid toolbar functions  
  function OnGridViewMergedToolbarItemClick(s, e) 
  {
    if (IsCustomGridViewToolbarCommand(e.item.name)) 
    {
      e.processOnServer=true;
      e.usePostBack=true;
    }
  }

  // merged gridview functions
  function OnGridViewMergedInit(s, e) 
  {
  }
    
  function OnGridViewMergedSelectionChanged(s, e) 
  {
    e.processOnServer=true;
    e.usePostBack=true;
  }
  
  function OnGridViewMergedFocusedRowChanged(s, e)
  {
    var fri = gridViewMerged.GetFocusedRowIndex();
    gridViewMerged.GetRowValues(fri, 'Location;Datasets', OnGetMergedFocusedRowValues);
    gridViewMerged.Refresh();    
  }

  function OnGetMergedFocusedRowValues(values)
  {
  	var location = values[0];
  	var datasets = values[1];
  	
    //split to array trim elements and update popup combo box
    var datasets = datasets.split(",") 
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

  window.OnPcInspectSubmitButtonClick = OnPcInspectSubmitButtonClick;

  window.OnGridViewDatasetInit = OnGridViewDatasetInit;
  window.OnGridViewDatasetSelectionChanged = OnGridViewDatasetSelectionChanged;
  window.OnGridViewDatasetFocusedRowChanged = OnGridViewDatasetFocusedRowChanged;  
  window.OnGridViewDatasetToolbarItemClick = OnGridViewDatasetToolbarItemClick;    

  window.OnGridViewMergedInit = OnGridViewMergedInit;
  window.OnGridViewMergedSelectionChanged = OnGridViewMergedSelectionChanged;
  window.OnGridViewMergedFocusedRowChanged = OnGridViewMergedFocusedRowChanged;  
  window.OnGridViewMergedToolbarItemClick = OnGridViewMergedToolbarItemClick;    

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
                           <dx:ASPxHyperLink ID="TopHelpHyperLink" runat="server" NavigateUrl="~/Default.aspx" Text="Staging" Font-Bold="True" Font-Size="Large" Border-BorderStyle="None" Border-BorderWidth="8px" />
                           <dx:ASPxLabel ID="ASPxLabel1" runat="server" Text=">"></dx:ASPxLabel>
                           <dx:ASPxLabel ID="TopSubHeaderLabel" runat="server" Text="Inspect Assets" Font-Bold="True" Font-Size="Large" Width="190px" />
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
          <dx:MenuItem Name="PageMenuUploads" Text="Uploads" NavigateUrl="~/Staging/Uploads.aspx" Alignment="Right" AdaptivePriority="2">
               <Image IconID="snap_datasource_svg_dark_16x16" />
          </dx:MenuItem>
          <dx:MenuItem Name="PageMenuDataSources" Text="Data Sources" NavigateUrl="~/Staging/DataSources.aspx" Alignment="Right" AdaptivePriority="3">
               <Image IconID="dashboards_updatedataextract_svg_dark_16x16" />
          </dx:MenuItem>
          <dx:MenuItem Name="PageMenuDatasets" Text="Datasets" NavigateUrl="~/Staging/DataSources.aspx" Alignment="Right" AdaptivePriority="4">
               <Image IconID="spreadsheet_changedatasourcepivottable_svg_dark_16x16" />
          </dx:MenuItem>
          
          <%--
          <dx:MenuItem Name="PageMenuFlexera" Text="Flexera" Alignment="Right" AdaptivePriority="5">
              <Image IconID="setup_properties_svg_dark_16x16" />
          </dx:MenuItem>
          --%>
              
          <dx:MenuItem Alignment="Right" AdaptivePriority="5">  
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
  
  
   <asp:SqlDataSource ID="SqlBlackBoxDataset" runat="server" 
     ConnectionString="<%$ ConnectionStrings:BlackBoxConnectionString %>" 
     
     SelectCommand="SELECT [ID],[ImportID],[DataSourceInstanceID],[Exclude],[FlexeraID]
         ,[AssetName],[AssetType],[SerialNo],[AssetTag],[ManufacturerName],[ModelNo],[AssetStatus],[ManufacturerPartNo],[Location],[BusinessUnit],[CostCenter],[Category]
         ,[AssignToUser],[AcquisitionMode],[ContractNo],[InventoryDatePhysical],[InventoriedByPhysical],[DeliveryDate],[InstallationDate],[RetirementDate],[DisposalDate],[Comments]
         ,[InventoriedByElectronic],[CurrencyCode],[CurrencyDate],[CurrencySnapshotName],[CurrencyRate],[LeaseNo],[LeaseAgreement],[LeaseStartDate],[LeaseEndDate],[LeaseTerminationDate],[LeaseTerminationReason]
         ,[LeasePrice],[LeasePeriodicPayment],[LeasePeriodType],[LeaseBuyoutCost],[WarrantyType],[WarrantyEndDate],[ChargesAmount],[ChargesFrequency],[EndOfLifeRecipient],[RetirementReason],[ResalePrice]
         ,[DepreciationCurrentValue],[DepreciationResidualValue],[DepreciationMethod],[DepreciationPeriod],[DepreciationRate],[WrittenOffValue]
         FROM [dbo].[itamAssets]"
          
     UpdateCommand="UPDATE [dbo].[itamAssets] SET [ImportID]=@ImportID,[DataSourceInstanceID]=@DataSourceInstanceID,[Exclude]=@Exclude,[FlexeraID]=@FlexeraID
         ,[AssetName]=@AssetName,[AssetType]=@AssetType,[SerialNo]=@SerialNo,[AssetTag]=@AssetTag,[ManufacturerName]=@ManufacturerName,[ModelNo]=@ModelNo,[AssetStatus]=@AssetStatus
         ,[ManufacturerPartNo]=@ManufacturerPartNo,[Location]=@Location,[BusinessUnit]=@BusinessUnit,[CostCenter]=CostCenter,[Category]=@Category
         ,[AssignToUser]=@AssignToUser,[AcquisitionMode]=@AcquisitionMode,[ContractNo]=@ContractNo,[InventoryDatePhysical]=@InventoryDatePhysical,[InventoriedByPhysical]=@InventoriedByPhysical
         ,[DeliveryDate]=@DeliveryDate,[InstallationDate]=@InstallationDate,[RetirementDate]=@RetirementDate,[DisposalDate]=@DisposalDate,[Comments]=@Comments
         ,[InventoriedByElectronic]=@InventoriedByElectronic,[CurrencyCode]=@CurrencyCode,[CurrencyDate]=@CurrencyDate,[CurrencySnapshotName]=@CurrencySnapshotName,[CurrencyRate]=@CurrencyRate,[LeaseNo]=@LeaseNo
         ,[LeaseAgreement]=@LeaseAgreement,[LeaseStartDate]=@LeaseStartDate,[LeaseEndDate]=@LeaseEndDate,[LeaseTerminationDate]=@LeaseTerminationDate,[LeaseTerminationReason]=@LeaseTerminationReason
         ,[LeasePrice]=@LeasePrice,[LeasePeriodicPayment]=@LeasePeriodicPayment,[LeasePeriodType]=@LeasePeriodType,[LeaseBuyoutCost]=@LeaseBuyoutCost,[WarrantyType]=@WarrantyType,[WarrantyEndDate]=@WarrantyEndDate
         ,[ChargesAmount]=@ChargesAmount,[ChargesFrequency]=@ChargesFrequency,[EndOfLifeRecipient]=@EndOfLifeRecipient,[RetirementReason]=@RetirementReason,[ResalePrice]=@ResalePrice
         ,[DepreciationCurrentValue]=@DepreciationCurrentValue,[DepreciationResidualValue]=@DepreciationResidualValue,[DepreciationMethod]=@DepreciationMethod,[DepreciationPeriod]=@DepreciationPeriod
         ,[DepreciationRate]=@DepreciationRate,[WrittenOffValue]=@WrittenOffValue
         WHERE [ID]=@ID"
     
     DeleteCommand="DELETE FROM [itamAssets] WHERE [ID] = @ID">
     
     <UpdateParameters>
         <asp:FormParameter FormField="ID" Name="ID" />     	
         <asp:FormParameter FormField="ImportID" Name="ImportID" />
         <asp:FormParameter FormField="DataSourceInstanceID" Name="DataSourceInstanceID" />
         <asp:FormParameter FormField="Exclude" Name="Exclude" />
         <asp:FormParameter FormField="FlexeraID" Name="FlexeraID" />
         <asp:FormParameter FormField="AssetName" Name="AssetName" />
         <asp:FormParameter FormField="AssetType" Name="AssetType" />
         <asp:FormParameter FormField="SerialNo" Name="SerialNo" />
         <asp:FormParameter FormField="AssetTag" Name="AssetTag" />
         <asp:FormParameter FormField="ManufacturerName" Name="ManufacturerName" />
         <asp:FormParameter FormField="ModelNo" Name="ModelNo" />
         <asp:FormParameter FormField="AssetStatus" Name="AssetStatus" />
         <asp:FormParameter FormField="ManufacturerPartNo" Name="ManufacturerPartNo" />
         <asp:FormParameter FormField="Location" Name="Location" />
         <asp:FormParameter FormField="BusinessUnit" Name="BusinessUnit" />
         <asp:FormParameter FormField="CostCenter" Name="CostCenter" />
         <asp:FormParameter FormField="Category" Name="Category" />
         <asp:FormParameter FormField="AssignToUser" Name="AssignToUser" />
         <asp:FormParameter FormField="AcquisitionMode" Name="AcquisitionMode" />
         <asp:FormParameter FormField="ContractNo" Name="ContractNo" />
         <asp:FormParameter FormField="InventoryDatePhysical" Name="InventoryDatePhysical" />
         <asp:FormParameter FormField="InventoriedByPhysical" Name="InventoriedByPhysical" />
         <asp:FormParameter FormField="DeliveryDate" Name="DeliveryDate" />
         <asp:FormParameter FormField="InstallationDate" Name="InstallationDate" />
         <asp:FormParameter FormField="RetirementDate" Name="RetirementDate" />
         <asp:FormParameter FormField="DisposalDate" Name="DisposalDate" />
         <asp:FormParameter FormField="Comments" Name="Comments" />
         <asp:FormParameter FormField="InventoriedByElectronic" Name="InventoriedByElectronic" />
         <asp:FormParameter FormField="CurrencyCode" Name="CurrencyCode" />
         <asp:FormParameter FormField="CurrencyDate" Name="CurrencyDate" />
         <asp:FormParameter FormField="CurrencySnapshotName" Name="CurrencySnapshotName" />
         <asp:FormParameter FormField="CurrencyRate" Name="CurrencyRate" />
         <asp:FormParameter FormField="LeaseNo" Name="LeaseNo" />
         <asp:FormParameter FormField="LeaseAgreement" Name="LeaseAgreement" />
         <asp:FormParameter FormField="LeaseStartDate" Name="LeaseStartDate" />
         <asp:FormParameter FormField="LeaseEndDate" Name="LeaseEndDate" />
         <asp:FormParameter FormField="LeaseTerminationDate" Name="LeaseTerminationDate" />
         <asp:FormParameter FormField="LeaseTerminationReason" Name="LeaseTerminationReason" />
         <asp:FormParameter FormField="LeasePrice" Name="LeasePrice" />
         <asp:FormParameter FormField="LeasePeriodicPayment" Name="LeasePeriodicPayment" />
         <asp:FormParameter FormField="LeasePeriodType" Name="LeasePeriodType" />
         <asp:FormParameter FormField="LeaseBuyoutCost" Name="LeaseBuyoutCost" />
         <asp:FormParameter FormField="WarrantyType" Name="WarrantyType" />
         <asp:FormParameter FormField="WarrantyEndDate" Name="WarrantyEndDate" />
         <asp:FormParameter FormField="ChargesAmount" Name="ChargesAmount" />
         <asp:FormParameter FormField="ChargesFrequency" Name="ChargesFrequency" />
         <asp:FormParameter FormField="EndOfLifeRecipient" Name="EndOfLifeRecipient" />
         <asp:FormParameter FormField="RetirementReason" Name="RetirementReason" />
         <asp:FormParameter FormField="ResalePrice" Name="ResalePrice" />
         <asp:FormParameter FormField="DepreciationCurrentValue" Name="DepreciationCurrentValue" />
         <asp:FormParameter FormField="DepreciationResidualValue" Name="DepreciationResidualValue" />
         <asp:FormParameter FormField="DepreciationMethod" Name="DepreciationMethod" />
         <asp:FormParameter FormField="DepreciationPeriod" Name="DepreciationPeriod" />
         <asp:FormParameter FormField="DepreciationRate" Name="DepreciationRate" />
         <asp:FormParameter FormField="WrittenOffValue" Name="WrittenOffValue" />
     </UpdateParameters>  
     
     <DeleteParameters>
        <asp:QueryStringParameter Name="ID" />
     </DeleteParameters>
   </asp:SqlDataSource>
  
   <asp:SqlDataSource ID="SqlBlackBoxMerged" runat="server" 
     ConnectionString="<%$ ConnectionStrings:BlackBoxConnectionString %>" 
     
     SelectCommand="SELECT [ID],[ImportID],[DataSourceInstanceID],[FlexeraID]
         ,[AssetName],[AssetType],[SerialNo],[AssetTag],[ManufacturerName],[ModelNo],[AssetStatus],[ManufacturerPartNo],[Location],[BusinessUnit],[CostCenter],[Category]
         ,[AssignToUser],[AcquisitionMode],[ContractNo],[InventoryDatePhysical],[InventoriedByPhysical],[DeliveryDate],[InstallationDate],[RetirementDate],[DisposalDate],[Comments]
         ,[InventoriedByElectronic],[CurrencyCode],[CurrencyDate],[CurrencySnapshotName],[CurrencyRate],[LeaseNo],[LeaseAgreement],[LeaseStartDate],[LeaseEndDate],[LeaseTerminationDate],[LeaseTerminationReason]
         ,[LeasePrice],[LeasePeriodicPayment],[LeasePeriodType],[LeaseBuyoutCost],[WarrantyType],[WarrantyEndDate],[ChargesAmount],[ChargesFrequency],[EndOfLifeRecipient],[RetirementReason],[ResalePrice]
         ,[DepreciationCurrentValue],[DepreciationResidualValue],[DepreciationMethod],[DepreciationPeriod],[DepreciationRate],[WrittenOffValue]
         FROM [dbo].[mergedAssets]">
              
   </asp:SqlDataSource>

        
   <%--
   **** TABBED PAGES
   --%>

   <dx:ASPxPageControl ID="mainTabPages" Width="100%" runat="server" ActiveTabIndex="0" EnableHierarchyRecreation="True" >
       <TabPages>
        
           <%--
           **** UPLOADED FILES TABPAGE
           --%>
                                                                                                                              
           <dx:TabPage Text="Staged Data">
              <ContentCollection>
                  <dx:ContentControl ID="MainContentControl1" runat="server">
    
                  <dx:ASPxGridView runat="server" ID="GridViewDataset" ClientInstanceName="gridViewDataset" DataSourceID="SqlBlackBoxDataset" KeyFieldName="ID" 
                      CssClass="grid-view" Width="95%" EnablePagingGestures="False"
                      OnSelecting="GridViewDataset_Selecting" OnInitNewRow="GridViewDataset_InitNewRow" OnCustomCallback="GridViewDataset_CustomCallback" OnToolbarItemClick="GridViewDataset_ToolbarItemClick"
                      AutoGenerateColumns="False">
                      <Columns>
                          <dx:GridViewCommandColumn ShowSelectCheckbox="True" SelectAllCheckboxMode="AllPages" VisibleIndex="0" Width="50" Visible="false" />
                          <dx:GridViewDataColumn FieldName="ID" Caption="ID" VisibleIndex="1" Width="60px" Visible="true" />
                          <dx:GridViewDataColumn FieldName="ImportID" Caption="ImportID" VisibleIndex="2" Width="140px" Visible="true" />
                          <dx:GridViewDataColumn FieldName="DataSourceInstanceID" Caption="DataSourceInstanceID" VisibleIndex="3" Width="60px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="Exclude" Caption="Exclude" VisibleIndex="4" Width="90px" Visible="true" />
                          <dx:GridViewDataColumn FieldName="FlexeraID" Caption="FlexeraID" VisibleIndex="5" Width="100px" Visible="true" />
                          <dx:GridViewDataColumn FieldName="AssetName" Caption="AssetName" VisibleIndex="6" Width="200px" Visible="true" />
                          <dx:GridViewDataColumn FieldName="AssetType" Caption="AssetType" VisibleIndex="7" Width="100px" Visible="true" />
                          <dx:GridViewDataColumn FieldName="SerialNo" Caption="SerialNo" VisibleIndex="8" Width="120px" Visible="true" />
                          <dx:GridViewDataColumn FieldName="AssetTag" Caption="AssetTag" VisibleIndex="9" Width="140px" Visible="true" />
                          <dx:GridViewDataColumn FieldName="ManufacturerName" Caption="Manufacturer" VisibleIndex="10" Width="180px" Visible="true" />
                          <dx:GridViewDataColumn FieldName="ModelNo" Caption="Model" VisibleIndex="11" Width="150px" Visible="true" />
                          <dx:GridViewDataColumn FieldName="AssetStatus" Caption="AssetStatus" VisibleIndex="12" Width="120px" Visible="true" />
                          <dx:GridViewDataColumn FieldName="ManufacturerPartNo" Caption="ManufacturerPartNo" VisibleIndex="13" Width="90px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="Location" Caption="Location" VisibleIndex="14" Width="240px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="BusinessUnit" Caption="BusinessUnit" VisibleIndex="15" Width="140px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="CostCenter" Caption="CostCenter" VisibleIndex="16" Width="140px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="Category" Caption="Category" VisibleIndex="17" Width="140px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="AssignToUser" Caption="AssignToUser" VisibleIndex="18" Width="120px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="AcquisitionMode" Caption="AcquisitionMode" VisibleIndex="19" Width="80px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="ContractNo" Caption="ContractNo" VisibleIndex="20" Width="120px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="InventoryDatePhysical" Caption="InventoryDatePhysical" VisibleIndex="21" Width="80px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="InventoriedByPhysical" Caption="InventoriedByPhysical" VisibleIndex="22" Width="90px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="DeliveryDate" Caption="DeliveryDate" VisibleIndex="23" Width="90px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="InstallationDate" Caption="InstallationDate" VisibleIndex="24" Width="90px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="RetirementDate" Caption="RetirementDate" VisibleIndex="25" Width="90px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="DisposalDate" Caption="DisposalDate" VisibleIndex="26" Width="90px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="Comments" Caption="Comments" VisibleIndex="27" Width="380px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="InventoriedByElectronic" Caption="InventoriedByElectronic" VisibleIndex="28" Width="90px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="CurrencyCode" Caption="CurrencyCode" VisibleIndex="29" Width="60px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="CurrencyDate" Caption="CurrencyDate" VisibleIndex="30" Width="90px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="CurrencySnapshotName" Caption="CurrencySnapshotName" VisibleIndex="31" Width="120px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="CurrencyRate" Caption="CurrencyRate" VisibleIndex="32" Width="80px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="LeaseNo" Caption="LeaseNo" VisibleIndex="33" Width="100px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="LeaseAgreement" Caption="LeaseAgreement" VisibleIndex="34" Width="120px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="LeaseStartDate" Caption="LeaseStartDate" VisibleIndex="35" Width="90px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="LeaseEndDate" Caption="LeaseEndDate" VisibleIndex="36" Width="90px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="LeaseTerminationDate" Caption="LeaseTerminationDate" VisibleIndex="37" Width="90px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="LeaseTerminationReason" Caption="LeaseTerminationReason" VisibleIndex="38" Width="180px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="LeasePrice" Caption="LeasePrice" VisibleIndex="39" Width="100px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="LeasePeriodicPayment" Caption="LeasePeriodicPayment" VisibleIndex="40" Width="90px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="LeasePeriodType" Caption="LeasePeriodType" VisibleIndex="41" Width="80px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="LeaseBuyoutCost" Caption="LeaseBuyoutCost" VisibleIndex="42" Width="80px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="WarrantyType" Caption="WarrantyType" VisibleIndex="43" Width="80px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="WarrantyEndDate" Caption="WarrantyEndDate" VisibleIndex="44" Width="90px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="ChargesAmount" Caption="ChargesAmount" VisibleIndex="45" Width="80px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="ChargesFrequency" Caption="ChargesFrequency" VisibleIndex="46" Width="80px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="EndOfLifeRecipient" Caption="EndOfLifeRecipient" VisibleIndex="47" Width="120px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="RetirementReason" Caption="RetirementReason" VisibleIndex="48" Width="140px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="ResalePrice" Caption="ResalePrice" VisibleIndex="49" Width="90px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="DepreciationCurrentValue" Caption="DepreciationCurrentValue" VisibleIndex="50" Width="80px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="DepreciationResidualValue" Caption="DepreciationResidualValue" VisibleIndex="51" Width="80px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="DepreciationMethod" Caption="DepreciationMethod" VisibleIndex="52" Width="90px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="DepreciationPeriod" Caption="DepreciationPeriod" VisibleIndex="53" Width="80px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="DepreciationRate" Caption="DepreciationRate" VisibleIndex="54" Width="80px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="WrittenOffValue" Caption="WrittenOffValue" VisibleIndex="55" Width="80px" Visible="false" />
                      </Columns>
                      <Toolbars>
                          <dx:GridViewToolbar>
                              <SettingsAdaptivity Enabled="true" EnableCollapseRootItemsToIcons="true" />
                              <Items>
                                  <dx:GridViewToolbarItem Command="Refresh" />
                                  <dx:GridViewToolbarItem Command="Edit" />
                                  <dx:GridViewToolbarItem Command="Delete" />
                                  <dx:GridViewToolbarItem Text="Export to" Image-IconID="actions_download_16x16office2013" BeginGroup="true" AdaptivePriority="1">
                                      <Items>
                                          <dx:GridViewToolbarItem Command="ExportToCsv" />
                                          <dx:GridViewToolbarItem Command="ExportToXls" Text="Export to XLS(DataAware)" />
                                          <dx:GridViewToolbarItem Name="CustomExportToXLS" Text="Export to XLS(WYSIWYG)" Image-IconID="export_exporttoxls_16x16office2013" />
                                          <dx:GridViewToolbarItem Command="ExportToXlsx" Text="Export to XLSX(DataAware)" />
                                          <dx:GridViewToolbarItem Name="CustomExportToXLSX" Text="Export to XLSX(WYSIWYG)" Image-IconID="export_exporttoxlsx_16x16office2013" />
                                      </Items>
                                  </dx:GridViewToolbarItem>                    	
                                  <dx:GridViewToolbarItem Command="ShowCustomizationWindow" /> 
                                  <dx:GridViewToolbarItem Name="CustomExcludeRecord" Text="Exclude" BeginGroup="true" Enabled="true" />
                                  <dx:GridViewToolbarItem Name="CustomIncludeRecord" Text="Include" BeginGroup="false" Enabled="true" />
                                  <%--                   	
                                  <dx:GridViewToolbarItem Alignment="Right" BeginGroup="true" AdaptivePriority="4">
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
                      <SettingsBehavior AllowFocusedRow="true" AllowSelectSingleRowOnly="True" AllowSelectByRowClick="true" AllowEllipsisInText="true" AllowDragDrop="true" />
                      <SettingsResizing ColumnResizeMode="Control" />                      	
                      <SettingsEditing Mode="PopupEditForm" EditFormColumnCount="2" />
                      <SettingsSearchPanel CustomEditorID="SearchButtonEdit" />
                      <Settings VerticalScrollBarMode="Hidden" HorizontalScrollBarMode="Auto" ShowHeaderFilterButton="true" />
                      <SettingsPager PageSize="15" EnableAdaptivity="true">
                          <PageSizeItemSettings Visible="true"></PageSizeItemSettings>
                      </SettingsPager>
                      <SettingsExport EnableClientSideExportAPI="true" ExportSelectedRowsOnly="true" />
                      <SettingsBehavior EnableCustomizationWindow="true" />        	
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
                              <dx:GridViewLayoutGroup ColCount="3" GroupBoxDecoration="None">
                                  <Items>                              
                                      <dx:GridViewColumnLayoutItem ColumnName="ID" Caption="ID" ShowCaption="false">
                                        <Template>
                                           <dx:ASPxLabel ID="idLabel" runat="server" Width="60%" Text='<%# "ID: " + Convert.ToString(Eval("ID")) %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>
                                      <dx:GridViewColumnLayoutItem ColumnName="DataSourceInstanceID" Caption="DSIID" ShowCaption="false">
                                        <Template>
                                           <dx:ASPxLabel ID="dsiidLabel" runat="server" Width="80%" Text='<%# "DataSourceInstanceID: " + Convert.ToString(Eval("DataSourceInstanceID")) %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>

                                      <dx:GridViewColumnLayoutItem ColumnName="Exclude" Caption="Exclude" ShowCaption="false">
                                        <Template>
                                           <dx:ASPxCheckBox ID="excludeChackBox" runat="server" Width="80%" Text="Exclude" Checked='<%# Bind("Exclude") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>

                                      <dx:GridViewColumnLayoutItem ColumnName="FlexeraID" Caption="FlexeraID" ColumnSpan="3">
                                        <Template>
                                           <dx:ASPxTextBox ID="flexidTextBox" runat="server" Width="60%" Text='<%# Bind("FlexeraID") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>

                                      <dx:GridViewColumnLayoutItem ColumnName="AssetTag" Caption="AssetTag" ColumnSpan="3">
                                        <Template>
                                           <dx:ASPxTextBox ID="tagTextBox" runat="server" Width="60%" Text='<%# Bind("AssetTag") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>
                 
                                      <dx:GridViewColumnLayoutItem ColumnName="AssetName" Caption="AssetName" ColumnSpan="3">
                                        <Template>
                                           <dx:ASPxTextBox ID="descTextBox" runat="server" Width="80%" Text='<%# Bind("AssetName") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>
                 
                                      <dx:GridViewColumnLayoutItem ColumnName="AssetType" Caption="AssetType" ColumnSpan="3">
                                        <Template>
                                           <dx:ASPxTextBox ID="typeTextBox" runat="server" Width="80%" Text='<%# Bind("AssetType") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>
                      
                                      <dx:GridViewColumnLayoutItem ColumnName="SerialNo" Caption="SerialNo" ColumnSpan="3">
                                        <Template>
                                           <dx:ASPxTextBox ID="serialTextBox" runat="server" Width="60%" Text='<%# Bind("SerialNo") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>
                                      
                                      <dx:GridViewColumnLayoutItem ColumnName="ManufacturerName" Caption="Manufacturer" ColumnSpan="3">
                                        <Template>
                                           <dx:ASPxTextBox ID="manufacturerTextBox" runat="server" Width="80%" Text='<%# Bind("ManufacturerName") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>
                                      
                                      <dx:GridViewColumnLayoutItem ColumnName="ModelNo" Caption="Model" ColumnSpan="3">
                                        <Template>
                                           <dx:ASPxTextBox ID="modelTextBox" runat="server" Width="80%" Text='<%# Bind("ModelNo") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>

                                      <dx:GridViewColumnLayoutItem ColumnName="AssetStatus" Caption="Status" ColumnSpan="3">
                                        <Template>
                                           <dx:ASPxTextBox ID="statusTextBox" runat="server" Width="60%" Text='<%# Bind("AssetStatus") %>' />
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
                      <ClientSideEvents Init="OnGridViewDatasetInit" SelectionChanged="OnGridViewDatasetSelectionChanged" ToolbarItemClick="OnGridViewDatasetToolbarItemClick" />
                  </dx:ASPxGridView>

                  </dx:ContentControl>
             </ContentCollection>                                    
           </dx:TabPage>
        
           <%--
           **** DATA SOURCES TABPAGE
           --%>

           <dx:TabPage Text="Merged Data">
              <ContentCollection>
                  <dx:ContentControl ID="MainContentControl2" runat="server">
                  <br/>
    
                  <dx:ASPxGridView runat="server" ID="GridViewMerged" ClientInstanceName="gridViewMerged" DataSourceID="SqlBlackBoxMerged" KeyFieldName="ID" 
                      CssClass="grid-view" Width="95%" EnablePagingGestures="False"
                      OnSelecting="GridViewMerged_Selecting" OnCustomCallback="GridViewMerged_CustomCallback" OnToolbarItemClick="GridViewMerged_ToolbarItemClick"
                      AutoGenerateColumns="False">
                      <Columns>
                          <dx:GridViewCommandColumn ShowSelectCheckbox="True" SelectAllCheckboxMode="AllPages" VisibleIndex="0" Width="50" Visible="false" />
                          <dx:GridViewDataColumn FieldName="ID" Caption="ID" VisibleIndex="1" Width="60px" Visible="true" />
                          <dx:GridViewDataColumn FieldName="ImportID" Caption="ImportID" VisibleIndex="2" Width="140px" Visible="true" />
                          <dx:GridViewDataColumn FieldName="DataSourceInstanceID" Caption="DataSourceInstanceID" VisibleIndex="3" Width="60px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="FlexeraID" Caption="FlexeraID" VisibleIndex="5" Width="100px" Visible="true" />
                          <dx:GridViewDataColumn FieldName="AssetName" Caption="AssetName" VisibleIndex="6" Width="200px" Visible="true" />
                          <dx:GridViewDataColumn FieldName="AssetType" Caption="AssetType" VisibleIndex="7" Width="100px" Visible="true" />
                          <dx:GridViewDataColumn FieldName="SerialNo" Caption="SerialNo" VisibleIndex="8" Width="120px" Visible="true" />
                          <dx:GridViewDataColumn FieldName="AssetTag" Caption="AssetTag" VisibleIndex="9" Width="140px" Visible="true" />
                          <dx:GridViewDataColumn FieldName="ManufacturerName" Caption="Manufacturer" VisibleIndex="10" Width="180px" Visible="true" />
                          <dx:GridViewDataColumn FieldName="ModelNo" Caption="Model" VisibleIndex="11" Width="150px" Visible="true" />
                          <dx:GridViewDataColumn FieldName="AssetStatus" Caption="AssetStatus" VisibleIndex="12" Width="120px" Visible="true" />
                          <dx:GridViewDataColumn FieldName="ManufacturerPartNo" Caption="ManufacturerPartNo" VisibleIndex="13" Width="90px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="Location" Caption="Location" VisibleIndex="14" Width="240px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="BusinessUnit" Caption="BusinessUnit" VisibleIndex="15" Width="140px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="CostCenter" Caption="CostCenter" VisibleIndex="16" Width="140px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="Category" Caption="Category" VisibleIndex="17" Width="140px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="AssignToUser" Caption="AssignToUser" VisibleIndex="18" Width="120px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="AcquisitionMode" Caption="AcquisitionMode" VisibleIndex="19" Width="80px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="ContractNo" Caption="ContractNo" VisibleIndex="20" Width="120px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="InventoryDatePhysical" Caption="InventoryDatePhysical" VisibleIndex="21" Width="80px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="InventoriedByPhysical" Caption="InventoriedByPhysical" VisibleIndex="22" Width="90px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="DeliveryDate" Caption="DeliveryDate" VisibleIndex="23" Width="90px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="InstallationDate" Caption="InstallationDate" VisibleIndex="24" Width="90px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="RetirementDate" Caption="RetirementDate" VisibleIndex="25" Width="90px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="DisposalDate" Caption="DisposalDate" VisibleIndex="26" Width="90px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="Comments" Caption="Comments" VisibleIndex="27" Width="380px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="InventoriedByElectronic" Caption="InventoriedByElectronic" VisibleIndex="28" Width="90px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="CurrencyCode" Caption="CurrencyCode" VisibleIndex="29" Width="60px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="CurrencyDate" Caption="CurrencyDate" VisibleIndex="30" Width="90px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="CurrencySnapshotName" Caption="CurrencySnapshotName" VisibleIndex="31" Width="120px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="CurrencyRate" Caption="CurrencyRate" VisibleIndex="32" Width="80px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="LeaseNo" Caption="LeaseNo" VisibleIndex="33" Width="100px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="LeaseAgreement" Caption="LeaseAgreement" VisibleIndex="34" Width="120px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="LeaseStartDate" Caption="LeaseStartDate" VisibleIndex="35" Width="90px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="LeaseEndDate" Caption="LeaseEndDate" VisibleIndex="36" Width="90px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="LeaseTerminationDate" Caption="LeaseTerminationDate" VisibleIndex="37" Width="90px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="LeaseTerminationReason" Caption="LeaseTerminationReason" VisibleIndex="38" Width="180px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="LeasePrice" Caption="LeasePrice" VisibleIndex="39" Width="100px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="LeasePeriodicPayment" Caption="LeasePeriodicPayment" VisibleIndex="40" Width="90px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="LeasePeriodType" Caption="LeasePeriodType" VisibleIndex="41" Width="80px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="LeaseBuyoutCost" Caption="LeaseBuyoutCost" VisibleIndex="42" Width="80px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="WarrantyType" Caption="WarrantyType" VisibleIndex="43" Width="80px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="WarrantyEndDate" Caption="WarrantyEndDate" VisibleIndex="44" Width="90px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="ChargesAmount" Caption="ChargesAmount" VisibleIndex="45" Width="80px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="ChargesFrequency" Caption="ChargesFrequency" VisibleIndex="46" Width="80px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="EndOfLifeRecipient" Caption="EndOfLifeRecipient" VisibleIndex="47" Width="120px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="RetirementReason" Caption="RetirementReason" VisibleIndex="48" Width="140px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="ResalePrice" Caption="ResalePrice" VisibleIndex="49" Width="90px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="DepreciationCurrentValue" Caption="DepreciationCurrentValue" VisibleIndex="50" Width="80px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="DepreciationResidualValue" Caption="DepreciationResidualValue" VisibleIndex="51" Width="80px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="DepreciationMethod" Caption="DepreciationMethod" VisibleIndex="52" Width="90px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="DepreciationPeriod" Caption="DepreciationPeriod" VisibleIndex="53" Width="80px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="DepreciationRate" Caption="DepreciationRate" VisibleIndex="54" Width="80px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="WrittenOffValue" Caption="WrittenOffValue" VisibleIndex="55" Width="80px" Visible="false" />
                      </Columns>
                      <Toolbars>
                          <dx:GridViewToolbar>
                              <SettingsAdaptivity Enabled="true" EnableCollapseRootItemsToIcons="true" />
                              <Items>
                                  <dx:GridViewToolbarItem Command="Refresh" />
                                  <dx:GridViewToolbarItem Text="Export to" Image-IconID="actions_download_16x16office2013" BeginGroup="true" AdaptivePriority="1">
                                      <Items>
                                          <dx:GridViewToolbarItem Command="ExportToCsv" />
                                          <dx:GridViewToolbarItem Command="ExportToXls" Text="Export to XLS(DataAware)" />
                                          <dx:GridViewToolbarItem Name="CustomExportToXLS" Text="Export to XLS(WYSIWYG)" Image-IconID="export_exporttoxls_16x16office2013" />
                                          <dx:GridViewToolbarItem Command="ExportToXlsx" Text="Export to XLSX(DataAware)" />
                                          <dx:GridViewToolbarItem Name="CustomExportToXLSX" Text="Export to XLSX(WYSIWYG)" Image-IconID="export_exporttoxlsx_16x16office2013" />
                                      </Items>
                                  </dx:GridViewToolbarItem>                    	
                                  <dx:GridViewToolbarItem Command="ShowCustomizationWindow" /> 
                              </Items>
                          </dx:GridViewToolbar>
                      </Toolbars>                                                
                      <SettingsBehavior AllowFocusedRow="true" AllowSelectSingleRowOnly="True" AllowSelectByRowClick="true" AllowEllipsisInText="true" AllowDragDrop="true" />
                      <SettingsResizing ColumnResizeMode="Control" />                      	
                      <SettingsEditing Mode="PopupEditForm" EditFormColumnCount="2" />
                      <SettingsSearchPanel CustomEditorID="SearchButtonEdit" />
                      <Settings VerticalScrollBarMode="Hidden" HorizontalScrollBarMode="Auto" ShowHeaderFilterButton="true" />
                      <SettingsPager PageSize="15" EnableAdaptivity="true">
                          <PageSizeItemSettings Visible="true"></PageSizeItemSettings>
                      </SettingsPager>
                      <SettingsExport EnableClientSideExportAPI="true" ExportSelectedRowsOnly="true" />
                      <SettingsBehavior EnableCustomizationWindow="true" />        	
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
                              <dx:GridViewLayoutGroup ColCount="3" GroupBoxDecoration="None">
                                  <Items>                              
                                      <dx:GridViewColumnLayoutItem ColumnName="ID" Caption="ID" ShowCaption="false">
                                        <Template>
                                           <dx:ASPxLabel ID="idLabel" runat="server" Width="60%" Text='<%# "ID: " + Convert.ToString(Eval("ID")) %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>
                                      <dx:GridViewColumnLayoutItem ColumnName="DataSourceInstanceID" Caption="DSIID" ShowCaption="false">
                                        <Template>
                                           <dx:ASPxLabel ID="dsiidLabel" runat="server" Width="80%" Text='<%# "DataSourceInstanceID: " + Convert.ToString(Eval("DataSourceInstanceID")) %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>

                                      <dx:GridViewColumnLayoutItem ColumnName="FlexeraID" Caption="FlexeraID" ColumnSpan="3">
                                        <Template>
                                           <dx:ASPxTextBox ID="flexidTextBox" runat="server" Width="60%" Text='<%# Bind("FlexeraID") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>

                                      <dx:GridViewColumnLayoutItem ColumnName="AssetTag" Caption="AssetTag" ColumnSpan="3">
                                        <Template>
                                           <dx:ASPxTextBox ID="tagTextBox" runat="server" Width="60%" Text='<%# Bind("AssetTag") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>
                 
                                      <dx:GridViewColumnLayoutItem ColumnName="AssetName" Caption="AssetName" ColumnSpan="3">
                                        <Template>
                                           <dx:ASPxTextBox ID="descTextBox" runat="server" Width="80%" Text='<%# Bind("AssetName") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>
                 
                                      <dx:GridViewColumnLayoutItem ColumnName="AssetType" Caption="AssetType" ColumnSpan="3">
                                        <Template>
                                           <dx:ASPxTextBox ID="typeTextBox" runat="server" Width="80%" Text='<%# Bind("AssetType") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>
                      
                                      <dx:GridViewColumnLayoutItem ColumnName="SerialNo" Caption="SerialNo" ColumnSpan="3">
                                        <Template>
                                           <dx:ASPxTextBox ID="serialTextBox" runat="server" Width="60%" Text='<%# Bind("SerialNo") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>
                                      
                                      <dx:GridViewColumnLayoutItem ColumnName="ManufacturerName" Caption="Manufacturer" ColumnSpan="3">
                                        <Template>
                                           <dx:ASPxTextBox ID="manufacturerTextBox" runat="server" Width="80%" Text='<%# Bind("ManufacturerName") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>
                                      
                                      <dx:GridViewColumnLayoutItem ColumnName="ModelNo" Caption="Model" ColumnSpan="3">
                                        <Template>
                                           <dx:ASPxTextBox ID="modelTextBox" runat="server" Width="80%" Text='<%# Bind("ModelNo") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>

                                      <dx:GridViewColumnLayoutItem ColumnName="AssetStatus" Caption="Status" ColumnSpan="3">
                                        <Template>
                                           <dx:ASPxTextBox ID="statusTextBox" runat="server" Width="60%" Text='<%# Bind("AssetStatus") %>' />
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
                      <ClientSideEvents Init="OnGridViewMergedInit" SelectionChanged="OnGridViewMergedSelectionChanged" ToolbarItemClick="OnGridViewMergedToolbarItemClick" />
                  </dx:ASPxGridView>

                  </dx:ContentControl>
             </ContentCollection>                                    
           </dx:TabPage>
        
           <%--
           **** DATASET HISTORY TABPAGE
           --%>

           <dx:TabPage Text="Dataset History">
              <ContentCollection>
                  <dx:ContentControl ID="MainContentControl3" runat="server">
                  <br/>

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
