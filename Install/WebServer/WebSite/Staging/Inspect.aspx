<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="Staging.Master" CodeBehind="Inspect.aspx.cs" Inherits="BlackBox.InspectPage" Title="BlackBox" %>

<%@ Register assembly="System.Web.DataVisualization, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" namespace="System.Web.UI.DataVisualization.Charting" tagprefix="asp" %>

<%@ Register assembly="DevExpress.Web.v22.2, Version=22.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" namespace="DevExpress.Web" tagprefix="dx" %>
<%@ Register assembly="DevExpress.XtraCharts.v22.2.Web, Version=22.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" namespace="DevExpress.XtraCharts.Web" tagprefix="dx" %>
<%@ Register assembly="DevExpress.XtraCharts.v22.2, Version=22.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" namespace="DevExpress.XtraCharts" tagprefix="dx" %>

<%--
**** HEADER CONTENT
--%>

<asp:Content runat="server" ContentPlaceHolderID="ContentPlaceHolderHead">  
  <script type="text/javascript">
           
  // page toolbar
  function updateToolbarButtonsState() 
  {
    var enabled = cardView.GetSelectedCardCount() > 0;
    //pageToolbar.GetItemByName("Delete").SetEnabled(enabled);
    //pageToolbar.GetItemByName("Edit").SetEnabled(cardView.GetFocusedRowIndex() !== -1);
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

  // ///////////////////////
  // popup functions
  // ///////////////////////

  // show the popup
  function ShowModalUploadsPopup() 
  {
    var source = dataSourceComboBox.GetText();
    pcSourceComboBox.SetText(source);    
    
    pcUploadCommentsTextBox.SetText("enter a comment");

    pcUploadDetails.Show();
    gridViewUploadedFiles.Refresh();
    gridViewDataSources.Refresh();

    pcUploadCommentsTextBox.Focus();
  }

  // ///////////////////////////////
  // data sources grid functions
  // ///////////////////////////////

  function onGridViewInit(s, e) 
  {
  }
    
  function onGridViewSelectionChanged(s, e) 
  {
    e.processOnServer=true;
    e.usePostBack=true;
  }
  
  function onGridViewFocusedRowChanged() 
  {
    // Query the server for the "Location" field from the focused row 
    var fri = gridViewUploadedFiles.GetFocusedRowIndex();
    gridViewUploadedFiles.GetRowValues(fri, 'Location', OnGetImportsFocusedRowValues);
    gridViewUploadedFiles.Refresh();    
  }
  
  function onGridViewToolbarItemClick(s, e) 
  {
    if (IsCustomExportGridToolbarCommand(e.item.name)) 
    {
      e.processOnServer=true;
      e.usePostBack=true;
    }
  }

  function onGetFocusedRowValues(value) 
  {
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
      case "CustomStageFile":
      case "CustomRecallFile":      
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

  window.onGridViewInit = onGridViewInit;
  window.onGridViewSelectionChanged = onGridViewSelectionChanged;
  window.onGridViewFocusedRowChanged = onGridViewFocusedRowChanged;  
  window.onGridViewToolbarItemClick = onGridViewToolbarItemClick;    

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
                           <dx:ASPxLabel ID="TopSubHeaderLabel" runat="server" Text="Inspect" Font-Bold="True" Font-Size="Large" Width="220px" />
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
          <dx:MenuItem Name="PageMenuAssets" NavigateUrl="~/Staging/Assets.aspx" Text="Assets" Alignment="Right" AdaptivePriority="1">
              <Image IconID="businessobjects_bo_order_svg_dark_16x16" />
          </dx:MenuItem>
          <%--
          <dx:MenuItem Name="PageMenuPurchases" NavigateUrl="~/Staging/Uploads.aspx?group=ITAM&source=Purchases" Text="Purchases" Alignment="Right" AdaptivePriority="2">
              <Image IconID="businessobjects_bo_price_svg_dark_16x16" />
          </dx:MenuItem>
          <dx:MenuItem Name="PageMenuMetrics" NavigateUrl="~/Staging/Uploads.aspx?group=ITAM&source=Metrics" Text="Metrics" Alignment="Right" AdaptivePriority="3">  
              <Image IconID="iconbuilder_business_calculator_svg_dark_16x16" />
          </dx:MenuItem>
          --%>
          <dx:MenuItem Name="PageMenuRisk" NavigateUrl="~/Staging/AssetRisk.aspx" Text="Risk Assessment" Alignment="Right" AdaptivePriority="4">  
              <Image IconID="businessobjects_bo_opportunity_svg_dark_16x16" />
          </dx:MenuItem>
          <dx:MenuItem Name="PageMenuSIA" NavigateUrl="~/Staging/SIA.aspx" Text="SIA" Alignment="Right" AdaptivePriority="5">  
              <Image IconID="businessobjects_bo_opportunity_svg_dark_16x16" />
          </dx:MenuItem>
          <dx:MenuItem Name="PageMenuSIDA" NavigateUrl="~/Staging/SIDA.aspx" Text="SIDA" Alignment="Right" AdaptivePriority="6">
              <Image IconID="dashboards_editrules_svg_dark_16x16" />
          </dx:MenuItem>
          
          <%--
          <dx:MenuItem Name="PageMenuFlexera" Text="Flexera" Alignment="Right" AdaptivePriority="6">
              <Image IconID="setup_properties_svg_dark_16x16" />
          </dx:MenuItem>
          --%>

          <dx:MenuItem Alignment="Right" AdaptivePriority="6">  
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
  
   <asp:SqlDataSource ID="SqlDatasetDataSource" runat="server" 
     ConnectionString="<%$ ConnectionStrings:BlackBoxConnectionString %>" 
     SelectCommand="SELECT FROM [dbo].[itamAssets]"
     DeleteCommand="DELETE FROM Asset WHERE [itamAssets] = @id">
     <DeleteParameters>
        <asp:QueryStringParameter Name="id" />
     </DeleteParameters>
   </asp:SqlDataSource>
        
   <%--
   **** TABBED PAGES
   --%>

   <dx:ASPxPageControl ID="mainTabPages" Width="100%" runat="server" ActiveTabIndex="0" EnableHierarchyRecreation="True" >
       <TabPages>
        
           <%--
           **** OVERVIEW TABPAGE
           --%>
                                                                                                                              
           <dx:TabPage Text="Overview">
              <ContentCollection>
                  <dx:ContentControl ID="MainContentControl1" runat="server">    

                  <dx:ASPxGridView runat="server" ID="GridView" ClientInstanceName="gridView" DataSourceID="SqlDatasetDataSource" KeyFieldName="ID" AutoGenerateColumns="true"
                      OnSelecting="GridView_Selecting" OnCustomCallback="GridView_CustomCallback" OnToolbarItemClick="GridView_ToolbarItemClick" OnDataBound="GridView_DataBound"
                      EnablePagingGestures="False" CssClass="grid-view" Width="95%" >
                      <Toolbars>
                          <dx:GridViewToolbar>
                              <SettingsAdaptivity Enabled="true" EnableCollapseRootItemsToIcons="true" />
                              <Items>
                                  <dx:GridViewToolbarItem Command="Refresh" BeginGroup="true" AdaptivePriority="1" />
                                  <dx:GridViewToolbarItem Command="ShowCustomizationWindow" BeginGroup="true" AdaptivePriority="2" />
                              </Items>
                          </dx:GridViewToolbar>
                      </Toolbars>
                      <SettingsResizing ColumnResizeMode="Control" />
                      <SettingsBehavior AllowFocusedRow="true" AllowSelectSingleRowOnly="true" AllowSelectByRowClick="true" AllowEllipsisInText="true" AllowDragDrop="true" />
                      <SettingsEditing Mode="PopupEditForm" EditFormColumnCount="2" />
                      <SettingsSearchPanel CustomEditorID="SearchButtonEdit" />
                      <Settings VerticalScrollBarMode="Hidden" HorizontalScrollBarMode="Auto" ShowHeaderFilterButton="true" />
                      <SettingsPager PageSize="10" EnableAdaptivity="true">
                          <PageSizeItemSettings Visible="true"></PageSizeItemSettings>
                      </SettingsPager>
                      <SettingsExport EnableClientSideExportAPI="true" ExportSelectedRowsOnly="true" />
                      <SettingsBehavior EnableCustomizationWindow="true" />
                      <EditFormLayoutProperties>
                           <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="900" />
                      </EditFormLayoutProperties>
                      <SettingsPopup>
                           <EditForm Width="1400">
                                <SettingsAdaptivity  MaxWidth="1200" Mode="OnWindowInnerWidth" SwitchAtWindowInnerWidth="1100" VerticalAlign="WindowCenter" />
                           </EditForm>
                      </SettingsPopup>
                      <Styles>
                          <Cell Wrap="false" />
                          <PagerBottomPanel CssClass="pager" />
                          <FocusedRow CssClass="focused" />
                      </Styles>
                      <ClientSideEvents Init="onGridViewInit" SelectionChanged="onGridViewSelectionChanged" ToolbarItemClick="onGridViewToolbarItemClick" />
                  </dx:ASPxGridView>          	                             

                  </dx:ContentControl>
             </ContentCollection>                                    
           </dx:TabPage>
        
           <%--
           **** DETAILS TABPAGE
           --%>

           <dx:TabPage Text="Details">
              <ContentCollection>
                  <dx:ContentControl ID="MainContentControl2" runat="server">


                  </dx:ContentControl>
             </ContentCollection>                                    
           </dx:TabPage>
                   
       </TabPages>
   </dx:ASPxPageControl>
        
   <%--
   **** POPUP PANEL
   --%>

        
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
