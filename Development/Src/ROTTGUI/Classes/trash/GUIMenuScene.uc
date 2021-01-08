/*=============================================================================
 * GUIMenuScene
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This class handles high level menu behavior
 *===========================================================================*/

class GUIMenuScene extends Object
  abstract; 

// This stores all the interface components to display on screen
var instanced array<GUIComponent> menuComponents;

// Shortcut reference to the 'Outer' HUD
var GUICompatibleHUD OwnerHUD; 

// Color codes
`include(ROTTColorLogs.h)

/*=============================================================================
 * Initialize Menu
 *
 * Description: This event is called when the menu is first loaded.
 *===========================================================================
event InitMenuScene() {
  local GUIComponent comp;
  
  // Initialize child components
  foreach menuComponents(comp) {
    comp.ParentScene = self;
    comp.InitializeComponent();

    if (comp.bEnabled) {
      // Check if the child is a page component
      if (GUIPage(comp) != none) {
        //pushPage(GUIPage(comp));
      }
      
      // Call event
      comp.OnBecomeEnabled(comp);
    }
  }
}
*/
/*=============================================================================
 * renderScene()
 *
 * This event is called every frame to draw the menu scene to the screen.
 *===========================================================================*/
event renderScene(Canvas C) {
  local GUIComponent comp;
  
  // Caching
  /**
  if (!bPrecachedTextures) {
    foreach menuComponents(comp) {
      comp.PrecacheComponentTextures(C);
    }
    bPrecachedTextures = true;
    cyanlog("Finished caching textures");
  }
  **/
  
  // Rendering
  foreach menuComponents(comp) {
    comp.drawComponent(C);
  }
}

/*=============================================================================
 * findComponentByTag
 *
 * This function returns a child component matching the specified tag
 *===========================================================================*/
public function GUIComponent findComponentByTag(string componentTag) {
  local GUIComponent comp, result;
  
  if (ComponentTag == "")
    return none;

  foreach menuComponents(comp) {
    result = comp.checkComponentTag(componentTag);
    if (result != none) return result;
  }

  return none;
}

/*=============================================================================
 * Time rendering accessors
 *
 * @return  true to consume the key event, false to pass it on.
 *===========================================================================*/
public function float getWorldTime() {
  return class'WorldInfo'.static.getWorldInfo().timeSeconds;
}

public function float getRenderDelta() {
  if (OwnerHUD != none)
    return OwnerHUD.renderDelta;

  return 0.0166; // inverse of 60 frames per second
}


/*=============================================================================
 * Properties
 *===========================================================================*/
DefaultProperties
{

}





















