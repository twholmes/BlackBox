<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="Support.master" CodeBehind="Log.aspx.cs" Inherits="BlackBox.HistoryLogsPage" Title="BlackBox" %>

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
                           <dx:ASPxHyperLink ID="TopHelpHyperLink" runat="server" NavigateUrl="~/Home.aspx" Text="Support" Font-Bold="True" Font-Size="Large" Border-BorderStyle="None" Border-BorderWidth="8px" />
                           <dx:ASPxLabel ID="ASPxLabel1" runat="server" Text=">"></dx:ASPxLabel>
                           <dx:ASPxLabel ID="BreadcrumbsLabel" runat="server" Text="Logs" Font-Bold="True" Font-Size="Large" Width="280px" />
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

    
    <%--
    **** RIGHT PANEL TAB PAGES
    --%>    

    <dx:ASPxPageControl ID="TabPagesRightPanel" Width="100%" runat="server" ActiveTabIndex="0" EnableHierarchyRecreation="True" >
       <TabPages>          
           <%--
           **** LOGFILES TABPAGE
           --%>

           <dx:TabPage Text="Log Files" Visible="true">
              <ContentCollection>
                  <dx:ContentControl ID="RightPanelContentControl1" runat="server">    
           
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
   **** CONTENT TABS
   --%>
   
   <dx:ASPxPageControl ID="TabPagesMainPanel" Width="100%" runat="server" ActiveTabIndex="0" EnableHierarchyRecreation="True" >
       <TabPages>

       <%--
       **** HISTORY TABPAGE
       --%>

       <dx:TabPage Text="History">
          <ContentCollection>
              <dx:ContentControl ID="MainContentControl1" runat="server">
              <br/>

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
                      <dx:GridViewDataTextColumn FieldName="ID" Caption="ID" VisibleIndex="1" Width="60px" Visible="true" />
                      <dx:GridViewDataTextColumn FieldName="Object" Caption="Object" VisibleIndex="2" Width="180px" Visible="true" />
                      <dx:GridViewDataTextColumn FieldName="RefID" Caption="RefID" VisibleIndex="3" Width="60px" Visible="true" />
                      <dx:GridViewDataTextColumn FieldName="UserID" Caption="UserID" VisibleIndex="4" Width="60px" Visible="true" />
                      <dx:GridViewDataTextColumn FieldName="User" Caption="User" VisibleIndex="5" Width="120px" Visible="true" />
                      <dx:GridViewDataTextColumn FieldName="ActorID" Caption="ActorID" VisibleIndex="6" Width="70px" Visible="true" />
                      <dx:GridViewDataTextColumn FieldName="Action" Caption="Action" VisibleIndex="7" Width="120px" Visible="true" />
                      <dx:GridViewDataTextColumn FieldName="Message" Caption="Message" VisibleIndex="8" Width="600px" Visible="true" />
                      <dx:GridViewDataTextColumn FieldName="TimeStamp" Caption="TimeStamp" VisibleIndex="9" Width="180px" Visible="true" />                           
                  </Columns>
                  <SettingsPager PageSize="10" AlwaysShowPager="True" EllipsisMode="OutsideNumeric" EnableAdaptivity="True">
                      <PageSizeItemSettings Visible="True"></PageSizeItemSettings>
                  </SettingsPager>
                  <SettingsSearchPanel Visible="true" ShowApplyButton="True" ShowClearButton="True" CustomEditorID="tbxSettingsToolbarSearch" />                  
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
