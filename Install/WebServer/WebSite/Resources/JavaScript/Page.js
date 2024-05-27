(
  function() 
  {
  	// Main Grid methods
    function onGridViewInit2(s, e) 
    {
      AddAdjustmentDelegate(adjustGridView2);
      //updateToolbarButtonsState2();
    }
    
    function onGridViewSelectionChanged(s, e) 
    {
      updateToolbarButtonsState();
    }
    
    // Settings Grid methods
    function onSettingsGridViewInit2(s, e) 
    {
    }
    
    function onSettingsGridViewSelectionChanged2(s, e) 
    {
    }
    
    // Toolbar methods
    function updateToolbarButtonsState2() 
    {
      //var enabled = gridView.GetSelectedRowCount() > 0;
      //pageToolbar.GetItemByName("Delete").SetEnabled(enabled);
      //pageToolbar.GetItemByName("Export").SetEnabled(enabled);
  
      //pageToolbar.GetItemByName("Edit").SetEnabled(gridView.GetFocusedRowIndex() !== -1);
    }
    
    function onPageToolbarItemClick2(s, e) 
    {
      switch(e.item.name) 
      {
        case "ToggleFilterPanel":
            toggleFilterPanel();
            break;
        case "New":
            gridView.AddNewRow();
            break;
        case "Edit":
            gridView.StartEditRow(gridView.GetFocusedRowIndex());
            break;
        case "Delete":
            deleteSelectedRecords();
            break;
        case "Export":
            gridView.ExportTo(ASPxClientGridViewExportFormat.Xlsx);
            break;
        case "FilterAll":
        case "FilterPersonal":
        case "FilterBusiness":
        case "FilterThisMonth":
        case "FilterToday":
            var now = new Date();   
            var snow;
            snow = ('0' + now.getDate()).slice(-2) + '/'
                 + ('0' + (now.getMonth()+1)).slice(-2) + '/'
                 + now.getFullYear();
            
            var startOfWeek = new Date( now.setDate(now.getDate() - now.getDay() - 1 + (now.getDay() === 0 ? -6 : 1)) );
            var ssow = startOfWeek.toLocaleDateString();
            var ssow;
            ssow = ('0' + startOfWeek.getDate()).slice(-2) + '/'
                 + ('0' + (startOfWeek.getMonth()+1)).slice(-2) + '/'
                 + startOfWeek.getFullYear();        
            
            var filters = {
                FilterAll: "",
                FilterPersonal: "[AddressBook] = 'Personal'",
                FilterBusiness: "[AddressBook] = 'Business'",
                FilterThisMonth: "[Created] > '" + ssow + "'",
                FilterToday: "[Created] >= '" + snow + "'"
            };
            var f = filters[e.item.name]; 
            gridView.ApplyFilter(f);
            HideLeftPanelIfRequired();                
            break;
      }
    }
    
    function onMainNavBarItemClick(s, e) 
    {
      var now = new Date();
      var snow = now.toLocaleDateString();
      var startOfWeek = new Date( now.setDate(now.getDate() - now.getDay() - 1 + (now.getDay() === 0 ? -6 : 1)) );  
      var ssow = startOfWeek.toLocaleDateString();  
      var filters = 
      {
        All: "",
        Personal: "[AddressBook] = 'Personal'",
        Business: "[AddressBook] = 'Business'",
        ThisMonth: "[Created] > '" + ssow + "'",
        Today: "[Created] >= '" + snow + "'"
      };
      var f = filters[e.item.name]; 
      gridView.ApplyFilter(f);
      HideLeftPanelIfRequired();
    }     
  
    function onMainNavBarItemClickXX(s, e) 
    {
      var filters = 
      {
        All: "",
        Personal: "[AddressBook] = 'Personal'",
        Business: "[AddressBook] = 'Business'",
      };
      var f = filters[e.item.name]; 

      // inline: HideLeftPanelIfRequired();
      if (leftPanel.IsExpandable() && leftPanel.IsExpanded())
      {
        leftPanel.Collapse();
      }    
    }     
 
    // Filter methods
    function onFilterPanelExpanded(s, e) 
    {
      adjustPageControls();
      searchButtonEdit.SetFocus();
    }
  
    // Utility methods
    function toggleFilterPanel() 
    {
      filterPanel.Toggle();
    }
    
    function adjustGridView2() 
    {
      gridView.AdjustControl();
    }
    
    function deleteSelectedRecords() 
    {
      if (confirm('Confirm Delete?')) 
      {
        gridView.PerformCallback('delete');
      }
    }

  
    // Page methods
    window.onGridViewInit = onGridViewInit2;
    window.onGridViewSelectionChanged = onGridViewSelectionChanged;
    
    window.onGridViewSettingsInit2 = onSettingsGridViewInit2;
    window.onGridViewSettingsSelectionChanged2 = onSettingsGridViewSelectionChanged2;
    
    window.onPageToolbarItemClick2 = onPageToolbarItemClick2;
    
    window.onFilterPanelExpanded = onFilterPanelExpanded;
    window.onMainNavBarItemClick = onMainNavBarItemClick;
  }
)();
