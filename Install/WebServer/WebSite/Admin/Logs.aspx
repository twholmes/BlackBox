<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="Admin.master" CodeBehind="Log.aspx.cs" Inherits="BlackBox.ProcessLogsPage" Title="BlackBox" %>

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
      case "Unknown":
          break;
      case "PageMenuLogs":
          //openUrlFromPage("Examine.ashx?fileset=logs&filename=BlackBox.log", true);      
          break;
    }
  }

  // //////////////////////////////////
  // process summary grid functions
  // //////////////////////////////////

  // process summary grid toolbar functions  
  function OnGridViewProcessSummaryToolbarItemClick(s, e) 
  {
    if (e.item.name == 'CustomInspectStaged')
    {
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

  // process summary gridview functions
  function OnGridViewProcessSummaryInit(s, e) 
  { 
    var toolbar = gridViewProcessSummary.GetToolbar(0);  
    if (toolbar != null) 
    {  
      //var btSubmit = toolbar.Items["CustomSubmitStaged"];  btSubmit.enabled = false;
    }
  }
    
  function OnGridViewProcessSummarySelectionChanged(s, e) 
  {
    e.processOnServer=true;
    e.usePostBack=true;
  }
 
  function OnGridViewProcessSummaryFocusedRowChanged(s, e)
  {
    var fri = gridViewProcessSummary.GetFocusedRowIndex();
    gridViewProcessSummary.GetRowValues(fri, 'ProcessID,StatusID', OnGetProcessSummaryFocusedRowValues);
    gridViewProcessSummary.Refresh();    
  }

  function OnGetProcessSummaryFocusedRowValues(values)
  {
    var pid = values[0];
    var sid = values[1];
  }

  // //////////////////////////////////
  // process steps grid functions
  // //////////////////////////////////

  // process steps grid toolbar functions  
  function OnGridViewProcessStepsToolbarItemClick(s, e) 
  {
    if (e.item.name == 'CustomInspectStaged')
    {
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

  // process steps gridview functions
  function OnGridViewProcessStepsInit(s, e) 
  { 
    var toolbar = gridViewProcessSteps.GetToolbar(0);  
    if (toolbar != null) 
    {  
      //var btSubmit = toolbar.Items["CustomSubmitStaged"];  btSubmit.enabled = false;
    }
  }
    
  function OnGridViewProcessStepsSelectionChanged(s, e) 
  {
    e.processOnServer=true;
    e.usePostBack=true;
  }
 
  function OnGridViewProcessStepsFocusedRowChanged(s, e)
  {
    var fri = gridViewProcessSteps.GetFocusedRowIndex();
    gridViewProcessSteps.GetRowValues(fri, 'ProcessStepID,Status', OnGetProcessStepsFocusedRowValues);
    gridViewProcessSteps.Refresh();    
  }

  function OnGetProcessStepsFocusedRowValues(values)
  {
    var psid = values[0];
    var sid = values[1];
  }

  // ////////////////////////////
  // validation grid functions
  // ////////////////////////////

  // validations grid toolbar functions  
  function OnGridViewProcessDetailsToolbarItemClick(s, e) 
  {
    if (e.item.name == 'CustomInspectStaged')
    {
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

  // validations gridview functions
  function OnGridViewProcessDetailsInit(s, e) 
  { 
    var toolbar = gridViewProcessDetails.GetToolbar(0);  
    if (toolbar != null) 
    {  
      //var btSubmit = toolbar.Items["CustomSubmitStaged"];  btSubmit.enabled = false;
    }
  }
    
  function OnGridViewProcessDetailsSelectionChanged(s, e) 
  {
    e.processOnServer=true;
    e.usePostBack=true;
  }
 
  function OnGridViewProcessDetailsFocusedRowChanged(s, e)
  {
    var fri = gridViewProcessDetails.GetFocusedRowIndex();
    gridViewProcessDetails.GetRowValues(fri, 'ProcessID,StatusID', OnGetValidationsFocusedRowValues);
    gridViewProcessDetails.Refresh();    
  }

  function OnGetValidationsFocusedRowValues(values)
  {
    var pid = values[0];
    var sid = values[1];
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

  window.OnGridViewProcessSummaryInit = OnGridViewProcessSummaryInit;
  window.OnGridViewProcessSummarySelectionChanged = OnGridViewProcessSummarySelectionChanged;
  window.OnGridViewProcessSummaryFocusedRowChanged = OnGridViewProcessSummaryFocusedRowChanged;  
  window.OnGridViewProcessSummaryToolbarItemClick = OnGridViewProcessSummaryToolbarItemClick;    

  window.OnGridViewProcessStepsInit = OnGridViewProcessStepsInit;
  window.OnGridViewProcessStepsSelectionChanged = OnGridViewProcessStepsSelectionChanged;
  window.OnGridViewProcessStepsFocusedRowChanged = OnGridViewProcessStepsFocusedRowChanged;  
  window.OnGridViewProcessStepsToolbarItemClick = OnGridViewProcessStepsToolbarItemClick;    

  window.OnGridViewProcessDetailsInit = OnGridViewProcessDetailsInit;
  window.OnGridViewProcessDetailsSelectionChanged = OnGridViewProcessDetailsSelectionChanged;
  window.OnGridViewProcessDetailsFocusedRowChanged = OnGridViewProcessDetailsFocusedRowChanged;  
  window.OnGridViewProcessDetailsToolbarItemClick = OnGridViewProcessDetailsToolbarItemClick;    

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
                           <dx:ASPxHyperLink ID="TopHelpHyperLink" runat="server" NavigateUrl="~/Admin.aspx" Text="Admin" Font-Bold="True" Font-Size="Large" Border-BorderStyle="None" Border-BorderWidth="8px" />
                           <dx:ASPxLabel ID="ASPxLabel1" runat="server" Text=">"></dx:ASPxLabel>
                           <dx:ASPxLabel ID="BreadcrumbsLabel" runat="server" Text="Process Logs" Font-Bold="True" Font-Size="Large" Width="280px" />
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
          <dx:MenuItem Name="PageMenuSessionLog" NavigateUrl="~/Examine.ashx" Target="_blank" Text="Session log" Alignment="Right" AdaptivePriority="2">
               <Image IconID="diagramicons_showprintpreview_svg_dark_16x16" />
          </dx:MenuItem>
          <dx:MenuItem Name="PageMenuLogs" NavigateUrl="~/Examine.ashx?fileset=logs&filename=BlackBox.log" Target="_blank" Text="BlackBox log" Alignment="Right" AdaptivePriority="3">
               <Image IconID="diagramicons_showprintpreview_svg_dark_16x16" />
          </dx:MenuItem>
          <dx:MenuItem Alignment="Right" AdaptivePriority="4">  
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

    <dx:ASPxPageControl ID="TabPagesRightPanel" Width="100%" runat="server" ActiveTabIndex="0" EnableHierarchyRecreation="True" >
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
           **** LOGFILES TABPAGE
           --%>

           <dx:TabPage Text="Log Files" Visible="true">
              <ContentCollection>
                  <dx:ContentControl ID="RightPanelContentControl2" runat="server">    
           
                  <dx:ASPxFileManager runat="server" ID="fileManager" ClientInstanceName="fileManager" OnFolderCreating="FileManager_FolderCreating"
                      OnItemDeleting="FileManager_ItemDeleting" OnItemMoving="FileManager_ItemMoving" OnCustomThumbnail="OnFileManagerCustomThumbnails"
                      OnItemRenaming="FileManager_ItemRenaming" OnFileUploading="FileManager_FileUploading" OnFilesUploaded="FileManager_FilesUploaded" 
                      OnItemCopying="FileManager_ItemCopying">
                      <Settings RootFolder="~/Logs" ThumbnailFolder="~/Resources/Thumbnails" 
                          AllowedFileExtensions=".log"
                          InitialFolder="~/Logs" />
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
    <%--
    **** CONTENT PANEL DATA SOURCES
    --%> 
  
   <asp:SqlDataSource ID="SqlBlackBoxProcessSummary" runat="server" 
      ConnectionString="<%$ ConnectionStrings:BlackBoxConnectionString %>" 
      SelectCommand="SELECT TOP(100) [ProcessID],[ProcessName],[JobID],[DatasetName],[DataSourceInstanceID],[Action],[StartDate],[EndDate],[Status],[Total],[Excluded],[Processed],[Result],[UserID] FROM [dbo].[BlackBoxProcessSummaryLog] ORDER BY [ProcessID] DESC"
      InsertCommand="INSERT INTO [dbo].[BlackBoxProcessSummaryLog] ([ProcessName],[JobID],[DatasetName],[DataSourceInstanceID],[Action],[StartDate],[EndDate],[Status],[Total],[Excluded],[Processed],[Result],[UserID]) VALUES(@processname,@jobid,@dataset,@dsiid,@action,@start,@end,@statusid,@total,@excluded,@processed,@results,@userid)"
      UpdateCommand="UPDATE [dbo].[BlackBoxProcessSummaryLog] ([ProcessName]=@processname,[JobID]=@jobid,[DatasetName]=@dataset,[DataSourceInstanceID]=@dsiid,[Action]=@action,[StartDate]=@start,[EndDate]=@end,[Status]=@statusid,[Total]=@total,[Excluded]=@excluded,[Processed]=@processed,[Result]=@results,[UserID]=@userid WHERE [ProcessID] = @pid"      
      DeleteCommand="DELETE FROM [dbo].[BlackBoxProcessSummaryLog] WHERE [ProcessID] = @pid">
      <%--OnSelecting="SqlBlackBoxProcessSummary_Selecting">--%>
       <SelectParameters>
           <asp:QueryStringParameter DefaultValue="0" Name="userid" QueryStringField="UserID" Type="Int32" />
       </SelectParameters>
      <InsertParameters>
          <asp:QueryStringParameter Name="pid" />       
          <asp:QueryStringParameter Name="processname" />
          <asp:QueryStringParameter Name="jobid" />
          <asp:QueryStringParameter Name="dataset" />
          <asp:QueryStringParameter Name="dsiid" />
          <asp:QueryStringParameter Name="action" />
          <asp:QueryStringParameter Name="start" />
          <asp:QueryStringParameter Name="end" />
          <asp:QueryStringParameter Name="statusid" />
          <asp:QueryStringParameter Name="total" />
          <asp:QueryStringParameter Name="excluded" />
          <asp:QueryStringParameter Name="processed" />
          <asp:QueryStringParameter Name="results" />
          <asp:QueryStringParameter Name="userid" />           
      </InsertParameters>
      <UpdateParameters>
          <asp:QueryStringParameter Name="pid" />       
          <asp:QueryStringParameter Name="processname" />
          <asp:QueryStringParameter Name="jobid" />
          <asp:QueryStringParameter Name="dataset" />
          <asp:QueryStringParameter Name="dsiid" />
          <asp:QueryStringParameter Name="action" />
          <asp:QueryStringParameter Name="start" />
          <asp:QueryStringParameter Name="end" />
          <asp:QueryStringParameter Name="statusid" />
          <asp:QueryStringParameter Name="total" />
          <asp:QueryStringParameter Name="excluded" />
          <asp:QueryStringParameter Name="processed" />
          <asp:QueryStringParameter Name="results" />
          <asp:QueryStringParameter Name="userid" />           
      </UpdateParameters>
      <DeleteParameters>
          <asp:QueryStringParameter Name="pid" />
      </DeleteParameters>
   </asp:SqlDataSource>

   <asp:SqlDataSource ID="SqlBlackBoxProcessSteps" runat="server" 
      ConnectionString="<%$ ConnectionStrings:BlackBoxConnectionString %>" 
      SelectCommand="SELECT TOP(500) [ProcessStepID],[ProcessStepName],[ProcessID],[JobID],[DatasetName],[DataSourceInstanceID],[StartDate],[EndDate],[Status],[Total],[Excluded]
           ,[Processed],[Matched],[Errors],[Warnings],[Updated],[Created],[Deleted] FROM [dbo].[BlackBoxProcessStepLog] ORDER BY [ProcessStepID] DESC"

      InsertCommand="INSERT INTO [dbo].[BlackBoxProcessStepLog] ([ProcessStepName],[ProcessID],[JobID],[DatasetName],[DataSourceInstanceID],[StartDate],[EndDate],[Status],[Total],[Excluded]
           ,[Processed],[Matched],[Errors],[Warnings],[Updated],[Created],[Deleted]) 
           VALUES(@stepname,@pid,@jobid,@dataset,@dsiid,@start,@end,@statusid,@total,@excluded,@processed,@matched,@errors,@warnings,@updated,@created,@deleted)"
           
      UpdateCommand="UPDATE [dbo].[BlackBoxProcessStepLog] ([ProcessStepName]=@stepname,[ProcessID]=@pid,[JobID]=@jobid,[DatasetName]=@dataset,[DataSourceInstanceID]=@dsiid,[StartDate]=@start
           ,[EndDate]=@end,[Status]=@statusid,[Total]=@total,[Excluded]=@excluded,[Processed]=@processed,[Matched]=@matched,[Errors]=@errors,[Warnings]=@warnings,[Updated]=@updated
           ,[Created]=@created,[Deleted]=@deleted WHERE [ProcessStepID] = @psid"
      
      DeleteCommand="DELETE FROM [dbo].[BlackBoxProcessStepLog] WHERE [ProcessStepID] = @psid">
      <%--OnSelecting="SqlBlackBoxProcessSteps_Selecting">--%>
       <SelectParameters>
           <asp:QueryStringParameter DefaultValue="0" Name="userid" QueryStringField="UserID" Type="Int32" />
       </SelectParameters>
      <InsertParameters>
          <asp:QueryStringParameter Name="stepname" />
          <asp:QueryStringParameter Name="pid" />       
          <asp:QueryStringParameter Name="jobid" />
          <asp:QueryStringParameter Name="dataset" />
          <asp:QueryStringParameter Name="dsiid" />
          <asp:QueryStringParameter Name="start" />
          <asp:QueryStringParameter Name="end" />
          <asp:QueryStringParameter Name="statusid" />
          <asp:QueryStringParameter Name="total" />
          <asp:QueryStringParameter Name="excluded" />
          <asp:QueryStringParameter Name="processed" />
          <asp:QueryStringParameter Name="matched" />
          <asp:QueryStringParameter Name="errors" />
          <asp:QueryStringParameter Name="warnings" />
          <asp:QueryStringParameter Name="updated" />
          <asp:QueryStringParameter Name="created" />
          <asp:QueryStringParameter Name="deleted" />
      </InsertParameters>
      <UpdateParameters>
          <asp:QueryStringParameter Name="psid" />
          <asp:QueryStringParameter Name="stepname" />
          <asp:QueryStringParameter Name="pid" />       
          <asp:QueryStringParameter Name="jobid" />
          <asp:QueryStringParameter Name="dataset" />
          <asp:QueryStringParameter Name="dsiid" />
          <asp:QueryStringParameter Name="start" />
          <asp:QueryStringParameter Name="end" />
          <asp:QueryStringParameter Name="statusid" />
          <asp:QueryStringParameter Name="total" />
          <asp:QueryStringParameter Name="excluded" />
          <asp:QueryStringParameter Name="processed" />
          <asp:QueryStringParameter Name="matched" />
          <asp:QueryStringParameter Name="errors" />
          <asp:QueryStringParameter Name="warnings" />
          <asp:QueryStringParameter Name="updated" />
          <asp:QueryStringParameter Name="created" />
          <asp:QueryStringParameter Name="deleted" />
      </UpdateParameters>
      <DeleteParameters>
          <asp:QueryStringParameter Name="psid" />
      </DeleteParameters>
   </asp:SqlDataSource>

   <asp:SqlDataSource ID="SqlBlackBoxProcessDetails" runat="server" 
      ConnectionString="<%$ ConnectionStrings:BlackBoxConnectionString %>"     
      SelectCommand="SELECT TOP(100) [ProcessDetailID],[ProcessStepID],[JobID],[DatasetName],[DataSourceInstanceID],[Action],[RecordNumber],[Item],[Result],[RecordKey],[RecordDescription],[Message] FROM [dbo].[BlackBoxProcessDetailLog] ORDER BY [ProcessDetailID] DESC"
      InsertCommand="INSERT INTO [dbo].[BlackBoxProcessDetailLog] ([ProcessStepID],[JobID],[DatasetName],[DataSourceInstanceID],[Action],[RecordNumber],[Item],[Result],[RecordKey],[RecordDescription],[Message]) VALUES(@psid,@jobid,@dataset,@dsiid,@action,@recnum,@item,@result,@reckey,@description,@message)"
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
   **** CONTENT TABS
   --%>
   
   <dx:ASPxPageControl ID="TabPagesMainPanel" Width="100%" runat="server" ActiveTabIndex="0" EnableHierarchyRecreation="True" >
       <TabPages>

       <%--
       **** PROCESS SUMMARY TABPAGE
       --%>

       <dx:TabPage Text="Process Summary">
          <ContentCollection>
              <dx:ContentControl ID="MainContentControl1" runat="server">
              <br/>

              <dx:ASPxGridView ID="ProcessSummaryGridView" runat="server" ClientInstanceName="gridViewProcessSummary" DataSourceID="SqlBlackBoxProcessSummary" KeyFieldName="ProcessID"
                OnRowCommand="ProcessSummaryGridView_RowCommand" OnSelectionChanged="ProcessSummaryGridView_SelectionChanged"
                OnInitNewRow="ProcessSummaryGridView_InitNewRow" OnRowInserting="ProcessSummaryGridView_RowInserting" OnRowUpdating="ProcessSummaryGridView_RowUpdating" OnRowDeleting="ProcessSummaryGridView_RowDeleting"
                OnCustomCallback="ProcessSummaryGridView_CustomCallback" OnToolbarItemClick="ProcessSummaryGridView_ToolbarItemClick"
                EnableTheming="True" EnableViewState="False" AutoGenerateColumns="False" Width="95%">
                <Toolbars>
                    <dx:GridViewToolbar>
                        <SettingsAdaptivity Enabled="true" EnableCollapseRootItemsToIcons="true" />
                        <Items>
                            <dx:GridViewToolbarItem Command="Refresh" />
                            <dx:GridViewToolbarItem Command="ShowFilterRow" BeginGroup="true" AdaptivePriority="1"/>
                            <dx:GridViewToolbarItem Command="ShowCustomizationWindow" AdaptivePriority="2"/>
                  
                            <dx:GridViewToolbarItem Text="Export to" Image-IconID="actions_download_16x16office2013" BeginGroup="true" AdaptivePriority="3">
                                <Items>
                                    <dx:GridViewToolbarItem Command="ExportToCsv" />
                                    <dx:GridViewToolbarItem Command="ExportToXlsx" Text="Export to XLSX" />
                                </Items>
                                <Image IconID="actions_download_16x16office2013"></Image>
                            </dx:GridViewToolbarItem>
          	
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
                      <dx:GridViewDataTextColumn FieldName="ProcessID" VisibleIndex="1" Width="80px" Visible="true" />
                      <dx:GridViewDataTextColumn FieldName="ProcessName" VisibleIndex="2" Width="180px" Visible="true" />
                      <dx:GridViewDataTextColumn FieldName="JobID" VisibleIndex="3" Width="100px" Visible="true" />
                      <dx:GridViewDataTextColumn FieldName="DatasetName" VisibleIndex="4" Width="200px" Visible="true" />
                      <dx:GridViewDataTextColumn FieldName="DataSourceInstanceID" Caption="DSIID" VisibleIndex="5" Width="100px" Visible="true" />
                      <dx:GridViewDataTextColumn FieldName="Action" VisibleIndex="6" Width="120px" Visible="true" />
                      <dx:GridViewDataTextColumn FieldName="StartDate" VisibleIndex="7" Width="150px" Visible="false" />
                      <dx:GridViewDataTextColumn FieldName="EndDate" VisibleIndex="8" Width="150px" Visible="false" />
                      <dx:GridViewDataTextColumn FieldName="Status" VisibleIndex="9" Width="80px" Visible="true" />
                      <dx:GridViewDataTextColumn FieldName="Total" VisibleIndex="10" Width="80px" Visible="false" />
                      <dx:GridViewDataTextColumn FieldName="Excluded" VisibleIndex="11" Width="80px" Visible="false" />
                      <dx:GridViewDataTextColumn FieldName="Processed" VisibleIndex="12" Width="80px" Visible="false" />
                      <dx:GridViewDataTextColumn FieldName="Result" Caption="Results" VisibleIndex="13" Width="680px" Visible="true" />                           
                      <dx:GridViewDataTextColumn FieldName="UserID" VisibleIndex="14" Width="80px" Visible="true" />                            
                  </Columns>
                  <SettingsPager PageSize="10" AlwaysShowPager="True" EllipsisMode="OutsideNumeric" EnableAdaptivity="True">
                      <PageSizeItemSettings Visible="True"></PageSizeItemSettings>
                  </SettingsPager>
                  <SettingsSearchPanel Visible="true" ShowApplyButton="True" ShowClearButton="True" CustomEditorID="tbSettingsToolbarSearch" />                  
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
                                  <dx:GridViewColumnLayoutItem ColumnName="ProcessID" Caption="ProcessID">
                                    <Template>
                                       <dx:ASPxLabel ID="pidLabel" runat="server" Width="40%" Text='<%# Bind("ProcessID") %>' />
                                    </Template>
                                  </dx:GridViewColumnLayoutItem>
                                  <dx:GridViewColumnLayoutItem ColumnName="UserID" Caption="UserID">
                                    <Template>
                                       <dx:ASPxLabel ID="useridLabel" runat="server" Width="40%" Text='<%# Bind("UserID") %>' />
                                    </Template>
                                  </dx:GridViewColumnLayoutItem>
                                  
                                  <dx:GridViewColumnLayoutItem ColumnName="ProcessName" Caption="Name" ColumnSpan="2">
                                    <Template>
                                       <dx:ASPxTextBox ID="procNameTextBox" runat="server" Width="80%" Text='<%# Bind("ProcessName") %>' />
                                    </Template>
                                  </dx:GridViewColumnLayoutItem>

                                  <dx:GridViewColumnLayoutItem ColumnName="JobID" Caption="JobID">
                                    <Template>
                                       <dx:ASPxLabel ID="procJobIdLabel" runat="server" Width="40%" Text='<%# Bind("JobID") %>' />
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
                                       <dx:ASPxTextBox ID="procActionTextBox" runat="server" Width="80%" Text='<%# Bind("Action") %>' />
                                    </Template>
                                  </dx:GridViewColumnLayoutItem>
                                 
                                  <dx:GridViewColumnLayoutItem ColumnName="StartDate" Caption="Start">
                                    <Template>
                                       <dx:ASPxTextBox ID="procStartDateTextBox" runat="server" Width="180%" Text='<%# Bind("StartDate") %>' />
                                    </Template>
                                  </dx:GridViewColumnLayoutItem>
                                  <dx:GridViewColumnLayoutItem ColumnName="EndDate" Caption="End">
                                    <Template>
                                       <dx:ASPxTextBox ID="procEndDateTextBox" runat="server" Width="180%" Text='<%# Bind("EndDate") %>' />
                                    </Template>
                                  </dx:GridViewColumnLayoutItem>

                                  <dx:GridViewColumnLayoutItem ColumnName="Status" Caption="Status" ColumnSpan="1">
                                    <Template>
                                       <dx:ASPxTextBox ID="procStatusTextBox" runat="server" Width="80%" Text='<%# Bind("Status") %>' />
                                    </Template>
                                  </dx:GridViewColumnLayoutItem>

                                  <dx:GridViewColumnLayoutItem ColumnName="Total" Caption="Total">
                                    <Template>
                                       <dx:ASPxTextBox ID="procTotalTextBox" runat="server" Width="80%" Text='<%# Bind("Total") %>' />
                                    </Template>
                                  </dx:GridViewColumnLayoutItem>
                                  <dx:GridViewColumnLayoutItem ColumnName="Excluded" Caption="Excluded">
                                    <Template>
                                       <dx:ASPxTextBox ID="procExcludedTextBox" runat="server" Width="80%" Text='<%# Bind("Excluded") %>' />
                                    </Template>
                                  </dx:GridViewColumnLayoutItem>
                                  <dx:GridViewColumnLayoutItem ColumnName="Processed" Caption="Processed">
                                    <Template>
                                       <dx:ASPxTextBox ID="procProcessedTextBox" runat="server" Width="80%" Text='<%# Bind("ProcesseExcluded") %>' />
                                    </Template>
                                  </dx:GridViewColumnLayoutItem>

                                  <dx:GridViewColumnLayoutItem ColumnName="Result" Caption="Results" ColumnSpan="2">
                                    <Template>
                                       <dx:ASPxTextBox ID="procResultTextBox" runat="server" Width="480%" Text='<%# Bind("Result") %>' />
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
                  <ClientSideEvents Init="OnGridViewProcessSummaryInit" SelectionChanged="OnGridViewProcessSummarySelectionChanged" FocusedRowChanged="OnGridViewProcessSummaryFocusedRowChanged" 
                    ToolbarItemClick="OnGridViewProcessSummaryToolbarItemClick" />
              </dx:ASPxGridView>

              </dx:ContentControl>
         </ContentCollection>                                    
       </dx:TabPage>

       <%--
       **** PROCESS STEPS TABPAGE
       --%>

       <dx:TabPage Text="Process Steps">
          <ContentCollection>
              <dx:ContentControl ID="MainContentControl2" runat="server">
              <br/>

              <dx:ASPxGridView ID="ProcessStepsGridView" runat="server" ClientInstanceName="gridViewProcessSteps" DataSourceID="SqlBlackBoxProcessSteps" KeyFieldName="ProcessStepID"
                OnRowCommand="ProcessStepsGridView_RowCommand" OnSelectionChanged="ProcessStepsGridView_SelectionChanged"
                OnInitNewRow="ProcessStepsGridView_InitNewRow" OnRowInserting="ProcessStepsGridView_RowInserting" OnRowUpdating="ProcessStepsGridView_RowUpdating" OnRowDeleting="ProcessStepsGridView_RowDeleting"
                OnCustomCallback="ProcessStepsGridView_CustomCallback" OnToolbarItemClick="ProcessStepsGridView_ToolbarItemClick"
                EnableTheming="True" EnableViewState="False" AutoGenerateColumns="False" Width="95%">
                <Toolbars>
                    <dx:GridViewToolbar>
                        <SettingsAdaptivity Enabled="true" EnableCollapseRootItemsToIcons="true" />
                        <Items>
                            <dx:GridViewToolbarItem Command="Refresh" />
                            <dx:GridViewToolbarItem Command="ShowFilterRow" BeginGroup="true" AdaptivePriority="1"/>
                            <dx:GridViewToolbarItem Command="ShowCustomizationWindow" AdaptivePriority="2"/>
                            <dx:GridViewToolbarItem Name="CustomValidationDetails" Text="Details" BeginGroup="true" Enabled="false" />                                  
                  
                            <dx:GridViewToolbarItem Text="Export to" Image-IconID="actions_download_16x16office2013" BeginGroup="true" AdaptivePriority="3">
                                <Items>
                                    <dx:GridViewToolbarItem Command="ExportToCsv" />
                                    <dx:GridViewToolbarItem Command="ExportToXlsx" Text="Export to XLSX" />
                                </Items>
                                <Image IconID="actions_download_16x16office2013"></Image>
                            </dx:GridViewToolbarItem>
          	
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
                      <dx:GridViewDataTextColumn FieldName="ProcessID" VisibleIndex="1" Width="80px" Visible="true" />                          	
                      <dx:GridViewDataTextColumn FieldName="JobID" VisibleIndex="2" Width="100px" Visible="true" />
                      <dx:GridViewDataTextColumn FieldName="ProcessStepID" Caption="StepID" VisibleIndex="3" Width="90px" Visible="true" />
                      <dx:GridViewDataTextColumn FieldName="ProcessStepName" Caption="StepName" VisibleIndex="4" Width="180px" Visible="true" />
                      <dx:GridViewDataTextColumn FieldName="DatasetName" VisibleIndex="5" Width="200px" Visible="true" />
                      <dx:GridViewDataTextColumn FieldName="DataSourceInstanceID" Caption="DSIID" VisibleIndex="6" Width="100px" Visible="true" />                          	
                      <dx:GridViewDataTextColumn FieldName="StartDate" VisibleIndex="7" Width="150px" Visible="false" />
                      <dx:GridViewDataTextColumn FieldName="EndDate" VisibleIndex="8" Width="150px" Visible="false" />
                      <dx:GridViewDataTextColumn FieldName="Status" VisibleIndex="9" Width="80px" Visible="true" />
                      <dx:GridViewDataTextColumn FieldName="Total" VisibleIndex="10" Width="80px" Visible="true" />
                      <dx:GridViewDataTextColumn FieldName="Excluded" VisibleIndex="11" Width="80px" Visible="true" />
                      <dx:GridViewDataTextColumn FieldName="Processed" VisibleIndex="12" Width="80px" Visible="true" />
                      <dx:GridViewDataTextColumn FieldName="Matched" VisibleIndex="13" Width="80px" Visible="true" />
                      <dx:GridViewDataTextColumn FieldName="Errors" VisibleIndex="14" Width="80px" Visible="true" />
                      <dx:GridViewDataTextColumn FieldName="Warnings" VisibleIndex="15" Width="80px" Visible="true" />
                      <dx:GridViewDataTextColumn FieldName="Updated" VisibleIndex="16" Width="80px" Visible="true" />
                      <dx:GridViewDataTextColumn FieldName="Created" VisibleIndex="17" Width="80px" Visible="true" />
                      <dx:GridViewDataTextColumn FieldName="Deleted" VisibleIndex="18" Width="80px" Visible="true" />
                  </Columns>
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
                                  <dx:GridViewColumnLayoutItem ColumnName="ProcessID" Caption="ProcessID">
                                    <Template>
                                       <dx:ASPxLabel ID="pidLabel" runat="server" Width="40%" Text='<%# Bind("ProcessID") %>' />
                                    </Template>
                                  </dx:GridViewColumnLayoutItem>
                                  <dx:GridViewColumnLayoutItem ColumnName="JobID" Caption="JobID">
                                    <Template>
                                       <dx:ASPxLabel ID="procJobIdLabel" runat="server" Width="40%" Text='<%# Bind("JobID") %>' />
                                    </Template>
                                  </dx:GridViewColumnLayoutItem>

                                  <dx:GridViewColumnLayoutItem ColumnName="ProcessStepID" Caption="ProcessStepID">
                                    <Template>
                                       <dx:ASPxLabel ID="psidLabel" runat="server" Width="40%" Text='<%# Bind("ProcessStepID") %>' />
                                    </Template>
                                  </dx:GridViewColumnLayoutItem>

                                  <dx:GridViewColumnLayoutItem ColumnName="Status" Caption="Status" ColumnSpan="1">
                                    <Template>
                                       <dx:ASPxTextBox ID="procStatusTextBox" runat="server" Width="80%" Text='<%# Bind("Status") %>' />
                                    </Template>
                                  </dx:GridViewColumnLayoutItem>

                                  <dx:GridViewColumnLayoutItem ColumnName="ProcessStepName" Caption="StepName" ColumnSpan="2">
                                    <Template>
                                       <dx:ASPxTextBox ID="procNameTextBox" runat="server" Width="80%" Text='<%# Bind("ProcessStepName") %>' />
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
                                 
                                  <dx:GridViewColumnLayoutItem ColumnName="StartDate" Caption="Start">
                                    <Template>
                                       <dx:ASPxTextBox ID="procStartDateTextBox" runat="server" Width="180%" Text='<%# Bind("StartDate") %>' />
                                    </Template>
                                  </dx:GridViewColumnLayoutItem>
                                  <dx:GridViewColumnLayoutItem ColumnName="EndDate" Caption="End">
                                    <Template>
                                       <dx:ASPxTextBox ID="procEndDateTextBox" runat="server" Width="180%" Text='<%# Bind("EndDate") %>' />
                                    </Template>
                                  </dx:GridViewColumnLayoutItem>

                                  <dx:GridViewColumnLayoutItem ColumnName="Total" Caption="Total">
                                    <Template>
                                       <dx:ASPxTextBox ID="procTotalTextBox" runat="server" Width="80%" Text='<%# Bind("Total") %>' />
                                    </Template>
                                  </dx:GridViewColumnLayoutItem>
                                  <dx:GridViewColumnLayoutItem ColumnName="Excluded" Caption="Excluded">
                                    <Template>
                                       <dx:ASPxTextBox ID="procExcludedTextBox" runat="server" Width="80%" Text='<%# Bind("Excluded") %>' />
                                    </Template>
                                  </dx:GridViewColumnLayoutItem>
                                  <dx:GridViewColumnLayoutItem ColumnName="Processed" Caption="Processed">
                                    <Template>
                                       <dx:ASPxTextBox ID="procProcessedTextBox" runat="server" Width="80%" Text='<%# Bind("Processed") %>' />
                                    </Template>
                                  </dx:GridViewColumnLayoutItem>

                                  <dx:GridViewColumnLayoutItem ColumnName="Matched" Caption="Matched">
                                    <Template>
                                       <dx:ASPxTextBox ID="procMatchedTextBox" runat="server" Width="80%" Text='<%# Bind("Matched") %>' />
                                    </Template>
                                  </dx:GridViewColumnLayoutItem>
                                  <dx:GridViewColumnLayoutItem ColumnName="Errors" Caption="Errors">
                                    <Template>
                                       <dx:ASPxTextBox ID="procErrorsTextBox" runat="server" Width="80%" Text='<%# Bind("Errors") %>' />
                                    </Template>
                                  </dx:GridViewColumnLayoutItem>
                                  <dx:GridViewColumnLayoutItem ColumnName="Warnings" Caption="Warnings">
                                    <Template>
                                       <dx:ASPxTextBox ID="procWarningsTextBox" runat="server" Width="80%" Text='<%# Bind("Warnings") %>' />
                                    </Template>
                                  </dx:GridViewColumnLayoutItem>

                                  <dx:GridViewColumnLayoutItem ColumnName="Updated" Caption="Updated">
                                    <Template>
                                       <dx:ASPxTextBox ID="procUpdatedTextBox" runat="server" Width="80%" Text='<%# Bind("Updated") %>' />
                                    </Template>
                                  </dx:GridViewColumnLayoutItem>
                                  <dx:GridViewColumnLayoutItem ColumnName="Created" Caption="Created">
                                    <Template>
                                       <dx:ASPxTextBox ID="procCreatedTextBox" runat="server" Width="80%" Text='<%# Bind("Created") %>' />
                                    </Template>
                                  </dx:GridViewColumnLayoutItem>
                                  <dx:GridViewColumnLayoutItem ColumnName="Deleted" Caption="Deleted">
                                    <Template>
                                       <dx:ASPxTextBox ID="procDeletedTextBox" runat="server" Width="80%" Text='<%# Bind("Deleted") %>' />
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
                  <ClientSideEvents Init="OnGridViewProcessStepsInit" SelectionChanged="OnGridViewProcessStepsSelectionChanged" FocusedRowChanged="OnGridViewProcessStepsFocusedRowChanged" 
                    ToolbarItemClick="OnGridViewProcessStepsToolbarItemClick" />
              </dx:ASPxGridView>

              </dx:ContentControl>
         </ContentCollection>                                    
       </dx:TabPage>

       <%--
       **** PROCESS DETAILS TABPAGE
       --%>

       <dx:TabPage Text="Process Details">
          <ContentCollection>
              <dx:ContentControl ID="MainContentControl3" runat="server">
              <br/>

              <dx:ASPxGridView ID="ProcessDetailsGridView" runat="server" ClientInstanceName="gridViewProcessDetails" DataSourceID="SqlBlackBoxProcessDetails" KeyFieldName="ProcessDetailID"
                OnRowCommand="ProcessDetailsGridView_RowCommand" OnSelectionChanged="ProcessDetailsGridView_SelectionChanged"
                OnInitNewRow="ProcessDetailsGridView_InitNewRow" OnRowInserting="ProcessDetailsGridView_RowInserting" OnRowUpdating="ProcessDetailsGridView_RowUpdating" OnRowDeleting="ProcessDetailsGridView_RowDeleting"
                OnCustomCallback="ProcessDetailsGridView_CustomCallback" OnToolbarItemClick="ProcessDetailsGridView_ToolbarItemClick"
                EnableTheming="True" EnableViewState="False" AutoGenerateColumns="False" Width="95%">
                <Toolbars>
                    <dx:GridViewToolbar>
                        <SettingsAdaptivity Enabled="true" EnableCollapseRootItemsToIcons="true" />
                        <Items>
                            <dx:GridViewToolbarItem Command="Refresh" />
                            <dx:GridViewToolbarItem Command="ShowFilterRow" BeginGroup="true" AdaptivePriority="1"/>
                            <dx:GridViewToolbarItem Command="ShowCustomizationWindow" AdaptivePriority="2"/>
                            <dx:GridViewToolbarItem Name="CustomValidationDetails" Text="Details" BeginGroup="true" Enabled="false" />                                  
                  
                            <dx:GridViewToolbarItem Text="Export to" Image-IconID="actions_download_16x16office2013" BeginGroup="true" AdaptivePriority="3">
                                <Items>
                                    <dx:GridViewToolbarItem Command="ExportToCsv" />
                                    <dx:GridViewToolbarItem Command="ExportToXlsx" Text="Export to XLSX" />
                                </Items>
                                <Image IconID="actions_download_16x16office2013"></Image>
                            </dx:GridViewToolbarItem>
          	
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
                      <dx:GridViewDataTextColumn FieldName="ProcessDetailID" VisibleIndex="1" Width="80px" Visible="true" />                          	
                      <dx:GridViewDataTextColumn FieldName="ProcessStepID" VisibleIndex="2" Width="80px" Visible="true" />
                      <dx:GridViewDataTextColumn FieldName="JobID" VisibleIndex="3" Width="100px" Visible="true" />
                      <dx:GridViewDataTextColumn FieldName="DatasetName" VisibleIndex="4" Width="150px" Visible="true" /> 
                      <dx:GridViewDataTextColumn FieldName="DataSourceInstanceID" Caption="DSIID" VisibleIndex="5" Width="60px" Visible="true" />
                      <dx:GridViewDataTextColumn FieldName="Action" VisibleIndex="6" Width="120px" Visible="true" />                          	
                      <dx:GridViewDataTextColumn FieldName="RecordNumber" Caption="RecNum" VisibleIndex="7" Width="80px" Visible="true" />
                      <dx:GridViewDataTextColumn FieldName="Item" VisibleIndex="8" Width="120px" Visible="true" />                          	
                      <dx:GridViewDataTextColumn FieldName="Result" VisibleIndex="9" Width="120px" Visible="true" />
                      <dx:GridViewDataTextColumn FieldName="RecordKey" VisibleIndex="10" Width="150px" Visible="true" />                          	
                      <dx:GridViewDataTextColumn FieldName="RecordDescription" VisibleIndex="11" Width="200px" Visible="true" />
                      <dx:GridViewDataTextColumn FieldName="Message" VisibleIndex="12" Width="500px" Visible="true" />	
                  </Columns>
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
                                  
                                  <dx:GridViewColumnLayoutItem ColumnName="RecordNumber" Caption="RecordNumber">
                                    <Template>
                                       <dx:ASPxTextBox ID="recnumTextBox" runat="server" Width="90%" Text='<%# Bind("RecordNumber") %>' />
                                    </Template>
                                  </dx:GridViewColumnLayoutItem>
                                  
                                  <dx:GridViewColumnLayoutItem ColumnName="Result" Caption="Result">
                                    <Template>
                                       <dx:ASPxTextBox ID="procActionTextBox" runat="server" Width="80%" Text='<%# Bind("Result") %>' />
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
                  <ClientSideEvents Init="OnGridViewProcessDetailsInit" SelectionChanged="OnGridViewProcessDetailsSelectionChanged" FocusedRowChanged="OnGridViewProcessDetailsFocusedRowChanged" 
                    ToolbarItemClick="OnGridViewProcessDetailsToolbarItemClick" />
              </dx:ASPxGridView>

              </dx:ContentControl>
         </ContentCollection>                                    
       </dx:TabPage>
           
       </TabPages>

   </dx:ASPxPageControl>
     
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


</asp:Content>
