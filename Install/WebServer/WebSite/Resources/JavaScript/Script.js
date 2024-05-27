(
  function() 
  {
    // *** ***********************
    // *** ***********************
    // *** ***********************

    var adjustmentDelegates = [];
    
    // ***
    // *** page toolbar handlers
    // ***
  
    function onPageToolbarInit(s, e) 
    {
      var adjustmentMethod = function() 
      {
        document.getElementById("pageContent").style.paddingTop = s.GetHeight() + "px"; 
      };
      AddAdjustmentDelegate(adjustmentMethod);
    }

    // ***
    // *** page control functions
    // ***
        
    function AddAdjustmentDelegate(adjustmentDelegate) 
    {
      adjustmentDelegates.push(adjustmentDelegate);
    }
    
    function onControlsInitialized(s, e) 
    {
      adjustPageControls();
    }
    
    function onBrowserWindowResized(s, e) 
    {
      adjustPageControls();
    }
    
    function adjustPageControls() 
    {
      for (var i = 0; i < adjustmentDelegates.length; i++) 
      {
        adjustmentDelegates[i]();
      }
    }
    
    // ***
    // *** popout panel handlers
    // ***

    function onPopoutPanelInit(s, e) 
    {
    }
   
    function onPopoutPanelCollapsed(s, e) 
    {
    }
   
      
    // ***
    // *** window handlers
    // ***
    
    window.onPageToolbarInit = onPageToolbarInit;
    
    window.adjustPageControls = adjustPageControls;
    window.AddAdjustmentDelegate = AddAdjustmentDelegate;

  
    window.onControlsInitialized = onControlsInitialized;    
    window.onBrowserWindowResized = onBrowserWindowResized;
   
    window.onPopoutPanelInit = onPopoutPanelInit;
    window.onPopoutPanelCollapsed = onPopoutPanelCollapsed;
        
    // *** ***********************
    // *** ***********************
    // *** ***********************
    
  }
)();