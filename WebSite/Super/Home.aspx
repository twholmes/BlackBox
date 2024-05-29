<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="Super.master" CodeBehind="Home.aspx.cs" Inherits="BlackBox.SuperHomePage" Title="BlackBox" %>

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
      case "Dummy":
          break;
    }
  }

  // ////////////////////////////////
  // contacts card view functions
  // ////////////////////////////////

  function OnCardViewInit(s, e) 
  {
    AddAdjustmentDelegate(adjustCardView);
    updateToolbarButtonsState();
  }
    
  function adjustCardView() 
  {
    cardView.AdjustControl();
  }    

  // card view toolbar functions
  function OnCardViewToolbarItemClick(s, e) 
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

  function OnCardViewSelectionChanged(s, e) 
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

  // //////////////////////////////
  // datasets cardview functions
  // //////////////////////////////

  // datasets cardview functions
  function onCardViewDatasetsInit(s, e) 
  {
    AddAdjustmentDelegate(adjustCardViewDatasets);
    updatePageToolbarButtonsState();
  }
    
  function adjustCardViewDatasets() 
  {
    cardViewDatasets.AdjustControl();
  }    

  function onCardViewDatasetsSelectionChanged(s, e) 
  {
    //var enabled = cardViewDatasets.GetSelectedCardCount() > 0;
    var fci = cardViewDatasets.GetFocusedCardIndex();
  }
  
  // datasets cardview toolbar functions
  function onCardViewDatasetsToolbarItemClick(s, e) 
  {
    switch(e.item.name) 
    {
      case "New":
          cardViewDatasets.AddNewCard();
          break;
      case "Edit":
          cardViewDatasets.StartEditCard(cardViewDatasets.GetFocusedRowIndex());
          break;
      case "Delete":
          deleteSelectedCards();
          break;
       case "Inspect":
          e.processOnServer=true;
          e.usePostBack=true;
          break;
       case "Import":
          e.processOnServer=true;
          e.usePostBack=true;
          break;
    }
  }
  
  // cardview support functions
  function deleteSelectedCards() 
  {
    if (confirm('Confirm Delete?')) 
    {
      e.processOnServer = true;
      e.usePostBack = true;     
      // alternate: cardViewFiles.PerformCallback('delete');
    }
  }

  // /////////////////////////////////
  // data sources cardview functions
  // /////////////////////////////////

  // data sources cardview functions
  function OnCardViewDataSourcesInit(s, e) 
  {
    AddAdjustmentDelegate(adjustCardViewDataSources);
    updatePageToolbarButtonsState();
  }
    
  function adjustCardViewDataSources() 
  {
    cardViewDataSources.AdjustControl();
  }    

  function OnCardViewDataSourcesSelectionChanged(s, e) 
  {
    var enabled = cardViewDataSources.GetSelectedCardCount() > 0;
  }

  // data sources cardview toolbar functions
  function OnCardViewDataSourcesToolbarItemClick(s, e) 
  {
    switch(e.item.name) 
    {
      case "New":
          cardViewDataSources.AddNewCard();
          break;
      case "Edit":
          cardViewDataSources.StartEditCard(cardViewDataSources.GetFocusedRowIndex());
          break;
      case "Delete":
          deleteSelectedCards();
          break;
       case "Inspect":
          e.processOnServer=true;
          e.usePostBack=true;
          break;
       case "Import":
          e.processOnServer=true;
          e.usePostBack=true;
          break;
   }
  }

  // //////////////////////////////
  // files cardview functions
  // //////////////////////////////

  // files cardview functions
  function onCardViewFilesInit(s, e) 
  {
    AddAdjustmentDelegate(adjustCardViewFiles);
    updatePageToolbarButtonsState();
  }
    
  function adjustCardViewFiles() 
  {
    cardViewFiles.AdjustControl();
  }    

  function onCardViewFilesSelectionChanged(s, e) 
  {
    //var enabled = cardViewFiles.GetSelectedCardCount() > 0;
    var fci = cardViewFiles.GetFocusedCardIndex();
  }

  // files cardview toolbar functions
  function onCardViewFilesToolbarItemClick(s, e) 
  {
    switch(e.item.name) 
    {
      case "New":
          cardViewFiles.AddNewCard();
          break;
      case "Edit":
          cardViewFiles.StartEditCard(cardViewFiles.GetFocusedRowIndex());
          break;
      case "Delete":
          deleteSelectedCards();
          break;
       case "Inspect":
          e.processOnServer=true;
          e.usePostBack=true;
          break;
       case "Import":
          e.processOnServer=true;
          e.usePostBack=true;
          break;
   }
  }
 
  // ///////////////////////
  // popup functions
  // ///////////////////////

  // show the popup
  function ShowModalInspectPopup() 
  {
    pcInspectSelect.Show();
    gridViewContacts.Refresh();
  }
 
  // popup submit button click
  function OnPcInspectSubmitButtonClick(s, e) 
  {
    var contact = pcContactComboBox.GetText();
    pcInspectSelect.Hide();
    if (contact == "Guest")
      openUrlFromPage("Contacts.aspx", true); 
    else
    {
      openUrlFromPage("Contacts.aspx?contact="+contact, true);     
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
  
  window.OnCardViewInit = OnCardViewInit;
  window.OnCardViewSelectionChanged = OnCardViewSelectionChanged;    
  window.OnCardViewToolbarItemClick = OnCardViewToolbarItemClick;

  window.onCardViewDatasetsInit = onCardViewDatasetsInit;
  window.onCardViewDatasetsSelectionChanged = onCardViewDatasetsSelectionChanged;    
  window.onCardViewDatasetsToolbarItemClick = onCardViewDatasetsToolbarItemClick;

  window.OnCardViewDataSourcesInit = OnCardViewDataSourcesInit;
  window.OnCardViewDataSourcesSelectionChanged = OnCardViewDataSourcesSelectionChanged;    
  window.OnCardViewDataSourcesToolbarItemClick = OnCardViewDataSourcesToolbarItemClick;
  
  window.onCardViewFilesInit = onCardViewFilesInit;
  window.onCardViewFilesSelectionChanged = onCardViewFilesSelectionChanged;    
  window.onCardViewFilesToolbarItemClick = onCardViewFilesToolbarItemClick;

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
                           <dx:ASPxLabel ID="BreadcrumbsLabel" runat="server" Text="Home" Font-Bold="True" Font-Size="Large" Width="480px" />
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
          <dx:MenuItem Name="PageMenuUploads" Text="Uploads" NavigateUrl="../Manager/ContactUploads.aspx" Target="_blank" Alignment="Right" AdaptivePriority="1">
               <Image IconID="snap_datasource_svg_dark_16x16" />
          </dx:MenuItem>        
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
           **** FILE MANAGER TABPAGE
           --%>
    
           <dx:TabPage Text="File Manager" Visible="true">
              <ContentCollection>
                  <dx:ContentControl ID="ContentControlRight1" runat="server">
    
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
    
           <dx:TabPage Text="Settings" Visible="true">
              <ContentCollection>
                  <dx:ContentControl ID="ContentControlRight2" runat="server">
     
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
                      VALUES(@cohort,@uid,@full,@first,@last,@book,@domain,@sam,@email,@photo,@country,@city,@address,@phone,@birthday,@site,@business,@job,@memberships,
                         @guest,@sa,@am,@admin,@password,@credits,@status,@updatedby,@updated)"

       UpdateCommand="UPDATE [dbo].[sysContacts] SET [Cohort]=@cohort,[UID]=@uid,[FullName]=@full,[FirstName]=@first,[LastName]=@last,[AddressBook]=@book,[Domain]=@domain,[SAMAccountName]=@sam
                         ,[Email]=@email,[PhotoFileName]=@photo,[Country]=@country,[City]=@city,[Address]=@address,[Phone]=@phone,[Birthday]=@birthday,[Site]=@site,[Business]=@business
                         ,[Job]=@job,[Memberships]=@memberships,[Guest]=@guest,[Operator]=@sa,[Manager]=@am,[Administrator]=@admin
                         ,[Password]=@password,[Credits]=@credits,[Status]=@status,[UpdatedBy]=@updatedby,[Updated]=@updated WHERE [ID] = @id"
       
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
           <asp:QueryStringParameter Name="updated" />
       </InsertParameters>
       <UpdateParameters>
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
           <asp:QueryStringParameter Name="updated" />
       </UpdateParameters>
       <DeleteParameters>
           <asp:QueryStringParameter Name="id" />
       </DeleteParameters>
    </asp:SqlDataSource>
      
      <asp:SqlDataSource ID="SqlBlackBoxDatasets" runat="server" 
         ConnectionString="<%$ ConnectionStrings:BlackBoxConnectionString %>" 
         SelectCommand="SELECT [Name],[Group],[TableName],[Flags],[Description],[StatusID],[Status],[Icon],[TimeStamp],[Age],[Rank] FROM [dbo].[vBlackBoxDatasets] WHERE [Group] not like 'System' ORDER BY [TimeStamp] DESC, [Name] DESC" 
         InsertCommand="INSERT INTO [dbo].[BlackBoxDatasets] ([Name],[Group],[TableName],[Flags],[Description],[StatusID],[TimeStamp]) VALUES(@name,@group,@table,@flags,@description,@statusid,@timestamp)"      
         UpdateCommand="UPDATE [dbo].[BlackBoxDatasets] SET [Group]=@group,[TableName]=@table,[Flags]=@flags,[Description]=@description,[StatusID]=@statusid,[TimeStamp]=@timestamp WHERE [Name] = @name"
         DeleteCommand="DELETE FROM [dbo].[BlackBoxDatasets] WHERE [Name] = @name">
        <SelectParameters>
            <asp:QueryStringParameter Name="group" DefaultValue="%" />
        </SelectParameters>
        <InsertParameters>
            <asp:QueryStringParameter Name="name" />
            <asp:QueryStringParameter Name="group" />
            <asp:QueryStringParameter Name="table" />
            <asp:QueryStringParameter Name="flags" />          
            <asp:QueryStringParameter Name="description" />
            <asp:QueryStringParameter Name="statusid" />
            <asp:QueryStringParameter Name="timestamp" />
        </InsertParameters>
        <UpdateParameters>
            <asp:QueryStringParameter Name="name" />
            <asp:QueryStringParameter Name="group" />
            <asp:QueryStringParameter Name="table" />
            <asp:QueryStringParameter Name="flags" />          
            <asp:QueryStringParameter Name="description" />
            <asp:QueryStringParameter Name="statusid" />
            <asp:QueryStringParameter Name="timestamp" />
        </UpdateParameters>
        <DeleteParameters>
             <asp:QueryStringParameter Name="name" />
         </DeleteParameters>
      </asp:SqlDataSource>      
      
      <asp:SqlDataSource ID="SqlBlackBoxDataSources" runat="server" 
        ConnectionString="<%$ ConnectionStrings:BlackBoxConnectionString %>"       
        SelectCommand="SELECT [Name],[Group],[Description],[TypeID],[Locked],[Datasets],[Prefix],[StatusID],[Status],[Icon],[TimeStamp],[Age] FROM [dbo].[vBlackBoxDataSources] WHERE [Group] like @group and [Group] not like 'System' ORDER BY [Name] DESC"
        InsertCommand="INSERT INTO [dbo].[BlackBoxDataSources] ([Name],[Group],[Description],[TypeID],[Datasets],[Prefix],[StatusID],[TimeStamp]) VALUES(@name,@group,@description,@typeid,@datasets,@prefix,@statusid,@timestamp)"
        UpdateCommand="UPDATE [dbo].[BlackBoxDataSources] SET [Group]=@group,[Description]=@description,[TypeID]=@typeid,[Datasets]=@datasets,[Prefix]=@prefix,[StatusID]=@statusid,[TimeStamp]=@timestamp WHERE [Name] = @name"
        DeleteCommand="DELETE FROM [dbo].[BlackBoxDataSources] WHERE [Name] like @name">
        <SelectParameters>
            <asp:QueryStringParameter Name="group" DefaultValue="%" />
        </SelectParameters>
        <InsertParameters>
            <asp:QueryStringParameter Name="name" />
            <asp:QueryStringParameter Name="group" />
            <asp:QueryStringParameter Name="description" />
            <asp:QueryStringParameter Name="typeid" />
            <asp:QueryStringParameter Name="datasets" />
            <asp:QueryStringParameter Name="prefix" />
            <asp:QueryStringParameter Name="statusid" />
            <asp:QueryStringParameter Name="timestamp" />
        </InsertParameters>
        <UpdateParameters>
            <asp:QueryStringParameter Name="name" />
            <asp:QueryStringParameter Name="group" />
            <asp:QueryStringParameter Name="description" />
            <asp:QueryStringParameter Name="typeid" />
            <asp:QueryStringParameter Name="datasets" />
            <asp:QueryStringParameter Name="prefix" />
            <asp:QueryStringParameter Name="statusid" />
            <asp:QueryStringParameter Name="timestamp" />
        </UpdateParameters>
        <DeleteParameters>
            <asp:QueryStringParameter Name="name" />
        </DeleteParameters>
      </asp:SqlDataSource>
  
      <asp:SqlDataSource ID="SqlBlackBoxFiles" runat="server" 
         ConnectionString="<%$ ConnectionStrings:BlackBoxConnectionString %>" 
         SelectCommand="SELECT TOP(200) [FID],[JOBID],[GUID],[Name],[Location],[TypeID],[Type],[Group],[Description],[DataSource],[DataSourceInstanceID],[Icon],[Datasets],[StatusID],[Status],[Locked],[UserID],[TimeStamp],[Age],[Rank] FROM [dbo].[vBlackBoxFiles]"
         InsertCommand="INSERT INTO [dbo].[BlackBoxFiles] ([JOBID],[GUID],[Name],[Location],[TypeID],[Group],[Description],[DataSource],[DataSourceInstanceID],[Datasets],[StatusID],[Locked],[TimeStamp]) VALUES(@jobid,@guid,@name,@location,@typeid,@group,@description,@datasource,@dsiid,@datasets,@statusid,@locked,@timestamp)"
         UpdateCommand="UPDATE [dbo].[BlackBoxFiles] SET [JOBID]=@jobid,[GUID]=@guid,[Name]=@name,[Location]=@location,[TypeID]=@typeid,[Group]=@group,[Description]=@description,[DataSource]=@datasource,[DataSourceInstanceID]=@dsiid,[Datasets]=@datasets,[StatusID]=@statusid,[Locked]=@locked,[TimeStamp]=@timestamp WHERE [FID] = @fid"
         DeleteCommand="DELETE FROM [dbo].[BlackBoxFiles] WHERE [FID] = @fid">
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

    <%--
    **** CONTENT TABS
    --%>
   
    <dx:ASPxPageControl ID="TabPagesMainPanel" Width="100%" runat="server" ActiveTabIndex="0" EnableHierarchyRecreation="True" >
        <TabPages>
                                                                                                                                                     
            <%--
            **** CONTACTS TABPAGE
            --%>
                                                                                                                             
             <dx:TabPage Text="Contacts">
                <ContentCollection>                              
                    <dx:ContentControl ID="ContentControl1" runat="server">                     
                       
                       <dx:ASPxCardView ID="CardView" ClientInstanceName="cardView" ClientIDMode="Static" runat="server" DataSourceID="ContactsDataSource" KeyFieldName="ID"  EnableCardsCache="false" Width="90%"
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
                               <dx:CardViewTextColumn FieldName="Memberships" />
                           </Columns>
                           <CardLayoutProperties ColCount="2">
                               <Items>
                                   <dx:CardViewCommandLayoutItem ShowSelectCheckbox="true" HorizontalAlign="Left" />              
                                   <dx:CardViewCommandLayoutItem ShowEditButton="true" ColSpan="1" HorizontalAlign="Right" />
                                   <dx:CardViewColumnLayoutItem ColumnName="Photo" ShowCaption="False" ColSpan="1" RowSpan="5">
                                       <Template>
                                           <dx:ASPxImage ID="ContactImage" runat="server" Height=140 Width=140 ImageAlign="Left" ImageUrl='<%# "~//Photos//" + Eval("PhotoFileName") %>'></dx:ASPxImage>
                                       </Template>
                                   </dx:CardViewColumnLayoutItem>
                                   <dx:CardViewColumnLayoutItem ColumnName="FullName" ShowCaption="False">
                                       <Template>
                                           <dx:ASPxHyperLink ID="ContactHyperLink" runat="server" Text='<%# Eval("FullName") %>' NavigateUrl='<%# "ContactDetails.aspx?id=" + Eval("ID") %>' />                                             
                                           <%--<dx:ASPxHyperLink ID="ContactHyperLink" runat="server" Text='<%# Eval("FirstName") + "&nbsp;" + Eval("LastName") %>' NavigateUrl='<%# "ContactDetails.aspx?id=" + Eval("ID") %>' />--%>
                                       </Template>
                                   </dx:CardViewColumnLayoutItem>
                                   <dx:CardViewColumnLayoutItem ColumnName="Email" />
                                   <dx:CardViewColumnLayoutItem ColumnName="Business" />
                                   <dx:CardViewColumnLayoutItem ColumnName="Site" />
                                   <dx:CardViewColumnLayoutItem ColumnName="Memberships" />                                                                   
                                   <dx:EditModeCommandLayoutItem ColSpan="2" HorizontalAlign="Right" />
                               </Items>
                           </CardLayoutProperties>
                           <Toolbars>
                               <dx:CardViewToolbar Position="Bottom">
                                   <SettingsAdaptivity Enabled="true" EnableCollapseRootItemsToIcons="true" />
                                   <Items>
                                       <dx:CardViewToolbarItem Command="Refresh" />
                                       <dx:CardViewToolbarItem Command="New" BeginGroup="true" AdaptivePriority="2"/>
                                       <dx:CardViewToolbarItem Command="Edit" />                                        
                                       <dx:CardViewToolbarItem Command="Delete" />
                                       <%--
                                       <dx:CardViewToolbarItem Alignment="Right" BeginGroup="true" AdaptivePriority="4">
                                           <Template>
                                               <dx:ASPxButtonEdit ID="tbToolbarSearch" runat="server" NullText="Search..." Height="100%">
                                                   <Buttons>
                                                       <dx:SpinButtonExtended Image-IconID="find_find_16x16gray" />
                                                   </Buttons>
                                               </dx:ASPxButtonEdit>
                                           </Template>
                                       </dx:CardViewToolbarItem>
                                       --%>
                                   </Items>
                               </dx:CardViewToolbar>
                           </Toolbars>
                           <SettingsBehavior AllowSelectByCardClick="true" AllowFocusedCard="true" AllowSelectSingleCardOnly="true" />        
                           <ClientSideEvents Init="OnCardViewInit" SelectionChanged="OnCardViewSelectionChanged" ToolbarItemClick="OnCardViewToolbarItemClick" 
                              CardDblClick="function(s, e) { s.StartEditCard(e.visibleIndex); }" />
                       </dx:ASPxCardView>
            
                    </dx:ContentControl>
               </ContentCollection>                                    
             </dx:TabPage>

            <%--
            **** DATASETS TABPAGE
            --%>

            <dx:TabPage Text="Datasets">
               <ContentCollection>                              
                   <dx:ContentControl ID="ContentControl2" runat="server">       
                      <br/>                          

                      <dx:ASPxCardView ID="CardViewDatasets" ClientInstanceName="cardViewDatasets" ClientIDMode="Static" runat="server" DataSourceID="SqlBlackBoxDatasets" KeyFieldName="Name"  EnableCardsCache="false" Width="90%"
                          OnCardDeleting="CardViewDatasets_CardDeleting" OnCardInserting="CardViewDatasets_CardInserting" OnCardUpdating="CardViewDatasets_CardUpdating" OnInitNewCard="CardViewDatasets_InitNewCard" 
                          OnCommandButtonInitialize="CardViewDatasets_CommandButtonInitialize" OnToolbarItemClick="CardViewDatasets_ToolbarItemClick">
                          <Settings ShowHeaderFilterButton="true" ShowHeaderPanel="true" /> 
                          <SettingsPager EnableAdaptivity="true">
                              <SettingsTableLayout RowsPerPage="2" />
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
                              <dx:CardViewTextColumn FieldName="Icon" />                          
                              <dx:CardViewTextColumn FieldName="Name" />
                              <dx:CardViewTextColumn FieldName="Group" />
                              <dx:CardViewTextColumn FieldName="TableName" />
                          </Columns>
                          <CardLayoutProperties ColCount="2">
                              <Items>
                                  <dx:CardViewCommandLayoutItem ShowSelectCheckbox="true" HorizontalAlign="Left" />             
                                  <dx:CardViewCommandLayoutItem ShowEditButton="true" ColSpan="1" HorizontalAlign="Right" />
                                  <dx:CardViewColumnLayoutItem ColumnName="Icon" ShowCaption="False" ColSpan="1" RowSpan="4">
                                      <Template>              
                                          <dx:ASPxImage ID="DatasetImage" runat="server" ImageAlign="Left" ImageUrl='<%# "~/Images/" + Convert.ToString(Eval("Icon")) + ".PNG" %>' ShowLoadingImage="false" />
                                      </Template>
                                  </dx:CardViewColumnLayoutItem>
                                  <dx:EmptyLayoutItem />
                                  <dx:CardViewColumnLayoutItem ColumnName="Name" ShowCaption="True"/>                                  
                                  <dx:CardViewColumnLayoutItem ColumnName="Group" ShowCaption="True"/>
                                  <dx:CardViewColumnLayoutItem ColumnName="TableName" ShowCaption="True"/>
                                  <dx:EmptyLayoutItem />
                              </Items>
                          </CardLayoutProperties>
                          <Toolbars>
                              <dx:CardViewToolbar Position="Bottom">
                                  <SettingsAdaptivity Enabled="true" EnableCollapseRootItemsToIcons="true" />
                                  <Items>
                                      <dx:CardViewToolbarItem Command="Refresh" />
                                      <dx:CardViewToolbarItem Command="New" BeginGroup="true" AdaptivePriority="2"/>
                                      <dx:CardViewToolbarItem Command="Edit" />                                       
                                      <dx:CardViewToolbarItem Command="Delete" />
                                      <dx:CardViewToolbarItem Name="Import" Text="Uploads..." BeginGroup="false" Enabled="true" />
                                  </Items>
                              </dx:CardViewToolbar>
                          </Toolbars>
                          <SettingsBehavior AllowSelectByCardClick="true" AllowFocusedCard="true" AllowSelectSingleCardOnly="true" />   
                          <SettingsAdaptivity>
                              <BreakpointsLayoutSettings CardsPerRow="3" />
                          </SettingsAdaptivity>              
                          <ClientSideEvents Init="onCardViewDatasetsInit" SelectionChanged="onCardViewDatasetsSelectionChanged" ToolbarItemClick="onCardViewDatasetsToolbarItemClick" />                
                      </dx:ASPxCardView>  

                   </dx:ContentControl>
              </ContentCollection>                                    
            </dx:TabPage>               
            
            <%--
            **** DATA SOURCES TABPAGE
            --%>
                                                                                                                                                     
            <dx:TabPage Text="Data Sources">
               <ContentCollection>                              
                   <dx:ContentControl ID="ContentControl3" runat="server">       
                      <br/>
                                          
                      <dx:ASPxCardView ID="CardViewDataSources" ClientInstanceName="cardViewDataSources" ClientIDMode="Static" runat="server" DataSourceID="SqlBlackBoxDataSources" KeyFieldName="Name" EnableCardsCache="false" Width="90%"
                          OnCardDeleting="CardViewDataSources_CardDeleting" OnCardInserting="CardViewDataSources_CardInserting" OnCardUpdating="CardViewDataSources_CardUpdating" OnInitNewCard="CardViewDataSources_InitNewCard" 
                          OnCommandButtonInitialize="CardViewDataSources_CommandButtonInitialize" OnToolbarItemClick="CardViewDataSources_ToolbarItemClick">
                          <Settings ShowHeaderFilterButton="true" ShowHeaderPanel="true" /> 
                          <SettingsPager EnableAdaptivity="true">
                              <SettingsTableLayout RowsPerPage="2" />
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
                              <dx:CardViewTextColumn FieldName="Icon" />
                              <dx:CardViewTextColumn FieldName="Name" />
                              <dx:CardViewTextColumn FieldName="Group" />
                          </Columns>
                          <CardLayoutProperties ColCount="2">
                              <Items>
                                  <dx:CardViewCommandLayoutItem ShowSelectCheckbox="true" HorizontalAlign="Left" />             
                                  <dx:CardViewCommandLayoutItem ShowEditButton="true" ColSpan="1" HorizontalAlign="Right" />
                                  <dx:CardViewColumnLayoutItem ColumnName="Icon" ShowCaption="False" ColSpan="1" RowSpan="3">
                                      <Template>              
                                          <dx:ASPxImage ID="DataSourceImage" runat="server" ImageAlign="Left" ImageUrl='<%# "~/Images/" + Convert.ToString(Eval("Icon")) + ".PNG" %>' ShowLoadingImage="false" />                                             
                                      </Template>
                                  </dx:CardViewColumnLayoutItem>
                                  <dx:CardViewColumnLayoutItem ColumnName="Name" ShowCaption="True"/>                                  
                                  <dx:CardViewColumnLayoutItem ColumnName="Group" ShowCaption="True"/>
                                  <dx:EmptyLayoutItem />  
                                  <dx:EditModeCommandLayoutItem ColSpan="2" HorizontalAlign="Right" />
                              </Items>
                          </CardLayoutProperties>
                          <Toolbars>
                              <dx:CardViewToolbar Position="Bottom">
                                  <SettingsAdaptivity Enabled="true" EnableCollapseRootItemsToIcons="true" />
                                  <Items>
                                      <dx:CardViewToolbarItem Command="Refresh" />
                                      <dx:CardViewToolbarItem Command="New" BeginGroup="true" AdaptivePriority="2"/>
                                      <dx:CardViewToolbarItem Command="Edit" />                                       
                                      <dx:CardViewToolbarItem Command="Delete" />
                                      <dx:CardViewToolbarItem Name="Inspect" Text="Inspect" BeginGroup="true" Enabled="true" />
                                      <dx:CardViewToolbarItem Name="Import" Text="Import" BeginGroup="false" Enabled="true" />
                                  </Items>
                              </dx:CardViewToolbar>
                          </Toolbars>
                          <SettingsBehavior AllowSelectByCardClick="true" AllowFocusedCard="true" AllowSelectSingleCardOnly="true" />   
                          <SettingsAdaptivity>
                              <BreakpointsLayoutSettings CardsPerRow="3" />
                          </SettingsAdaptivity>              
                          <ClientSideEvents Init="OnCardViewDataSourcesInit" SelectionChanged="OnCardViewDataSourcesSelectionChanged" ToolbarItemClick="OnCardViewDataSourcesToolbarItemClick" />                
                      </dx:ASPxCardView>  
       
                   </dx:ContentControl>
              </ContentCollection>                                    
            </dx:TabPage>

            <%--
            **** FILES TABPAGE
            --%>

            <dx:TabPage Text="Files">
               <ContentCollection>                              
                   <dx:ContentControl ID="ContentControl4" runat="server"> 
       
                      <br/>                                              
                      <dx:ASPxCardView ID="CardViewFiles" ClientInstanceName="cardViewFiles" ClientIDMode="Static" runat="server" DataSourceID="SqlBlackBoxFiles" KeyFieldName="FID" EnableCardsCache="false" Width="90%"
                          OnCardDeleting="CardViewFiles_CardDeleting" OnCardInserting="CardViewFiles_CardInserting" OnCardUpdating="CardViewFiles_CardUpdating" OnInitNewCard="CardViewFiles_InitNewCard" 
                          OnCommandButtonInitialize="CardViewFiles_CommandButtonInitialize" OnToolbarItemClick="CardViewFiles_ToolbarItemClick">
                          <Settings ShowHeaderFilterButton="true" ShowHeaderPanel="true" /> 
                          <SettingsPager EnableAdaptivity="true">
                              <SettingsTableLayout RowsPerPage="2" />
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
                              <dx:CardViewTextColumn FieldName="Icon" />
                              <dx:CardViewTextColumn FieldName="Name" />
                              <dx:CardViewTextColumn FieldName="DataSource" />                                    
                              <dx:CardViewTextColumn FieldName="Group" />                                   
                              <dx:CardViewTextColumn FieldName="FID" />                                   
                          </Columns>
                          <CardLayoutProperties ColCount="2">
                              <Items>
                                  <dx:CardViewCommandLayoutItem ShowSelectCheckbox="true" HorizontalAlign="Left" />             
                                  <dx:CardViewCommandLayoutItem ShowEditButton="true" ColSpan="1" HorizontalAlign="Right" />
                                  <dx:CardViewColumnLayoutItem ColumnName="Icon" ShowCaption="False" ColSpan="1" RowSpan="4">
                                      <Template>              
                                          <dx:ASPxImage ID="DataSourceImage" runat="server" ImageAlign="Left" ImageUrl='<%# "~/Images/" + Convert.ToString(Eval("Icon")) + ".PNG" %>' ShowLoadingImage="false" />                                             
                                      </Template>
                                  </dx:CardViewColumnLayoutItem>
                                  <dx:CardViewColumnLayoutItem ColumnName="Name" ShowCaption="True"/>
                                  <dx:CardViewColumnLayoutItem ColumnName="DataSource" ShowCaption="True"/>                                       
                                  <dx:CardViewColumnLayoutItem ColumnName="Group" ShowCaption="True"/>
                                  <dx:CardViewColumnLayoutItem ColumnName="FID" Caption="FID" ShowCaption="True"/>
                              </Items>
                          </CardLayoutProperties>
                          <Toolbars>
                              <dx:CardViewToolbar Position="Bottom">
                                  <SettingsAdaptivity Enabled="true" EnableCollapseRootItemsToIcons="true" />
                                  <Items>
                                      <dx:CardViewToolbarItem Command="Refresh" />
                                      <dx:CardViewToolbarItem Command="New" BeginGroup="true" AdaptivePriority="2"/>
                                      <dx:CardViewToolbarItem Command="Edit" />                                       
                                      <dx:CardViewToolbarItem Command="Delete" />
                                      <dx:CardViewToolbarItem Name="Import" Text="Uploads..." BeginGroup="false" Enabled="true" />
                                  </Items>
                              </dx:CardViewToolbar>
                          </Toolbars>
                          <SettingsBehavior AllowSelectByCardClick="true" AllowFocusedCard="true" AllowSelectSingleCardOnly="true" />   
                          <SettingsAdaptivity>
                              <BreakpointsLayoutSettings CardsPerRow="3" />
                          </SettingsAdaptivity>              
                          <ClientSideEvents Init="onCardViewFilesInit" SelectionChanged="onCardViewFilesSelectionChanged" ToolbarItemClick="onCardViewFilesToolbarItemClick" />                
                      </dx:ASPxCardView>  
       
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
                                 <dx:LayoutItem Caption="Contact Details">
                                     <LayoutItemNestedControlCollection>
                                         <dx:LayoutItemNestedControlContainer>
                                             <dx:ASPxComboBox ID="pcContactComboBox" ClientInstanceName="pcContactComboBox" runat="server" ClientIDMode="Static" AutoPostBack="False" Width="90%" SelectedIndex="0">
                                                <Items>
                                                     <dx:ListEditItem Value="Guest" Text="Guest" />
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
