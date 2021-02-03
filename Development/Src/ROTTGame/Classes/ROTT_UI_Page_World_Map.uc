/*=============================================================================
 * ROTT_UI_Page_World_Map
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This page shows the world map (Opened with the select button)
 *===========================================================================*/
 
class ROTT_UI_Page_World_Map extends ROTT_UI_Page;

// Internal references
var private UI_Sprite worldMap;
var private UI_Label gameVersionText;

// Parent scene
var private ROTT_UI_Scene_World_Map someScene;

// Map controls
var private float mapSpeed;

/*============================================================================= 
 * initializeComponent()
 *
 * Called once, when the scene is first initialized.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  super.initializeComponent(newTag);
  
  // set parent scene
  someScene = ROTT_UI_Scene_World_Map(outer);
  
  // Internal references
  worldMap = findSprite("Background_Sprite");
  gameVersionText = findLabel("Game_Version_Text");
  
  // Draw version info
  gameVersionText.setText(gameInfo.getVersionInfo()); 
}

/*============================================================================= 
 * onPushPageEvent
 *
 * Description: This event is called every time the page is pushed.
 *===========================================================================*/
event onPushPageEvent() {
  
}

/*============================================================================= 
 * onPopPageEvent()
 *
 * This event is called when the page is removed
 *===========================================================================*/
event onPopPageEvent() {
  
}

/*============================================================================= 
 * refresh()
 *
 * This function should ensure that any data thats been changed will be 
 * correctly updated on the UI.
 *===========================================================================*/
public function refresh() {
  
}
  
/*============================================================================= 
 * onSceneActivation
 *
 * Called every time the parent scene is loaded
 *===========================================================================*/
public function onSceneActivation() {

}

/*=============================================================================
 * onFocusMenu()
 *
 * Called when a menu is given focus.  Assign controls, and enable graphics.
 *===========================================================================*/
event onFocusMenu();

/*=============================================================================
 * elapseTimers()
 *
 * Ticks every frame.  Used to check for joystick navigation.
 *===========================================================================*/
public function elapseTimers(float deltaTime) {
  super.elapseTimers(deltaTime);
  
  // Map movement
  worldMap.shiftX(mapSpeed * gameInfo.tempestPC.PlayerInput.RawJoyRight * -1);
  worldMap.shiftY(mapSpeed * gameInfo.tempestPC.PlayerInput.RawJoyUp);
  
  // Left-right bounds
  if (worldMap.getX() < -1 * NATIVE_WIDTH) {
    worldMap.updatePosition(
      -1 * NATIVE_WIDTH
    );
  } else if (worldMap.getX() > 0) {
    worldMap.updatePosition(
      0
    );
  }
  
  // Up-down bounds
  if (worldMap.getY() < -1 * NATIVE_HEIGHT) {
    worldMap.updatePosition(
      ,
      -1 * NATIVE_HEIGHT
    );
  } else if (worldMap.getY() > 0) {
    worldMap.updatePosition(
      ,
      0
    );
  }
}

/*=============================================================================
 * Controls
 *
 * ControllerId     the controller that generated this input key event
 * Key              the name of the key which an event occured for
 * EventType        the type of event which occured
 * AmountDepressed  for analog keys, the depression percent.
 *
 * Returns: true to consume the key event, false to pass it on.
 *===========================================================================*/
function bool onInputKey( 
  int ControllerId, 
  name Key, 
  EInputEvent Event, 
  float AmountDepressed = 1.f, 
  bool bGamepad = false) 
{
  switch (Key) {
    case 'XboxTypeS_Back': 
      // World map
      if (Event == IE_Pressed) gameinfo.sceneManager.switchScene(SCENE_OVER_WORLD);
      break;
    default:
      return super.onInputKey(ControllerId, Key, Event, AmountDepressed, bGamepad);
  }
  
  return false;
}

/*=============================================================================
 * D-Pad controls
 *===========================================================================*/
public function onNavigateLeft();
public function onNavigateRight();
protected function navigateDown();
protected function navigateUp();

/*=============================================================================
 * Button controls
 *===========================================================================*/
protected function navigationRoutineA();

protected function navigationRoutineB() {
  gameInfo.sceneManager.switchScene(SCENE_OVER_WORLD);
  gameInfo.sfxBox.playSfx(SFX_MENU_BACK);
}

/*=============================================================================
 * Assets
 *===========================================================================*/
defaultProperties
{
  // Map controls
  mapSpeed=12.f
  
  /** ===== Input ===== **/
  begin object class=ROTT_Input_Handler Name=Input_B
    inputName="XBoxTypeS_B"
    buttonComponent=none
  end object
  inputList.add(Input_B)
  
  /** ===== Textures ===== **/
  // Left menu backgrounds
  begin object class=UI_Texture_Info Name=World_Map
    componentTextures.add(Texture2D'GUI_Overworld.World_Map')
  end object
  
  /** ===== UI Components ===== **/
  // Background
  begin object class=UI_Sprite Name=Background_Sprite
    tag="Background_Sprite"
    bEnabled=true
    posX=-720
    posY=-450
    posXEnd=2160
    posYEnd=1350
    images(0)=World_Map
  end object
  componentList.add(Background_Sprite)
  
  // Left menu backgrounds
  begin object class=UI_Texture_Info Name=World_Map_Frame
    componentTextures.add(Texture2D'GUI_Overworld.World_Map_Frame')
  end object
  
  // Background
  begin object class=UI_Sprite Name=Frame_Sprite
    tag="Frame_Sprite"
    bEnabled=true
    posX=0
    posY=0
    posXEnd=1440
    posYEnd=900
    images(0)=World_Map_Frame
  end object
  componentList.add(Frame_Sprite)
  
  // Version label
  begin object class=UI_Label Name=Game_Version_Text
    tag="Game_Version_Text"
    posX=25
    posY=25
    posXEnd=1415
    posYEnd=875
    alignX=LEFT
    alignY=BOTTOM
    fontStyle=DEFAULT_SMALL_BROWN
    labelText=""
  end object
  componentList.add(Game_Version_Text)
  
}
















