<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="Support.master" CodeBehind="Validations.aspx.cs" Inherits="BlackBox.ValicationsPage" Title="BlackBox" %>

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

  // /////////////////////////////
  // actions callback functions
  // /////////////////////////////
         
  function OnActionsCallbackComplete(s, e) 
  {
    var result = e.result;
    //gridViewUploadedFiles.Refresh();    
    LoadingPanel.Hide();
  }
  
  // ///////////////////////
  // popup functions
  // ///////////////////////

  // test timeout
  function OnTimeout(s, e) 
  {
	  var alive = '<%= Session["HeartBeat"] %>';
	  if (alive != "true")
	  {
      tbReason.SetText("The session has timed out. Please reauthenticate");        
      pcBlock.Show();
      btBlockConfirm.Focus();  		
    }
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
       
  
  // ////////////////////////////
  // validation grid functions
  // ////////////////////////////

  // validations grid toolbar functions  
  function OnGridViewValidationResultsToolbarItemClick(s, e) 
  {
    if (IsCustomGridViewToolbarCommand(e.item.name)) 
    {
      e.processOnServer=true;
      e.usePostBack=true;
    }
  }

  // validations gridview functions
  function OnGridViewValidationResultsInit(s, e) 
  { 
    var toolbar = gridViewValidationResults.GetToolbar(0);  
    if (toolbar != null) 
    {  
      //var btSubmit = toolbar.Items["CustomSubmitStaged"];  btSubmit.enabled = false;
    }
  }
    
  function OnGridViewValidationResultsSelectionChanged(s, e) 
  {
    e.processOnServer=true;
    e.usePostBack=true;
  }
 
  function OnGridViewValidationResultsFocusedRowChanged(s, e)
  {
    var fri = gridViewValidationResults.GetFocusedRowIndex();
    gridViewValidationResults.GetRowValues(fri, 'ProcessID,StatusID', OnGetValidationsFocusedRowValues);
    gridViewValidationResults.Refresh();    
  }

  function OnGetValidationsFocusedRowValues(values)
  {
    var pid = values[0];
    var sid = values[1];
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
      case "CustomDownloadFile":      
          isCustom = true;
          break;
          
      case "CustomOpenFile":      
          //openUrlWithParamFromPage("../Spreadsheet.aspx", true);
          //isCustom = true;
          break;

      case "CustomInspectStagedSiteAuditAssetList":
      case "CustomInspectStagedSIA":
          //isCustom = true;
          break;
           
      case "CustomStageFile":      
      case "CustomValidateStaged":
          LoadingPanel.Show();      
          isCustom = true;
          break;

      case "CustomSubmitStaged":
      case "CustomRecallStaged":   
          LoadingPanel.Show();         
          isCustom = true;
          break;
      
      case "CustomProcessStaged":
          LoadingPanel.Show();         
          isCustom = true;
          break;

      case "CustomWithdrawStaged":     
      case "CustomArchiveStaged":
          //LoadingPanel.Show();      
          isCustom = false;
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
 
  // open url in new tab or existing tab
  function openUrlWithParamFromPage(baseurl, fid, newtab) 
  {
    //var fid = hfStateValues.Get("FID")    
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

  window.OnGridViewValidationResultsInit = OnGridViewValidationResultsInit;
  window.OnGridViewValidationResultsSelectionChanged = OnGridViewValidationResultsSelectionChanged;
  window.OnGridViewValidationResultsFocusedRowChanged = OnGridViewValidationResultsFocusedRowChanged;  
  window.OnGridViewValidationResultsToolbarItemClick = OnGridViewValidationResultsToolbarItemClick;    

  window.OnGridViewValidationListsInit = OnGridViewValidationListsInit;
  window.OnGridViewValidationListsSelectionChanged = OnGridViewValidationListsSelectionChanged;
  window.OnGridViewValidationListsFocusedRowChanged = OnGridViewValidationListsFocusedRowChanged;  
  window.OnGridViewValidationListsToolbarItemClick = OnGridViewValidationListsToolbarItemClick;    

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
                           <dx:ASPxHyperLink ID="BreadcrumbsHyperLink" runat="server" NavigateUrl="~/Home.aspx" Text="Support" Font-Bold="True" Font-Size="Large" Border-BorderStyle="None" Border-BorderWidth="8px" />
                           <dx:ASPxLabel ID="BreadcrumbsSpacer" runat="server" Text=">"></dx:ASPxLabel>
                           <dx:ASPxLabel ID="BreadcrumbsLabel" ClientIDMode="Static" runat="server" Text="Validations" Font-Bold="True" Font-Size="Large" Width="300px" />
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

    <asp:SqlDataSource ID="SqlSysValidationLists" runat="server" 
      ConnectionString="<%$ ConnectionStrings:BlackBoxConnectionString %>"     
      SelectCommand="SELECT [ID],[JobID],[DataSourceInstanceID],[LineNumber],[FlexeraID],[DataSource],[ListName],[Value],[Status] FROM [dbo].[stagedValidationLists] WHERE [DataSource] = 'AssetCriticality' AND ([Status]=0 OR [Status]=1)" 
      InsertCommand="INSERT INTO [dbo].[stagedValidationLists] ([JobID],[DataSourceInstanceID],[LineNumber],[FlexeraID],[DataSource],[ListName],[Value],[Status]) VALUES(@JobID,@DataSourceInstanceID,@LineNumber,@FlexeraID,@DataSource,@ListName,@Value,@Status)"
      UpdateCommand="UPDATE [dbo].[stagedValidationLists] SET [JobID]=@JobID,[DataSourceInstanceID]=@DataSourceInstanceID,[LineNumber]=@LineNumber,[FlexeraID]=@FlexeraID,[DataSource]=@DataSource,[ListName]=@ListName,[Value]=@Value,[Status]=@Status WHERE [ID]=@ID"
      DeleteCommand="DELETE FROM [dbo].[stagedValidationLists] WHERE [ID] = @ID">
      <InsertParameters>
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
          <asp:QueryStringParameter Name="ID" />
      </DeleteParameters>
    </asp:SqlDataSource>
   
    <asp:SqlDataSource ID="SqlActionHistory" runat="server" 
      ConnectionString="<%$ ConnectionStrings:BlackBoxConnectionString %>"     
      SelectCommand="SELECT TOP 1000 [ID],[Object],[RefID],[UserID],[User],[SAMAccountName],[ActorID],[Action],[Message],[TimeStamp] FROM [dbo].[vBlackBoxHistory]"
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

    <dx:ASPxPageControl ID="TabPagesRightPanel" Width="100%" runat="server" ActiveTabIndex="0" EnableHierarchyRecreation="true" >
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
                    EnableTheming="True" EnableViewState="False" AutoGenerateColumns="False" Width="98%">
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
                                  	
                                <dx:GridViewToolbarItem Alignment="Right" BeginGroup="true" AdaptivePriority="2">
                                    <Template>
                                        <dx:ASPxButtonEdit ID="tbxHistoryToolbarSearch" runat="server" NullText="Search..." Height="100%">
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
                          <dx:GridViewCommandColumn VisibleIndex="0" SelectAllCheckboxMode="AllPages" ShowSelectCheckbox="True" Width="50px" Visible="false" />
                          <dx:GridViewDataTextColumn FieldName="ID" Caption="ID" VisibleIndex="1" Width="60px" Visible="true" />
                          <dx:GridViewDataTextColumn FieldName="Object" Caption="Object" VisibleIndex="2" Width="120px" Visible="false" />
                          <dx:GridViewDataTextColumn FieldName="RefID" Caption="FID" VisibleIndex="3" Width="60px" Visible="true" />
                          <dx:GridViewDataTextColumn FieldName="UserID" Caption="UserID" VisibleIndex="4" Width="60px" Visible="false" />
                          <dx:GridViewDataTextColumn FieldName="User" Caption="UserName" VisibleIndex="5" Width="120px" Visible="false" />
                          <dx:GridViewDataTextColumn FieldName="SAMAccountName" Caption="User" VisibleIndex="6" Width="90px" Visible="true" />                          	
                          <dx:GridViewDataTextColumn FieldName="ActorID" Caption="ActorID" VisibleIndex="7" Width="70px" Visible="false" />
                          <dx:GridViewDataTextColumn FieldName="Action" Caption="Action" VisibleIndex="8" Width="80px" Visible="true" />
                          <dx:GridViewDataTextColumn FieldName="Message" Caption="Message" VisibleIndex="9" Width="200px" Visible="true" />
                          <dx:GridViewDataTextColumn FieldName="TimeStamp" Caption="TimeStamp" VisibleIndex="10" Width="110px" Visible="true" />                           
                      </Columns>
                      <SettingsPager PageSize="7" AlwaysShowPager="True" EllipsisMode="OutsideNumeric" EnableAdaptivity="True">
                          <PageSizeItemSettings Visible="True"></PageSizeItemSettings>
                      </SettingsPager>
                      <Settings ShowFilterBar="Auto" ShowFilterRow="False" ShowFilterRowMenu="True" ShowHeaderFilterButton="False" 
                        ShowGroupedColumns="True" ShowPreview="True" VerticalScrollBarMode="Hidden" HorizontalScrollBarMode="Auto" /> 
                      <SettingsResizing ColumnResizeMode="Control" />                                               
                      <SettingsBehavior AllowClientEventsOnLoad="False"  AllowSelectSingleRowOnly="True" AllowSelectByRowClick="True" AllowFocusedRow="True" EnableCustomizationWindow="true" AllowEllipsisInText="False" AllowDragDrop="True" />
                      <SettingsExport EnableClientSideExportAPI="true" ExportSelectedRowsOnly="False" />
                      <SettingsSearchPanel Visible="true" ShowApplyButton="True" ShowClearButton="True" CustomEditorID="tbxHistoryToolbarSearch" />                      	
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
           **** VALIDATION LISTS TABPAGE
           --%>

           <dx:TabPage Text="Validation Lists" Visible="true">
              <ContentCollection>
                  <dx:ContentControl ID="RightPanelContentControl2" runat="server">

                  <dx:ASPxGridView ID="ValidationListsGridView" runat="server" ClientInstanceName="gridViewValidationLists" DataSourceID="SqlSysValidationLists" KeyFieldName="ID"
                    OnRowCommand="ValidationListsGridView_RowCommand" OnSelectionChanged="ValidationListsGridView_SelectionChanged"
                    OnInitNewRow="ValidationListsGridView_InitNewRow" 
                    OnRowInserting="ValidationListsGridView_RowInserting" OnRowUpdating="ValidationListsGridView_RowUpdating" OnRowDeleting="ValidationListsGridView_RowDeleting"
                    OnCustomCallback="ValidationListsGridView_CustomCallback" OnToolbarItemClick="ValidationListsGridView_ToolbarItemClick"
                    EnableTheming="True" EnableViewState="False" AutoGenerateColumns="False" Width="95%">
                    <Toolbars>
                        <dx:GridViewToolbar>
                            <SettingsAdaptivity Enabled="true" EnableCollapseRootItemsToIcons="true" />
                            <Items>
                                <dx:GridViewToolbarItem Command="Refresh" BeginGroup="true" AdaptivePriority="1"/>
                                <%--<dx:GridViewToolbarItem Command="New" BeginGroup="true" AdaptivePriority="2"/>--%>
                                <%--<dx:GridViewToolbarItem Command="Edit" AdaptivePriority="3"/>--%>
                                <%--<dx:GridViewToolbarItem Command="Delete" AdaptivePriority="4"/>--%>
                                <dx:GridViewToolbarItem Command="ShowFilterRow" BeginGroup="true" AdaptivePriority="5"/>
                                <dx:GridViewToolbarItem Command="ShowCustomizationWindow" BeginGroup="true" AdaptivePriority="6"/>
                                <dx:GridViewToolbarItem Name="CustomSettingItemSearch" Alignment="Right" BeginGroup="true" AdaptivePriority="5">
                                    <Template>
                                        <dx:ASPxButtonEdit ID="tbSettingsToolbarSearch" runat="server" NullText="Search..." Height="100%">
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
                          <dx:GridViewDataColumn FieldName="ID" Caption="ID" VisibleIndex="1" Width="60px" Visible="true" />
                          <dx:GridViewDataColumn FieldName="JobID" Caption="JobID" VisibleIndex="2" Width="90px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="DataSourceInstanceID" Caption="DSIID" VisibleIndex="3" Width="100px" Visible="false" />
                          <dx:GridViewDataColumn FieldName="FlexeraID" Caption="FlexeraID" VisibleIndex="4" Width="100px" Visible="false" />                               
                          <dx:GridViewDataTextColumn FieldName="DataSource" Caption="DataSource" VisibleIndex="5" Width="120px" Visible="false" />
                          <dx:GridViewDataTextColumn FieldName="ListName" Caption="ListName" VisibleIndex="6" Width="180px" Visible="true" />
                          <dx:GridViewDataTextColumn FieldName="Value" VisibleIndex="7" Width="300px" Visible="true" />
                          <dx:GridViewDataColumn FieldName="Status" VisibleIndex="8" Width="50px" Visible="false" />
                      </Columns>
                      <SettingsSearchPanel Visible="true" ShowApplyButton="True" ShowClearButton="True" CustomEditorID="tbSettingsToolbarSearch" />
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

                                      <dx:GridViewColumnLayoutItem ColumnName="FlexeraID" Caption="FlexeraID" ColumnSpan="1">
                                        <Template>
                                           <dx:ASPxTextBox ID="flexidTextBox" runat="server" Width="60%" Text='<%# Bind("FlexeraID") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>                                     

                                      <dx:GridViewColumnLayoutItem ColumnName="ListName" Caption="ListName" ColumnSpan="2">
                                        <Template>
                                           <dx:ASPxTextBox ID="colnameTextBox" runat="server" Width="50%" Text='<%# Bind("ListName") %>' />                                             
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>                                     

                                      <dx:GridViewColumnLayoutItem ColumnName="DataSource" Caption="DataSource" ColumnSpan="2">
                                        <Template>
                                           <dx:ASPxTextBox ID="listnameTextBox" runat="server" Width="80%" Text='<%# Bind("DataSource") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>
                                                                        
                                      <dx:GridViewColumnLayoutItem ColumnName="Value" Caption="Value" ColumnSpan="2">
                                        <Template>
                                           <dx:ASPxTextBox ID="valueTextBox" runat="server" Width="480%" Text='<%# Bind("Value") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>
                                      
                                      <dx:GridViewColumnLayoutItem ColumnName="Status" Caption="Status">
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
                      <ClientSideEvents Init="OnGridViewValidationListsInit" SelectionChanged="OnGridViewValidationListsSelectionChanged" FocusedRowChanged="OnGridViewValidationListsFocusedRowChanged" 
                        ToolbarItemClick="OnGridViewValidationListsToolbarItemClick" />
                   </dx:ASPxGridView>

                  </dx:ContentControl>
             </ContentCollection>
           </dx:TabPage>
          
           <%--
           **** TEMPLATES TABPAGE
           --%>

           <dx:TabPage Text="Templates" Visible="false">
              <ContentCollection>
                  <dx:ContentControl ID="RightPanelContentControl3" runat="server">    
           
                  <dx:ASPxFileManager runat="server" ID="fileManager" ClientInstanceName="fileManager" OnFolderCreating="FileManager_FolderCreating"
                      OnItemDeleting="FileManager_ItemDeleting" OnItemMoving="FileManager_ItemMoving" OnCustomThumbnail="OnFileManagerCustomThumbnails"
                      OnItemRenaming="FileManager_ItemRenaming" OnFileUploading="FileManager_FileUploading" OnFilesUploaded="FileManager_FilesUploaded" 
                      OnItemCopying="FileManager_ItemCopying">
                      <Settings RootFolder="~/Data/templates/RioTinto" ThumbnailFolder="~/Resources/Thumbnails" 
                          AllowedFileExtensions=".csv,.xls,.xlsx"
                          InitialFolder="~/Data/templates/RioTinto" />
                      <SettingsEditing AllowCreate="false" AllowDelete="true" AllowMove="false" AllowRename="true" AllowCopy="true" AllowDownload="true" />
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
  
   <asp:SqlDataSource ID="SqlBlackBoxFiles" runat="server" 
      ConnectionString="<%$ ConnectionStrings:BlackBoxConnectionString %>" 
      SelectCommand="SELECT TOP(100) [FID],[JOBID],[GUID],[Name],[Location],[TypeID],[Type],[Group],[Description],[DataSource],[DataSourceInstanceID],[Datasets],[StatusID],[Status],[Validations],[Locked],[UserID],[SAMAccountName],[TimeStamp],[Age],[Rank] FROM [dbo].[vBlackBoxFilesWithValidation] WHERE [Group] != 'Templates' AND[UserID] = @userid ORDER BY [TimeStamp] DESC"
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

   <asp:SqlDataSource ID="SqlBlackBoxValidationResults" runat="server" 
      ConnectionString="<%$ ConnectionStrings:BlackBoxConnectionString %>"     
      SelectCommand="SELECT TOP(100) [ProcessDetailID],[ProcessStepID],[ProcessName],[ProcessStepName],[JobID],[DatasetName],[DataSourceInstanceID],[Action],[RecordNumber],[Item],[Result],[RecordKey],[RecordDescription],[Message] FROM [dbo].[vBlackBoxProcessingResults] ORDER BY [ProcessDetailID] DESC"
      InsertCommand="INSERT INTO [dbo].[BlackBoxProcessDetailLog] ([ProcessStepID],[JobID],[DatasetName],[DataSourceInstanceID],[Action],[RecordNumber],{Item],[Result],[RecordKey],[RecordDescription],[Message]) VALUES(@psid,@jobid,@dataset,@dsiid,@action,@recnum,@item,@result,@reckey,@description,@message)" 
      UpdateCommand="UPDATE [dbo].[BlackBoxProcessDetailLog] ([ProcessStepID]=@psid,[JobID]=@jobid,[DatasetName]=@dataset,[DataSourceInstanceID]=@dsiid,[Action]=@action,[RecordNumber]=@recnum,[Item]=@item,[Result]=@result,[RecordKey]=@reckey,[RecordDescription]=@decription,[Message]=@message WHERE [ProcessDetailID] = @pdid"
      DeleteCommand="DELETE FROM [dbo].[BlackBoxProcessDetailLog] WHERE [ProcessDetailID] = @pdid">
      <%--OnSelecting="SqlBlackBoxProcessSteps_Selecting">--%>
       <SelectParameters>
           <asp:QueryStringParameter DefaultValue="0" Name="userid" QueryStringField="UserID" Type="Int32" />
       </SelectParameters>
      <InsertParameters>
          <asp:QueryStringParameter Name="psid" />
          <asp:QueryStringParameter Name="jobid" />
          <asp:QueryStringParameter Name="dataset" />
          <asp:QueryStringParameter Name="dsiid" />
          <asp:QueryStringParameter Name="action" />
          <asp:QueryStringParameter Name="recnum" />
          <asp:QueryStringParameter Name="item" />            
          <asp:QueryStringParameter Name="result" />
          <asp:QueryStringParameter Name="reckey" />
          <asp:QueryStringParameter Name="description" />
          <asp:QueryStringParameter Name="message" />
      </InsertParameters>
      <UpdateParameters>
          <asp:QueryStringParameter Name="pdid" />
          <asp:QueryStringParameter Name="psid" />
          <asp:QueryStringParameter Name="jobid" />
          <asp:QueryStringParameter Name="dataset" />
          <asp:QueryStringParameter Name="dsiid" />
          <asp:QueryStringParameter Name="action" />          	
          <asp:QueryStringParameter Name="recnum" />
          <asp:QueryStringParameter Name="item" />
          <asp:QueryStringParameter Name="result" />
          <asp:QueryStringParameter Name="reckey" />
          <asp:QueryStringParameter Name="description" />
          <asp:QueryStringParameter Name="message" />
      </UpdateParameters>
      <DeleteParameters>
          <asp:QueryStringParameter Name="pdid" />
      </DeleteParameters>
   </asp:SqlDataSource>
        
   <%--
   **** HIDDEN PAGES
   --%>

   <dx:ASPxHiddenField runat="server" ID="StateValues" ClientInstanceName="hfStateValues" />
       
   <%--
   **** TABBED PAGES
   --%>

   <dx:ASPxPageControl ID="mainTabPages" Width="100%" ClientInstanceName="mainTabPages" runat="server" ActiveTabIndex="0" EnableHierarchyRecreation="True" >
       <TabPages>       
           <%--
           **** VALIDATION RESULTS TABPAGE
           --%>

           <dx:TabPage Text="Validation Results">
              <ContentCollection>
                  <dx:ContentControl ID="MainContentControl1" runat="server">
                  <br/>

                  <dx:ASPxGridView ID="ValidationResultsGridView" runat="server" ClientInstanceName="gridViewValidationResults" DataSourceID="SqlBlackBoxValidationResults" KeyFieldName="ProcessDetailID"
                    OnRowCommand="ValidationResultsGridView_RowCommand" OnSelectionChanged="ValidationResultsGridView_SelectionChanged"
                    OnInitNewRow="ValidationResultsGridView_InitNewRow" OnRowInserting="ValidationResultsGridView_RowInserting" OnRowUpdating="ValidationResultsGridView_RowUpdating" OnRowDeleting="ValidationResultsGridView_RowDeleting"
                    OnCustomCallback="ValidationResultsGridView_CustomCallback" OnToolbarItemClick="ValidationResultsGridView_ToolbarItemClick"
                    EnableTheming="True" EnableViewState="False" AutoGenerateColumns="False" Width="95%">
                    <Toolbars>
                        <dx:GridViewToolbar>
                            <SettingsAdaptivity Enabled="true" EnableCollapseRootItemsToIcons="true" />
                            <Items>
                                <dx:GridViewToolbarItem Command="Refresh" />
                                <dx:GridViewToolbarItem Command="ShowFilterRow" BeginGroup="true" AdaptivePriority="1"/>
                                <dx:GridViewToolbarItem Command="ShowCustomizationWindow" BeginGroup="true" AdaptivePriority="2"/>

                                 <dx:GridViewToolbarItem Text="Export to" Image-IconID="actions_download_16x16office2013" BeginGroup="true" AdaptivePriority="3">
                                     <Items>
                                         <dx:GridViewToolbarItem Command="ExportToCsv" />
                                         <dx:GridViewToolbarItem Command="ExportToXlsx" Text="Export to XLSX" />
                                     </Items>
                                     <Image IconID="actions_download_16x16office2013"></Image>
                                 </dx:GridViewToolbarItem>
                                 
                                <dx:GridViewToolbarItem Name="CustomSettingItemSearch" Alignment="Right" BeginGroup="true" AdaptivePriority="4">                                  
                                    <Template>
                                        <dx:ASPxButtonEdit ID="tbxSettingsToolbarSearch" runat="server" NullText="Search..." Height="100%">
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
                          <dx:GridViewDataTextColumn FieldName="ProcessDetailID" Caption="PDID" VisibleIndex="1" Width="60px" Visible="true" />                           
                          <dx:GridViewDataTextColumn FieldName="ProcessStepID" Caption="PSID" VisibleIndex="2" Width="60px" Visible="false" />
                          <dx:GridViewDataTextColumn FieldName="ProcessName" VisibleIndex="3" Width="100px" Visible="false" />
                          <dx:GridViewDataTextColumn FieldName="ProcessStepName" Caption="Step Name" VisibleIndex="4" Width="160px" Visible="true" />
                          <dx:GridViewDataTextColumn FieldName="JobID" VisibleIndex="5" Width="80px" Visible="false" />
                          <dx:GridViewDataTextColumn FieldName="DatasetName" VisibleIndex="6" Width="140px" Visible="true" /> 
                          <dx:GridViewDataTextColumn FieldName="DataSourceInstanceID" Caption="DSIID" VisibleIndex="7" Width="90px" Visible="true" /> 
                          <dx:GridViewDataTextColumn FieldName="Action" Caption="Action" VisibleIndex="8" Width="70px" Visible="false" />
                          <dx:GridViewDataTextColumn FieldName="RecordNumber" Caption="Record #" VisibleIndex="9" Width="80px" Visible="true" />
                          <dx:GridViewDataTextColumn FieldName="Result" VisibleIndex="10" Width="80px" Visible="true" />
                          <dx:GridViewDataTextColumn FieldName="Item" VisibleIndex="11" Width="200px" Visible="true" />                           
                          <dx:GridViewDataTextColumn FieldName="RecordKey" VisibleIndex="12" Width="180px" Visible="true" />                            
                          <dx:GridViewDataTextColumn FieldName="RecordDescription" VisibleIndex="13" Width="300px" Visible="false" />
                          <dx:GridViewDataTextColumn FieldName="Message" VisibleIndex="14" Width="500px" Visible="true" />  
                      </Columns>
                      <SettingsSearchPanel Visible="true" ShowApplyButton="True" ShowClearButton="True" CustomEditorID="tbxSettingsToolbarSearch" />
                      <SettingsPager PageSize="10" AlwaysShowPager="True" EllipsisMode="OutsideNumeric" EnableAdaptivity="True">
                          <PageSizeItemSettings Visible="True"></PageSizeItemSettings>
                      </SettingsPager>
                      <Settings ShowFilterBar="Auto" ShowFilterRow="False" ShowFilterRowMenu="True" ShowHeaderFilterButton="False" 
                        ShowGroupedColumns="True" ShowPreview="True" VerticalScrollBarMode="Hidden" HorizontalScrollBarMode="Auto" /> 
                      <SettingsResizing ColumnResizeMode="Control" />                                               
                      <SettingsBehavior AllowClientEventsOnLoad="False"  AllowSelectSingleRowOnly="True" AllowSelectByRowClick="True" AllowFocusedRow="False" EnableCustomizationWindow="true" AllowEllipsisInText="False" AllowDragDrop="True" />
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
                                      <dx:GridViewColumnLayoutItem ColumnName="ProcessDetailID" Caption="ProcessDetailID">
                                        <Template>
                                           <dx:ASPxLabel ID="pdidLabel" runat="server" Width="40%" Text='<%# Bind("ProcessDetailID") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>
                                      <dx:GridViewColumnLayoutItem ColumnName="ProcessStepID" Caption="ProcessStepID">
                                        <Template>
                                           <dx:ASPxTextBox ID="psidTextBox" runat="server" Width="50%" Text='<%# Bind("ProcessStepID") %>' />                                             
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>
                                      
                                      <%--
                                      <dx:GridViewColumnLayoutItem ColumnName="ProcessID" Caption="ProcessID">
                                        <Template>
                                           <dx:ASPxTextBox ID="pidTextBox" runat="server" Width="50%" Text='<%# Bind("ProcessID") %>' /> 
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>
                                      --%>                                      

                                      <dx:GridViewColumnLayoutItem ColumnName="JobID" Caption="JobID">
                                        <Template>
                                           <dx:ASPxTextBox ID="jobidTextBox" runat="server" Width="50%" Text='<%# Bind("JobID") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>

                                      <dx:GridViewColumnLayoutItem ColumnName="DatasetName" Caption="Dataset">
                                        <Template>
                                           <dx:ASPxTextBox ID="procDatasetTextBox" runat="server" Width="80%" Text='<%# Bind("DatasetName") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>
                                      <dx:GridViewColumnLayoutItem ColumnName="DataSourceInstanceID" Caption="DataSourceInstanceID">
                                        <Template>
                                           <dx:ASPxTextBox ID="fileSourceIDTextBox" runat="server" Width="80%" Text='<%# Bind("DataSourceInstanceID") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>
                                      
                                      <dx:GridViewColumnLayoutItem ColumnName="Action" Caption="Action">
                                        <Template>
                                           <dx:ASPxTextBox ID="actionTextBox" runat="server" Width="90%" Text='<%# Bind("Action") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>
                                      
                                      <dx:GridViewColumnLayoutItem ColumnName="RecordNumber" Caption="RecordNumber">
                                        <Template>
                                           <dx:ASPxTextBox ID="recnumTextBox" runat="server" Width="90%" Text='<%# Bind("RecordNumber") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>
                                      
                                      <dx:GridViewColumnLayoutItem ColumnName="Item" Caption="Item">
                                        <Template>
                                           <dx:ASPxTextBox ID="procItemTextBox" runat="server" Width="80%" Text='<%# Bind("Item") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>
                                      
                                      <dx:GridViewColumnLayoutItem ColumnName="Result" Caption="Result">
                                        <Template>
                                           <dx:ASPxTextBox ID="procResultTextBox" runat="server" Width="80%" Text='<%# Bind("Result") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>
                                    
                                      <dx:GridViewColumnLayoutItem ColumnName="RecordKey" Caption="Key">
                                        <Template>
                                           <dx:ASPxTextBox ID="keyTextBox" runat="server" Width="120%" Text='<%# Bind("RecordKey") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>

                                      <dx:GridViewColumnLayoutItem ColumnName="RecordDescription" Caption="Description" ColumnSpan="2">
                                        <Template>
                                           <dx:ASPxTextBox ID="descTextBox" runat="server" Width="480%" Text='<%# Bind("RecordDescription") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>

                                      <dx:GridViewColumnLayoutItem ColumnName="Message" Caption="Message" ColumnSpan="2">
                                        <Template>
                                           <dx:ASPxTextBox ID="msgTextBox" runat="server" Width="480%" Text='<%# Bind("Message") %>' />
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
                      <ClientSideEvents Init="OnGridViewValidationResultsInit" SelectionChanged="OnGridViewValidationResultsSelectionChanged" FocusedRowChanged="OnGridViewValidationResultsFocusedRowChanged" 
                        ToolbarItemClick="OnGridViewValidationResultsToolbarItemClick" />
                  </dx:ASPxGridView>

                  </dx:ContentControl>
             </ContentCollection>                                    
           </dx:TabPage>
           
       </TabPages>
       <ClientSideEvents Init="OnPageControlInit" />
   </dx:ASPxPageControl>
        
   <%--
   **** POPUP PANEL
   --%>

   <dx:ASPxPopupControl ID="pcBlock" runat="server" Width="500" ClientInstanceName="pcBlock" HeaderText="Access Rights Check"
       CloseAction="CloseButton" CloseOnEscape="true" Modal="True" EnableViewState="False" AllowDragging="True"
       PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" PopupAnimationType="Fade"
       PopupHorizontalOffset="40" PopupVerticalOffset="40" AutoUpdatePosition="true">
       <ClientSideEvents PopUp="function(s, e) { }" CloseButtonClick="function(s, e) { window.location.reload(); }" />
       <SizeGripImage Width="11px" />
       <ContentCollection>
           <dx:PopupControlContentControl runat="server">
               <dx:ASPxPanel ID="BlockPanel" runat="server" DefaultButton="btBlockConfirm">
                   <PanelCollection>
                       <dx:PanelContent runat="server">
                           <dx:ASPxFormLayout runat="server" ID="BlockFormLayout" Width="100%" Height="100%">
                               <Items>
                                   <dx:LayoutItem Caption="BlackBox">
                                       <LayoutItemNestedControlCollection>
                                           <dx:LayoutItemNestedControlContainer>
                                               <dx:ASPxMemo ID="tbReason" runat="server" Width="350px" Height="100px" MaxLength="200" ReadOnly="True" ClientInstanceName="tbReason"/>
                                           </dx:LayoutItemNestedControlContainer>
                                       </LayoutItemNestedControlCollection>
                                   </dx:LayoutItem>
                                   <dx:LayoutItem ShowCaption="False">
                                       <LayoutItemNestedControlCollection>
                                           <dx:LayoutItemNestedControlContainer>
                                               <dx:ASPxButton ID="btBlockConfirm" runat="server" Text="OK" Width="80px" AutoPostBack="False" Style="float: left; margin-right: 8px">
                                                   <ClientSideEvents Click="function(s, e) { pcBlock.Hide(); window.open('../default.aspx','_self'); }" />
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

   <dx:ASPxPopupControl ID="pcMsg" runat="server" Width="500" CloseAction="CloseButton" CloseOnEscape="true"
       PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" ClientInstanceName="pcMsg"
       HeaderText="Alert" AllowDragging="True" Modal="True" PopupAnimationType="Fade"
       EnableViewState="False" PopupHorizontalOffset="40" PopupVerticalOffset="40" AutoUpdatePosition="true">
       <ClientSideEvents PopUp="function(s, e) { }" CloseButtonClick="function(s, e) { window.location.reload(); }" />
       <SizeGripImage Width="11px" />
       <ContentCollection>
           <dx:PopupControlContentControl runat="server">
               <dx:ASPxPanel ID="pcMsgPanel" runat="server" DefaultButton="btConfirm">
                   <PanelCollection>
                       <dx:PanelContent runat="server">
                           <dx:ASPxFormLayout runat="server" ID="pcMsgFormLayout" Width="100%" Height="100%">
                               <Items>
                                   <dx:LayoutItem Caption="Message">
                                       <LayoutItemNestedControlCollection>
                                           <dx:LayoutItemNestedControlContainer>
                                               <dx:ASPxMemo ID="memoMessage" runat="server" Width="350px" Height="100px" MaxLength="200" ReadOnly="True" ClientInstanceName="memoMessage"/>
                                           </dx:LayoutItemNestedControlContainer>
                                       </LayoutItemNestedControlCollection>
                                   </dx:LayoutItem>
                                   <dx:LayoutItem ShowCaption="False">
                                       <LayoutItemNestedControlCollection>
                                           <dx:LayoutItemNestedControlContainer>
                                               <dx:ASPxButton ID="btConfirm" runat="server" Text="OK" Width="80px" AutoPostBack="False" Style="float: left; margin-right: 8px">
                                                   <ClientSideEvents Click="function(s, e) { pcMsg.Hide(); }" />
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

   <dx:ASPxPopupControl ID="pcAction" runat="server" Width="500" CloseAction="CloseButton" CloseOnEscape="true"
       PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter" ClientInstanceName="pcAction"
       HeaderText="Confirm Action" AllowDragging="True" Modal="True" PopupAnimationType="Fade"
       EnableViewState="False" PopupHorizontalOffset="40" PopupVerticalOffset="40" AutoUpdatePosition="true">
       <ClientSideEvents PopUp="function(s, e) { }" CloseButtonClick="function(s, e) { window.location.reload(); }" />
       <SizeGripImage Width="11px" />
       <ContentCollection>
           <dx:PopupControlContentControl runat="server">
               <dx:ASPxPanel ID="pcActionPanel" runat="server" DefaultButton="btActionCancel">
                   <PanelCollection>
                       <dx:PanelContent runat="server">
                           <dx:ASPxFormLayout runat="server" ID="pcActionFormLayout" Width="100%" Height="100%">
                               <Items>
                                   <dx:LayoutItem Caption="Message" ShowCaption="False">
                                       <LayoutItemNestedControlCollection>
                                           <dx:LayoutItemNestedControlContainer>
                                               <dx:ASPxMemo ID="memoActionMessage" runat="server" Width="350px" Height="40px" MaxLength="200" ReadOnly="True" ClientInstanceName="memoActionMessage"/>
                                           </dx:LayoutItemNestedControlContainer>
                                       </LayoutItemNestedControlCollection>
                                   </dx:LayoutItem>
                                   <dx:LayoutItem ShowCaption="False">
                                       <LayoutItemNestedControlCollection>
                                           <dx:LayoutItemNestedControlContainer>
                                               <dx:ASPxButton ID="btActionCancel" runat="server" Text="Cancel" Width="80px" AutoPostBack="False" Style="float: left; margin-right: 8px">
                                                   <ClientSideEvents Click="function(s, e) { pcAction.Hide(); }" />
                                               </dx:ASPxButton>
                                               <dx:ASPxLabel ID="SpacerLabel1" runat="server" Text="  " />                                               
                                               <dx:ASPxButton ID="btActionConfirm" runat="server" Text="OK" Width="80px" AutoPostBack="False" Style="float: left; margin-right: 8px">
                                                   <ClientSideEvents Click="function(s, e) { pcAction.Hide(); LoadingPanel.Show(); actionsCallback.PerformCallback('archive'); }" />
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
   **** CALLBACK CONTROLS
   --%>
      
   <dx:ASPxCallback ID="ASPxActionsCallback" runat="server" ClientInstanceName="actionsCallback" OnCallback="ASPxActionsCallback_Callback">
       <ClientSideEvents CallbackComplete="OnActionsCallbackComplete" />
   </dx:ASPxCallback>

   <%--
   **** LOADING PANELS
   --%>

   <dx:ASPxLoadingPanel ID="LoadingPanel" runat="server" ClientInstanceName="LoadingPanel" Modal="True" />

   <dx:ASPxLoadingPanel ID="ASPxLoadingPanelMain" ClientInstanceName="ASPxLoadingPanelMain" runat="server" Modal="True" Text="Processing&amp;hellip;" ValidateRequestMode="Disabled">
   </dx:ASPxLoadingPanel>    
   
   <%--
   **** CONTENT DATA SOURCES
   --%>
      
       
</asp:Content>
