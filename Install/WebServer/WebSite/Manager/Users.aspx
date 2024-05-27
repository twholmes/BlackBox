<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="Manager.master" CodeBehind="Users.aspx.cs" Inherits="BlackBox.ManageUsersPage" Title="BlackBox" %>

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

  // ////////////////////////////////
  // contacts card view functions
  // ////////////////////////////////

  function onCardViewInit(s, e) 
  {
    AddAdjustmentDelegate(adjustCardView);
    updateToolbarButtonsState();
  }
    
  function adjustCardView() 
  {
    cardView.AdjustControl();
  }    

  // card view toolbar functions
  function onCardViewToolbarItemClick(s, e) 
  {
    switch(e.item.name) 
    {
      case "New":
          cardView.AddNewCard();
          break;
      case "Edit":
          cardView.StartEditCard(cardView.GetFocusedCardIndex());
          break;
      case "Delete":
          deleteSelectedCards();
          break;
    }
  }

  function onCardViewSelectionChanged(s, e) 
  {
    var enabled = cardView.GetSelectedCardCount() > 0;
  }

  function deleteSelectedCards() 
  {
    if (confirm('Confirm Delete?')) 
    {
      e.processOnServer = true;
      e.usePostBack = true;     
      // alternate: cardView.PerformCallback('delete');
    }
  }

  // ///////////////////////
  // files grid functions
  // ///////////////////////

  // files grid toolbar functions  
  function OnGridViewContactsToolbarItemClick(s, e) 
  {
    if (IsCustomGridViewToolbarCommand(e.item.name)) 
    {
      e.processOnServer=true;
      e.usePostBack=true;
    }
  }

  // contacts gridview functions
  function OnGridViewContactsInit(s, e) 
  { 
    var toolbar = gridViewContacts.GetToolbar(0);  
    if (toolbar != null) 
    {  
    }
  }
    
  function OnGridViewContactsSelectionChanged(s, e) 
  {
    e.processOnServer=true;
    e.usePostBack=true;
  }
 
  function OnGridViewContactsFocusedRowChanged(s, e)
  {
    var fri = gridViewContacts.GetFocusedRowIndex();
    gridViewContacts.GetRowValues(fri, 'Domain;SAMAccountName', OnGetImportsFocusedRowValues);
    gridViewContacts.Refresh();    
  }

  function OnGetImportsFocusedRowValues(values)
  {
    var domain = values[0];
    var sam = values[1];
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
  
  window.onCardViewInit = onCardViewInit;
  window.onCardViewSelectionChanged = onCardViewSelectionChanged;    
  window.onCardViewToolbarItemClick = onCardViewToolbarItemClick;
  
  window.OnGridViewContactsInit = OnGridViewContactsInit;
  window.OnGridViewContactsSelectionChanged = OnGridViewContactsSelectionChanged;
  window.OnGridViewContactsFocusedRowChanged = OnGridViewContactsFocusedRowChanged;  
  window.OnGridViewContactsToolbarItemClick = OnGridViewContactsToolbarItemClick;    

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
                           <dx:ASPxHyperLink ID="TopHelpHyperLink" runat="server" NavigateUrl="~/Manager.aspx" Text="Manager" Font-Bold="True" Font-Size="Large" Border-BorderStyle="None" Border-BorderWidth="8px" />
                           <dx:ASPxLabel ID="ASPxLabel1" runat="server" Text=">"></dx:ASPxLabel>
                           <dx:ASPxLabel ID="BreadcrumbsLabel" runat="server" Text="Inspect Users" Font-Bold="True" Font-Size="Large" Width="480px" />
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

    <asp:ObjectDataSource ID="SettingsDataModelSource" runat="server" TypeName="BlackBox.Model.SettingsProvider"
        SelectMethod="GetSettingsGroupList" InsertMethod="AddNewSetting" UpdateMethod="SetSetting" DeleteMethod="DeleteSetting" 
        OnSelecting="SettingsDataModelSource_Selecting" >
       <SelectParameters>
           <asp:QueryStringParameter DefaultValue="Contacts" Name="Group" QueryStringField="Group" Type="String" />
       </SelectParameters>
    </asp:ObjectDataSource>
                
    <dx:ASPxPageControl ID="TabPagesRightPanel" Width="100%" runat="server" ActiveTabIndex="0" EnableHierarchyRecreation="True" >
       <TabPages>
           <%--
           **** SYNC TABPAGE
           --%>
    
           <dx:TabPage Text="Sync Settings" Visible="false">
              <ContentCollection>
                  <dx:ContentControl ID="ContentControlRight1" runat="server">

                  <dx:ASPxFormLayout ID="SyncFormLayout" runat="server" AlignItemCaptionsInAllGroups="True" UseDefaultPaddings="True">
                     <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="700" />
                     <Items>
                         <dx:LayoutGroup Caption="Active Directory" ShowCaption="true" ColCount="1" SettingsItems-HorizontalAlign="Left" HorizontalAlign="Left" Width="500">
                             <Items>
                                 <dx:LayoutItem Caption="NETBIOS Domain Name" FieldName="UserDomain" ShowCaption="True">
                                     <LayoutItemNestedControlCollection>
                                         <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                             <dx:ASPxTextBox ID="UserDomainTextBox" runat="server" Width="95%" ReadOnly="False" />
                                         </dx:LayoutItemNestedControlContainer>
                                     </LayoutItemNestedControlCollection>
                                 </dx:LayoutItem>
                                 <dx:LayoutItem Caption="DNS Domain Name" FieldName="UserDNSDomain" ShowCaption="True">
                                     <LayoutItemNestedControlCollection>
                                         <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                             <dx:ASPxTextBox ID="UserDNSDomainTextBox" runat="server" Width="95%" ReadOnly="False" />
                                         </dx:LayoutItemNestedControlContainer>
                                     </LayoutItemNestedControlCollection>
                                 </dx:LayoutItem>
                                 <dx:EmptyLayoutItem />
                             </Items>
                         </dx:LayoutGroup>

                         <dx:LayoutGroup Caption="Security Groups" ShowCaption="true" ColCount="2" SettingsItems-HorizontalAlign="Left" HorizontalAlign="Left" Width="500">
                             <Items>
                                 <dx:LayoutItem Caption="SiteAudit Group" FieldName="SiteAuditADGroup" ShowCaption="False">
                                     <LayoutItemNestedControlCollection>
                                         <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                             <dx:ASPxTextBox ID="SiteAuditorADGroupTextBox" runat="server" Width="100%" ReadOnly="False" />
                                         </dx:LayoutItemNestedControlContainer>
                                     </LayoutItemNestedControlCollection>
                                 </dx:LayoutItem>
                                 <dx:LayoutItem Caption="Manager Group" FieldName="AssetManagerADGroup" ShowCaption="False">
                                     <LayoutItemNestedControlCollection>
                                         <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                             <dx:ASPxTextBox ID="AssetManagerADGroupTextBox" runat="server" Width="100%" ReadOnly="False" />
                                         </dx:LayoutItemNestedControlContainer>
                                     </LayoutItemNestedControlCollection>
                                 </dx:LayoutItem>
                                  <dx:LayoutItem Caption="Administrator Group" FieldName="AdministratorADGroup" ShowCaption="False">
                                     <LayoutItemNestedControlCollection>
                                         <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                             <dx:ASPxTextBox ID="AdministratorADGroupTextBox" runat="server" Width="100%" ReadOnly="False" />
                                         </dx:LayoutItemNestedControlContainer>
                                     </LayoutItemNestedControlCollection>
                                 </dx:LayoutItem>
                                 <dx:EmptyLayoutItem />
                                 <dx:EmptyLayoutItem />
                             </Items>
                         </dx:LayoutGroup>

                         <dx:LayoutGroup Caption="Sync Options" ShowCaption="true" ColCount="2" SettingsItems-HorizontalAlign="Left" HorizontalAlign="Left" Width="500">
                             <Items>                                
                                 <dx:LayoutItem Caption="Local Sync" FieldName="LocalSyncEnabled" ShowCaption="True">
                                     <LayoutItemNestedControlCollection>
                                         <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                             <dx:ASPxCheckBox ID="cbLocalSyncEnabled" runat="server" AutoPostBack="False" Width="50" Checked="False" />
                                         </dx:LayoutItemNestedControlContainer>
                                     </LayoutItemNestedControlCollection>
                                 </dx:LayoutItem>
                                 
                                 <dx:LayoutItem Caption="AD Sync" FieldName="ADSyncEnabled" ShowCaption="True">
                                     <LayoutItemNestedControlCollection>
                                         <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                             <dx:ASPxCheckBox ID="cbADSyncEnabled" runat="server" AutoPostBack="False" Width="50" Checked="False" />
                                         </dx:LayoutItemNestedControlContainer>
                                     </LayoutItemNestedControlCollection>
                                 </dx:LayoutItem>
                                 
                                 <dx:LayoutItem Caption="AD Sync Mode" FieldName="ADSyncMode" ShowCaption="True" ColumnSpan="2">
                                     <LayoutItemNestedControlCollection>
                                         <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">                                            	
                                             <dx:ASPxComboBox ID="ADSyncModeComboBox" DropDownStyle="DropDown" runat="server" Width="50%">
                                                <Items>
                                                   <dx:ListEditItem Value="inclusive" Text="inclussive" />                                                     
                                                   <dx:ListEditItem Value="exclusive" Text="exclusive" />
                                                </Items>
                                             </dx:ASPxComboBox>
                                         </dx:LayoutItemNestedControlContainer>
                                     </LayoutItemNestedControlCollection>
                                 </dx:LayoutItem>
                                 
                                 <dx:EmptyLayoutItem />
                                 <dx:EmptyLayoutItem />
                             </Items>
                         </dx:LayoutGroup>
                  
                         <dx:LayoutGroup Name="SyncButtonGroup" Caption="Sync" ShowCaption="false" ColCount="1" SettingsItems-HorizontalAlign="Left" HorizontalAlign="Left" Width="500">
                             <Items>
                                 <dx:LayoutItem ShowCaption="False" CssClass="buttonAlign" Width="100%">
                                     <LayoutItemNestedControlCollection>
                                         <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                             <dx:ASPxButton ID="UpdateSyncSettingsButton" runat="server" Text="Update" OnClick="UpdateSyncSettingsButtonClick" Width="100" Visible="true">
                                                 <ClientSideEvents Click="function(s, e) { LoadingPanel.Show(); }" />
                                             </dx:ASPxButton>                          
                                         </dx:LayoutItemNestedControlContainer>
                                     </LayoutItemNestedControlCollection>
                                 </dx:LayoutItem>
                             </Items>
                         </dx:LayoutGroup>           
                  
                     </Items>
                  </dx:ASPxFormLayout>
    
                  </dx:ContentControl>
             </ContentCollection>
           </dx:TabPage>

           <%--
           **** FILE MANAGER TABPAGE
           --%>
    
           <dx:TabPage Text="File Manager" Visible="true">
              <ContentCollection>
                  <dx:ContentControl ID="ContentControlRight2" runat="server">
    
                  <dx:ASPxFileManager runat="server" ID="fileManager" ClientInstanceName="fileManager" OnFolderCreating="FileManager_FolderCreating"
                      OnItemDeleting="FileManager_ItemDeleting" OnItemMoving="FileManager_ItemMoving" OnCustomThumbnail="OnFileManagerCustomThumbnails"
                      OnItemRenaming="FileManager_ItemRenaming" OnFileUploading="FileManager_FileUploading" OnItemCopying="FileManager_ItemCopying">
                      <Settings RootFolder="~/Photos" ThumbnailFolder="~/Resources/Thumbnails" 
                          AllowedFileExtensions=".jpg,.jpeg,.gif,.rtf,.txt,.avi,.png,.mp3,.xml,.doc,.pdf,.html,.csv,.xls,.xlsx,.xml,.zip"
                          InitialFolder="~/Photos" />
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
           **** SETTINGS TABPAGE
           --%>
    
           <dx:TabPage Text="Settings" Visible="false">
              <ContentCollection>
                  <dx:ContentControl ID="ContentControlRight3" runat="server">
     
                  <dx:ASPxGridView runat="server" ID="SettingsGridView" ClientInstanceName="gridViewSettings"
                      KeyFieldName="Group;Name" EnablePagingGestures="False"
                      CssClass="grid-view" Width="100%"
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

    <asp:ObjectDataSource ID="ContactsDataSource" runat="server" DataObjectTypeName="BlackBox.Helper.Contact" TypeName="BlackBox.Model.DataProvider"
        SelectMethod="GetContactsList" InsertMethod="AddNewContact" UpdateMethod="UpdateContact" DeleteMethod="DeleteContact">
    </asp:ObjectDataSource>
    
    <asp:SqlDataSource ID="SqlSysContacts" runat="server" 
        ConnectionString="<%$ ConnectionStrings:BlackBoxConnectionString %>" 
     
        SelectCommand="SELECT [ID],[Cohort],[UID],[FullName],[FirstName],[LastName],[AddressBook],[Domain],[SAMAccountName],[Email],[PhotoFileName],[Country],[City],
                         [Address],[Phone],[Birthday],[Site],[Business],[Job],[Memberships],[Guest],[Operator],[Manager],[Administrator],[Password],[Credits],
                         [Status],[UpdatedBy],[Updated] FROM [dbo].[sysContacts] ORDER BY [Updated] DESC"
        
        InsertCommand="INSERT INTO [dbo].[sysContacts] ([Cohort],[UID],[FullName],[FirstName],[LastName],[AddressBook],[Domain],[SAMAccountName],[Email],[PhotoFileName],
                          [Country],[City],[Address],[Phone],[Birthday],[Site],[Business],[Job],[Memberships],[Guest],[Operator],[Manager],[Administrator],
                          [Password],[Credits],[Status],[UpdatedBy],[Updated])
                       VALUES(@cohort,CONVERT(nvarchar(36),NEWID()),@full,@first,@last,@book,@domain,@sam,@email,@photo,@country,@city,@address,@phone,@birthday,@site,@business,@job,@memberships,
                          @guest,@sa,@am,@admin,@password,@credits,@status,@updatedby,GetDate())"
        
        UpdateCommand="UPDATE [dbo].[sysContacts] SET [Cohort]=@cohort,[UID]=@uid,[FullName]=@full,[FirstName]=@first,[LastName]=@last,[AddressBook]=@book,[Domain]=@domain,[SAMAccountName]=@sam
                          ,[Email]=@email,[PhotoFileName]=@photo,[Country]=@country,[City]=@city,[Address]=@address,[Phone]=@phone,[Birthday]=@birthday,[Site]=@site,[Business]=@business
                          ,[Job]=@job,[Memberships]=@memberships,[Guest]=@guest,[Operator]=@sa,[Manager]=@am,[Administrator]=@admin
                          ,[Password]=@password,[Credits]=@credits,[Status]=@status,[UpdatedBy]=@updatedby,[Updated]=GetDate() WHERE [ID] = @id"
        
        DeleteCommand="DELETE FROM [dbo].[sysContacts] WHERE [ID] = @id">
        <InsertParameters>
            <asp:QueryStringParameter Name="cohort" />
            <asp:QueryStringParameter Name="uid" />
            <asp:QueryStringParameter Name="full" />             
            <asp:QueryStringParameter Name="first" />
            <asp:QueryStringParameter Name="last" />
            <asp:QueryStringParameter Name="book" />
            <asp:QueryStringParameter Name="domain" />
            <asp:QueryStringParameter Name="sam" />
            <asp:QueryStringParameter Name="email" />
            <asp:QueryStringParameter Name="photo" />
            <asp:QueryStringParameter Name="country" />
            <asp:QueryStringParameter Name="city" />
            <asp:QueryStringParameter Name="address" />
            <asp:QueryStringParameter Name="phone" />
            <asp:QueryStringParameter Name="birthday" />
            <asp:QueryStringParameter Name="site" />
            <asp:QueryStringParameter Name="business" />
            <asp:QueryStringParameter Name="job" />
            <asp:QueryStringParameter Name="memberships" />
            <asp:QueryStringParameter Name="guest" />
            <asp:QueryStringParameter Name="sa" />
            <asp:QueryStringParameter Name="am" />
            <asp:QueryStringParameter Name="admin" />
            <asp:QueryStringParameter Name="password" />
            <asp:QueryStringParameter Name="credits" />
            <asp:QueryStringParameter Name="status" />
            <asp:QueryStringParameter Name="updatedby" />
        </InsertParameters>
        <UpdateParameters>
            <asp:QueryStringParameter Name="id" />         
            <asp:QueryStringParameter Name="cohort" />
            <asp:QueryStringParameter Name="uid" />
            <asp:QueryStringParameter Name="full" />             
            <asp:QueryStringParameter Name="first" />
            <asp:QueryStringParameter Name="last" />
            <asp:QueryStringParameter Name="book" />
            <asp:QueryStringParameter Name="domain" />
            <asp:QueryStringParameter Name="sam" />
            <asp:QueryStringParameter Name="email" />
            <asp:QueryStringParameter Name="photo" />
            <asp:QueryStringParameter Name="country" />
            <asp:QueryStringParameter Name="city" />
            <asp:QueryStringParameter Name="address" />
            <asp:QueryStringParameter Name="phone" />
            <asp:QueryStringParameter Name="birthday" />
            <asp:QueryStringParameter Name="site" />
            <asp:QueryStringParameter Name="business" />
            <asp:QueryStringParameter Name="job" />
            <asp:QueryStringParameter Name="memberships" />
            <asp:QueryStringParameter Name="guest" />
            <asp:QueryStringParameter Name="sa" />
            <asp:QueryStringParameter Name="am" />
            <asp:QueryStringParameter Name="admin" />
            <asp:QueryStringParameter Name="password" />
            <asp:QueryStringParameter Name="credits" />
            <asp:QueryStringParameter Name="status" />
            <asp:QueryStringParameter Name="updatedby" />
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
            **** CONTACTS GRIDVIEW TAB
            --%>
                                                                                                                                                                       
            <dx:TabPage Text="GridView">
               <ContentCollection>                              
                   <dx:ContentControl ID="ContentControl1" runat="server">

                   <dx:ASPxGridView ID="ContactsGridView" runat="server" ClientInstanceName="gridViewContacts" DataSourceID="SqlSysContacts" KeyFieldName="ID"
                     OnRowCommand="ContactsGridView_RowCommand" OnSelectionChanged="ContactsGridView_SelectionChanged"
                     OnInitNewRow="ContactsGridView_InitNewRow" OnRowInserting="ContactsGridView_RowInserting" OnRowUpdating="ContactsGridView_RowUpdating" OnRowDeleting="ContactsGridView_RowDeleting"
                     OnCustomCallback="ContactsGridView_CustomCallback" OnToolbarItemClick="ContactsGridView_ToolbarItemClick"
                     EnableTheming="True" EnableViewState="False" AutoGenerateColumns="False" Width="95%">
                     <Toolbars>
                         <dx:GridViewToolbar>
                             <SettingsAdaptivity Enabled="true" EnableCollapseRootItemsToIcons="true" />
                             <Items>
                                 <dx:GridViewToolbarItem Command="Refresh" AdaptivePriority="1" />
                                 <dx:GridViewToolbarItem Name="New" Command="New" BeginGroup="true" AdaptivePriority="6" />
                                 <dx:GridViewToolbarItem Name="Edit" Command="Edit" Enabled="true" AdaptivePriority="5" />                                        
                                 <dx:GridViewToolbarItem Name="Delete" Command="Delete" Enabled="true" AdaptivePriority="7" />                                  
                                 <dx:GridViewToolbarItem Name="ShowFilterRow" Command="ShowFilterRow" BeginGroup="true" AdaptivePriority="2"/>
                                 <dx:GridViewToolbarItem Name="ShowCustomizationWindow" Command="ShowCustomizationWindow" AdaptivePriority="3"/>  

                                 <dx:GridViewToolbarItem Text="Export to" Image-IconID="actions_download_16x16office2013" BeginGroup="true" AdaptivePriority="4">
                                     <Items>
                                         <dx:GridViewToolbarItem Command="ExportToCsv" />
                                         <dx:GridViewToolbarItem Command="ExportToXlsx" Text="Export to XLSX" />
                                     </Items>
                                     <Image IconID="actions_download_16x16office2013"></Image>
                                 </dx:GridViewToolbarItem>

                                 <dx:GridViewToolbarItem Name="CustomImpersonate" Text="Impersonate" BeginGroup="true" AdaptivePriority="4" Enabled="false" />
                   
                                 <dx:GridViewToolbarItem Alignment="Right" BeginGroup="true" AdaptivePriority="5">
                                     <Template>
                                         <dx:ASPxButtonEdit ID="tbxContactsToolbarSearch" runat="server" NullText="Search..." Height="100%">
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
                           <dx:GridViewDataTextColumn FieldName="ID" VisibleIndex="1" Width="60px" Visible="true" />
                           <dx:GridViewDataTextColumn FieldName="Cohort" VisibleIndex="2" Width="100px" Visible="true" />
                           <dx:GridViewDataTextColumn FieldName="UID" VisibleIndex="3" Width="200px" Visible="false" />
                           <dx:GridViewDataTextColumn FieldName="FullName" VisibleIndex="4" Width="120px" Visible="true" />                                          
                           <dx:GridViewDataTextColumn FieldName="FirstName" VisibleIndex="5" Width="120px" Visible="true" />
                           <dx:GridViewDataTextColumn FieldName="LastName" VisibleIndex="6" Width="140px" Visible="true" />
                           <%--<dx:GridViewDataTextColumn FieldName="AddressBook" VisibleIndex="7" Width="120px" Visible="false" />--%>
                           <dx:GridViewDataTextColumn FieldName="Domain" VisibleIndex="8" Width="140px" Visible="true" />
                           <dx:GridViewDataTextColumn FieldName="SAMAccountName" VisibleIndex="9" Width="140px" Visible="true" />
                           <dx:GridViewDataTextColumn FieldName="Email" VisibleIndex="10" Width="200px" Visible="false" />
                           <dx:GridViewDataTextColumn FieldName="PhotoFileName" VisibleIndex="11" Width="180px" Visible="true" />
                           <dx:GridViewDataTextColumn FieldName="Country" VisibleIndex="12" Width="140px" Visible="false" />
                           <dx:GridViewDataTextColumn FieldName="City" VisibleIndex="13" Width="140px" Visible="false" />
                           <dx:GridViewDataTextColumn FieldName="Address" VisibleIndex="14" Width="260px" Visible="false" />
                           <dx:GridViewDataTextColumn FieldName="Phone" VisibleIndex="15" Width="120px" Visible="false" />
                           <%--<dx:GridViewDataTextColumn FieldName="Birthday" VisibleIndex="16" Width="90px" Visible="false" />--%>
                           <dx:GridViewDataTextColumn FieldName="Site" VisibleIndex="17" Width="140px" Visible="false" />      
                           <dx:GridViewDataTextColumn FieldName="Business" VisibleIndex="18" Width="140px" Visible="false" />
                           <dx:GridViewDataTextColumn FieldName="Job" VisibleIndex="19" Width="140px" Visible="false" />
                           <dx:GridViewDataTextColumn FieldName="Memberships" VisibleIndex="20" Width="200px" Visible="false" />
                           <dx:GridViewDataTextColumn FieldName="Guest" VisibleIndex="21" Width="80px" Visible="false" />
                           <dx:GridViewDataTextColumn FieldName="Operator" VisibleIndex="22" Width="100px" Visible="true" />
                           <dx:GridViewDataTextColumn FieldName="Manager" VisibleIndex="23" Width="100px" Visible="true" />
                           <dx:GridViewDataTextColumn FieldName="Administrator" VisibleIndex="24" Width="100px" Visible="true" />                                                                                                                 
                           <%--<dx:GridViewDataTextColumn FieldName="Password" VisibleIndex="25" Width="150px" Visible="false" />
                           <%--<dx:GridViewDataTextColumn FieldName="Credits" VisibleIndex="26" Width="90px" Visible="false" />--%>
                           <dx:GridViewDataTextColumn FieldName="Status" VisibleIndex="27" Width="90px" Visible="false" />
                           <dx:GridViewDataTextColumn FieldName="UpdatedBy" VisibleIndex="28" Width="120px" Visible="false" />
                           <dx:GridViewDataTextColumn FieldName="Updated" VisibleIndex="29" Width="140px" Visible="false" />
                       </Columns>
                       <SettingsPager PageSize="10" AlwaysShowPager="True" EllipsisMode="OutsideNumeric" EnableAdaptivity="True">
                           <PageSizeItemSettings Visible="True"></PageSizeItemSettings>
                       </SettingsPager>
                       <Settings ShowFilterBar="Auto" ShowFilterRow="False" ShowFilterRowMenu="True" ShowHeaderFilterButton="False" 
                         ShowGroupedColumns="True" ShowPreview="True" VerticalScrollBarMode="Hidden" HorizontalScrollBarMode="Auto" /> 
                       <SettingsResizing ColumnResizeMode="Control" />                                               
                       <SettingsBehavior AllowClientEventsOnLoad="False"  AllowSelectSingleRowOnly="True" AllowSelectByRowClick="True" AllowFocusedRow="True" EnableCustomizationWindow="true" AllowEllipsisInText="False" AllowDragDrop="True" />
                       <SettingsExport EnableClientSideExportAPI="true" ExportSelectedRowsOnly="False" />
                      <SettingsSearchPanel Visible="true" ShowApplyButton="True" ShowClearButton="True" CustomEditorID="tbxContactsToolbarSearch" />                       
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
                                       <dx:GridViewColumnLayoutItem ColumnName="UID" Caption="UID" ColumnSpan="1">
                                         <Template>
                                            <dx:ASPxLabel ID="uidLabel" runat="server" Width="90%" Text='<%# Bind("UID") %>' />
                                         </Template>
                                       </dx:GridViewColumnLayoutItem>
                   
                                       <dx:GridViewColumnLayoutItem ColumnName="Cohort" Caption="Cohort" ColumnSpan="1">
                                         <Template>
                                            <dx:ASPxTextBox ID="cohortTextBox" runat="server" Width="80%" Text='<%# Bind("Cohort") %>' />
                                         </Template>
                                       </dx:GridViewColumnLayoutItem>                   

                                       <%--
                                       <dx:GridViewColumnLayoutItem ColumnName="AddressBook" Caption="Book" ColumnSpan="1">
                                         <Template>
                                            <dx:ASPxTextBox ID="bookTextBox" runat="server" Width="80%" Text='<%# Bind("AddressBook") %>' />
                                         </Template>
                                       </dx:GridViewColumnLayoutItem>
                                       --%>

                                       <dx:GridViewColumnLayoutItem ColumnName="Status" Caption="Status" ColumnSpan="1">
                                         <Template>
                                            <dx:ASPxTextBox ID="statusTextBox" runat="server" Width="80%" Text='<%# Bind("Status") %>' />
                                         </Template>
                                       </dx:GridViewColumnLayoutItem>
                   
                                       <dx:GridViewColumnLayoutItem ColumnName="FullName" Caption="FullName" ColumnSpan="2">
                                         <Template>
                                            <dx:ASPxTextBox ID="fullNameTextBox" runat="server" Width="80%" Text='<%# Bind("FullName") %>' />
                                         </Template>
                                       </dx:GridViewColumnLayoutItem>
                   
                                       <dx:GridViewColumnLayoutItem ColumnName="FirstName" Caption="Name" ColumnSpan="1">
                                         <Template>
                                            <dx:ASPxTextBox ID="firstNameTextBox" runat="server" Width="80%" Text='<%# Bind("FirstName") %>' />
                                         </Template>
                                       </dx:GridViewColumnLayoutItem>
                                       <dx:GridViewColumnLayoutItem ColumnName="LastName" Caption="LastName" ColumnSpan="1">
                                         <Template>
                                            <dx:ASPxTextBox ID="lastNameTextBox" runat="server" Width="80%" Text='<%# Bind("LastName") %>' />
                                         </Template>
                                       </dx:GridViewColumnLayoutItem>
                   
                                       <dx:GridViewColumnLayoutItem ColumnName="Domain" Caption="Domain" ColumnSpan="1">
                                         <Template>
                                            <dx:ASPxTextBox ID="domainTextBox" runat="server" Width="80%" Text='<%# Bind("Domain") %>' />
                                         </Template>
                                       </dx:GridViewColumnLayoutItem>
                                       <dx:GridViewColumnLayoutItem ColumnName="SAMAccountName" Caption="Account" ColumnSpan="1">
                                         <Template>
                                            <dx:ASPxTextBox ID="samTextBox" runat="server" Width="80%" Text='<%# Bind("SAMAccountName") %>' />
                                         </Template>
                                       </dx:GridViewColumnLayoutItem>
                   
                                       <dx:GridViewColumnLayoutItem ColumnName="Email" Caption="Email" ColumnSpan="1">
                                         <Template>
                                            <dx:ASPxTextBox ID="emailTextBox" runat="server" Width="80%" Text='<%# Bind("Email") %>' />
                                         </Template>
                                       </dx:GridViewColumnLayoutItem>
                   
                                       <dx:GridViewColumnLayoutItem ColumnName="PhotoFileName" Caption="PhotoFileName" ColumnSpan="1">
                                         <Template>
                                            <%--<dx:ASPxTextBox ID="photoTextBox" runat="server" Width="80%" Text='<%# Bind("PhotoFileName") %>' />--%>
                                            <dx:ASPxComboBox ID="photoComboBox" DropDownStyle="DropDown" runat="server" Width="50%" Value='<%# Bind("PhotoFileName") %>'>
                                               <Items>
                                                   <dx:ListEditItem Value="guest.jpg" Text="guest.jpg" />
                                                   <dx:ListEditItem Value="User.png" Text="user.png" />                                                     
                                                   <dx:ListEditItem Value="boss.png" Text="boss.png" />
                                                   <dx:ListEditItem Value="student.png" Text="student.png" />
                                                   <dx:ListEditItem Value="supervisor.png" Text="supervisor.png" />
                                                   <dx:ListEditItem Value="businessman.png" Text="businessman.png" />
                                                   <dx:ListEditItem Value="medical.png" Text="medical.png" />
                                                   <dx:ListEditItem Value="captain.png" Text="captain.png" />                                                     
                                                   <dx:ListEditItem Value="armyofficer.png" Text="officer.png" />
                                                   <dx:ListEditItem Value="superman.png" Text="superman.png" />
                                                   <dx:ListEditItem Value="devil.png" Text="devil.png" />
                                                </Items>
                                            </dx:ASPxComboBox>                                              
                                         </Template>
                                       </dx:GridViewColumnLayoutItem>
                   
                                       <dx:GridViewColumnLayoutItem ColumnName="Country" Caption="Country" ColumnSpan="1">
                                         <Template>
                                            <dx:ASPxTextBox ID="countryTextBox" runat="server" Width="80%" Text='<%# Bind("Country") %>' />
                                         </Template>
                                       </dx:GridViewColumnLayoutItem>
                   
                                       <dx:GridViewColumnLayoutItem ColumnName="City" Caption="City" ColumnSpan="1">
                                         <Template>
                                            <dx:ASPxTextBox ID="cityTextBox" runat="server" Width="80%" Text='<%# Bind("City") %>' />
                                         </Template>
                                       </dx:GridViewColumnLayoutItem>
                   
                                       <dx:GridViewColumnLayoutItem ColumnName="Address" Caption="Address" ColumnSpan="2">
                                         <Template>
                                            <dx:ASPxTextBox ID="addressTextBox" runat="server" Width="80%" Text='<%# Bind("Address") %>' />
                                         </Template>
                                       </dx:GridViewColumnLayoutItem>
                   
                                       <dx:GridViewColumnLayoutItem ColumnName="Phone" Caption="Phone" ColumnSpan="1">
                                         <Template>
                                            <dx:ASPxTextBox ID="phoneTextBox" runat="server" Width="80%" Text='<%# Bind("Phone") %>' />
                                         </Template>
                                       </dx:GridViewColumnLayoutItem>

                                       <%--                             
                                       <dx:GridViewColumnLayoutItem ColumnName="Birthday" Caption="Birthday" ColumnSpan="1">
                                         <Template>
                                            <dx:ASPxDateEdit ID="birthdateEdit" runat="server" EditFormat="Date" Width="95%" ReadOnly="False" Value='<%# Bind("Birthday") %>' />
                                         </Template>
                                       </dx:GridViewColumnLayoutItem>
                                       --%>
                   
                                       <dx:GridViewColumnLayoutItem ColumnName="Site" Caption="Site" ColumnSpan="1">
                                         <Template>
                                            <dx:ASPxTextBox ID="siteTextBox" runat="server" Width="80%" Text='<%# Bind("Site") %>' />
                                         </Template>
                                       </dx:GridViewColumnLayoutItem>
                   
                                       <dx:GridViewColumnLayoutItem ColumnName="Business" Caption="Business" ColumnSpan="1">
                                         <Template>
                                            <dx:ASPxTextBox ID="businessTextBox" runat="server" Width="80%" Text='<%# Bind("Business") %>' />
                                         </Template>
                                       </dx:GridViewColumnLayoutItem>
                   
                                       <dx:GridViewColumnLayoutItem ColumnName="Job" Caption="Job" ColumnSpan="1">
                                         <Template>
                                            <dx:ASPxTextBox ID="jobTextBox" runat="server" Width="80%" Text='<%# Bind("Job") %>' />
                                         </Template>
                                       </dx:GridViewColumnLayoutItem>

                                       <%--                   
                                       <dx:GridViewColumnLayoutItem ColumnName="Memberships" Caption="Memberships" ColumnSpan="1">
                                         <Template>
                                            <dx:ASPxTextBox ID="memberTextBox" runat="server" Width="80%" Text='<%# Bind("Memberships") %>' />
                                         </Template>
                                       </dx:GridViewColumnLayoutItem>
                                       --%>                                       
                   
                                       <dx:GridViewColumnLayoutItem ColumnName="Guest" Caption="IsGuest" ColumnSpan="1">
                                         <Template>
                                            <dx:ASPxCheckBox ID="guestCheckBox" runat="server" Width="80%" Value='<%# Bind("Guest") %>' />
                                         </Template>
                                       </dx:GridViewColumnLayoutItem>
                   
                                       <dx:GridViewColumnLayoutItem ColumnName="Operator" Caption="IsOperator" ColumnSpan="1">
                                         <Template>
                                            <dx:ASPxCheckBox ID="saCheckBox" runat="server" Width="80%" Value='<%# Bind("Operator") %>' />
                                         </Template>
                                       </dx:GridViewColumnLayoutItem>
                   
                                       <dx:GridViewColumnLayoutItem ColumnName="Manager" Caption="IsManager" ColumnSpan="1">
                                         <Template>
                                            <dx:ASPxCheckBox ID="amCheckBox" runat="server" Width="80%" Value='<%# Bind("Manager") %>' />
                                         </Template>
                                       </dx:GridViewColumnLayoutItem>
                   
                                       <dx:GridViewColumnLayoutItem ColumnName="Administrator" Caption="IsAdministrator" ColumnSpan="1">
                                         <Template>
                                            <dx:ASPxCheckBox ID="adminCheckBox" runat="server" Width="80%" Value='<%# Bind("Administrator") %>' />
                                         </Template>
                                       </dx:GridViewColumnLayoutItem>

                                       <%--
                                       <dx:GridViewColumnLayoutItem ColumnName="Password" Caption="Password" ColumnSpan="1">
                                         <Template>
                                            <dx:ASPxTextBox ID="passwordTextBox" runat="server" Width="80%" Text='<%# Bind("Password") %>' />
                                         </Template>
                                       </dx:GridViewColumnLayoutItem>
                                       --%>
                   
                                       <%--
                                       <dx:GridViewColumnLayoutItem ColumnName="Credits" Caption="Credits" ColumnSpan="1">
                                         <Template>
                                            <dx:ASPxTextBox ID="creditsTextBox" runat="server" Width="80%" Text='<%# Bind("Credits") %>' />
                                         </Template>
                                       </dx:GridViewColumnLayoutItem>
                                       --%>
                                             
                                       <%--
                                       <dx:GridViewColumnLayoutItem ColumnName="UpdatedBy" Caption="UpdatedBy" ColumnSpan="1">
                                         <Template>
                                            <dx:ASPxTextBox ID="updatedbyTextBox" runat="server" Width="80%" Text='<%# Bind("UpdatedBy") %>' />
                                         </Template>
                                       </dx:GridViewColumnLayoutItem>
                                       --%>
                   
                                       <%--
                                       <dx:GridViewColumnLayoutItem ColumnName="Updated" Caption="Updated" ColumnSpan="2">
                                      --%>
                   
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
                       <ClientSideEvents Init="OnGridViewContactsInit" SelectionChanged="OnGridViewContactsSelectionChanged" FocusedRowChanged="OnGridViewContactsFocusedRowChanged" 
                         ToolbarItemClick="OnGridViewContactsToolbarItemClick" />
                   </dx:ASPxGridView>
                
                   <br/>
                   <dx:ASPxButton ID="SyncButton" runat="server" Text="Sync-AD" OnClick="SyncButtonClick" Width="100" Visible="true">
                       <ClientSideEvents Click="function(s, e) { LoadingPanel.Show(); }" />
                   </dx:ASPxButton>
                   <br/>
              
                   </dx:ContentControl>
              </ContentCollection>                                    
            </dx:TabPage>

            <%--
            **** CONTACT CARDS TAB
            --%>
                                                                                                                                                     
            <dx:TabPage Text="Cards">
               <ContentCollection>                              
                   <dx:ContentControl ID="ContentControl2" runat="server">                    
                      
                      <dx:ASPxCardView ID="CardView" ClientInstanceName="cardView" ClientIDMode="Static" runat="server" DataSourceID="ContactsDataSource" KeyFieldName="ID" EnableCardsCache="false" Width="90%"
                          OnCardDeleting="CardView_CardDeleting" OnCardInserting="CardView_CardInserting" OnCardUpdating="CardView_CardUpdating" OnInitNewCard="CardView_InitNewCard">
                          <Settings ShowHeaderFilterButton="true" ShowHeaderPanel="true"/>      
                          <SettingsPager EnableAdaptivity="true">
                              <SettingsTableLayout ColumnCount="3" RowsPerPage="2" />
                          </SettingsPager>
                          <SettingsPopup>
                              <EditForm>
                                  <SettingsAdaptivity Mode="OnWindowInnerWidth" SwitchAtWindowInnerWidth="768" />
                              </EditForm>
                          </SettingsPopup>
                          <Styles>
                              <Card BackColor="#E1E1E1" />
                          </Styles>                          
                          <Columns>
                              <dx:CardViewTextColumn FieldName="FullName" />                          
                              <dx:CardViewTextColumn FieldName="Cohort" />
                              <dx:CardViewTextColumn FieldName="AddressBook" />             
                              <dx:CardViewTextColumn FieldName="Email" />
                              <dx:CardViewTextColumn FieldName="Business" />
                              <dx:CardViewTextColumn FieldName="Site" />
                              <dx:CardViewTextColumn FieldName="Operator" />
                              <dx:CardViewTextColumn FieldName="Manager" />
                              <dx:CardViewTextColumn FieldName="Administrator" />                                                                                               
                          </Columns>
                          <CardLayoutProperties ColCount="2">
                              <Items>
                                  <dx:CardViewColumnLayoutItem ColumnName="Photo" ShowCaption="False" ColSpan="1" RowSpan="4">
                                      <Template>
                                          <dx:ASPxImage ID="ContactImage" runat="server" Height=140 Width=140 ImageAlign="Left" ImageUrl='<%# "~//Photos//" + Eval("PhotoFileName") %>'></dx:ASPxImage>
                                      </Template>
                                  </dx:CardViewColumnLayoutItem>
                                  <dx:CardViewColumnLayoutItem ColumnName="FullName" ShowCaption="False">
                                      <Template>
                                          <dx:ASPxLabel ID="fullnameLabel" runat="server" Font-Bold="True" Font-Size="Medium" Width="80%" Text='<%# Bind("FullName") %>' />
                                      </Template>
                                  </dx:CardViewColumnLayoutItem>
                                  <dx:CardViewColumnLayoutItem ColumnName="Email" />
                                  <dx:CardViewColumnLayoutItem ColumnName="Business" />
                                  <dx:CardViewColumnLayoutItem ColumnName="Site" />
                                  <dx:CardViewColumnLayoutItem ColumnName="Operator" />
                                  <dx:CardViewColumnLayoutItem ColumnName="Manager" />
                                  <dx:CardViewColumnLayoutItem ColumnName="Administrator" />
                              </Items>
                          </CardLayoutProperties>
                          <Toolbars>
                              <dx:CardViewToolbar Position="Bottom">
                                  <SettingsAdaptivity Enabled="true" EnableCollapseRootItemsToIcons="true" />
                                  <Items>
                                      <dx:CardViewToolbarItem Command="Refresh" />
                                      <dx:CardViewToolbarItem Command="New" BeginGroup="true" AdaptivePriority="2" Visible="false"/>
                                      <dx:CardViewToolbarItem Command="Edit" Visible="false"/>                                       
                                      <dx:CardViewToolbarItem Command="Delete" Visible="false"/>
                                      <dx:CardViewToolbarItem Alignment="Right" BeginGroup="true" AdaptivePriority="4">
                                          <Template>
                                              <dx:ASPxButtonEdit ID="tbxCardsToolbarSearch" runat="server" NullText="Search..." Height="100%">
                                                  <Buttons>
                                                      <dx:SpinButtonExtended Image-IconID="find_find_16x16gray" />
                                                  </Buttons>
                                              </dx:ASPxButtonEdit>
                                          </Template>
                                      </dx:CardViewToolbarItem>
                                  </Items>
                              </dx:CardViewToolbar>
                          </Toolbars>
                          <SettingsBehavior AllowSelectByCardClick="true" AllowFocusedCard="true" AllowSelectSingleCardOnly="true" /> 
                          <SettingsSearchPanel Visible="true" ShowApplyButton="True" ShowClearButton="True" CustomEditorID="tbxCardsToolbarSearch" />
                          <ClientSideEvents Init="onCardViewInit" SelectionChanged="onCardViewSelectionChanged" ToolbarItemClick="onCardViewToolbarItemClick" />                                        
                      </dx:ASPxCardView>  

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

   <asp:SqlDataSource ID="SqlSettingsDataSource" runat="server"
     ConnectionString="<%$ ConnectionStrings:BlackBoxConnectionString %>" 
     SelectCommand="SELECT [Group],[Name],[SerializeAs],[Value],[UpdatedBy],[Updated] FROM [dbo].[BlackBoxSettings] ORDER BY [group] DESC, [name]"
     UpdateCommand="UPDATE [dbo].[BlackBoxSettings] SET [SerializeAs]=@serializeAs, [Value]=@value, [UpdatedBy]=@updatedBy WHERE [Group]=@group AND [Name]=@name"
     DeleteCommand="DELETE FROM [BlackBoxSettings] WHERE [Group]=@group AND [Name]=@name">
     <SelectParameters>
        <asp:QueryStringParameter Name="group" />
        <asp:QueryStringParameter Name="name" />
     </SelectParameters>
     <UpdateParameters>
         <asp:QueryStringParameter Name="group" />
         <asp:QueryStringParameter Name="name" />
         <asp:QueryStringParameter Name="serializeAs" />
         <asp:QueryStringParameter Name="value" />
         <asp:QueryStringParameter Name="updatedBy" />                                    
     </UpdateParameters>  
     <DeleteParameters>
        <asp:QueryStringParameter Name="group" />
        <asp:QueryStringParameter Name="name" />
     </DeleteParameters>
   </asp:SqlDataSource>

   <%--
   **** ADDITIONAL DATA SOURCES
   --%>
  

</asp:Content>
