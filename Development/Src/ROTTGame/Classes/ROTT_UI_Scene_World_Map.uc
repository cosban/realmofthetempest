/*=============================================================================
 * ROTT_UI_Scene_World_Map
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This scene displays the world map
 *===========================================================================*/

class ROTT_UI_Scene_World_Map extends ROTT_UI_Scene;

// Page references
var privatewrite ROTT_UI_Page_World_Map worldMapPage;

/*=============================================================================
 * initScene()
 *
 * Called when this scene is created
 *===========================================================================*/
event initScene() {
  // References
  worldMapPage = ROTT_UI_Page_World_Map(findComp("Page_World_Map"));
  
  super.initScene();
  
  // Push initial stack
  pushPage(worldMapPage);
  gameInfo.pauseGame();
}

/*=============================================================================
 * loadScene()
 *
 * Called when switching to this scene
 *===========================================================================*/
event loadScene() {
  super.loadScene();
}

/*=============================================================================
 * deleteScene()
 *
 * Deletes scene references for garbage collection
 *===========================================================================*/
public function deleteScene() {
  super.deleteScene();
  
  worldMapPage = none;
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties 
{
  // Allow controls
  bAllowOverWorldControl=false
  
  // Scene frame
  begin object class=ROTT_UI_Screen_Frame Name=Screen_Frame
    tag="Screen_Frame"
    bEnabled=true
  end object
  uiComponents.add(Screen_Frame)
  
  // World map
  begin object class=ROTT_UI_Page_World_Map Name=Page_World_Map
    tag="Page_World_Map"
    bEnabled=false
  end object
  pageComponents.add(Page_World_Map)

	// Black Texture
	///begin object class=UI_Texture_Info Name=Black_Texture
	///	componentTextures.add(Texture2D'GUI.Black_Square')
	///end object
  ///
	///// Black screen 
	///begin object class=UI_Sprite Name=World_Black_Screen
	///	tag="World_Black_Screen"
  ///  bEnabled=false
	///	posX=0
	///	posY=0
	///	posXEnd=NATIVE_WIDTH
	///	posYEnd=NATIVE_HEIGHT
	///	images(0)=Black_Texture
  ///  bMandatoryScaleToWindow=true
	///end object
	///uiComponents.add(World_Black_Screen)
	
}










