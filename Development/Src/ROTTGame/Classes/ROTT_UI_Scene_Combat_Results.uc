/*=============================================================================
 * ROTT_UI_Scene_Combat_Results
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This scene displays the results from a combat scenario.
 *===========================================================================*/

class ROTT_UI_Scene_Combat_Results extends ROTT_UI_Scene;

// Page references
var privatewrite ROTT_UI_Page_Combat_Victory pageCombatVictory;
var privatewrite ROTT_UI_Page_Combat_Analysis pageCombatAnalysis;
var privatewrite ROTT_UI_Page_Transition transitionPageIn;
var privatewrite ROTT_UI_Page_Transition transitionPageOut;
var privatewrite ROTT_UI_Page_Transition transitionPageOverWorld;

// Page transfering mechanics
var public bool bLevelUpTransfer;
var public bool bLootPending;

/*=============================================================================
 * initScene()
 *
 * Called when this scene is created
 *===========================================================================*/
event initScene() {
  super.initScene();
  
  // Internal menu references
  pageCombatVictory = ROTT_UI_Page_Combat_Victory(findComp("Page_Combat_Victory"));
  pageCombatAnalysis = ROTT_UI_Page_Combat_Analysis(findComp("Page_Combat_Analysis"));
  transitionPageIn = ROTT_UI_Page_Transition(findComp("Page_Transition_In"));
  transitionPageOut = ROTT_UI_Page_Transition(findComp("Page_Transition_Out"));
  transitionPageOverWorld = ROTT_UI_Page_Transition(findComp("Page_Transition_Out_Over_World"));
  
  pushPage(pageCombatVictory);
}

/*=============================================================================
 * loadScene()
 *
 * Called every time the menu is opened
 *===========================================================================*/
event loadScene() {
  super.loadScene();
  
  // Clear the stack
  while (pageStack.length != 0) {
    popPage();
  }
  
  // Transition into victory page
  pushPage(pageCombatVictory);
  pushPage(transitionPageIn); 
}

/*=============================================================================
 * transitionToAnalysis()
 *
 * Called from the victory page to switch to analysis
 *===========================================================================*/
event transitionToAnalysis() {
  // Set transition
  transitionPageOut.destinationPage = pageCombatAnalysis;
  transitionPageOut.destinationScene = NO_SCENE;
  pushPage(transitionPageOut);
}

/*=============================================================================
 * transitionToHeroStats()
 *
 * Called to transition out from combat analysis to game menu hero stats
 * after level up.
 *===========================================================================*/
event transitionToHeroStats() {
  // Set transition
  transitionPageOut.destinationPage = none;
  transitionPageOut.destinationScene = SCENE_GAME_MENU;
  pushPage(transitionPageOut);
  
  // Make menu navigate to hero
  gameInfo.sceneManager.sceneGameMenu.transitionToHeroStats();
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
  
  // Victory Page
  begin object class=ROTT_UI_Page_Combat_Victory Name=Page_Combat_Victory
    tag="Page_Combat_Victory"
  end object
  pageComponents.add(Page_Combat_Victory)
  
  // Analysis Page
  begin object class=ROTT_UI_Page_Combat_Analysis Name=Page_Combat_Analysis
    tag="Page_Combat_Analysis"
  end object
  pageComponents.add(Page_Combat_Analysis)
  
  // Transition Page (in)
  begin object class=ROTT_UI_Page_Transition Name=Page_Transition_In
    tag="Page_Transition_In"
    bEnabled=false
    bConsumeInput=true
    transitionDelay=0.2
    
    // Sorter effect config
    effectConfig=RIGHT_SWEEP_TRANSITION_IN
    
    // Destination
    destinationScene=NO_SCENE
  end object
  pageComponents.add(Page_Transition_In)

  // Transition Page (out)
  begin object class=ROTT_UI_Page_Transition Name=Page_Transition_Out
    tag="Page_Transition_Out"
    bEnabled=false
    bConsumeInput=true
    transitionDelay=0.2
    
    // Sorter effect config
    effectConfig=RIGHT_SWEEP_TRANSITION_OUT
    
    // Destination
    destinationScene=NO_SCENE
  end object
  pageComponents.add(Page_Transition_Out)
  
  // Transition Page (out)
  begin object class=ROTT_UI_Page_Transition Name=Page_Transition_Out_Over_World
    tag="Page_Transition_Out_Over_World"
    bEnabled=false
    bConsumeInput=true
    
    // Sorter effect config
    effectConfig=RIGHT_SWEEP_TRANSITION_OUT
    
    // Destination
    destinationScene=SCENE_OVER_WORLD
  end object
  pageComponents.add(Page_Transition_Out_Over_World)

}













