<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="Super.master" CodeBehind="Settings.aspx.cs" Inherits="BlackBox.SettingsPage" Title="BlackBox" %>

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
    var enabled = true;
  }
    
  function onPageToolbarItemClick(s, e) 
  {
    switch(e.item.name) 
    {
      case "Dummy":
          break;
      default:
          break;
    }
  }

  // //////////////////////////////////
  // settings grid functions
  // //////////////////////////////////

  // settings grid toolbar functions  
  function OnGridViewSettingsToolbarItemClick(s, e) 
  {
    if (IsCustomGridViewToolbarCommand(e.item.name)) 
    {
      e.processOnServer=true;
      e.usePostBack=true;
    }
  }

  // settings gridview functions
  function OnGridViewSettingsInit(s, e) 
  { 
    var toolbar = gridViewSettings.GetToolbar(0);  
    if (toolbar != null) 
    {  
    }
  }
    
  function OnGridViewSettingsSelectionChanged(s, e) 
  {
    e.processOnServer=true;
    e.usePostBack=true;
  }

  // //////////////////////////////////
  // edit settings grid functions
  // //////////////////////////////////

  // edit settings grid toolbar functions  
  function OnGridViewEditSettingsToolbarItemClick(s, e) 
  {
    if (IsCustomGridViewToolbarCommand(e.item.name)) 
    {
      e.processOnServer=true;
      e.usePostBack=true;
    }
  }

  // edit settings gridview functions
  function OnGridViewEditSettingsInit(s, e) 
  { 
    var toolbar = gridViewEditSettings.GetToolbar(0);  
    if (toolbar != null) 
    {  
    }
  }
    
  function OnGridViewEditSettingsSelectionChanged(s, e) 
  {
    e.processOnServer=true;
    e.usePostBack=true;
  }

  function OnGridViewEditSettingsFocusedRowChanged(s, e) 
  {
    gridViewEditSettings.GetRowValues(gridViewEditSettings.GetFocusedRowIndex(), 'Group;Name;SerializeAs;Value', OnGetRowValues);
  }
  
  function OnGetRowValues(values) 
  {
    formGroupLabel.SetText(values[0]);
    formNameLabel.SetText(values[1]);
    formSerializeAsLabel.SetText(values[2]);    
    formValueTextBox.SetText(values[3]);
    if (values[2] == "bool")
    {
      editFormLayout.GetItemByName("formItemValue").SetVisible(false);
      editFormLayout.GetItemByName("formItemIntValue").SetVisible(false);      
      editFormLayout.GetItemByName("formItemBoolValue").SetVisible(true);
    	//formValueTextBox.SetReadOnly(true);
    	//formIntValueTextBox.SetReadOnly(true);
    	//formValueRadioButtonList.SetReadOnly(false);    	
      formValueRadioButtonList.SetValue(values[3]); 
      formIntValueTextBox.SetText("");
    }
    else if (values[2] == "int")
    {
      editFormLayout.GetItemByName("formItemValue").SetVisible(false);
      editFormLayout.GetItemByName("formItemIntValue").SetVisible(true);      
      editFormLayout.GetItemByName("formItemBoolValue").SetVisible(false);
    	//formValueTextBox.SetReadOnly(true);
    	//formIntValueTextBox.SetReadOnly(false);    	
    	//formValueRadioButtonList.SetReadOnly(false);  
      formValueRadioButtonList.SetValue("");
      formIntValueTextBox.SetText(values[3]);
    }
    else
    {
      editFormLayout.GetItemByName("formItemValue").SetVisible(true);
      editFormLayout.GetItemByName("formItemIntValue").SetVisible(false);      
      editFormLayout.GetItemByName("formItemBoolValue").SetVisible(false);    	
    	//formValueTextBox.SetReadOnly(false);  
    	//formIntValueTextBox.SetReadOnly(true);    	  	
    	//formValueRadioButtonList.SetReadOnly(true);
      formValueRadioButtonList.SetValue("");    	
      formIntValueTextBox.SetText("");          	
    }    	
  }

  // /////////////////////
  // splitter functions
  // /////////////////////
  
  function OnSplitterPaneResized(s, e) 
  {
    var name = e.pane.name;
    if(name == 'gridViewBoxContainer')
    {
      ResizeControl(gridViewEditSettings, e.pane);
    }
    else if(name == 'editFormContainer')
    {
      ResizeControl(editFormLayout, e.pane);
    }
  }
        
  function ResizeControl(control, splitterPane) 
  {
    control.SetWidth(splitterPane.GetClientWidth());
    control.SetHeight(splitterPane.GetClientHeight());
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
      case "CustomImpersonate":
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
  
  window.OnGridViewSettingsInit = OnGridViewSettingsInit;
  window.OnGridViewSettingsSelectionChanged = OnGridViewSettingsSelectionChanged;
  window.OnGridViewSettingsToolbarItemClick = OnGridViewSettingsToolbarItemClick;    
  
  window.OnGridViewEditSettingsInit = OnGridViewEditSettingsInit;
  window.OnGridViewEditSettingsToolbarItemClick = OnGridViewEditSettingsToolbarItemClick;
  window.OnGridViewEditSettingsSelectionChanged = OnGridViewEditSettingsSelectionChanged;
  window.OnGridViewEditSettingsFocusedRowChanged = OnGridViewEditSettingsFocusedRowChanged;

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
                           <dx:ASPxHyperLink ID="TopHelpHyperLink" runat="server" NavigateUrl="~/SuperAdmin.aspx" Text="SuperAdmin" Font-Bold="True" Font-Size="Large" Border-BorderStyle="None" Border-BorderWidth="8px" />
                           <dx:ASPxLabel ID="ASPxLabel1" runat="server" Text=">"></dx:ASPxLabel>
                           <dx:ASPxLabel ID="BreadcrumbsLabel" runat="server" Text="Inspect Settings" Font-Bold="True" Font-Size="Large" Width="480px" />
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
                
    <dx:ASPxPageControl ID="TabPagesRightPanel" Width="100%" runat="server" ActiveTabIndex="0" EnableHierarchyRecreation="True" >
       <TabPages>                                                                                                                                   
           <%--
           **** FILE MANAGER TABPAGE
           --%>
    
           <dx:TabPage Text="File Manager" Visible="true">
              <ContentCollection>
                  <dx:ContentControl ID="ContentControlRight1" runat="server">
    
                  <dx:ASPxFileManager runat="server" ID="fileManager" ClientInstanceName="fileManager" OnFolderCreating="FileManager_FolderCreating"
                      OnItemDeleting="FileManager_ItemDeleting" OnItemMoving="FileManager_ItemMoving" OnCustomThumbnail="OnFileManagerCustomThumbnails"
                      OnItemRenaming="FileManager_ItemRenaming" OnFileUploading="FileManager_FileUploading" OnItemCopying="FileManager_ItemCopying">
                      <Settings RootFolder="~/Data" ThumbnailFolder="~/Resources/Thumbnails" 
                          AllowedFileExtensions=".jpg,.jpeg,.gif,.rtf,.txt,.avi,.png,.mp3,.xml,.doc,.pdf,.html,.log,.csv,.xls,.xlsx,.xml,.sql,.zip"
                          InitialFolder="~/Data" />
                      <SettingsEditing AllowCreate="true" AllowDelete="true" AllowMove="true" AllowRename="true" AllowCopy="true" AllowDownload="true" />
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
    
           <%--
           **** EXTRA TABPAGE
           --%>
    
           <dx:TabPage Text="Extra" Visible="false">
              <ContentCollection>
                  <dx:ContentControl ID="ContentControlRight2" runat="server">    
    
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

    <asp:ObjectDataSource ID="SettingsDataModelSource" runat="server" TypeName="BlackBox.Model.SettingsProvider"
        SelectMethod="GetSettingsGroupsList" InsertMethod="AddNewSetting" UpdateMethod="SetSetting" DeleteMethod="DeleteSetting" 
        OnSelecting="SettingsDataModelSource_Selecting" >
       <SelectParameters>
           <asp:QueryStringParameter DefaultValue="%" Name="Groups" QueryStringField="Groups" Type="String" />
       </SelectParameters>
    </asp:ObjectDataSource>

    <%--
    **** CONTENT TABS
    --%>

    <dx:ASPxPageControl ID="TabPagesMainPanel" Width="100%" runat="server" ActiveTabIndex="0" EnableHierarchyRecreation="True" >
        <TabPages>
           <%--
           **** SETTINGS GRIDVIEW TAB
           --%>
                                                                                                                                                               
           <dx:TabPage Text="Settings">
              <ContentCollection>                              
                  <dx:ContentControl ID="ContentControl1" runat="server">

                  <dx:ASPxGridView runat="server" ID="SettingsGridView" ClientInstanceName="gridViewSettings"
                      KeyFieldName="Group;Name" EnablePagingGestures="False"
                      CssClass="grid-view" Width="100%"
                      DataSourceID="SettingsDataModelSource"
                      OnCustomCallback="SettingsGridView_CustomCallback" OnToolbarItemClick="SettingsGridView_ToolbarItemClick"
                      OnInitNewRow="SettingsGridView_InitNewRow" AutoGenerateColumns="False">
                      <Columns>
                          <dx:GridViewCommandColumn ShowSelectCheckbox="True" SelectAllCheckboxMode="AllPages" VisibleIndex="0" Width="50"></dx:GridViewCommandColumn>
                          <dx:GridViewDataColumn FieldName="Group" Caption="Group" Width="150px" />                               
                          <dx:GridViewDataColumn FieldName="Name" Caption="Name" Width="250px" />
                          <dx:GridViewDataColumn FieldName="SerializeAs" Caption="Type" Visible="true" />
                          <dx:GridViewDataColumn FieldName="Value" Caption="Value" Width="550px" />
                          <dx:GridViewDataColumn FieldName="UpdatedBy" Caption="Updated By" Width="150px" />
                          <dx:GridViewDataColumn FieldName="Updated" Caption="Dated" Width="150px" />
                      </Columns>
                      <Toolbars>
                          <dx:GridViewToolbar Name="settingsToolbar">
                              <SettingsAdaptivity Enabled="true" EnableCollapseRootItemsToIcons="true" />
                              <Items>
                                  <dx:GridViewToolbarItem Command="Refresh" Visible="true" AdaptivePriority="1"/>
                                  <dx:GridViewToolbarItem Command="New" BeginGroup="true" Visible="false" AdaptivePriority="2"/>
                                  <dx:GridViewToolbarItem Command="Edit" Visible="true" AdaptivePriority="3"/>
                                  <dx:GridViewToolbarItem Command="Delete" Visible="false" AdaptivePriority="4"/>
                                  <dx:GridViewToolbarItem Command="ShowFilterRow" BeginGroup="true" AdaptivePriority="6"/>
                                  <dx:GridViewToolbarItem Command="ShowCustomizationWindow" BeginGroup="true" AdaptivePriority="7"/>
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
                      <SettingsSearchPanel Visible="true" ShowApplyButton="True" ShowClearButton="True" CustomEditorID="tbSettingsToolbarSearch" />
                      <SettingsBehavior EnableCustomizationWindow="true" AllowFocusedRow="true" AllowSelectByRowClick="true" AllowEllipsisInText="true" AllowDragDrop="false" />
                      <SettingsEditing Mode="PopupEditForm" EditFormColumnCount="2" />
                      <Settings VerticalScrollBarMode="Hidden" HorizontalScrollBarMode="Auto" ShowHeaderFilterButton="true" />
                      <SettingsPager PageSize="10" EnableAdaptivity="true">
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
                                           <%--<dx:ASPxTextBox ID="groupTextBox" runat="server" Width="80%" Text='<%# Bind("Group") %>' />--%>
                                           <dx:ASPxLabel ID="groupTextBox" runat="server" Width="80%" Text='<%# Bind("Group") %>' />                                            
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>
                 
                                      <dx:GridViewColumnLayoutItem ColumnName="Name">
                                        <Template>
                                           <%--<dx:ASPxTextBox ID="nameTextBox" runat="server" Width="80%" Text='<%# Bind("Name") %>' />--%>
                                           <dx:ASPxLabel ID="nameTextBox" runat="server" Width="80%" Text='<%# Bind("Name") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>
                  
                                      <dx:GridViewColumnLayoutItem ColumnName="Type" Caption="Type">
                                        <Template>
                                           <dx:ASPxLabel ID="typeTextBox" runat="server" Width="60%" Text='<%# Bind("SerializeAs") %>' />
                                           <%--
                                           <dx:ASPxComboBox ID="typeComboBox" DropDownStyle="DropDownList" runat="server" Width="75%" Value='<%# Bind("SerializeAs") %>'>
                                              <Items>
                                                  <dx:ListEditItem Value="string" Text="string" />
                                                  <dx:ListEditItem Value="bool" Text="bool" />                                                    
                                                  <dx:ListEditItem Value="int" Text="int" />
                                               </Items>
                                           </dx:ASPxComboBox>   
                                           --%>
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
                                                                                                                                                               
           <dx:TabPage Text="Edit Settings">
              <ContentCollection>                              
                  <dx:ContentControl ID="ContentControl2" runat="server">

                  <dx:ASPxSplitter ID="ASPxSplitter1" runat="server" Height="650px" ClientInstanceName="editSettingsSplitter">
                      <Styles>
                          <Pane>
                              <Paddings Padding="0px" />
                              <Border BorderStyle="None" />                                
                          </Pane>
                      </Styles>
                      <Panes>
                          <dx:SplitterPane Size="50%" Name="gridViewContainer" ShowCollapseBackwardButton="True">
                              <ContentCollection>
                                  <dx:SplitterContentControl runat="server">

                                      <dx:ASPxGridView runat="server" ID="EditSettingsGridView" ClientInstanceName="gridViewEditSettings"
                                          KeyFieldName="Group;Name" EnablePagingGestures="False"
                                          CssClass="grid-view" Width="760px"
                                          DataSourceID="SettingsDataModelSource"
                                          OnCustomCallback="EditSettingsGridView_CustomCallback" 
                                          OnToolbarItemClick="EditSettingsGridView_ToolbarItemClick" OnSelectionChanged="EditSettingsGridView_SelectionChanged"
                                          OnInitNewRow="EditSettingsGridView_InitNewRow" AutoGenerateColumns="False">
                                          <Columns>
                                              <dx:GridViewCommandColumn ShowSelectCheckbox="True" SelectAllCheckboxMode="AllPages" VisibleIndex="0" Width="50"></dx:GridViewCommandColumn>
                                              <dx:GridViewDataColumn FieldName="Group" Caption="Group" Width="150px" />                               
                                              <dx:GridViewDataColumn FieldName="Name" Caption="Name" Width="255px" />
                                              <dx:GridViewDataColumn FieldName="SerializeAs" Caption="Type" Visible="false" />
                                              <dx:GridViewDataColumn FieldName="Value" Caption="Value" Width="270px" Visible="true" />
                                              <dx:GridViewDataColumn FieldName="UpdatedBy" Caption="Updated By" Width="150px" Visible="false" />
                                              <dx:GridViewDataColumn FieldName="Updated" Caption="Dated" Width="200px" Visible="false" />
                                           </Columns>
                                          <Toolbars>
                                              <dx:GridViewToolbar Name="settingsToolbar">
                                                  <SettingsAdaptivity Enabled="true" EnableCollapseRootItemsToIcons="true" />
                                                  <Items>
                                                      <dx:GridViewToolbarItem Command="Refresh" Visible="true" AdaptivePriority="1"/>
                                                      <dx:GridViewToolbarItem Command="ShowFilterRow" BeginGroup="true" AdaptivePriority="2"/>
                                                      <dx:GridViewToolbarItem Command="ShowCustomizationWindow" BeginGroup="true" Enabled="true" AdaptivePriority="3"/>                                                      	
                                                  </Items>
                                              </dx:GridViewToolbar>
                                          </Toolbars>
                                          <SettingsBehavior EnableCustomizationWindow="true" AllowFocusedRow="true" AllowSelectSingleRowOnly="true" AllowSelectByRowClick="true" AllowEllipsisInText="true" AllowDragDrop="false" />
                                          <Settings VerticalScrollBarMode="Hidden" HorizontalScrollBarMode="Auto" ShowHeaderFilterButton="true" />
                                          <SettingsPager PageSize="12" EnableAdaptivity="true">
                                              <PageSizeItemSettings Visible="false"></PageSizeItemSettings>
                                          </SettingsPager>
                                          <SettingsPopup>
                                              <FilterControl AutoUpdatePosition="False"></FilterControl>
                                          </SettingsPopup>
                                          <Styles>
                                              <Cell Wrap="false" />
                                              <PagerBottomPanel CssClass="pager" />
                                              <FocusedRow CssClass="focused" />
                                          </Styles>
                                          <ClientSideEvents Init="OnGridViewEditSettingsInit" SelectionChanged="OnGridViewEditSettingsSelectionChanged" ToolbarItemClick="OnGridViewEditSettingsToolbarItemClick"
                                               FocusedRowChanged="OnGridViewEditSettingsFocusedRowChanged" />
                                      </dx:ASPxGridView>                                    
                                      
                                  </dx:SplitterContentControl>
                              </ContentCollection>
                          </dx:SplitterPane>

                          <dx:SplitterPane Size="50%" Name="editFormContainer" ShowCollapseBackwardButton="True">
                              <ContentCollection>
                                  <dx:SplitterContentControl runat="server">
                                     <br/>
                                     <dx:ASPxLabel ID="EditFormLabel" runat="server" ClientIDMode="Static" Text="Edit Selected Setting" Font-Bold="True" Font-Size="18px" ForeColor="DarkGray" Width="400px" />
                                     <br/>

                                     <dx:ASPxFormLayout ID="EditFormLayout" runat="server" ClientInstanceName="editFormLayout" AlignItemCaptionsInAllGroups="True" UseDefaultPaddings="False">
                                        <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="800" />
                                        <Items>
                                            <dx:EmptyLayoutItem />
                                         
                                            <dx:LayoutGroup Caption="Selected Item" ShowCaption="true" ColCount="2" SettingsItems-HorizontalAlign="Left" HorizontalAlign="Left" Width="600">
                                                <Items>     
                                                   <dx:LayoutItem Caption="Group" ShowCaption="true" CssClass="buttonAlign" Width="40%">
                                                       <LayoutItemNestedControlCollection>
                                                           <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                                              <dx:ASPxLabel ID="SettingFormGroupLabel" ClientInstanceName="formGroupLabel" runat="server" Font-Size="12px" Font-Bold="True"></dx:ASPxLabel> 
                                                           </dx:LayoutItemNestedControlContainer>
                                                       </LayoutItemNestedControlCollection>
                                                   </dx:LayoutItem>
                                                   <dx:LayoutItem Caption="Name" ShowCaption="true" CssClass="buttonAlign" Width="40%">
                                                       <LayoutItemNestedControlCollection>
                                                           <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                                              <dx:ASPxLabel ID="SettingFormNameLabel" ClientInstanceName="formNameLabel" runat="server" Font-Size="12px" Font-Bold="True"></dx:ASPxLabel> 
                                                           </dx:LayoutItemNestedControlContainer>
                                                       </LayoutItemNestedControlCollection>
                                                   </dx:LayoutItem>
                                                   <dx:LayoutItem Caption="SerializeAs" ShowCaption="true" CssClass="buttonAlign" Width="40%">
                                                       <LayoutItemNestedControlCollection>
                                                           <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                                              <dx:ASPxLabel ID="SettingFormSerializeAsLabel" ClientInstanceName="formSerializeAsLabel" runat="server" Font-Size="12px" Font-Bold="True"></dx:ASPxLabel> 
                                                           </dx:LayoutItemNestedControlContainer>
                                                       </LayoutItemNestedControlCollection>
                                                   </dx:LayoutItem>
                                                </Items>
                                            </dx:LayoutGroup>
                                    
                                            <dx:EmptyLayoutItem />
                                    
                                            <dx:LayoutGroup Caption="Value" ShowCaption="false" ColCount="2" SettingsItems-HorizontalAlign="Left" HorizontalAlign="Left" Width="600">
                                                <Items>                                     
                                                   <dx:LayoutItem Caption="Value" ShowCaption="true" Name="formItemValue" CssClass="buttonAlign" Width="40%">
                                                       <LayoutItemNestedControlCollection>
                                                           <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                                               <dx:ASPxTextBox ID="SettingValueTextBox" ClientInstanceName="formValueTextBox" Width="400px" runat="server" ReadOnly="false" />
                                                           </dx:LayoutItemNestedControlContainer>
                                                       </LayoutItemNestedControlCollection>
                                                   </dx:LayoutItem>

                                                   <dx:LayoutItem Caption="Integer Value" ShowCaption="true" Name="formItemIntValue" CssClass="buttonAlign" Width="40%">
                                                       <LayoutItemNestedControlCollection>
                                                           <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">                                                               	
                                                               <dx:ASPxTextBox ID="SettingIntValueTextBox" ClientInstanceName="formIntValueTextBox" Width="100px" runat="server" ReadOnly="false">
                                                                 <MaskSettings Mask="9999999" ErrorText="Input numeric characters only" />
                                                               </dx:ASPxTextBox>
                                                           </dx:LayoutItemNestedControlContainer>
                                                       </LayoutItemNestedControlCollection>
                                                   </dx:LayoutItem>
                                                               
                                                   <dx:LayoutItem Caption="Boolean Value" ShowCaption="true" Name="formItemBoolValue" CssClass="buttonAlign" Width="40%">
                                                       <LayoutItemNestedControlCollection>
                                                           <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">                                                               
                                                               <dx:ASPxRadioButtonList ID="SettingValueRadioButtonList" ClientInstanceName="formValueRadioButtonList" runat="server">
                                                                   <Items>
                                                                       <dx:ListEditItem Value="true" />
                                                                       <dx:ListEditItem Value="false" />
                                                                   </Items>
                                                               </dx:ASPxRadioButtonList>
                                                           </dx:LayoutItemNestedControlContainer>
                                                       </LayoutItemNestedControlCollection>
                                                   </dx:LayoutItem>
                                                </Items>
                                            </dx:LayoutGroup>
                                                   
                                            <dx:EmptyLayoutItem />
                                    
                                            <dx:LayoutItem ShowCaption="False" CssClass="buttonAlign" Width="100%">
                                                <LayoutItemNestedControlCollection>
                                                    <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                                        <dx:ASPxButton ID="UpdateSettingButton" runat="server" Text="Update" OnClick="UpdateSettingButtonClick" Width="100" />
                                                    </dx:LayoutItemNestedControlContainer>
                                                </LayoutItemNestedControlCollection>
                                            </dx:LayoutItem>
                                                    	
                                        </Items>
                                     </dx:ASPxFormLayout>
                                     
                                  </dx:SplitterContentControl>
                              </ContentCollection>
                          </dx:SplitterPane>
                  
                      </Panes>
                      <ClientSideEvents PaneResized="OnSplitterPaneResized" />
                  </dx:ASPxSplitter>
                  
                  </dx:ContentControl>
             </ContentCollection>                                    
           </dx:TabPage>

           <%--
           **** TODO TAB
           --%>
                                                                                                                                                                       
           <dx:TabPage Text="TODO" Visible="False">
              <ContentCollection>                              
                  <dx:ContentControl ID="ContentControl3" runat="server">

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
   **** LOADING PANELS
   --%>

   <dx:ASPxLoadingPanel ID="LoadingPanel" runat="server" ClientInstanceName="LoadingPanel" Modal="True" />   
  
   <%--
   **** DATA SOURCES
   --%>


   <%--
   **** ADDITIONAL DATA SOURCES
   --%>
  

</asp:Content>
