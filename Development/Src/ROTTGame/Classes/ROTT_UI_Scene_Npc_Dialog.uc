/*=============================================================================
 * ROTT_UI_Scene_Npc_Dialog
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This scene is displayed when the player talks to an NPC.
 *===========================================================================*/

class ROTT_UI_Scene_Npc_Dialog extends ROTT_UI_Scene;

// NPC interface
var privatewrite ROTT_UI_Page_NPC_Dialogue npcDialoguePage;
var privatewrite ROTT_UI_Page_Naming_Interface namingPage;

// Transitions
var privatewrite ROTT_UI_Page_Transition transitionIn;
///var privatewrite ROTT_UI_Page_Transition transitionOut;
var privatewrite ROTT_UI_Page_Transition transitionCombat;
var privatewrite ROTT_UI_Page_Transition transitionNewWorld;


/*=============================================================================
 * initScene()
 *
 * Called when this scene is created
 *===========================================================================*/
event initScene() {
  // NPC interface
  npcDialoguePage = ROTT_UI_Page_NPC_Dialogue(findComp("Page_NPC_Dialogue"));
  namingPage = ROTT_UI_Page_Naming_Interface(findComp("Page_Naming_Interface"));
  
  // Transitions
  transitionIn = ROTT_UI_Page_Transition(findComp("Page_Transition_In"));
  ///transitionOut = ROTT_UI_Page_Transition(findComp("Page_Transition_Out"));
  transitionCombat = ROTT_UI_Page_Transition(findComp("Page_Combat_Transition"));
  transitionNewWorld = ROTT_UI_Page_Transition(findComp("Page_New_World_Transition"));
  
  super.initScene();
  
  // Initial display
  pushPage(npcDialoguePage);
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
 * unloadScene()
 * 
 * Called when this scene will no longer be rendered
 *===========================================================================*/
event unloadScene() {
  super.unloadScene();
}

/*=============================================================================
 * openNPCDialog()
 * 
 * Opens npc screen with the given NPC
 *===========================================================================*/
public function openNPCDialog(class<ROTT_NPC_Container> npcType) {
  npcDialoguePage.launchNPC(npcType);
  
  // Transition into dialog
  pushPage(transitionIn, false);
}

/*=============================================================================
 * openNamingInterface()
 * 
 * Opens the naming page, letting the player input a profile name
 *===========================================================================*/
public function openNamingInterface() {
  pushPage(namingPage);
}

/*=============================================================================
 * combatTransition()
 * 
 * This pushes an effect to transition into combat
 *===========================================================================*/
public function combatTransition() {
  // Transition to combat
  pushPage(transitionCombat, false);
}

/*=============================================================================
 * deleteScene()
 *
 * Deletes scene references for garbage collection
 *===========================================================================*/
public function deleteScene() {
  super.deleteScene();
  
  npcDialoguePage = none;
}

/*=============================================================================
 * Default properties
 *===========================================================================*/
defaultProperties 
{
  // Scene frame
  begin object class=ROTT_UI_Screen_Frame Name=Screen_Frame
    tag="Screen_Frame"
    bEnabled=true
  end object
  uiComponents.add(Screen_Frame)
  
  // NPC Dialogue Page
  begin object class=ROTT_UI_Page_NPC_Dialogue Name=Page_NPC_Dialogue
    tag="Page_NPC_Dialogue"
    bEnabled=true
  end object
  pageComponents.add(Page_NPC_Dialogue)

  // Naming Interface Page
  begin object class=ROTT_UI_Page_Naming_Interface Name=Page_Naming_Interface
    tag="Page_Naming_Interface"
    bEnabled=true
  end object
  pageComponents.add(Page_Naming_Interface)

  // Transition in
  begin object class=ROTT_UI_Page_Transition Name=Page_Transition_In
    tag="Page_Transition_In"
    bEnabled=false
    
    // Transition speed
    tilesPerTick=8
    
    // Sorter effect config
    effectConfig=NPC_TRANSITION_IN
    
    // Destination
    destinationScene=NO_SCENE
  end object
  pageComponents.add(Page_Transition_In)

  // Transition to combat
  begin object class=ROTT_UI_Page_Transition Name=Page_Combat_Transition
    tag="Page_Combat_Transition"
    bEnabled=false
    
    // Transition speed
    tilesPerTick=8
    
    // Sorter effect config
    effectConfig=RANDOM_SORT_TRANSITION
    
    // Destination
    destinationScene=SCENE_COMBAT_ENCOUNTER
  end object
  pageComponents.add(Page_Combat_Transition)

  // Transition for exiting the new game dialog
  begin object class=ROTT_UI_Page_Transition Name=Page_New_World_Transition
    tag="Page_New_World_Transition"
    bEnabled=false
    
    // Transition speed
    tilesPerTick=10
    
    // Sorter effect config
    effectConfig=RANDOM_SORT_TRANSITION
    
    // Destination
    destinationWorld="ROTT-Talonovia"
    destinationScene=NO_SCENE
  end object
  pageComponents.add(Page_New_World_Transition)

}










