<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="Root.master" CodeBehind="FileManager.aspx.cs" Inherits="BlackBox.FileManagerPage" Title="BlackBox" %>

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
    //var enabled = false;
  }
    
  function OnPageToolbarItemClick(s, e) 
  {
    switch(e.item.name) 
    {
      default:
          break;
    }
  }
 
  // ///////////////////////////
  // file manager functions
  // //////////////////////////
  
  function OnFileManagerInit(s, e) 
  { 
    //var toolbar = AllFileManager.GetToolbar(0);  
    //if (toolbar != null) 
    //{  
    //}
  }
  
  function OnCustomFileManagerCommand(s, e) 
  {
    switch(e.commandName) 
    {
      case "Thumbnails":
          s.PerformCallback("Thumbnails");      
          break;
      case "Details":
          //s.PerformCallback("Details");      
          break;
    }
  }  
  
  function OnToolbarUpdating(s, e) 
  {
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

  window.OnPageToolbarItemClick = OnPageToolbarItemClick;

  window.OnFileManagerInit = OnFileManagerInit;
  window.OnCustomFileManagerCommand = OnCustomFileManagerCommand;
  
  window.OnToolbarUpdating = OnToolbarUpdating;  

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
                           <dx:ASPxHyperLink ID="BreadcrumbsHyperLink" runat="server" NavigateUrl="~/Default.aspx" Text="Root" Font-Bold="True" Font-Size="Large" Border-BorderStyle="None" Border-BorderWidth="8px" />
                           <dx:ASPxLabel ID="BreadcrumbsSpacer" runat="server" Text=">"></dx:ASPxLabel>
                           <dx:ASPxLabel ID="BreadcrumbsLabel" ClientIDMode="Static" runat="server" Text="File Manager" Font-Bold="True" Font-Size="Large" Width="300px" />
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
       <ClientSideEvents ItemClick="OnPageToolbarItemClick" />        
    </dx:ASPxMenu>
  
</asp:Content>

<%--
**** RIGHT PANEL
--%>

<asp:Content runat="server" ContentPlaceHolderID="ContentPlaceHolderRightPanelContent">  
    <%--
    **** RIGHT PANEL DATA SOURCES
    --%>    

    <asp:ObjectDataSource ID="SettingsDataModelSource" runat="server" TypeName="BlackBox.Model.SettingsProvider"
        SelectMethod="GetSettingsGroupsList" InsertMethod="AddNewSetting" UpdateMethod="SetSetting" DeleteMethod="DeleteSetting" 
        OnSelecting="SettingsDataModelSource_Selecting" >
       <SelectParameters>
           <asp:QueryStringParameter DefaultValue="FileManager" Name="Groups" QueryStringField="Groups" Type="String" />
       </SelectParameters>
    </asp:ObjectDataSource>

    <%--
    **** RIGHT PANEL CONTENT
    --%>    
                
    <dx:ASPxPageControl ID="TabPagesRightPanel" Width="100%" runat="server" ActiveTabIndex="0" EnableHierarchyRecreation="True" >
       <TabPages>
           <%--
           **** FILE MANAGER LAYOUT TABPAGE
           --%>
    
           <dx:TabPage Text="Options" Visible="true">
              <ContentCollection>
                  <dx:ContentControl ID="ContentControlRight1" runat="server">

                  <table>
                    <tr>
                      <td>
                        <p style="font-weight: bold; font-size: medium; font-family: Arial, Helvetica, sans-serif">File Manager Layout</p>
                      </td>
                      <td style="width: 80px">&nbsp;
                      </td>
                   </tr>
                  </table>
                                         
                  <dx:ASPxFormLayout runat="server" ID="OptionsFormLayout">
                      <Items>
                          <dx:LayoutGroup Caption="Editing Settings" ShowCaption="true" ColCount="3" SettingsItems-HorizontalAlign="Left" HorizontalAlign="Left" Width="500px">
                              <Items>
                                  <dx:LayoutItem Caption="AllowMove">
                                      <LayoutItemNestedControlCollection>
                                          <dx:LayoutItemNestedControlContainer>
                                              <dx:ASPxCheckBox ID="cbAllowMove" runat="server" AutoPostBack="False" Checked="True" />
                                          </dx:LayoutItemNestedControlContainer>
                                      </LayoutItemNestedControlCollection>
                                  </dx:LayoutItem>
                                  <dx:LayoutItem Caption="AllowDelete">
                                      <LayoutItemNestedControlCollection>
                                          <dx:LayoutItemNestedControlContainer>
                                              <dx:ASPxCheckBox ID="cbAllowDelete" runat="server" AutoPostBack="False" Checked="True" />
                                          </dx:LayoutItemNestedControlContainer>
                                      </LayoutItemNestedControlCollection>
                                  </dx:LayoutItem>
                                  <dx:LayoutItem Caption="AllowRename">
                                      <LayoutItemNestedControlCollection>
                                          <dx:LayoutItemNestedControlContainer>
                                              <dx:ASPxCheckBox ID="cbAllowRename" runat="server" AutoPostBack="False" Checked="True" />
                                          </dx:LayoutItemNestedControlContainer>
                                      </LayoutItemNestedControlCollection>
                                  </dx:LayoutItem>
                                  <dx:LayoutItem Caption="AllowCreate">
                                      <LayoutItemNestedControlCollection>
                                          <dx:LayoutItemNestedControlContainer>
                                              <dx:ASPxCheckBox ID="cbAllowCreate" runat="server" AutoPostBack="False" Checked="True" />
                                          </dx:LayoutItemNestedControlContainer>
                                      </LayoutItemNestedControlCollection>
                                  </dx:LayoutItem>
                                  <dx:LayoutItem Caption="AllowCopy">
                                      <LayoutItemNestedControlCollection>
                                          <dx:LayoutItemNestedControlContainer>
                                              <dx:ASPxCheckBox ID="cbAllowCopy" runat="server" AutoPostBack="False" Checked="True" />
                                          </dx:LayoutItemNestedControlContainer>
                                      </LayoutItemNestedControlCollection>
                                  </dx:LayoutItem>
                                  <dx:LayoutItem Caption="AllowDownload">
                                      <LayoutItemNestedControlCollection>
                                          <dx:LayoutItemNestedControlContainer>
                                              <dx:ASPxCheckBox ID="cbAllowDownload" runat="server" AutoPostBack="False" Checked="True" />
                                          </dx:LayoutItemNestedControlContainer>
                                      </LayoutItemNestedControlCollection>
                                  </dx:LayoutItem>
                              </Items>
                          </dx:LayoutGroup>

                          <dx:LayoutGroup Caption="Toolbar Settings" ShowCaption="true" ColCount="2" SettingsItems-HorizontalAlign="Left" HorizontalAlign="Left" Width="400px">
                              <Items>
                                  <dx:LayoutItem Caption="ShowPath">
                                      <LayoutItemNestedControlCollection>
                                          <dx:LayoutItemNestedControlContainer>
                                              <dx:ASPxCheckBox ID="cbShowPath" runat="server" AutoPostBack="False" HorizontalAlign="Left" Checked="True" />
                                          </dx:LayoutItemNestedControlContainer>
                                      </LayoutItemNestedControlCollection>
                                  </dx:LayoutItem>
                                  <dx:LayoutItem Caption="ShowFilterBox">
                                      <LayoutItemNestedControlCollection>
                                          <dx:LayoutItemNestedControlContainer>
                                              <dx:ASPxCheckBox ID="cbShowFilterBox" runat="server" AutoPostBack="False" HorizontalAlign="Left" Checked="True" />
                                          </dx:LayoutItemNestedControlContainer>
                                      </LayoutItemNestedControlCollection>
                                  </dx:LayoutItem>
                              </Items>
                          </dx:LayoutGroup>

                          <dx:LayoutGroup Caption="Breadcrumbs Settings" ShowCaption="true" ColCount="2" SettingsItems-HorizontalAlign="Left" HorizontalAlign="Left" Width="400px">
                              <Items>
                                  <dx:LayoutItem Caption="Visible">
                                      <LayoutItemNestedControlCollection>
                                          <dx:LayoutItemNestedControlContainer>
                                              <dx:ASPxCheckBox ID="cbBreadcrumbsVisible" runat="server" Width="100px" AutoPostBack="False" Checked="True" />
                                          </dx:LayoutItemNestedControlContainer>
                                      </LayoutItemNestedControlCollection>
                                  </dx:LayoutItem>
                                  <dx:LayoutItem Caption="ShowParentFolderButton">
                                      <LayoutItemNestedControlCollection>
                                          <dx:LayoutItemNestedControlContainer>
                                              <dx:ASPxCheckBox ID="cbBreadcrumbsShowParentFolderButton" runat="server" AutoPostBack="False" Checked="True" />
                                          </dx:LayoutItemNestedControlContainer>
                                      </LayoutItemNestedControlCollection>
                                  </dx:LayoutItem>
                                  <dx:LayoutItem Caption="Position">
                                      <LayoutItemNestedControlCollection>
                                          <dx:LayoutItemNestedControlContainer>
                                              <dx:ASPxComboBox ID="cmbBreadcrumbsPosition" runat="server" SelectedIndex="0" Width="100px" AutoPostBack="False">
                                                  <Items>
                                                      <dx:ListEditItem Value="Top" Text="Top" />
                                                      <dx:ListEditItem Value="Bottom" Text="Bottom" />
                                                  </Items>
                                              </dx:ASPxComboBox>
                                          </dx:LayoutItemNestedControlContainer>
                                      </LayoutItemNestedControlCollection>
                                  </dx:LayoutItem>
                              </Items>
                          </dx:LayoutGroup>
                          
                          <dx:LayoutGroup Caption="Upload Settings" ShowCaption="true" ColCount="2" SettingsItems-HorizontalAlign="Left" HorizontalAlign="Left" Width="400px">
                              <Items>
                                  <dx:LayoutItem Caption="Enabled">
                                      <LayoutItemNestedControlCollection>
                                          <dx:LayoutItemNestedControlContainer>
                                              <dx:ASPxCheckBox ID="cbUploadEnabled" runat="server" AutoPostBack="False" Checked="True" />
                                          </dx:LayoutItemNestedControlContainer>
                                      </LayoutItemNestedControlCollection>
                                  </dx:LayoutItem>
                                  <dx:LayoutItem Caption="EnableMultiSelect">
                                      <LayoutItemNestedControlCollection>
                                          <dx:LayoutItemNestedControlContainer>
                                              <dx:ASPxCheckBox ID="cbUploadMultiSelect" runat="server" AutoPostBack="False" Checked="True" />
                                          </dx:LayoutItemNestedControlContainer>
                                      </LayoutItemNestedControlCollection>
                                  </dx:LayoutItem>
                              </Items>
                          </dx:LayoutGroup>
                          
                          <dx:LayoutGroup Caption="File List Settings" ShowCaption="true" ColCount="3" SettingsItems-HorizontalAlign="Left" HorizontalAlign="Left" Width="500">
                              <Items>
                                  <dx:LayoutItem Caption="ShowFolders">
                                      <LayoutItemNestedControlCollection>
                                          <dx:LayoutItemNestedControlContainer>
                                              <dx:ASPxCheckBox ID="cbFileListShowFolders" runat="server" AutoPostBack="False" Checked="True" />
                                          </dx:LayoutItemNestedControlContainer>
                                      </LayoutItemNestedControlCollection>
                                  </dx:LayoutItem>
                                  <dx:LayoutItem Caption="ShowParentFolder">
                                      <LayoutItemNestedControlCollection>
                                          <dx:LayoutItemNestedControlContainer>
                                              <dx:ASPxCheckBox ID="cbFileListShowParentFolder" runat="server" AutoPostBack="False" Checked="True" Text="" />
                                          </dx:LayoutItemNestedControlContainer>
                                      </LayoutItemNestedControlCollection>
                                  </dx:LayoutItem>
                              </Items>
                          </dx:LayoutGroup>
                          
                          <dx:LayoutGroup Caption="Folder Settings" ShowCaption="true" ColCount="2" SettingsItems-HorizontalAlign="Left" HorizontalAlign="Left" Width="500">
                              <Items>
                                  <dx:LayoutItem Caption="Visible">
                                      <LayoutItemNestedControlCollection>
                                          <dx:LayoutItemNestedControlContainer>
                                              <dx:ASPxCheckBox ID="cbFoldersVisible" runat="server" AutoPostBack="False" Checked="True" />
                                          </dx:LayoutItemNestedControlContainer>
                                      </LayoutItemNestedControlCollection>
                                  </dx:LayoutItem>
                                  <dx:LayoutItem Caption="EnableCallBacks">
                                      <LayoutItemNestedControlCollection>
                                          <dx:LayoutItemNestedControlContainer>
                                              <dx:ASPxCheckBox ID="cbFoldersEnableCallBacks" runat="server" AutoPostBack="False" Checked="True" />
                                          </dx:LayoutItemNestedControlContainer>
                                      </LayoutItemNestedControlCollection>
                                  </dx:LayoutItem>
                                  <dx:LayoutItem Caption="ShowFolderIcons">
                                      <LayoutItemNestedControlCollection>
                                          <dx:LayoutItemNestedControlContainer>
                                              <dx:ASPxCheckBox ID="cbShowFolderIcons" runat="server" AutoPostBack="False" Checked="True" />
                                          </dx:LayoutItemNestedControlContainer>
                                      </LayoutItemNestedControlCollection>
                                  </dx:LayoutItem>
                                  <dx:LayoutItem Caption="ShowLockedFolderIcons">
                                      <LayoutItemNestedControlCollection>
                                          <dx:LayoutItemNestedControlContainer>
                                              <dx:ASPxCheckBox ID="cbShowLockedFolderIcons" runat="server" AutoPostBack="False" Checked="True" />
                                          </dx:LayoutItemNestedControlContainer>
                                      </LayoutItemNestedControlCollection>
                                  </dx:LayoutItem>
                              </Items>
                          </dx:LayoutGroup>
                                    
                          <dx:LayoutItem ShowCaption="False" CssClass="buttonAlign" Width="100%">
                              <LayoutItemNestedControlCollection>
                                  <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                      <asp:Button ID="SubmitSettingsButton" runat="server" AutoPostBack="false" OnClick="SubmitSettingsButton_Click" Text="Submit" />
                                  </dx:LayoutItemNestedControlContainer>
                              </LayoutItemNestedControlCollection>
                          </dx:LayoutItem>
                                    
                          <dx:LayoutItem ShowCaption="False" CssClass="buttonAlign" Width="100%">
                              <LayoutItemNestedControlCollection>
                                  <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                      <asp:Button ID="ResetSettingsButton" runat="server" AutoPostBack="false" OnClick="ResetSettingsButton_Click" Text="Reset" />	
                                  </dx:LayoutItemNestedControlContainer>
                              </LayoutItemNestedControlCollection>
                          </dx:LayoutItem>

                      </Items>
                  </dx:ASPxFormLayout>
    
                  </dx:ContentControl>
             </ContentCollection>
           </dx:TabPage>

           <%--
           **** SETTINGS TABPAGE
           --%>
    
           <dx:TabPage Text="Settings" Visible="true">
              <ContentCollection>
                  <dx:ContentControl ID="ContentControlRight2" runat="server">
     
                  <dx:ASPxGridView runat="server" ID="SettingsGridView" ClientInstanceName="gridViewSettings"
                      KeyFieldName="Group;Name" EnablePagingGestures="False"
                      CssClass="grid-view" Width="100%"
                      DataSourceID="SettingsDataModelSource"
                      OnCustomCallback="SettingsGridView_CustomCallback" OnToolbarItemClick="SettingsGridView_ToolbarItemClick"
                      OnInitNewRow="SettingsGridView_InitNewRow" AutoGenerateColumns="False">
                      <Columns>
                          <dx:GridViewCommandColumn ShowSelectCheckbox="True" SelectAllCheckboxMode="AllPages" VisibleIndex="0" Width="50"></dx:GridViewCommandColumn>
                          <dx:GridViewDataColumn FieldName="Group" Caption="Group" Width="100px" />                               
                          <dx:GridViewDataColumn FieldName="Name" Caption="Name" Width="150px" />
                          <dx:GridViewDataColumn FieldName="SerializeAs" Caption="Type" Visible="False" />
                          <dx:GridViewDataColumn FieldName="Value" Caption="Value" Width="250px" />
                      </Columns>
                      <Toolbars>
                          <dx:GridViewToolbar Name="settingsToolbar">
                              <SettingsAdaptivity Enabled="true" EnableCollapseRootItemsToIcons="true" />
                              <Items>
                                  <dx:GridViewToolbarItem Command="Refresh" />
                                  <dx:GridViewToolbarItem Command="New" BeginGroup="true" AdaptivePriority="2" Visible="false"/>
                                  <dx:GridViewToolbarItem Command="Edit" Visible="true"/>
                                  <dx:GridViewToolbarItem Command="Delete" Visible="false"/>
                                  <dx:GridViewToolbarItem Name="CustomSettingItemSearch" Alignment="Right" BeginGroup="true" AdaptivePriority="4">
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
                      <SettingsBehavior AllowFocusedRow="true" AllowSelectByRowClick="true" AllowEllipsisInText="true" AllowDragDrop="false" />
                      <SettingsEditing Mode="PopupEditForm" EditFormColumnCount="2" />
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
                                           <dx:ASPxTextBox ID="valueTextBox" runat="server" Width="80%" Text='<%# Bind("Value") %>' OnValidation="ASPxTextBoxSettings_Validation">
                                           	  <%-- --%>
                                              <ValidationSettings ValidationGroup="testGroup">
                                                 <RequiredField IsRequired="True" ErrorText="A value is required"/>
                                              </ValidationSettings>
                                              <%-- --%>
                                           </dx:ASPxTextBox>	
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
    <%--
    **** CONTENT PANEL DATA SOURCES
    --%>


    <%--
    **** CONTENT TABS
    --%>
   
    <dx:ASPxPageControl ID="TabPagesMainPanel" Width="100%" runat="server" ActiveTabIndex="0" EnableHierarchyRecreation="True" >
        <TabPages>           
           <%--
           **** DATAFOLDER TABPAGE
           --%>

           <dx:TabPage Text="Job and Upload Files">
              <ContentCollection>
                  <dx:ContentControl ID="MainContentControl1" runat="server">
                  	
                  <dx:ASPxFileManager ID="FileManager" ClientInstanceName="FileManager" runat="server" Width="95%" Height="750px"
                      OnCustomCallback="FileManager_CustomCallback" OnCustomThumbnail="OnFileManagerCustomThumbnails"
                      OnItemDeleting="FileManager_ItemDeleting" OnItemMoving="FileManager_ItemMoving" OnItemsDeleted="FileManager_ItemsDeleted" OnItemMoved="FileManager_ItemMoved"
                      OnItemRenaming="FileManager_ItemRenaming" OnItemCopying="FileManager_ItemCopying" OnItemRenamed="FileManager_ItemRenamed" OnItemsCopied="FileManager_ItemsCopied"
                      OnFileUploading="FileManager_FileUploading" OnFolderCreating="FileManager_FolderCreating">
                      <Settings RootFolder="~/Jobs" ThumbnailFolder="~/Resources/Thumbnails"
                          AllowedFileExtensions=".jpg,.jpeg,.gif,.rtf,.txt,.avi,.png,.mp3,.xml,.doc,.pdf,.html,.log,.csv,.xls,.xlsx,.xml,.sql,.zip"
                          InitialFolder="~/Jobs" />
                      <SettingsEditing AllowCreate="true" AllowDelete="true" AllowMove="true" AllowRename="true" AllowCopy="true" AllowDownload="true" />
                      <SettingsPermissions>
                          <AccessRules>
                              <dx:FileManagerFolderAccessRule Path="system" Edit="Deny" />
                              <dx:FileManagerFileAccessRule Path="system\*" Download="Deny" />
                          </AccessRules>
                      </SettingsPermissions>
                      <SettingsFolders Visible="true" />                          
                      <SettingsFileList View="Thumbnails" ShowFolders="true" ShowParentFolder="true">
                         <DetailsViewSettings AllowColumnResize="true" AllowColumnDragDrop="true" AllowColumnSort="true" ShowHeaderFilterButton="true" />
                      </SettingsFileList>                                 
                      <SettingsBreadcrumbs Visible="true" ShowParentFolderButton="true" Position="Top" />
                      <SettingsUpload UseAdvancedUploadMode="true">
                          <AdvancedModeSettings EnableMultiSelect="true" />
                      </SettingsUpload>
                      <SettingsAdaptivity Enabled="true" /> 
                      <SettingsToolbar>
                          <Items>
                              <dx:FileManagerToolbarCustomButton CommandName="Properties" BeginGroup="true">
                                  <Image IconID="setup_properties_32x32" />
                              </dx:FileManagerToolbarCustomButton>
                              <dx:FileManagerToolbarCreateButton BeginGroup="true" />                           
                              <dx:FileManagerToolbarRenameButton BeginGroup="true" />                           
                              <dx:FileManagerToolbarMoveButton />
                              <dx:FileManagerToolbarCopyButton />
                              <dx:FileManagerToolbarDeleteButton />
                              <dx:FileManagerToolbarRefreshButton BeginGroup="true" />
                              <dx:FileManagerToolbarDownloadButton />
                          </Items>
                      </SettingsToolbar>
                      <ClientSideEvents Init="OnFileManagerInit" CustomCommand="OnCustomFileManagerCommand" />                        
                  </dx:ASPxFileManager>

                  </dx:ContentControl>
             </ContentCollection>                                    
           </dx:TabPage>

           <%--
           **** LOGS TABPAGE
           --%>

           <dx:TabPage Text="Log Files">
              <ContentCollection>
                  <dx:ContentControl ID="MainContentControl2" runat="server">
                  	
                  <dx:ASPxFileManager ID="LogsFileManager" ClientInstanceName="LogsFileManager" runat="server" Width="95%" Height="750px"
                      OnCustomCallback="LogsFileManager_CustomCallback" OnCustomThumbnail="OnFileManagerCustomThumbnails"
                      OnItemDeleting="LogsFileManager_ItemDeleting" OnItemMoving="LogsFileManager_ItemMoving" OnItemsDeleted="LogsFileManager_ItemsDeleted" OnItemMoved="LogsFileManager_ItemMoved"
                      OnItemRenaming="LogsFileManager_ItemRenaming" OnItemCopying="LogsFileManager_ItemCopying" OnItemRenamed="LogsFileManager_ItemRenamed" OnItemsCopied="LogsFileManager_ItemsCopied"
                      OnFileUploading="LogsFileManager_FileUploading" OnFolderCreating="LogsFileManager_FolderCreating">
                      <Settings RootFolder="~/Logs" ThumbnailFolder="~/Resources/Thumbnails"
                          AllowedFileExtensions=".jpg,.jpeg,.gif,.rtf,.txt,.avi,.png,.mp3,.xml,.doc,.pdf,.html,.log,.csv,.xls,.xlsx,.xml,.zip"
                          InitialFolder="~/Logs" />
                      <SettingsEditing AllowCreate="true" AllowDelete="true" AllowMove="true" AllowRename="true" AllowCopy="true" AllowDownload="true" />
                      <SettingsPermissions>
                          <AccessRules>
                              <dx:FileManagerFolderAccessRule Path="system" Edit="Deny" />
                              <dx:FileManagerFileAccessRule Path="system\*" Download="Deny" />
                          </AccessRules>
                      </SettingsPermissions>
                      <SettingsFolders Visible="true" />                          
                      <SettingsFileList View="Thumbnails" ShowFolders="true" ShowParentFolder="true">
                         <DetailsViewSettings AllowColumnResize="true" AllowColumnDragDrop="true" AllowColumnSort="true" ShowHeaderFilterButton="true" />
                      </SettingsFileList>                                 
                      <SettingsBreadcrumbs Visible="true" ShowParentFolderButton="true" Position="Top" />
                      <SettingsUpload UseAdvancedUploadMode="true">
                          <AdvancedModeSettings EnableMultiSelect="true" />
                      </SettingsUpload>
                      <SettingsAdaptivity Enabled="true" /> 
                      <SettingsToolbar>
                          <Items>
                              <dx:FileManagerToolbarCustomButton CommandName="Properties" BeginGroup="true">
                                  <Image IconID="setup_properties_32x32" />
                              </dx:FileManagerToolbarCustomButton>
                              <dx:FileManagerToolbarCreateButton BeginGroup="true" />                           
                              <dx:FileManagerToolbarRenameButton BeginGroup="true" />                           
                              <dx:FileManagerToolbarMoveButton />
                              <dx:FileManagerToolbarCopyButton />
                              <dx:FileManagerToolbarDeleteButton />
                              <dx:FileManagerToolbarRefreshButton BeginGroup="true" />
                              <dx:FileManagerToolbarDownloadButton />
                          </Items>
                      </SettingsToolbar>
                      <ClientSideEvents Init="OnFileManagerInit" CustomCommand="OnCustomFileManagerCommand" />                        
                  </dx:ASPxFileManager>

                  </dx:ContentControl>
             </ContentCollection>                                    
           </dx:TabPage>

           <%--
           **** OTHER FILES TABPAGE
           --%>
           
           <dx:TabPage Text="Other Files" Visible="true">
              <ContentCollection>                              
                  <dx:ContentControl ID="ContentControl4" runat="server">

                  </dx:ContentControl>
             </ContentCollection>                                    
           </dx:TabPage>

        </TabPages>

    </dx:ASPxPageControl>

   <%--
   **** POPUP PANEL
   --%>

     
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
   **** ADDITIONAL DATA SOURCES
   --%>


</asp:Content>
