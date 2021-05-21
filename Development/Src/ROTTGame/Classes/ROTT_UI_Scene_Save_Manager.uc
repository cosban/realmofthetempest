/*=============================================================================
 * ROTT_UI_Scene_Save_Manager
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: The save manager scene displays a list of save game files.
 *===========================================================================*/

class ROTT_UI_Scene_Save_Manager extends ROTT_UI_Scene;

// Internal page references
var private ROTT_UI_Page_Save_Manager saveManagerPage;
var private ROTT_UI_Page_Transition transitionOnLoadGame;

/*=============================================================================
 * initScene()
 *
 * Called when this scene is created
 *===========================================================================*/
event initScene() {
  super.initScene();
  
  // Internal references
  saveManagerPage = ROTT_UI_Page_Save_Manager(findComp("Page_Save_Manager"));
  transitionOnLoadGame = ROTT_UI_Page_Transition(findComp("Page_Transition_Load_Game"));
  
  // Initial stack
  pushPage(saveManagerPage);
}

/*=============================================================================
 * loadScene()
 *
 * Called every time the menu is opened
 *===========================================================================*/
event loadScene() {
  super.loadScene();
}

/*=============================================================================
 * unloadScene()
 * 
 * Called when this scene will no longer be rendered.  Each page receives
 * a call for the onSceneDeactivation() event
 *===========================================================================*/
event unloadScene() {
  super.unloadScene();
}

/*=============================================================================
 * transitionLoadGame()
 *
 * Show the transition effect for loading a game.
 *===========================================================================*/
public function transitionLoadGame() {
  // Load last town
  transitionOnLoadGame.destinationWorld = gameInfo.getMapFileName(MAP_TALONOVIA_TOWN);
  /* to do ... replace talonovia with last town */
  
  // Execute transition
  pushPage(transitionOnLoadGame);
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties 
{
  // Scene frame
  begin object class=ROTT_UI_Screen_Frame Name=Screen_Frame
    tag="Screen_Frame"
    bEnabled=true
  end object
  uiComponents.add(Screen_Frame)
  
  /** ===== Page Components ===== **/
  // Page Party Manager (Main page)
  begin object class=ROTT_UI_Page_Save_Manager Name=Page_Save_Manager
    tag="Page_Save_Manager"
  end object
  pageComponents.add(Page_Save_Manager)
  
  // Transition for loading game
  begin object class=ROTT_UI_Page_Transition Name=Page_Transition_Load_Game
    tag="Page_Transition_Load_Game"
    bEnabled=false
    
    // Transition speed
    tilesPerTick=18
    
    // Sorter effect config
    effectConfig=NPC_TRANSITION_OUT
    
    // Destination
    destinationScene=NO_SCENE
  end object
  pageComponents.add(Page_Transition_Load_Game)
  
}














