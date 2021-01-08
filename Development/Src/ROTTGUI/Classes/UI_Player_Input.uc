/*=============================================================================
 * UI_Player_Input
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: Handles input for the players 3D world behavior.
 *===========================================================================*/

class UI_Player_Input extends PlayerInput;

// Store mouse position
var privatewrite IntPoint mousePosition;

// Store mouse position
var public float cursorSpeed;

// Padding for screen edges
var const float padSize;

`include(ROTTColorLogs.h)

/*============================================================================= 
 * playerInput()
 *
 * Called every frame
 *===========================================================================*/
event playerInput(float deltaTime) {
  super.playerInput(deltaTime);
  
  // Check for HUD
  if (myHUD != none) {
    // Move mouse on x & y axis 
    mousePosition.x += aMouseX * cursorSpeed;
    mousePosition.y -= aMouseY * cursorSpeed;
    
    // Clamp mouse within viewport width and height 
    mousePosition.x = clamp(mousePosition.x, 0, myHUD.SizeX - padSize);
    mousePosition.y = clamp(mousePosition.y, 0, myHUD.SizeY - padSize);
    
  }

}

/*============================================================================= 
 * setMousePosition()
 *
 * Sets mouse coordinates
 *===========================================================================*/
public function setMousePosition(int x, int y) {
  mousePosition.x = x;
  mousePosition.y = y;
}

/*=============================================================================
 * Process an input key event routed through unrealscript from another object. 
 * This method is assigned as the value for the OnRecievedNativeInputKey
 * delegate so that native input events are routed to this unrealscript function.
 *
 * @param   ControllerId    the controller that generated this input key event
 * @param   Key             the name of the key which an event occured for (KEY_Up, KEY_Down, etc.)
 * @param   EventType       the type of event which occured (pressed, released, etc.)
 * @param   AmountDepressed for analog keys, the depression percent.
 *
 * @return  true to consume the key event, false to pass it on.
 *===========================================================================*/
function bool onInputKey
(
  int ControllerId, 
  name Key, 
  EInputEvent Event, 
  float AmountDepressed = 1.f, 
  bool bGamepad = false
)
{
  // Check if input is from controller
  if (bGamepad) {
    // Hide cursor on controller use
    hideCursor();
  } else {
    // Show mouse control menus
    showMouseMenus();
  }
  
  return false;
}

/*============================================================================= 
 * hideCursor()
 *
 * Called when controller input is given.  Hides mouse UI. 
 *===========================================================================*/
public function hideCursor() {
  if (UI_HUD(myHUD) != none) UI_HUD(myHUD).hideCursor();
}

/*============================================================================= 
 * showMouseMenus()
 *
 * Called when keyboard and mouse input is given.  Shows mouse UI.
 *===========================================================================*/
public function showMouseMenus() {
  if (UI_HUD(myHUD) != none) UI_HUD(myHUD).showMouseMenus();
}

/*============================================================================= 
 * default properties
 *===========================================================================*/
defaultProperties
{
  // Mouse speed
  cursorSpeed=0.4125
  
  // Distance from edges
  padSize=10
  
  //OnReceivedNativeInputKey=onInputKey
  //OnReceivedNativeInputChar=InputChar
}















