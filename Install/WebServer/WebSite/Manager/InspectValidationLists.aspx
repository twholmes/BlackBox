<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="Manager.Master" CodeBehind="InspectValidationLists.aspx.cs" Inherits="BlackBox.InspectValidationListsPage" Title="BlackBox" %>

<%@ Register assembly="System.Web.DataVisualization, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" namespace="System.Web.UI.DataVisualization.Charting" tagprefix="asp" %>

<%@ Register assembly="DevExpress.Web.v22.2, Version=22.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" namespace="DevExpress.Web" tagprefix="dx" %>
<%@ Register assembly="DevExpress.Web.ASPxSpreadsheet.v22.2, Version=22.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" namespace="DevExpress.Web.ASPxSpreadsheet" tagprefix="dx" %>
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

  // /////////////////////////////
  // actions callback functions
  // /////////////////////////////
         
  function OnActionsCallbackComplete(s, e) 
  {
    var result = e.result;
    gridViewDataset.Refresh();    
    LoadingPanel.Hide();
  }

  // ///////////////////////
  // popup functions
  // ///////////////////////


  // ///////////////////////
  // dataset grid functions
  // ///////////////////////

  // dataset grid toolbar functions  
  function OnGridViewDatasetToolbarItemClick(s, e) 
  {
    if (IsCustomGridViewToolbarCommand(e.item.name)) 
    {
      e.processOnServer=true;
      e.usePostBack=true;
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
    gridViewDataset.GetRowValues(fri, 'ListName;Value', OnGetDatasetFocusedRowValues);
    gridViewDataset.Refresh();    
  }

  function OnGetDatasetFocusedRowValues(values)
  {
    var listentryname = values[0];
    var listentryvalue = values[1];
  }

  // //////////////////////////////////
  // history gridview functions
  // //////////////////////////////////

  // history grid toolbar functions  
  function OnGridViewHistoryToolbarItemClick(s, e) 
  {
    if (IsCustomGridViewToolbarCommand(e.item.name)) 
    {
      e.processOnServer=true;
      e.usePostBack=true;
    }
  }

  // history gridview functions
  function OnGridViewHistoryInit(s, e) 
  { 
    var toolbar = gridViewHistory.GetToolbar(0);  
    if (toolbar != null) 
    {  
    }
  }
    
  function OnGridViewHistorySelectionChanged(s, e) 
  {
    e.processOnServer=true;
    e.usePostBack=true;
  }
 
  function OnGridViewHistoryFocusedRowChanged(s, e)
  {
    var fri = gridViewHistory.GetFocusedRowIndex();
    //gridViewValidationLists.GetRowValues(fri, 'ID,ListName', OnGetValidationListsFocusedRowValues);
    //gridViewValidationLists.Refresh();    
  }

  function OnGetHistoryFocusedRowValues(values)
  {
    var id = values[0];
    var col = values[1];
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
      case "CustomExcludeRecord":
          LoadingPanel.Show(); 
          actionsCallback.PerformCallback("exclude");
          break;

      case "CustomIncludeRecord":
          LoadingPanel.Show(); 
          actionsCallback.PerformCallback("include");
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
 
  // open url in new tab or existing tab
  function openUrlWithParamFromPage(baseurl, fid, newtab) 
  {
    var url = baseurl + "?fid=" + fid
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

  window.OnGridViewDatasetInit = OnGridViewDatasetInit;
  window.OnGridViewDatasetSelectionChanged = OnGridViewDatasetSelectionChanged;
  window.OnGridViewDatasetFocusedRowChanged = OnGridViewDatasetFocusedRowChanged;  
  window.OnGridViewDatasetToolbarItemClick = OnGridViewDatasetToolbarItemClick;    

  window.OnGridViewHistoryInit = OnGridViewHistoryInit;
  window.OnGridViewHistorySelectionChanged = OnGridViewHistorySelectionChanged;
  window.OnGridViewHistoryFocusedRowChanged = OnGridViewHistoryFocusedRowChanged;  
  window.OnGridViewHistoryToolbarItemClick = OnGridViewHistoryToolbarItemClick;    
   
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
                           <dx:ASPxHyperLink ID="BreadcrumbsHyperLink" runat="server" NavigateUrl="~/Manager.aspx" Text="Manager" Font-Bold="True" Font-Size="Large" Border-BorderStyle="None" Border-BorderWidth="8px" />
                           <dx:ASPxLabel ID="ASPxLabel1" runat="server" Text=">"></dx:ASPxLabel>
                           <dx:ASPxLabel ID="BreadcrumbsLabel" runat="server" Text="Inspect Validation Lists" Font-Bold="True" Font-Size="Large" Width="850px" />
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
          <dx:MenuItem Name="PageMenuUploads" Text="Uploads" NavigateUrl="../Manager/TemplateUploads.aspx" Target="_blank" Alignment="Right" AdaptivePriority="2">
               <Image IconID="snap_datasource_svg_dark_16x16" />
          </dx:MenuItem>
              
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

   <asp:SqlDataSource ID="SqlActionHistory" runat="server" 
     ConnectionString="<%$ ConnectionStrings:BlackBoxConnectionString %>"     
     SelectCommand="SELECT TOP 1000 [ID],[Object],[RefID],[UserID],[User],[ActorID],[Action],[Message],[TimeStamp] FROM [dbo].[vBlackBoxHistory]"
     InsertCommand="INSERT INTO [dbo].[BlackBoxHistory] ([Object],[RefID],[UserID],[ActorID],[Action],[Message],[TimeStamp]) VALUES(@Object,@RefID,@UserID,@ActorID,@Action,@Message,GetDate())"
     UpdateCommand="UPDATE [dbo].[BlackBoxHistory] SET [Object]=@Object,[RefID]=@RefID,[UserID]=@UserID,[ActorID]=@ActorID,[Action]=@Action,[Message]=@Message,[TimeStamp]=GetDate() WHERE [ID]=@ID"
	   DeleteCommand="DELETE FROM [dbo].[BlackBoxHistory] WHERE [ID] = @ID">
     <InsertParameters>
         <asp:FormParameter FormField="Object" Name="Object" />
         <asp:FormParameter FormField="RefID" Name="RefID" />
         <asp:FormParameter FormField="UserID" Name="UserID" />
         <asp:FormParameter FormField="ActorID" Name="ActorID" />
         <asp:FormParameter FormField="Action" Name="Action" />
         <asp:FormParameter FormField="Message" Name="Message" />
     </InsertParameters>
     <UpdateParameters>
         <asp:FormParameter FormField="ID" Name="ID" />     	
         <asp:FormParameter FormField="Object" Name="Object" />
         <asp:FormParameter FormField="RefID" Name="RefID" />
         <asp:FormParameter FormField="UserID" Name="UserID" />
         <asp:FormParameter FormField="ActorID" Name="ActorID" />
         <asp:FormParameter FormField="Action" Name="Action" />
         <asp:FormParameter FormField="Message" Name="Message" />
     </UpdateParameters>
     <DeleteParameters>
         <asp:QueryStringParameter Name="ID" />
     </DeleteParameters>
   </asp:SqlDataSource>

    <%--
    **** RIGHT PANEL TAB PAGES
    --%>    

    <dx:ASPxPageControl ID="TabPagesRightPanel" Width="100%" runat="server" ActiveTabIndex="1" EnableHierarchyRecreation="true" >
       <TabPages>
           <%--
           **** HISTORY TABPAGE
           --%>

           <dx:TabPage Text="History" Visible="true">
              <ContentCollection>
                  <dx:ContentControl ID="RightPanelContentControl1" runat="server">

                  <dx:ASPxGridView ID="HistoryGridView" runat="server" ClientInstanceName="gridViewHistory" DataSourceID="SqlActionHistory" KeyFieldName="ID"
                    OnRowCommand="HistoryGridView_RowCommand" OnSelectionChanged="HistoryGridView_SelectionChanged"
                    OnInitNewRow="HistoryGridView_InitNewRow" OnRowInserting="HistoryGridView_RowInserting" OnRowUpdating="HistoryGridView_RowUpdating" OnRowDeleting="HistoryGridView_RowDeleting"
                    OnCustomCallback="HistoryGridView_CustomCallback" OnToolbarItemClick="HistoryGridView_ToolbarItemClick"
                    EnableTheming="True" EnableViewState="False" AutoGenerateColumns="False" Width="95%">
                    <Toolbars>
                        <dx:GridViewToolbar>
                            <SettingsAdaptivity Enabled="true" EnableCollapseRootItemsToIcons="true" />
                            <Items>
                                <dx:GridViewToolbarItem Command="Refresh" BeginGroup="true" AdaptivePriority="1"/>
                                <dx:GridViewToolbarItem Command="New" BeginGroup="true" AdaptivePriority="2" Visible="false"/>
                                <dx:GridViewToolbarItem Command="Edit" AdaptivePriority="3" Visible="false"/>
                                <dx:GridViewToolbarItem Command="Delete" AdaptivePriority="4" Visible="false"/>

                                <dx:GridViewToolbarItem Command="ShowFilterRow" BeginGroup="true" AdaptivePriority="5"/>
                                <dx:GridViewToolbarItem Command="ShowCustomizationWindow" BeginGroup="true" AdaptivePriority="6"/>
                            </Items>
                        </dx:GridViewToolbar>
                    </Toolbars>                     
                    <SettingsPopup>
                      <HeaderFilter MinHeight="140px"></HeaderFilter>
                    </SettingsPopup>
                    <Columns>                            
                          <dx:GridViewCommandColumn VisibleIndex="0" SelectAllCheckboxMode="AllPages" ShowSelectCheckbox="True" Width="50px" Visible="true" />
                          <dx:GridViewDataTextColumn FieldName="ID" Caption="ID" VisibleIndex="1" Width="60px" Visible="true" />
                          <dx:GridViewDataTextColumn FieldName="Object" Caption="Object" VisibleIndex="2" Width="140px" Visible="false" />
                          <dx:GridViewDataTextColumn FieldName="RefID" Caption="RefID" VisibleIndex="3" Width="60px" Visible="false" />
                          <dx:GridViewDataTextColumn FieldName="UserID" Caption="UserID" VisibleIndex="4" Width="60px" Visible="false" />
                          <dx:GridViewDataTextColumn FieldName="User" Caption="User" VisibleIndex="5" Width="150px" Visible="false" />
                          <dx:GridViewDataTextColumn FieldName="ActorID" Caption="ActorID" VisibleIndex="6" Width="70px" Visible="true" />
                          <dx:GridViewDataTextColumn FieldName="Action" Caption="Action" VisibleIndex="7" Width="80px" Visible="true" />
                          <dx:GridViewDataTextColumn FieldName="Message" Caption="Message" VisibleIndex="8" Width="170px" Visible="true" />
                          <dx:GridViewDataTextColumn FieldName="TimeStamp" Caption="TimeStamp" VisibleIndex="9" Width="160px" Visible="true" />                          	
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
                                      <dx:GridViewColumnLayoutItem ColumnName="ID" Caption="ID">
                                        <Template>
                                           <dx:ASPxLabel ID="idLabel" runat="server" Width="40%" Text='<%# Bind("ID") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>

                                      <dx:GridViewColumnLayoutItem ColumnName="Object" Caption="ObjectName" ColumnSpan="1">
                                        <Template>
                                           <dx:ASPxTextBox ID="objectTextBox" runat="server" Width="50%" Text='<%# Bind("Object") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>                                     

                                      <dx:GridViewColumnLayoutItem ColumnName="RefID" Caption="RefID" ColumnSpan="1">
                                        <Template>
                                           <dx:ASPxTextBox ID="refidTextBox" runat="server" Width="60%" Text='<%# Bind("RefID") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>

                                      <dx:GridViewColumnLayoutItem ColumnName="UserID" Caption="UserID" ColumnSpan="1">
                                        <Template>
                                           <dx:ASPxTextBox ID="useridTextBox" runat="server" Width="60%" Text='<%# Bind("UserID") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>

                                      <dx:GridViewColumnLayoutItem ColumnName="ActorID" Caption="ActorID" ColumnSpan="1">
                                        <Template>
                                           <dx:ASPxTextBox ID="actoridTextBox" runat="server" Width="60%" Text='<%# Bind("ActorID") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>

                                      <dx:GridViewColumnLayoutItem ColumnName="Action" Caption="Action" ColumnSpan="1">
                                        <Template>
                                           <dx:ASPxTextBox ID="actionTextBox" runat="server" Width="80%" Text='<%# Bind("Action") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>
                                                                      	
                                      <dx:GridViewColumnLayoutItem ColumnName="Message" Caption="Message" ColumnSpan="2">
                                        <Template>
                                           <dx:ASPxTextBox ID="messageTextBox" runat="server" Width="480%" Text='<%# Bind("Message") %>' />
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
                      <ClientSideEvents Init="OnGridViewHistoryInit" SelectionChanged="OnGridViewHistorySelectionChanged" FocusedRowChanged="OnGridViewHistoryFocusedRowChanged" 
                        ToolbarItemClick="OnGridViewHistoryToolbarItemClick" />
                  </dx:ASPxGridView>

                  </dx:ContentControl>
             </ContentCollection>
           </dx:TabPage>

           <%--
           **** SETTINGS TABPAGE
           --%>

           <dx:TabPage Text="Settings" Visible="false">
              <ContentCollection>
                  <dx:ContentControl ID="RightPanelContentControl3" runat="server">

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
  
     SelectCommand="SELECT [ID],[JobID],[DataSourceInstanceID],[LineNumber],[Exclude],[FlexeraID],[DataSource],[ListName],[Value],[Status] FROM [dbo].[sysValidationLists]"
     
     InsertCommand="INSERT INTO [dbo].[sysValidationLists] ([JobID],[DataSourceInstanceID],[LineNumber],[FlexeraID],[DataSource],[ListName],[Value],[Status]) 
        VALUES(@JobID,@DataSourceInstanceID,@LineNumber,@Exclude,@FlexeraID,@DataSource,@ListName,@Value,@Status)"
        
     UpdateCommand="UPDATE [dbo].[sysValidationLists] SET [JobID]=@JobID,[DataSourceInstanceID]=@DataSourceInstanceID,[LineNumber]=@LineNumber,[Exclude]=@Exclude
        ,[FlexeraID]=@FlexeraID,[DataSource]=@DataSource,[ListName]=@ListName,[Value]=@Value,[Status]=@Status WHERE [ID]=@ID"

     DeleteCommand="DELETE FROM [dbo].[sysValidationLists] WHERE [ID] = @ID">
     
     <InsertParameters>
         <asp:FormParameter FormField="JobID" Name="JobID" />
         <asp:FormParameter FormField="DataSourceInstanceID" Name="DataSourceInstanceID" />
         <asp:FormParameter FormField="LineNumber" Name="LineNumber" />
         <asp:FormParameter FormField="Exclude" Name="Exclude" />         	
         <asp:FormParameter FormField="FlexeraID" Name="FlexeraID" />
         <asp:FormParameter FormField="DataSource" Name="DataSource" />
         <asp:FormParameter FormField="ListName" Name="ListName" />
         <asp:FormParameter FormField="Value" Name="Value" />
         <asp:FormParameter FormField="Status" Name="Status" />
     </InsertParameters>
     
     <UpdateParameters>
         <asp:FormParameter FormField="ID" Name="ID" />
         <asp:FormParameter FormField="JobID" Name="JobID" />
         <asp:FormParameter FormField="DataSourceInstanceID" Name="DataSourceInstanceID" />
         <asp:FormParameter FormField="LineNumber" Name="LineNumber" />
         <asp:FormParameter FormField="Exclude" Name="Exclude" />         	
         <asp:FormParameter FormField="FlexeraID" Name="FlexeraID" />
         <asp:FormParameter FormField="DataSource" Name="DataSource" />
         <asp:FormParameter FormField="ListName" Name="ListName" />
         <asp:FormParameter FormField="Value" Name="Value" />
         <asp:FormParameter FormField="Status" Name="Status" />
     </UpdateParameters>
     
     <DeleteParameters>
        <asp:QueryStringParameter Name="ID" />
     </DeleteParameters>
   </asp:SqlDataSource>
        
   <%--
   **** TABBED PAGES
   --%>

   <dx:ASPxPageControl ID="mainTabPages" Width="100%" runat="server" ActiveTabIndex="0" EnableHierarchyRecreation="True" >
       <TabPages>        
           <%--
           **** DATASET VIEW TABPAGE
           --%>
                                                                                                                              
           <dx:TabPage Text="Staged Data">
              <ContentCollection>
                  <dx:ContentControl ID="MainContentControl1" runat="server">
    
                  <dx:ASPxGridView runat="server" ID="GridViewDataset" ClientInstanceName="gridViewDataset" DataSourceID="SqlBlackBoxDataset" KeyFieldName="ID" 
                      CssClass="grid-view" Width="95%" EnablePagingGestures="False"
                      OnToolbarItemClick="GridViewDataset_ToolbarItemClick" OnSelectionChanged="GridViewDataset_SelectionChanged"                      
                      OnSelecting="GridViewDataset_Selecting" OnInitNewRow="GridViewDataset_InitNewRow" OnCustomCallback="GridViewDataset_CustomCallback"
                      AutoGenerateColumns="False">
                      <Columns>                            
                         <dx:GridViewCommandColumn VisibleIndex="0" SelectAllCheckboxMode="AllPages" ShowSelectCheckbox="True" Width="50px" Visible="true" />
                         <dx:GridViewDataColumn FieldName="ID" Caption="ID" VisibleIndex="1" Width="80px" Visible="true" />
                         <dx:GridViewDataColumn FieldName="JobID" Caption="JobID" VisibleIndex="2" Width="90px" Visible="false" />
                         <dx:GridViewDataColumn FieldName="DataSourceInstanceID" Caption="DSIID" VisibleIndex="3" Width="100px" Visible="false" />
                         <dx:GridViewDataColumn FieldName="LineNumber" Caption="Line #" VisibleIndex="4" Width="80px" Visible="true" />
                         <dx:GridViewDataColumn FieldName="Exclude" Caption="Exclude" VisibleIndex="5" Width="90px" Visible="true" />
                         <dx:GridViewDataColumn FieldName="FlexeraID" Caption="FlexeraID" VisibleIndex="6" Width="100px" Visible="false" />
                         <dx:GridViewDataTextColumn FieldName="DataSource" Caption="DataSource" VisibleIndex="7" Width="150px" Visible="false" />
                         <dx:GridViewDataTextColumn FieldName="ListName" Caption="ListName" VisibleIndex="8" Width="250px" Visible="true" />
                         <dx:GridViewDataTextColumn FieldName="Value" VisibleIndex="9" Width="620px" Visible="true" />
                         <dx:GridViewDataColumn FieldName="Status" VisibleIndex="10" Width="90px" Visible="true" />
                      </Columns>
                      <Toolbars>
                         <dx:GridViewToolbar>
                            <SettingsAdaptivity Enabled="true" EnableCollapseRootItemsToIcons="true" />
                            <Items>
                               <dx:GridViewToolbarItem Command="Refresh" BeginGroup="true" AdaptivePriority="1" Visible="true"/>
                               <dx:GridViewToolbarItem Command="Edit" BeginGroup="false" AdaptivePriority="2" Visible="false" Enabled="true"/>
                               <dx:GridViewToolbarItem Command="Delete" BeginGroup="false" AdaptivePriority="3" Visible="false" Enabled="true"/>

                               <dx:GridViewToolbarItem Command="ShowFilterRow" BeginGroup="true" AdaptivePriority="4"/>
                               <dx:GridViewToolbarItem Command="ShowCustomizationWindow" BeginGroup="false" AdaptivePriority="5"/>
                               	
                               <dx:GridViewToolbarItem Text="Export to" Image-IconID="actions_download_16x16office2013" BeginGroup="true" AdaptivePriority="6">
                                   <Items>
                                       <dx:GridViewToolbarItem Command="ExportToCsv" />
                                       <dx:GridViewToolbarItem Command="ExportToXlsx" Text="Export to XLSX" />
                                   </Items>
                               </dx:GridViewToolbarItem>                    	

                               <dx:GridViewToolbarItem Name="CustomExcludeRecord" Text="Exclude" BeginGroup="true" AdaptivePriority="7" Enabled="false" />
                               <dx:GridViewToolbarItem Name="CustomIncludeRecord" Text="Include" BeginGroup="false" AdaptivePriority="7" Enabled="false" /> 
                               	
                               <dx:GridViewToolbarItem Alignment="Right" BeginGroup="true" AdaptivePriority="1">
                                   <Template>
                                       <dx:ASPxButtonEdit ID="tbxDatasetToolbarSearch" runat="server" NullText="Search..." Height="100%">
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
                      <SettingsPager PageSize="10" AlwaysShowPager="True" EllipsisMode="OutsideNumeric" EnableAdaptivity="True">
                          <PageSizeItemSettings Visible="True"></PageSizeItemSettings>
                      </SettingsPager>
                      <Settings ShowFilterBar="Auto" ShowFilterRow="False" ShowFilterRowMenu="True" ShowHeaderFilterButton="False" 
                          ShowGroupedColumns="True" ShowPreview="True" VerticalScrollBarMode="Hidden" HorizontalScrollBarMode="Auto" /> 
                      <SettingsResizing ColumnResizeMode="Control" />                                               
                      <SettingsBehavior AllowClientEventsOnLoad="False"  AllowSelectSingleRowOnly="True" AllowSelectByRowClick="True" AllowFocusedRow="True" EnableCustomizationWindow="true" AllowEllipsisInText="False" AllowDragDrop="True" />
                      <SettingsExport EnableClientSideExportAPI="true" ExportSelectedRowsOnly="False" />
                      <SettingsSearchPanel Visible="true" ShowApplyButton="True" ShowClearButton="True" CustomEditorID="tbxDatasetToolbarSearch" />                      	      	                      	
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
                              <dx:GridViewLayoutGroup ColCount="4" GroupBoxDecoration="None">
                                  <Items>
                                      <dx:GridViewColumnLayoutItem ColumnName="ID" Caption="ID" ShowCaption="false">
                                        <Template>
                                           <dx:ASPxLabel ID="idLabel" runat="server" Width="60%" Text='<%# "ID: " + Convert.ToString(Eval("ID")) %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>
                                      
                                      <dx:GridViewColumnLayoutItem ColumnName="JobID" Caption="JobID" ShowCaption="false">
                                        <Template>
                                           <dx:ASPxLabel ID="jobidLabel" runat="server" Width="80%" Text='<%# "JobID: " + Convert.ToString(Eval("JobID")) %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>
                                      
                                      <dx:GridViewColumnLayoutItem ColumnName="DataSourceInstanceID" Caption="DSIID" ShowCaption="false" ColumnSpan="2">
                                        <Template>
                                           <dx:ASPxLabel ID="dsiidLabel" runat="server" Width="80%" Text='<%# "DataSourceInstanceID: " + Convert.ToString(Eval("DataSourceInstanceID")) %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>

                                      <dx:GridViewColumnLayoutItem ColumnName="Exclude" Caption="Exclude" ShowCaption="true" ColumnSpan="1">
                                        <Template>
                                           <dx:ASPxComboBox ID="excludeComboBox" DropDownStyle="DropDown" runat="server" Width="25%" Value='<%# Bind("Exclude") %>'>
                                              <Items>
                                                 <dx:ListEditItem Value="Yes" Text="Yes" />                                                     
                                                 <dx:ListEditItem Value="No" Text="No" />
                                              </Items>
                                             </dx:ASPxComboBox>                                           	                                      	
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>

                                      <dx:GridViewColumnLayoutItem ColumnName="LineNumber" Caption="Line#" ShowCaption="true">
                                        <Template>
                                           <dx:ASPxTextBox ID="lineNumberTextBox" runat="server" Width="50%" Text='<%# Bind("LineNumber") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>

                                      <dx:GridViewColumnLayoutItem ColumnName="FlexeraID" Caption="FlexeraID" ColumnSpan="1">
                                        <Template>
                                           <dx:ASPxTextBox ID="flexidTextBox" runat="server" Width="50%" Text='<%# Bind("FlexeraID") %>' />
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
                                                                        
                                      <dx:GridViewColumnLayoutItem ColumnName="Value" Caption="Value" ColumnSpan="4">
                                        <Template>
                                           <dx:ASPxTextBox ID="valueTextBox" runat="server" Width="95%" Text='<%# Bind("Value") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>
                                      
                                      <dx:GridViewColumnLayoutItem ColumnName="Status" Caption="Status" ColumnSpan="2">
                                        <Template>
                                           <%--<dx:ASPxTextBox ID="statusTextBox" runat="server" Width="50%" Text='<%# Bind("Status") %>' />--%>
                                           <dx:ASPxComboBox ID="statusComboBox" DropDownStyle="DropDown" runat="server" Width="50%" Value='<%# Bind("Status") %>'>
                                              <Items>
                                                  <dx:ListEditItem Value="0" Text="0-Loaded" />
                                                  <dx:ListEditItem Value="1" Text="1-Static" />                                                     
                                                  <dx:ListEditItem Value="2" Text="2-Hidden" />
                                                  <dx:ListEditItem Value="3" Text="3-Remove" />
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
           **** SPREADSHEET VIEW TABPAGE
           --%>

           <dx:TabPage Text="Spreadsheet" Visible="false">
              <ContentCollection>
                  <dx:ContentControl ID="MainContentControl2" runat="server">
                  
                  </dx:ContentControl>
             </ContentCollection>                                    
           </dx:TabPage>
                   
       </TabPages>
   </dx:ASPxPageControl>

   <%--
   **** CALLBACK CONTROLS
   --%>
      
   <dx:ASPxCallback ID="ASPxActionsCallback" runat="server" ClientInstanceName="actionsCallback" OnCallback="ASPxActionsCallback_Callback">
       <ClientSideEvents CallbackComplete="OnActionsCallbackComplete" />
   </dx:ASPxCallback>
        
   <%--
   **** LOADING PANEL  
   --%>

   <dx:ASPxLoadingPanel ID="LoadingPanel" runat="server" ClientInstanceName="LoadingPanel"
       Modal="true">
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
