/*=============================================================================
 * ROTT_UI_Page_Party_Manager
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: The party manager allows the player to select which party
 * they want to play as.
 *===========================================================================*/
class ROTT_UI_Page_Party_Manager extends ROTT_UI_Page;

// Parent scene
var privatewrite ROTT_UI_Scene_Party_Manager someScene;

// This tracks which party is actually targetted by the selector
var privatewrite int selectionIndex;

// This is the cap for selectionIndex, based on the number of parties
var private int maxIndex;

// Internal UI references
var private ROTT_UI_Party_Manager_Container_List containerList;
var private UI_Selector selector;

/*=============================================================================
 * Initialize Component
 *
 * Description: This event is called as the UI is loaded.
 *              Our initial scene is drawn here.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  super.initializeComponent(newTag);
  
  someScene = ROTT_UI_Scene_Party_Manager(outer);
  
  // Internal References
  containerList = ROTT_UI_Party_Manager_Container_List(findComp("Party_Manager_Container_List"));
  selector = UI_Selector(findComp("Party_Mgmt_Selector"));
}

/*=============================================================================
 * onFocusMenu()
 *
 * Called when a menu is given focus.  Assign controls, and enable graphics.
 *===========================================================================*/
event onFocusMenu() {
  selector.setActive(true);
}

/*============================================================================= 
 * onSceneActivation()
 *
 * Called every time the parent scene is loaded
 *===========================================================================*/
public function onSceneActivation() {
  // Reset selector
  selectionIndex = 0;
  selector.resetSelection();
  
  // Render the party system
  containerList.displayParties(partySystem);
  
  // Render info to screen
  refresh();
}

/*============================================================================= 
 * refresh()
 *
 * This function should ensure that any data thats been changed will be 
 * correctly updated on the UI.
 *===========================================================================*/
public function refresh() {
  // Render the party system
  containerList.refreshParties();
  
  // Selection data is based on number of parties, plus conscription option
  maxIndex = partySystem.getNumberOfParties();
}

/*=============================================================================
 * conscription()
 * 
 * Adds a new team to the player's profile
 *===========================================================================*/
public function conscription() {
  // Create new party
  partySystem.addParty();
  
  // New character selection for new party
  gameInfo.closeGameMenu();
  sceneManager.switchScene(SCENE_CHARACTER_CREATION);
  
  // UI Reset selection
  selectionIndex = 0;
  selector.resetSelection();
  refresh();
}

/*=============================================================================
 * Button inputs
 *===========================================================================*/
protected function navigationRoutineA() {
  // Check if conscription is selected
  if (selectionIndex == maxIndex) {
    // push conscription page
    someScene.pushPartyConscriptionPage();
    
  } else {
    // push party viewer page
    someScene.pushPartyViewerPage();
  }
  // Sfx
  gameInfo.sfxBox.playSfx(SFX_MENU_ACCEPT);
}

protected function navigationRoutineB() {
  sceneManager.switchScene(SCENE_GAME_MENU);
  // Sfx
  gameInfo.sfxBox.playSfx(SFX_MENU_BACK);
}

/*=============================================================================
 * D-Pad controls
 *===========================================================================*/
public function bool preNavigateDown() {
  if (selectionIndex == 0 || selectionIndex == maxIndex - 1) {
    selectionIndex++;
    return true;
  } else if (selectionIndex < maxIndex) {
    if (containerList.lerpUp()) {
      selectionIndex++;
      return false;
    }
  }
  return false;
}

public function bool preNavigateUp() {
  if (selectionIndex == maxIndex || selectionIndex == 1) {
    selectionIndex--;
    return true;
  } else if (selectionIndex > 0) {
    if (containerList.lerpDown()) {
      selectionIndex--;
      return false;
    }
  }
  return false;
}

public function onNavigateLeft();
public function onNavigateRight();

/*=============================================================================
 * Assets
 *===========================================================================*/
defaultProperties
{  
  /** ===== Input ===== **/
  begin object class=ROTT_Input_Handler Name=Input_A
    inputName="XBoxTypeS_A"
    buttonComponent=none
  end object
  inputList.add(Input_A)
  
  begin object class=ROTT_Input_Handler Name=Input_B
    inputName="XBoxTypeS_B"
    buttonComponent=none
  end object
  inputList.add(Input_B)
  
  /** ===== Textures ===== **/
  // Background
  begin object class=UI_Texture_Info Name=Party_Manager_Background
    componentTextures.add(Texture2D'GUI.Party_Manager_Background')
  end object
  
  // Border
  begin object class=UI_Texture_Info Name=Party_Manager_Border
    componentTextures.add(Texture2D'GUI.Party_Manager_Border')
  end object
  
  /** Visual Page Setup **/
  tag="Party_MGR_Page"
  posX=0
  posY=0
  posXEnd=NATIVE_WIDTH
  posYEnd=NATIVE_HEIGHT
  
  // Party Management Background
  begin object class=UI_Sprite Name=Party_Mgmt_Background
    tag="Party_Mgmt_Background"
    posX=0
    posY=0
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    images(0)=Party_Manager_Background
  end object
  componentList.add(Party_Mgmt_Background)
  
  // Party Management - Container List
  begin object class=ROTT_UI_Party_Manager_Container_List Name=Party_Manager_Container_List
    tag="Party_Manager_Container_List" 
  end object
  componentList.add(Party_Manager_Container_List)
  
  // Selector
  begin object class=UI_Selector Name=Party_Mgmt_Selector
    tag="Party_Mgmt_Selector"
    bActive=true
    posX=53
    posY=39
    selectionOffset=(x=0,y=280)
    numberOfMenuOptions=3
    
    // Selection texture
    begin object class=UI_Texture_Info Name=Selection_Box_Texture
      componentTextures.add(Texture2D'GUI.PartyMGR_Selection_Box')
    end object

    // Selector sprite
    begin object class=UI_Sprite Name=Selector_Sprite
      tag="Selector_Sprite"
      images(0)=Selection_Box_Texture
      activeEffects.add((effectType = EFFECT_ALPHA_CYCLE, lifeTime = -1, elapsedTime = 0, intervalTime = 0.4, min = 170, max = 255))
    end object
    componentList.add(Selector_Sprite)
    
    // Selection arrow
    begin object class=UI_Texture_Info Name=Inactive_Selection_Arrow
      componentTextures.add(Texture2D'GUI.Menu_Selection_Arrow')
    end object
    
    // Inactive sprite
    begin object class=UI_Sprite Name=Inactive_Selector_Sprite
      tag="Inactive_Selector_Sprite"
      posy=90
      posx=-30
      images(0)=Inactive_Selection_Arrow
      activeEffects.add((effectType=EFFECT_FLICKER, lifeTime=-1, elapsedTime=0, intervalTime=0.1, min=200, max=255))
    end object
    componentList.add(Inactive_Selector_Sprite)
    
  end object
  componentList.add(Party_Mgmt_Selector)
  
  // Party Management Border
  begin object class=UI_Sprite Name=Party_Mgmt_Border
    tag="Party_Mgmt_Border"
    posX=0
    posY=0
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    images(0)=Party_Manager_Border
  end object
  componentList.add(Party_Mgmt_Border)
  
  
  
}



