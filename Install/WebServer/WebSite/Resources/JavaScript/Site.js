(
  function() 
  {    
    // *** ***********************
    // *** ***********************
    // *** ***********************
    
    // ***
    // *** site state data
    // ***

    var leftPanelAdjustmentDelegates = [];
    
    // ***
    // *** left panel handlers
    // ***

    function onLeftPanelInit(s, e) 
    {
      var adjustmentMethod = function() 
      {
        var pageToolbarPanel = ASPx.GetControlCollection().GetByName("pageToolbarPanel");
        if (pageToolbarPanel)
        {
          pageToolbarPanel.GetMainElement().style.left = s.GetWidth() + "px";
        }
        var toggleButton = leftAreaMenu.GetItemByName("ToggleLeftPanel");
        if (s.IsExpandable())
        {
          toggleButton.SetChecked(leftPanel.IsExpanded());
        }
        else 
        {
          if (leftPanel.GetVisible())
            document.body.style.marginLeft = "1px";
          else
            document.body.style.marginLeft = 0;
            
          toggleButton.SetChecked(leftPanel.GetVisible());
        }
      };
      AddLeftPanelAdjustmentDelegate(adjustmentMethod);
    }
  
    function onLeftPanelCollapsed(s, e) 
    {
      leftAreaMenu.GetItemByName("ToggleLeftPanel").SetChecked(false);
    }
        
    // ***
    // *** left panel functions
    // ***
    
    function onLeftMenuItemClick(s, e) 
    {
      if (e.item.name === "ToggleLeftPanel") 
      {
        ToggleLeftPanel();
      }
      if (e.item.name === "Back") 
      { 
        window.history.back();
      }
    }
    
    function ToggleLeftPanel() 
    {
      var width = leftPanel.GetWidth();     
      if (leftPanel.IsExpandable()) 
      {
        leftPanel.Toggle();
      }
      else 
      {
        leftPanel.SetVisible(!leftPanel.GetVisible());                  
        AdjustLeftPanelControls();
      }
    }
    
    function HideLeftPanel() 
    {
      leftPanel.Collapse();
    }
  
    function HideLeftPanelIfRequired() 
    {
      if (leftPanel.IsExpandable() && leftPanel.IsExpanded())
        leftPanel.Collapse();
    }
    
    function AdjustLeftPanelControls() 
    {
      for (var i = 0; i < leftPanelAdjustmentDelegates.length; i++) 
      {             
        leftPanelAdjustmentDelegates[i]();
      }                                   
    }            
        
    function AddLeftPanelAdjustmentDelegate(adjustmentDelegate) 
    {
      leftPanelAdjustmentDelegates.push(adjustmentDelegate);
    }
                                     
    
    // ***
    // *** right panel handlers
    // ***
 
    function onRightPanelInit(s, e) 
    {
      var toggleButton = rightAreaMenu.GetItemByName("ToggleRightPanel");
      if (s.IsExpandable())
      {
        toggleButton.SetChecked(rightPanel.IsExpanded());
      }
      else
      {
        toggleButton.SetChecked(rightPanel.GetVisible());
      }
    }

    function onRightPanelCollapsed(s, e) 
    {
      rightAreaMenu.GetItemByName("ToggleRightPanel").SetChecked(false);
    }
   
    // ***
    // *** right panel functions
    // ***
  
    function toggleRightPanel() 
    {
      rightPanel.Toggle();
    }

   
    // ***
    // *** header panel functions
    // ***
  
    function onHeaderPanelRightMenuItemClick(s, e) 
    {
      if (e.item.name === "ReauthenticateItem")
      {
        e.processOnServer = true;
      }
      else
      {
        e.processOnServer = false;    
        switch(e.item.name) 
        {
          case "ToggleRightPanel":
              toggleRightPanel();
              break;
                    
          case "AccountItem":
              break;
            
          case "SignInAsNewUser":
              pcCreateAccount.Show();
              tbUsername.Focus();
              break;
        }
      }        
    }

    // ***
    // *** popup functions
    // ***
        
    function ShowAlertWindow() 
    {
      pcAlert.Show();
      tbMessage.Focus();
    }

    // ***
    // *** other functions
    // ***

    function openURL(url, newtab) 
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

      
    // ***
    // *** window handlers
    // ***
  
    window.onLeftPanelInit = onLeftPanelInit;
    window.onLeftPanelCollapsed = onLeftPanelCollapsed;
    
    window.onLeftMenuItemClick = onLeftMenuItemClick;
    window.HideLeftPanelIfRequired = HideLeftPanelIfRequired;

    window.AdjustLeftPanelControls = AdjustLeftPanelControls;
    window.AddLeftPanelAdjustmentDelegate = AddLeftPanelAdjustmentDelegate; 

    window.onRightPanelInit = onRightPanelInit;
    window.onRightPanelCollapsed = onRightPanelCollapsed;

    window.onHeaderPanelRightMenuItemClick = onHeaderPanelRightMenuItemClick;    
        
    // *** ***********************
    // *** ***********************
    // *** ***********************
    
  }
)();