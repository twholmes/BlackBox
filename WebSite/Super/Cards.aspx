<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="Super.master" CodeBehind="Cards.aspx.cs" Inherits="BlackBox.CardsPage" Title="BlackBox" %>

<%@ Register assembly="DevExpress.Web.v22.2, Version=22.2.3.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" namespace="DevExpress.Web" tagprefix="dx" %>

<%--
**** HEADER CONTENT
--%>

<asp:Content runat="server" ContentPlaceHolderID="ContentPlaceHolderHead">
  
  <style type="text/css">

  // ///////////////////////
  // extra styles
  // ///////////////////////
 
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
  function updatePageToolbarButtonsState() 
  {
  }
    
  function OnPageToolbarItemClick(s, e) 
  {
    switch(e.item.name) 
    {
      case "Unknow":
          break;
    }
  }

  // ////////////////////////////////
  // contacts card view functions
  // ////////////////////////////////

  function OnCardViewInit(s, e) 
  {
    AddAdjustmentDelegate(adjustCardView);
    updatePageToolbarButtonsState();
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
  function OnCardViewDatasetsInit(s, e) 
  {
    AddAdjustmentDelegate(adjustCardViewDatasets);
    updatePageToolbarButtonsState();
  }
    
  function adjustCardViewDatasets() 
  {
    cardViewDatasets.AdjustControl();
  }    

  function OnCardViewDatasetsSelectionChanged(s, e) 
  {
    //var enabled = cardViewDatasets.GetSelectedCardCount() > 0;
    var fci = cardViewDatasets.GetFocusedCardIndex();
  }
  
  // datasets cardview toolbar functions
  function OnCardViewDatasetsToolbarItemClick(s, e) 
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
  function OnCardViewFilesInit(s, e) 
  {
    AddAdjustmentDelegate(adjustCardViewFiles);
    updatePageToolbarButtonsState();
  }
    
  function adjustCardViewFiles() 
  {
    cardViewFiles.AdjustControl();
  }    

  function OnCardViewFilesSelectionChanged(s, e) 
  {
    //var enabled = cardViewFiles.GetSelectedCardCount() > 0;
    var fci = cardViewFiles.GetFocusedCardIndex();
  }

  // files cardview toolbar functions
  function OnCardViewFilesToolbarItemClick(s, e) 
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

  window.OnCardViewInit = OnCardViewInit;
  window.OnCardViewSelectionChanged = OnCardViewSelectionChanged;    
  window.OnCardViewToolbarItemClick = OnCardViewToolbarItemClick;

  window.OnCardViewDatasetsInit = OnCardViewDatasetsInit;
  window.OnCardViewDatasetsSelectionChanged = OnCardViewDatasetsSelectionChanged;    
  window.OnCardViewDatasetsToolbarItemClick = OnCardViewDatasetsToolbarItemClick;

  window.OnCardViewDataSourcesInit = OnCardViewDataSourcesInit;
  window.OnCardViewDataSourcesSelectionChanged = OnCardViewDataSourcesSelectionChanged;    
  window.OnCardViewDataSourcesToolbarItemClick = OnCardViewDataSourcesToolbarItemClick;
  
  window.OnCardViewFilesInit = OnCardViewFilesInit;
  window.OnCardViewFilesSelectionChanged = OnCardViewFilesSelectionChanged;    
  window.OnCardViewFilesToolbarItemClick = OnCardViewFilesToolbarItemClick;

 
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
                           <dx:ASPxLabel ID="BreadcrumbsLabel" runat="server" Text="Cards" Font-Bold="True" Font-Size="Large" Width="280px" />
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


   <%--
   **** CONTENT TABS
   --%>

   <dx:ASPxPageControl ID="mainTabPages" Width="100%" ClientInstanceName="mainTabPages" runat="server" ActiveTabIndex="0" EnableHierarchyRecreation="True" >
       <TabPages>

       <%--
       **** CONTACTS TABPAGE
       --%>

       <dx:TabPage Text="Contacts">
          <ContentCollection>                              
              <dx:ContentControl ID="MainContentControl1" runat="server">                     
                 
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
                                 <dx:CardViewToolbarItem Command="New" BeginGroup="true" AdaptivePriority="2" Visible="false" />
                                 <dx:CardViewToolbarItem Command="Edit" Visible="false" />
                                 <dx:CardViewToolbarItem Command="Delete" Visible="false" />
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
              <dx:ContentControl ID="MainContentControl2" runat="server">       
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
                                 <dx:CardViewToolbarItem Command="New" BeginGroup="true" AdaptivePriority="2" Visible="false" />
                                 <dx:CardViewToolbarItem Command="Edit" Visible="false" />                                      
                                 <dx:CardViewToolbarItem Command="Delete" Visible="false" />
                                 <dx:CardViewToolbarItem Name="Import" Text="Uploads..." BeginGroup="false" Enabled="true" />
                             </Items>
                         </dx:CardViewToolbar>
                     </Toolbars>
                     <SettingsBehavior AllowSelectByCardClick="true" AllowFocusedCard="true" AllowSelectSingleCardOnly="true" />   
                     <SettingsAdaptivity>
                         <BreakpointsLayoutSettings CardsPerRow="3" />
                     </SettingsAdaptivity>              
                     <ClientSideEvents Init="OnCardViewDatasetsInit" SelectionChanged="OnCardViewDatasetsSelectionChanged" ToolbarItemClick="OnCardViewDatasetsToolbarItemClick" />                
                 </dx:ASPxCardView>  

              </dx:ContentControl>
         </ContentCollection>                                    
       </dx:TabPage>               
       
       <%--
       **** DATA SOURCES TABPAGE
       --%>
                                                                                                                                                
       <dx:TabPage Text="Data Sources">
          <ContentCollection>                              
              <dx:ContentControl ID="MainContentControl3" runat="server">       
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
                                 <dx:CardViewToolbarItem Command="New" BeginGroup="true" AdaptivePriority="2" Visible="false" />
                                 <dx:CardViewToolbarItem Command="Edit" Visible="false" />
                                 <dx:CardViewToolbarItem Command="Delete" Visible="false" />
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
              <dx:ContentControl ID="MainContentControl4" runat="server"> 
   
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
                                 <dx:CardViewToolbarItem Command="New" BeginGroup="true" AdaptivePriority="2" Visible="false" />
                                 <dx:CardViewToolbarItem Command="Edit" Visible="false" />
                                 <dx:CardViewToolbarItem Command="Delete" Visible="false" />
                                 <dx:CardViewToolbarItem Name="Import" Text="Uploads..." BeginGroup="false" Enabled="true" />
                             </Items>
                         </dx:CardViewToolbar>
                     </Toolbars>
                     <SettingsBehavior AllowSelectByCardClick="true" AllowFocusedCard="true" AllowSelectSingleCardOnly="true" />   
                     <SettingsAdaptivity>
                         <BreakpointsLayoutSettings CardsPerRow="3" />
                     </SettingsAdaptivity>              
                     <ClientSideEvents Init="OnCardViewFilesInit" SelectionChanged="OnCardViewFilesSelectionChanged" ToolbarItemClick="OnCardViewFilesToolbarItemClick" />                
                 </dx:ASPxCardView>  
   
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
   
   <asp:ObjectDataSource ID="ContactsDataSource" runat="server" DataObjectTypeName="BlackBox.Helper.Contact"
       TypeName="BlackBox.Model.DataProvider"
       SelectMethod="GetContactsList" InsertMethod="AddNewContact" UpdateMethod="UpdateContact" DeleteMethod="DeleteContact">
   </asp:ObjectDataSource>
    
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
   **** ADDITIONAL DATA SOURCES
   --%>


</asp:Content>
