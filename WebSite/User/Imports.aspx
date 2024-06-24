<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="User.master" CodeBehind="Imports.aspx.cs" Inherits="BlackBox.UserImportsPage" Title="BlackBox" %>

<%@ Register assembly="System.Web.DataVisualization, Version=4.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" namespace="System.Web.UI.DataVisualization.Charting" tagprefix="asp" %>

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
  }

  // page toolbar click
  function OnPageToolbarItemClick(s, e) 
  {
    var fri = gridViewUploadedFiles.GetFocusedRowIndex();
    switch(e.item.name) 
    {
      case "PageMenuDataFiles":
          gridViewUploadedFiles.GetRowValues(fri, 'FID', OnGetUploadedFilesFocusedRowValues1);
          break;
      case "PageMenuJobFiles":
          gridViewUploadedFiles.GetRowValues(fri, 'FID', OnGetUploadedFilesFocusedRowValues2);
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
 
  // ///////////////////////
  // imports grid functions
  // ///////////////////////

  // imports gridview functions
  function OnGridViewImportsInit(s, e) 
  { 
    var toolbar = gridViewUploadedFiles.GetToolbar(0);  
    if (toolbar != null) 
    {  
      //var btSubmit = toolbar.Items["CustomStageStep"];  btSubmit.enabled = false;
    }
    gridViewUploadedFiles.GetRowValues(0, 'FID;DataSourceInstanceID', OnGetImportsFocusedRowValues);    
  }
 
  // imports grid focused row changed
  function OnGridViewImportsFocusedRowChanged(s, e)
  {
    var fri = gridViewUploadedFiles.GetFocusedRowIndex();
    gridViewUploadedFiles.GetRowValues(fri, 'FID;DataSourceInstanceID', OnGetImportsFocusedRowValues);
    gridViewUploadedFiles.Refresh();    
  }

  function OnGetImportsFocusedRowValues(values)
  {
    var dsiid = values[1];
    var filterCondition1 = "[DataSourceInstanceID] = " + dsiid;
    //gridViewValidationResults.ApplyFilter(filterCondition1);    
    var fid = values[0];
    var filterCondition2 = "[RefID] = " + fid;
    gridViewHistory.ApplyFilter(filterCondition2);    
  }
    
  // imports grid selected row changed
  function OnGridViewImportsSelectionChanged(s, e) 
  {
    e.processOnServer=true;
    e.usePostBack=true;
  }

  // imports grid toolbar functions  
  function OnGridViewImportsToolbarItemClick(s, e) 
  {
   if (IsCustomGridViewToolbarCommand(e.item.name)) 
   {
     e.processOnServer=true;
     e.usePostBack=true;
   }
   else
   {
     var fri = gridViewUploadedFiles.GetFocusedRowIndex();
     switch(e.item.name) 
     {
       case "CustomOpenFile":
          gridViewUploadedFiles.GetRowValues(fri, 'FID', OnGetUploadedFilesFocusedRowValues1);     
          break;

       case "CustomEditFile":
          gridViewUploadedFiles.GetRowValues(fri, 'FID', OnGetUploadedFilesFocusedRowValues3);
          break;

       case "CustomArchiveStep":
          memoActionMessage.SetText("Do you really want to achive this file?");        
          pcAction.Show();
          btActionCancel.Focus(); 
          break;
      }
    }
  }

  function OnGetUploadedFilesFocusedRowValues1(fid)
  {
    openUrlWithParamFromPage("DataFiles.aspx", "fid", fid, true);
  }

  function OnGetUploadedFilesFocusedRowValues2(fid)
  {
    openUrlWithParamFromPage("JobFiles.aspx", "fid", fid, true);
  }

  function OnGetUploadedFilesFocusedRowValues3(fid)
  {
    openUrlWithParamFromPage("Editor.aspx", "fid", fid, true);
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
      case "CustomDownloadFile":
          isCustom = true;
          break;
                
      case "CustomOpenFile":      
          //openUrlWithParamFromPage("~/Spreadsheet.aspx", true);
          isCustom = false;
          break;
                
      case "CustomEditFile":
          isCustom = false;
          break;

      case "CustomScheduleStep":
      case "CustomRecallStep":
          isCustom = true;
          break;

      case "CustomRegisterStep":
      case "CustomLoadStep":
      case "CustomValidateStep":
          LoadingPanel.Show();      
          isCustom = true;
          break;

      case "CustomStageStep":
      case "CustomRejectStep":   
          LoadingPanel.Show();         
          isCustom = true;
          break;

      case "CustomProcessStep":
      case "CustomPublishStep":
          LoadingPanel.Show();      
          isCustom = true;
          break;

      case "CustomWithdrawStep":     
          LoadingPanel.Show();      
          isCustom = true;
          break;

      case "CustomArchiveStep":
          isCustom = false;
          break;

      case "CustomExcludeRecord":
      case "CustomIncludeRecord":
          isCustom = true;
          break;

      case "CustomDeleteStep":     
          LoadingPanel.Show();      
          isCustom = true;
          break;
    }
    return isCustom;
  }

  // ///////////////////////
  // popup functions
  // ///////////////////////


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
  function openUrlWithParamFromPage(baseurl, param, fid, newtab) 
  {
    //var fid = hfStateValues.Get("FID")    
    var url = baseurl + "?" + param + "=" + fid
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

  window.OnGridViewImportsInit = OnGridViewImportsInit;
  window.OnGridViewImportsSelectionChanged = OnGridViewImportsSelectionChanged;
  window.OnGridViewImportsFocusedRowChanged = OnGridViewImportsFocusedRowChanged;  
  window.OnGridViewImportsToolbarItemClick = OnGridViewImportsToolbarItemClick;    

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
                           <dx:ASPxHyperLink ID="BreadcrumbsHyperLink" runat="server" NavigateUrl="~/Default.aspx" Text="User" Font-Bold="True" Font-Size="Large" Border-BorderStyle="None" Border-BorderWidth="8px" />
                           <dx:ASPxLabel ID="BreadcrumbsSpacer" runat="server" Text=">"></dx:ASPxLabel>
                           <dx:ASPxLabel ID="BreadcrumbsLabel" ClientIDMode="Static" runat="server" Text="Home" Font-Bold="True" Font-Size="Large" Width="300px" />
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
       	  <%--
          <dx:MenuItem Name="PageMenuDataFiles" Text="Data Files" Alignment="Right" AdaptivePriority="1">
               <Image IconID="format_listbullets_svg_dark_16x16" />
          </dx:MenuItem>        
          <dx:MenuItem Name="PageMenuJobFiles" Text="Job Files" Alignment="Right" AdaptivePriority="2">
               <Image IconID="format_listbullets_svg_dark_16x16" />
          </dx:MenuItem>
          --%>    
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

   <asp:ObjectDataSource ID="ContactsDataSource" runat="server" TypeName="BlackBox.Model.DataProvider" 
       SelectMethod="GetContact" UpdateMethod="UpdateContact" OldValuesParameterFormatString="original_{0}"
       OnSelecting="ContactsDataSource_Selecting" OnUpdating="ContactsDataSource_Updating" >
       <SelectParameters>
           <asp:QueryStringParameter DefaultValue="1" Name="id" QueryStringField="id" Type="Int64" />
       </SelectParameters>
       <UpdateParameters>
           <asp:QueryStringParameter DefaultValue="0" Name="id" QueryStringField="id" Type="Int64" />
           <asp:Parameter Name="uid" Type="String" />
           <asp:Parameter Name="full" Type="String" />               
           <asp:Parameter Name="first" Type="String" />
           <asp:Parameter Name="last" Type="String" />
           <asp:Parameter Name="birth" Type="DateTime" />
           <asp:Parameter Name="phone" Type="String" />
           <asp:Parameter Name="email" Type="String" />            
           <asp:Parameter Name="country" Type="String" />
           <asp:Parameter Name="city" Type="String" />
           <asp:Parameter Name="address" Type="String" />
           <asp:Parameter Name="dom" Type="String" />
           <asp:Parameter Name="sam" Type="String" />
           <asp:Parameter Name="site" Type="String" />
           <asp:Parameter Name="business" Type="String" />
           <asp:Parameter Name="job" Type="String" />
           <asp:Parameter Name="memberships" Type="String" />
           <asp:Parameter Name="guest" Type="Boolean" />
           <asp:Parameter Name="Operator" Type="Boolean" />
           <asp:Parameter Name="assetmanager" Type="Boolean" />
           <asp:Parameter Name="administrator" Type="Boolean" />                                               
       </UpdateParameters>
       <InsertParameters>
           <asp:QueryStringParameter DefaultValue="0" Name="ID" QueryStringField="id" Type="Int64" />
           <asp:ControlParameter ControlID="uidLabel" Name="UID" PropertyName="Text" Type="String" />
           <asp:ControlParameter ControlID="fullNameTextBox" Name="FullName" PropertyName="Text" Type="String" />                
           <asp:ControlParameter ControlID="firstNameTextBox" Name="FirstName" PropertyName="Text" Type="String" />
           <asp:ControlParameter ControlID="lastNameTextBox" Name="LastName" PropertyName="Text" Type="String" />
           <asp:ControlParameter ControlID="birthDateEdit" Name="Birthday" PropertyName="Value" Type="DateTime" />
           <asp:ControlParameter ControlID="phoneTextBox" Name="Phone" PropertyName="Text" Type="String" />
           <asp:ControlParameter ControlID="emailTextBox" Name="Email" PropertyName="Text" Type="String" />
           <asp:ControlParameter ControlID="countryTextBox" Name="Country" PropertyName="Text" Type="String" />
           <asp:ControlParameter ControlID="cityTextBox" Name="City" PropertyName="Text" Type="String" />
           <asp:ControlParameter ControlID="addressTextBox" Name="Address" PropertyName="Text" Type="String" />
       </InsertParameters>
   </asp:ObjectDataSource> 

    <%--
    **** RIGHT PANEL TAB PAGES
    --%>    

    <dx:ASPxPageControl ID="TabPagesRightPanel" Width="100%" runat="server" ActiveTabIndex="0" EnableHierarchyRecreation="true" >
       <TabPages>          
           <%--
           **** PROFILE TABPAGE
           --%>
         
           <dx:TabPage Text="My Profile">
              <ContentCollection>
                  <dx:ContentControl ID="RightPanelContentControl1" runat="server">    
         
                  <dx:ASPxFormLayout ID="UserFormLayout" runat="server" DataSourceID="ContactsDataSource" AlignItemCaptionsInAllGroups="True" UseDefaultPaddings="False">
                     <SettingsAdaptivity AdaptivityMode="SingleColumnWindowLimit" SwitchToSingleColumnAtWindowInnerWidth="700" />
                     <Items>        
                         <dx:LayoutGroup Caption="User Information" ShowCaption="false" ColCount="2" SettingsItems-HorizontalAlign="Left" HorizontalAlign="Left" Width="600">
                             <Items>
                                 <dx:LayoutItem Caption="User Name" ShowCaption="false" VerticalAlign="Top" HorizontalAlign="Left" CaptionSettings-VerticalAlign="Middle" ColumnSpan="2">
                                     <LayoutItemNestedControlCollection>
                                         <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                            <dx:ASPxLabel ID="FormUserNameLabel" runat="server" Font-Size="30px" Font-Bold="True"></dx:ASPxLabel> 
                                         </dx:LayoutItemNestedControlContainer>
                                     </LayoutItemNestedControlCollection>
                                 </dx:LayoutItem>
                                 <dx:LayoutItem Caption="Photo" ShowCaption="false" HorizontalAlign="Left" Width="100px" CaptionSettings-VerticalAlign="Middle" RowSpan="5">
                                     <LayoutItemNestedControlCollection>
                                         <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                            <dx:ASPxImage ID="FormUserImage" runat="server" Height=150 Width=150 ImageAlign="Left" /> 
                                         </dx:LayoutItemNestedControlContainer>
                                     </LayoutItemNestedControlCollection>
                                 </dx:LayoutItem>
                                 <dx:LayoutItem Caption="Cohort" FieldName="Cohort">
                                     <LayoutItemNestedControlCollection>
                                         <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                             <dx:ASPxTextBox ID="cohortTextBox" runat="server" Width="95%" ReadOnly="True" />
                                         </dx:LayoutItemNestedControlContainer>
                                     </LayoutItemNestedControlCollection>
                                 </dx:LayoutItem>
                                 <dx:LayoutItem Caption="Account Name" FieldName="SAMAccountName">
                                     <LayoutItemNestedControlCollection>
                                         <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                             <dx:ASPxTextBox ID="FormAccountTextBox" runat="server" Width="95%" ReadOnly="True" />
                                         </dx:LayoutItemNestedControlContainer>
                                     </LayoutItemNestedControlCollection>
                                 </dx:LayoutItem>
                                 <dx:LayoutItem Caption="Domain Name" FieldName="Domain">
                                     <LayoutItemNestedControlCollection>
                                         <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                             <dx:ASPxTextBox ID="FormDomainTextBox" runat="server" Width="95%" ReadOnly="True" />
                                         </dx:LayoutItemNestedControlContainer>
                                     </LayoutItemNestedControlCollection>
                                 </dx:LayoutItem>
              
                                 <%--
                                 <dx:LayoutItem Caption="Birth Date" FieldName="Birthday">
                                     <LayoutItemNestedControlCollection>
                                         <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                             <dx:ASPxDateEdit ID="birthdateEdit" runat="server" EditFormat="Date" Width="95%" ReadOnly="False" />
                                         </dx:LayoutItemNestedControlContainer>
                                     </LayoutItemNestedControlCollection>
                                 </dx:LayoutItem>
                                 <dx:LayoutItem Caption="Address Book" FieldName="AddressBook">
                                     <LayoutItemNestedControlCollection>
                                         <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                             <dx:ASPxTextBox ID="addressbookTextBox" runat="server" Width="95%" ReadOnly="True" />
                                         </dx:LayoutItemNestedControlContainer>
                                     </LayoutItemNestedControlCollection>
                                 </dx:LayoutItem>
                                 --%>
              
                                 <%--                         
                                 <dx:LayoutItem Caption="Memberships" FieldName="Memberships" HorizontalAlign="Right" ColumnSpan="1">
                                     <LayoutItemNestedControlCollection>
                                         <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                             <dx:ASPxTextBox ID="membershipsTextBox" ClientIDMode="Static" runat="server" Width="95%" ReadOnly="False" />
                                         </dx:LayoutItemNestedControlContainer>
                                     </LayoutItemNestedControlCollection>
                                 </dx:LayoutItem>
                                 --%>
                                 
                                <dx:EmptyLayoutItem />
                             </Items>
                         </dx:LayoutGroup>           
                         <%--<dx:EmptyLayoutItem />--%>
              
                         <dx:LayoutGroup Caption="Names" ShowCaption="true" ColCount="2" SettingsItems-HorizontalAlign="Left" HorizontalAlign="Left" Width="600">
                             <Items>
                                 <dx:LayoutItem Caption="First Name" FieldName="FirstName">
                                     <LayoutItemNestedControlCollection>
                                         <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                             <%-- <dx:ASPxLabel ID="firstNameLabel" runat="server" /> --%>
                                             <dx:ASPxTextBox ID="firstTextBox" runat="server" Width="90%" ReadOnly="False" />
                                         </dx:LayoutItemNestedControlContainer>
                                     </LayoutItemNestedControlCollection>
                                 </dx:LayoutItem>
                                 <dx:LayoutItem Caption="Last Name" FieldName="LastName">
                                     <LayoutItemNestedControlCollection>
                                         <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                             <%-- <dx:ASPxLabel ID="lastNameLabel" runat="server" />  --%>
                                             <dx:ASPxTextBox ID="lastTextBox" runat="server" Width="95%" ReadOnly="False" />
                                         </dx:LayoutItemNestedControlContainer>
                                     </LayoutItemNestedControlCollection>
                                 </dx:LayoutItem>
                                 <%--
                                 <dx:LayoutItem Caption="Birth Date" FieldName="Birthday">
                                     <LayoutItemNestedControlCollection>
                                         <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                             <dx:ASPxDateEdit ID="birthdateEdit" runat="server" EditFormat="Date" Width="95%" ReadOnly="False" />
                                         </dx:LayoutItemNestedControlContainer>
                                     </LayoutItemNestedControlCollection>
                                 </dx:LayoutItem>
                                 --%>
                             </Items>
                         </dx:LayoutGroup>           
              
                         <dx:LayoutGroup Caption="Home" ShowCaption="true" ColCount="2" SettingsItems-HorizontalAlign="Left" HorizontalAlign="Left" Width="600">
                             <Items>
                                 <dx:LayoutItem Caption="Site" FieldName="Site">
                                     <LayoutItemNestedControlCollection>
                                         <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                             <dx:ASPxTextBox ID="siteTextBox" runat="server" Width="95%" ReadOnly="False" />
                                         </dx:LayoutItemNestedControlContainer>
                                     </LayoutItemNestedControlCollection>
                                 </dx:LayoutItem>
                                 <dx:LayoutItem Caption="Business" FieldName="Business">
                                     <LayoutItemNestedControlCollection>
                                         <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                             <dx:ASPxTextBox ID="businessTextBox" runat="server" Width="95%" ReadOnly="False" />
                                         </dx:LayoutItemNestedControlContainer>
                                     </LayoutItemNestedControlCollection>
                                 </dx:LayoutItem>
                                 <%--
                                 <dx:LayoutItem Caption="Job" FieldName="Job">
                                     <LayoutItemNestedControlCollection>
                                         <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                             <dx:ASPxTextBox ID="jobTextBox" runat="server" Width="95%" ReadOnly="False" />
                                         </dx:LayoutItemNestedControlContainer>
                                     </LayoutItemNestedControlCollection>
                                 </dx:LayoutItem>
                                 --%>
                             </Items>
                         </dx:LayoutGroup>    
                         <%--<dx:EmptyLayoutItem />--%>
                  
                         <dx:LayoutGroup Caption="Roles" ShowCaption="true" ColCount="3" SettingsItems-HorizontalAlign="Left" HorizontalAlign="Left" Width="600">
                             <Items>
                                <dx:LayoutItem Caption="Guest" ColumnSpan="1">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer>
                                            <dx:ASPxCheckBox ID="cbUserGuest" runat="server" AutoPostBack="False" Width="50" Enabled="False" Checked="True" />
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                </dx:LayoutItem>
                               
                                <dx:LayoutItem Caption="User">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer>
                                            <dx:ASPxCheckBox ID="cbUserOperator" runat="server" AutoPostBack="False" Width="50" Enabled="False" Checked="False" />
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                </dx:LayoutItem>
              
                                <dx:LayoutItem Caption="Manager" ColumnSpan="1">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer>
                                            <dx:ASPxCheckBox ID="cbUserManager" runat="server" AutoPostBack="False" Width="50" Enabled="False" Checked="False" />
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                </dx:LayoutItem>
                                
                                <dx:LayoutItem Caption="Administrator" ColumnSpan="1">
                                    <LayoutItemNestedControlCollection>
                                        <dx:LayoutItemNestedControlContainer>
                                            <dx:ASPxCheckBox ID="cbUserAdmin" runat="server" AutoPostBack="False" Width="50" Enabled="False" Checked="False" />
                                        </dx:LayoutItemNestedControlContainer>
                                    </LayoutItemNestedControlCollection>
                                </dx:LayoutItem>                                                  
                             </Items>
                         </dx:LayoutGroup>    
                         <dx:EmptyLayoutItem />
                         
                         <dx:LayoutItem ShowCaption="False" CssClass="buttonAlign" Width="100%">
                             <LayoutItemNestedControlCollection>
                                 <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                     <dx:ASPxButton ID="ReauthenticateButton" runat="server" Text="Refresh" OnClick="ReauthenticateButtonClick" Width="100" />
                                 </dx:LayoutItemNestedControlContainer>
                             </LayoutItemNestedControlCollection>
                         </dx:LayoutItem>
                         
                         <dx:LayoutItem ShowCaption="False" CssClass="buttonAlign" Width="100%">
                             <LayoutItemNestedControlCollection>
                                 <dx:LayoutItemNestedControlContainer runat="server" SupportsDisabledAttribute="True">
                                     <dx:ASPxButton ID="UpdateUserButton" runat="server" Text="Update" OnClick="UpdateUserButtonClick" Width="100" />
                                 </dx:LayoutItemNestedControlContainer>
                             </LayoutItemNestedControlCollection>
                         </dx:LayoutItem>

                     </Items>
                  </dx:ASPxFormLayout>
                              
                  </dx:ContentControl>
             </ContentCollection>
           </dx:TabPage>
         

           <%--
           **** TEMPLATES TABPAGE
           --%>

           <dx:TabPage Text="Templates" Visible="true">
              <ContentCollection>
                  <dx:ContentControl ID="RightPanelContentControl2" runat="server">
           
                  <dx:ASPxFileManager runat="server" ID="fileManager" ClientInstanceName="fileManager" Height="750px" 
                  	  OnFolderCreating="FileManager_FolderCreating"
                      OnItemDeleting="FileManager_ItemDeleting" OnItemMoving="FileManager_ItemMoving" OnCustomThumbnail="OnFileManagerCustomThumbnails"
                      OnItemRenaming="FileManager_ItemRenaming" OnFileUploading="FileManager_FileUploading" OnFilesUploaded="FileManager_FilesUploaded" 
                      OnItemCopying="FileManager_ItemCopying">
                      <Settings RootFolder="~/Templates" ThumbnailFolder="~/Resources/Thumbnails" 
                          AllowedFileExtensions=".csv,.xls,.xlsx"
                          InitialFolder="~/Templates" />
                      <SettingsToolbar ShowPath="false" />
                      <SettingsEditing AllowCreate="false" AllowDelete="false" AllowMove="false" AllowRename="false" AllowCopy="false" AllowDownload="true" />
                      <SettingsPermissions>
                          <AccessRules>
                              <dx:FileManagerFolderAccessRule Path="system" Edit="Deny" />
                              <dx:FileManagerFileAccessRule Path="system\*" Download="Deny" />
                          </AccessRules>
                      </SettingsPermissions>
                      <SettingsFolders Visible="False" />                                    
                      <SettingsFileList ShowFolders="false" ShowParentFolder="false" />
                      <SettingsBreadcrumbs Visible="true" ShowParentFolderButton="false" Position="Top" />
                      <SettingsUpload Enabled="false" UseAdvancedUploadMode="false">
                          <AdvancedModeSettings EnableMultiSelect="false" />
                      </SettingsUpload>
                      <SettingsAdaptivity Enabled="true" />
                  </dx:ASPxFileManager>                  
              
                  </dx:ContentControl>
             </ContentCollection>
           </dx:TabPage>

           <%--
           **** OTHER TABPAGE
           --%>

           <dx:TabPage Text="Other" Visible="false">
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
 
   <asp:SqlDataSource ID="SqlBlackBoxFiles" runat="server" 
      ConnectionString="<%$ ConnectionStrings:BlackBoxConnectionString %>" 
      SelectCommand="SELECT TOP(1000) [FID],[JOBID],[GUID],[Name],[Location],[TypeID],[Type],[Group],[Description],[DataSource],[DataSourceInstanceID],[Datasets],[StatusID],[Status],[Validations],[Locked],[UserID],[TimeStamp],[Age],[Rank] FROM [dbo].[vBlackBoxFilesWithValidation] WHERE [Group] != 'Templates' AND [UserID] = @userid ORDER BY [TimeStamp] DESC"
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
   
   <asp:SqlDataSource ID="SqlActionHistory" runat="server" 
     ConnectionString="<%$ ConnectionStrings:BlackBoxConnectionString %>"     
     SelectCommand="SELECT TOP 1000 [ID],[Object],[RefID],[UserID],[User],[SAMAccountName],[Action],[Message],[TimeStamp] FROM [dbo].[vBlackBoxHistory]"
     InsertCommand="INSERT INTO [dbo].[BlackBoxHistory] ([Object],[RefID],[UserID],[Action],[Message],[TimeStamp]) VALUES(@Object,@RefID,@UserID,@Action,@Message,GetDate())"
     UpdateCommand="UPDATE [dbo].[BlackBoxHistory] SET [Object]=@Object,[RefID]=@RefID,[UserID]=@UserID,[Action]=@Action,[Message]=@Message,[TimeStamp]=GetDate() WHERE [ID]=@ID"
     DeleteCommand="DELETE FROM [dbo].[BlackBoxHistory] WHERE [ID] = @ID">
     <InsertParameters>
         <asp:FormParameter FormField="Object" Name="Object" />
         <asp:FormParameter FormField="RefID" Name="RefID" />
         <asp:FormParameter FormField="UserID" Name="UserID" />
         <asp:FormParameter FormField="Action" Name="Action" />
         <asp:FormParameter FormField="Message" Name="Message" />
     </InsertParameters>
     <UpdateParameters>
         <asp:FormParameter FormField="ID" Name="ID" />       
         <asp:FormParameter FormField="Object" Name="Object" />
         <asp:FormParameter FormField="RefID" Name="RefID" />
         <asp:FormParameter FormField="UserID" Name="UserID" />
         <asp:FormParameter FormField="Action" Name="Action" />
         <asp:FormParameter FormField="Message" Name="Message" />
     </UpdateParameters>
     <DeleteParameters>
         <asp:QueryStringParameter Name="ID" />
     </DeleteParameters>
   </asp:SqlDataSource>
       
   <%--
   **** TABBED PAGES
   --%>

   <dx:ASPxPageControl ID="mainTabPages" Width="100%" ClientInstanceName="mainTabPages" runat="server" ActiveTabIndex="0" EnableHierarchyRecreation="True" >
       <TabPages>
                
           <%--
           **** UPLOADS TABPAGE
           --%>
                                                                                                                              
           <dx:TabPage Text="Uploaded Files">
              <ContentCollection>
                  <dx:ContentControl ID="MainContentControl1" runat="server">

                  <table>
                    <tr style="vertical-align: middle">
                      <td style="width: 500px">
                        <fieldset>
                           <legend>Upload</legend>
                           <dx:ASPxUploadControl ID="ASPxUploadControlImports" runat="server"  ViewStateMode="Enabled" Width="460px" 
                              UploadMode="Advanced" UploadStorage="FileSystem" AutoStartUpload="True"
                              CancelButtonHorizontalPosition="Left" ShowProgressPanel="True" ShowClearFileSelectionButton="False"
                              OnLoad="ASPxUploadControl_Load" OnFileUploadComplete="ASPxUploadControl_FileUploadComplete" OnFilesUploadComplete="ASPxUploadControl_FilesUploadComplete" 
                              OnGenerateFileNameInStorage="ASPxUploadControl_GenerateFileNameInStorage" >
                              <AdvancedModeSettings EnableMultiSelect="False" EnableFileList="True" EnableDragAndDrop="True" />                              
                              <FileSystemSettings UploadFolder="~/Jobs" />
                              <ClientSideEvents FileUploadComplete="OnFileUploadComplete" FilesUploadComplete="OnFilesUploadComplete" FilesUploadStart="OnFileUploadStart" />
                           </dx:ASPxUploadControl>
                        </fieldset>          
                      </td>
                      <td style="width: 50px">&nbsp;
                         <dx:ASPxCheckBox ID="AutoScheduleCheckBox" runat="server" Text="Auto Publish" AutoPostBack="False" Width="250" Checked="True" />                        
                      </td>
                   </tr>
                  </table>
                  <br/>

                  <dx:ASPxGridView ID="UploadedFilesGridView" runat="server" ClientInstanceName="gridViewUploadedFiles" DataSourceID="SqlBlackBoxFiles" KeyFieldName="FID"
                    OnRowCommand="UploadedFilesGridView_RowCommand" OnSelectionChanged="UploadedFilesGridView_SelectionChanged"
                    OnInitNewRow="UploadedFilesGridView_InitNewRow" OnRowInserting="UploadedFilesGridView_RowInserting" OnRowUpdating="UploadedFilesGridView_RowUpdating" OnRowDeleting="UploadedFilesGridView_RowDeleting"
                    OnCustomCallback="UploadedFilesGridView_CustomCallback" OnToolbarItemClick="UploadedFilesGridView_ToolbarItemClick"
                    EnableTheming="True" EnableViewState="False" AutoGenerateColumns="False" Width="95%">
                    <Toolbars>
                        <dx:GridViewToolbar>
                            <SettingsAdaptivity Enabled="true" EnableCollapseRootItemsToIcons="true" />
                            <Items>
                                <dx:GridViewToolbarItem Command="Refresh" />
                                <dx:GridViewToolbarItem Command="ShowFilterRow" BeginGroup="true" AdaptivePriority="1"/>
                                <dx:GridViewToolbarItem Command="ShowCustomizationWindow" AdaptivePriority="2"/>  

                                <dx:GridViewToolbarItem Name="CustomDownloadFile" Text="Download" BeginGroup="true" AdaptivePriority="3" Enabled="false" />
                                <dx:GridViewToolbarItem Name="CustomOpenFile" Text="Open" BeginGroup="true" AdaptivePriority="4" Enabled="false" />
                                <%--<dx:GridViewToolbarItem Name="CustomEditFile" Text="Edit" BeginGroup="true" Enabled="false" />--%>

                                <%--
                                <dx:GridViewToolbarItem Text="Steps" BeginGroup="true" AdaptivePriority="5">
                                    <Items>
                                        <dx:GridViewToolbarItem Name="CustomRegisterStep" Text="Register" BeginGroup="true" Enabled="false" />
                                        <dx:GridViewToolbarItem Name="CustomScheduleStep" Text="Schedule" BeginGroup="true" Enabled="false" />
                                        <dx:GridViewToolbarItem Name="CustomLoadStep" Text="Load" BeginGroup="false" Enabled="false" />
                                        <dx:GridViewToolbarItem Name="CustomRecallStep" Text="Recall" BeginGroup="false" Enabled="false" />
                                        <dx:GridViewToolbarItem Name="CustomValidateStep" Text="Validate" BeginGroup="false" Enabled="false" />
                                        <dx:GridViewToolbarItem Name="CustomStageStep" Text="Stage" BeginGroup="false" Enabled="false" />
                                        <dx:GridViewToolbarItem Name="CustomRejectStep" Text="Reject" BeginGroup="false" Enabled="false" />
                                    </Items>
                                </dx:GridViewToolbarItem>
                                --%>

                                <dx:GridViewToolbarItem Name="CustomProcessStep" Text="Process" BeginGroup="true" AdaptivePriority="6" Enabled="false" />
                                <dx:GridViewToolbarItem Name="CustomPublishStep" Text="Publish" BeginGroup="true" AdaptivePriority="7" Enabled="false" />
                                   
                                <dx:GridViewToolbarItem Name="CustomWithdrawStep" Text="Withdraw" BeginGroup="true" AdaptivePriority="8" Enabled="false" />
                                <dx:GridViewToolbarItem Name="CustomArchiveStep" Text="Archive" BeginGroup="true" AdaptivePriority="9" Enabled="false" />
                                <dx:GridViewToolbarItem Name="CustomDeleteStep" Text="Delete" BeginGroup="true" AdaptivePriority="10" Enabled="false" />        	
                            </Items>
                        </dx:GridViewToolbar>
                    </Toolbars>                     
                    <SettingsPopup>
                      <HeaderFilter MinHeight="140px"></HeaderFilter>
                    </SettingsPopup>
                    <Columns>                   
                          <dx:GridViewCommandColumn VisibleIndex="0" SelectAllCheckboxMode="AllPages" ShowSelectCheckbox="True" Width="50px" Visible="true" />
                          <dx:GridViewDataTextColumn FieldName="FID" VisibleIndex="1" Width="60px" Visible="true" />
                          <dx:GridViewDataTextColumn FieldName="JOBID" VisibleIndex="2" Width="80px" Visible="false" />
                          <dx:GridViewDataTextColumn FieldName="GUID" VisibleIndex="3" Width="290px" Visible="false" />
                          <dx:GridViewDataTextColumn FieldName="Name" VisibleIndex="4" Width="320px" Visible="true" />                            
                          <dx:GridViewDataTextColumn FieldName="Location" VisibleIndex="5" Width="420px" Visible="false" />
                          <dx:GridViewDataTextColumn FieldName="TypeID" VisibleIndex="6" Width="80px" Visible="false" />
                          <dx:GridViewDataTextColumn FieldName="Type" VisibleIndex="7" Width="90px" Visible="false" />
                          <dx:GridViewDataTextColumn FieldName="Group" VisibleIndex="8" Width="120px" Visible="true" />                           
                          <dx:GridViewDataTextColumn FieldName="Description" VisibleIndex="9" Width="330px" Visible="false" />
                          <dx:GridViewDataTextColumn FieldName="DataSource" VisibleIndex="10" Width="140px" Visible="true" />
                          <dx:GridViewDataTextColumn FieldName="DataSourceInstanceID" Caption="DSIID" VisibleIndex="11" Width="90px" Visible="true" />
                          <dx:GridViewDataTextColumn FieldName="Datasets" VisibleIndex="12" Width="300px" Visible="false" />                            
                          <dx:GridViewDataTextColumn FieldName="StatusID" VisibleIndex="13" Width="80px" Visible="false" />
                          <dx:GridViewDataTextColumn FieldName="Validations" VisibleIndex="14" Width="140px" Visible="true" />
                          <dx:GridViewDataTextColumn FieldName="Status" VisibleIndex="15" Width="120px" Visible="true" />
                          <dx:GridViewDataTextColumn FieldName="Locked" VisibleIndex="16" Width="90px" Visible="false" />
                          <dx:GridViewDataTextColumn FieldName="UserID" VisibleIndex="17" Width="80px" Visible="true" />                            
                          <dx:GridViewDataDateColumn FieldName="TimeStamp" VisibleIndex="18" Width="120px" Visible="true" />
                          <dx:GridViewDataTextColumn FieldName="Age" VisibleIndex="19" Width="90px" Visible="false" />
                          <dx:GridViewDataTextColumn FieldName="Rank" VisibleIndex="20" Width="90px" Visible="false" />
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
                                      <dx:GridViewColumnLayoutItem ColumnName="FID" Caption="FileID">
                                        <Template>
                                           <dx:ASPxLabel ID="fidLabel" runat="server" Width="40%" Text='<%# Bind("FID") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>
                                      <dx:GridViewColumnLayoutItem ColumnName="JOBID" Caption="JobID">
                                        <Template>
                                           <dx:ASPxLabel ID="fileJobIdLabel" runat="server" Width="40%" Text='<%# Bind("JOBID") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>
                                      <dx:GridViewColumnLayoutItem ColumnName="GUID" Caption="GUID" ColumnSpan="2">
                                        <Template>
                                           <dx:ASPxLabel ID="fileGuidLabel" runat="server" Width="40%" Text='<%# Bind("GUID") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>

                                      <dx:GridViewColumnLayoutItem ColumnName="Name" Caption="Name">
                                        <Template>
                                           <dx:ASPxTextBox ID="fileNameTextBox" runat="server" Width="80%" Text='<%# Bind("Name") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>

                                      <dx:GridViewColumnLayoutItem ColumnName="TypeID" Caption="TypeID">
                                        <Template>
                                           <%--<dx:ASPxTextBox ID="fileTypeIdTextBox" runat="server" Width="50%" Text='<%# Bind("TypeID") %>' />--%>
                                           <dx:ASPxComboBox ID="dsxTypeIdComboBox" runat="server" AutoPostBack="False" Width="50%" Value='<%# Bind("TypeID") %>'>
                                              <Items>
                                                   <dx:ListEditItem Value=0 Text="0-Ready" />
                                                   <dx:ListEditItem Value=1 Text="1-SQL" />
                                                   <dx:ListEditItem Value=2 Text="2-PS1" />
                                                   <dx:ListEditItem Value=3 Text="3-JS" />
                                                   <dx:ListEditItem Value=4 Text="4-CSV" />
                                                   <dx:ListEditItem Value=5 Text="5-XSLX" />
                                                   <dx:ListEditItem Value=6 Text="6-XML" />
                                                   <dx:ListEditItem Value=7 Text="7-BlackBox" />
                                                   <dx:ListEditItem Value=8 Text="8-FNMS" />
                                               </Items>
                                           </dx:ASPxComboBox>   
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>

                                      <dx:GridViewColumnLayoutItem ColumnName="Group" Caption="Group">
                                        <Template>
                                           <%--<dx:ASPxTextBox ID="fileGroupTextBox" runat="server" Width="60%" Text='<%# Bind("Group") %>' />--%>
                                           <dx:ASPxComboBox ID="fileGroupComboBox" ClientInstanceName="fileGroupComboBox" runat="server" Width="70%" SelectedIndex="0" ClientIDMode="Static" Value='<%# Bind("Group") %>'>
                                             <Items>
                                                 <dx:ListEditItem Value="" Text="None" />                                               
                                                 <dx:ListEditItem Value="ITAM" Text="ITAM" />
                                                 <dx:ListEditItem Value="RIOTINTO" Text="RIOTINTO" />                                                   
                                                 <dx:ListEditItem Value="Metrics" Text="Metrics" />
                                                 <dx:ListEditItem Value="Inventory" Text="Inventory" />
                                                 <dx:ListEditItem Value="RvTools" Text="RvTools" />
                                                 <dx:ListEditItem Value="Other" Text="Other" />                                     
                                            </Items>
                                           </dx:ASPxComboBox>
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>

                                      <dx:GridViewColumnLayoutItem ColumnName="DataSource" Caption="Data Source">
                                        <Template>
                                           <dx:ASPxTextBox ID="fileSourceTextBox" runat="server" Width="80%" Text='<%# Bind("DataSource") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>
                                      <dx:GridViewColumnLayoutItem ColumnName="DataSourceInstanceID" Caption="DataSourceInstanceID">
                                        <Template>
                                           <dx:ASPxTextBox ID="fileSourceIDTextBox" runat="server" Width="80%" Text='<%# Bind("DataSourceInstanceID") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>

                                      <dx:GridViewColumnLayoutItem ColumnName="Location" Caption="Location" ColumnSpan="2">
                                        <Template>
                                           <dx:ASPxTextBox ID="fileLocationTextBox" runat="server" Width="80%" Text='<%# Bind("Location") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>

                                      <dx:GridViewColumnLayoutItem ColumnName="Description" Caption="Description" ColumnSpan="2">
                                        <Template>
                                           <dx:ASPxTextBox ID="fileDescriptionTextBox" runat="server" Width="90%" Text='<%# Bind("Description") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>

                                      <dx:GridViewColumnLayoutItem ColumnName="Datasets" Caption="Datasets" ColumnSpan="2">
                                        <Template>
                                           <dx:ASPxTextBox ID="fileDatasetsTextBox" runat="server" Width="90%" Text='<%# Bind("Datasets") %>' />
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>

                                      <dx:GridViewColumnLayoutItem ColumnName="StatusID" Caption="StatusID">
                                        <Template>
                                           <dx:ASPxComboBox ID="fileStatusComboBox" runat="server" AutoPostBack="False" Width="50%" Value='<%# Bind("StatusID") %>'>
                                              <Items>
                                                   <dx:ListEditItem Value=0 Text="0-Ready" />
                                                   <dx:ListEditItem Value=1 Text="1-Uploaded" />
                                                   <dx:ListEditItem Value=2 Text="2-Staged" />
                                                   <dx:ListEditItem Value=3 Text="3-Submitted" />
                                                   <dx:ListEditItem Value=4 Text="4-Approved" />
                                                   <dx:ListEditItem Value=5 Text="5-Rejected" />
                                                   <dx:ListEditItem Value=6 Text="6-Processed" />                                                     
                                                   <dx:ListEditItem Value=7 Text="7-Locked" />                                                    
                                                   <dx:ListEditItem Value=8 Text="8-Withdrawn" />  
                                                   <dx:ListEditItem Value=9 Text="9-Archived" />
                                               </Items>
                                           </dx:ASPxComboBox>   
                                        </Template>
                                      </dx:GridViewColumnLayoutItem>

                                      <dx:GridViewColumnLayoutItem ColumnName="Locked" Caption="Locked">
                                        <Template>
                                           <%--<dx:ASPxTextBox ID="fileLockedTextBox" runat="server" Width="30%" Text='<%# Bind("Locked") %>' />--%>
                                           <dx:ASPxComboBox ID="fileLockedComboBox" runat="server" AutoPostBack="false" Width="50%" Value='<%# Bind("Locked") %>'>
                                              <Items>
                                                   <dx:ListEditItem Value=true Text="true" />
                                                   <dx:ListEditItem Value=false Text="false" />
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
                      <ClientSideEvents Init="OnGridViewImportsInit" SelectionChanged="OnGridViewImportsSelectionChanged" FocusedRowChanged="OnGridViewImportsFocusedRowChanged" 
                        ToolbarItemClick="OnGridViewImportsToolbarItemClick" />
                  </dx:ASPxGridView>

                  </dx:ContentControl>
             </ContentCollection>                                    
           </dx:TabPage>       
        
           <%--
           **** PROCESSING HISTORY TABPAGE
           --%>

           <dx:TabPage Text="Processing History">
              <ContentCollection>
                  <dx:ContentControl ID="MainContentControl2" runat="server">
                  <br/>
                  
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

                                <dx:GridViewToolbarItem Text="Export to" Image-IconID="actions_download_16x16office2013" BeginGroup="true" AdaptivePriority="7">
                                    <Items>
                                        <dx:GridViewToolbarItem Command="ExportToCsv" />
                                        <dx:GridViewToolbarItem Command="ExportToXlsx" Text="Export to XLSX" />
                                    </Items>
                                    <Image IconID="actions_download_16x16office2013"></Image>
                                </dx:GridViewToolbarItem>
                                    
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
                          <dx:GridViewCommandColumn VisibleIndex="0" SelectAllCheckboxMode="AllPages" ShowSelectCheckbox="True" Width="50px" Visible="true" />
                          <dx:GridViewDataTextColumn FieldName="ID" Caption="ID" VisibleIndex="1" Width="60px" Visible="true" />
                          <dx:GridViewDataTextColumn FieldName="Object" Caption="Object" VisibleIndex="2" Width="160px" Visible="true" />
                          <dx:GridViewDataTextColumn FieldName="RefID" Caption="FID" VisibleIndex="3" Width="60px" Visible="true" />
                          <dx:GridViewDataTextColumn FieldName="UserID" Caption="UserID" VisibleIndex="4" Width="80px" Visible="true" />
                          <dx:GridViewDataTextColumn FieldName="User" Caption="UserName" VisibleIndex="5" Width="120px" Visible="false" />
                          <dx:GridViewDataTextColumn FieldName="SAMAccountName" Caption="SAMAccountName" VisibleIndex="6" Width="160px" Visible="true" />                           
                          <dx:GridViewDataTextColumn FieldName="Action" Caption="Action" VisibleIndex="8" Width="140px" Visible="true" />
                          <dx:GridViewDataTextColumn FieldName="Message" Caption="Message" VisibleIndex="9" Width="660px" Visible="true" />
                          <dx:GridViewDataTextColumn FieldName="TimeStamp" Caption="TimeStamp" VisibleIndex="10" Width="200px" Visible="true" />                           
                      </Columns>
                      <SettingsPager PageSize="10" AlwaysShowPager="True" EllipsisMode="OutsideNumeric" EnableAdaptivity="True">
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
   **** LOADING PANEL  
   --%>

   <dx:ASPxLoadingPanel ID="LoadingPanel" runat="server" ClientInstanceName="LoadingPanel" Modal="True" />

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


</asp:Content>
