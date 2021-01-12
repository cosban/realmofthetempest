/*=============================================================================
 * ROTT_UI_Page_Game_Menu
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This class handles the leftside of the game menu.
 *===========================================================================*/
 
class ROTT_UI_Page_Game_Menu extends ROTT_UI_Page;

/** ============================== **/

enum LeftMenuGraphics {
  MENU_EMPTY_GRAPHIC,
  
  MENU_DEFAULT_GRAPHIC,
  MENU_CONFIRM_GRAPHIC,
  MENU_REINVEST_STAT_GRAPHIC,
  MENU_REINVEST_SKILL_GRAPHIC
};

var private LeftMenuGraphics LeftMenuGraphic;

// Menu options
enum LeftGameMenuOptions {
  MENU_PARTY,
  MENU_UTILITIES,
  MENU_ARTIFACTS,
  MENU_GAME
};

enum CreationMenuOptions {
  MENU_INFO,
  MENU_CONFIRM
};

var private bool bCreationMode;

/** ============================== **/

// Internal references
var private UI_Selector menuSelector;
var private ROTT_UI_Party_Display partyDisplayer;
var private UI_Sprite menuBackground;

// Parent reference
var private ROTT_UI_Scene_Game_Menu someScene;

/*============================================================================= 
 * initializeComponent
 *
 * Called once, when the scene is first initialized.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  super.initializeComponent(newTag);
  
  someScene = ROTT_UI_Scene_Game_Menu(outer);
  
  // Get internal references
  menuBackground = findSprite("Menu_Background_Left");
  menuSelector = UI_Selector(findComp("Game_Menu_Selector"));
  partyDisplayer = ROTT_UI_Party_Display(findComp("Party_Displayer"));
  
  setMenuGraphic(MENU_DEFAULT_GRAPHIC);
}


/*============================================================================= 
 * resetSelector()
 *
 * This can be called by other scenes when they dont want the cursor preserved
 *===========================================================================*/
public function resetSelector() {
  // Reset selector info
  menuSelector.resetSelection();
}


/*============================================================================= 
 * setCreationMode
 *
 * This is called to limit the menu options to character creation mode.
 *===========================================================================*/
public function setCreationMode() {
  bCreationMode = true;
  setMenuGraphic(MENU_CONFIRM_GRAPHIC);
}

/*============================================================================= 
 * onPushPageEvent
 *
 * Description: This event is called every time the page is pushed.
 *===========================================================================*/
event onPushPageEvent() {
  partyDisplayer.syncIconEffects();
}

/*============================================================================= 
 * onSceneActivation
 *
 * Called every time the parent scene is loaded
 *===========================================================================*/
public function onSceneActivation() {
  // Render active party when game menu is opened
  partyDisplayer.renderParty(gameInfo.getActiveParty()); 
}

/*=============================================================================
 * onFocusMenu()
 *
 * Called when a menu is given focus.  Assign controls, and enable graphics.
 *===========================================================================*/
event onFocusMenu() {
  menuSelector.setActive(true);
}

/*=============================================================================
 * onUnfocusMenu()
 *
 * Called when the menu loses focus, but is not popped from the page stack.
 * Disable controls and update graphics accordingly.
 *===========================================================================*/
event onUnfocusMenu() {
  menuSelector.setActive(false);
}

/*============================================================================= 
 * refresh()
 *
 * Called to update info after investing skill points
 *===========================================================================*/
public function refresh() {
  partyDisplayer.renderParty(gameInfo.getActiveParty()); 
}

/*=============================================================================
 * setMenuGraphic()
 *
 * Changes the left menu graphic
 *===========================================================================*/
private function setMenuGraphic(LeftMenuGraphics newGraphic) {
  LeftMenuGraphic = newGraphic;
  menuBackground.setDrawIndex(newGraphic);
  
  switch (newGraphic) {
    case MENU_DEFAULT_GRAPHIC: 
      menuSelector.setNumberOfMenuOptions(4);
      break;
    case MENU_CONFIRM_GRAPHIC: 
      menuSelector.setNumberOfMenuOptions(2);
      break;
  }
}

/*=============================================================================
 * confirmCreation()
 *
 * Confirms a character class selection, and handles what happens next
 *===========================================================================*/
private function confirmCreation() {
  // Reset creation mode settings and graphics
  bCreationMode = false;
  setMenuGraphic(MENU_DEFAULT_GRAPHIC);
  
  // Reset character class selection page
  sceneManager.sceneCharacterCreation.characterCreationPage.resetSelection();
  
  if (partySystem.activePartySize() == 1) {
    // New active party index is set to this new party
    partySystem.setActiveParty(partySystem.getNumberOfParties() - 1);
    
    if (partySystem.getNumberOfParties() == 1) {
      // Go back to new game dialogue with NPC
      gameInfo.sceneManager.switchScene(SCENE_NPC_DIALOG);
      gameInfo.sceneManager.sceneNpcDialog.npcDialoguePage.npc.dialogTraversal(true);
    } else {
      // Remain in town after new party conscription
      
    }
  } else {
    // Update menu status to 'closed'
    gameInfo.closeGameMenu();
    parentScene.popPage();
  }
}

/*=============================================================================
 * Button controls
 *===========================================================================*/
protected function navigationRoutineA() {
  local LeftGameMenuOptions selection;
  local CreationMenuOptions altSelection;
  
  switch (bCreationMode) {
    case true:
      altSelection = CreationMenuOptions(menuSelector.getSelection());
      
      switch (altSelection) {
        case MENU_INFO:    someScene.pushMenu(PARTY_SELECTION);          break;
        case MENU_CONFIRM: confirmCreation();                              break;
      }
      break;
    case false:
      selection = LeftGameMenuOptions(menuSelector.getSelection());
      
      switch (selection) {
        case MENU_PARTY:     someScene.pushMenu(PARTY_SELECTION);        break;
        case MENU_UTILITIES: someScene.pushMenu(UTILITY_MENU);           break;
        case MENU_ARTIFACTS: someScene.pushMenu(ARTIFACT_COLLECTION);    break;
        case MENU_GAME:      sceneManager.switchScene(SCENE_GAME_MANAGER); break;
      }
      break;
  }
  
  // Sfx
  gameInfo.sfxBox.playSfx(SFX_MENU_ACCEPT);
}

protected function navigationRoutineB() {
  // Reset selector info
  resetSelector();
  
  switch (bCreationMode) {
    case false:
      // Update menu status to 'closed'
      gameInfo.closeGameMenu();
      break;
    case true:
      // Remove hero
      gameInfo.playerProfile.getActiveParty().removeHero();
      
      // Go back to class selection
      sceneManager.switchScene(SCENE_CHARACTER_CREATION);
      break;
  }
  parentScene.popPage();
  
  // Sfx
  gameInfo.sfxBox.playSfx(SFX_MENU_BACK);
}

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
  // Left menu backgrounds
  begin object class=UI_Texture_Info Name=Menu_Background_Left_Confirm
    componentTextures.add(Texture2D'GUI.Menu_Background_Left_Confirm')
  end object
	begin object class=UI_Texture_Info Name=Menu_Background_Left_Texture
    componentTextures.add(Texture2D'GUI.Menu_Background_Left')
  end object
  
  // Rightside background
  begin object class=UI_Texture_Info Name=Menu_Background_Texture
    componentTextures.add(Texture2D'GUI.Game_Menu_Right_Side_Cover') 
  end object
  
  /** ===== UI Components ===== **/
  // Left background
	begin object class=UI_Sprite Name=Menu_Background_Left
		tag="Menu_Background_Left"
    bEnabled=true
		posX=0
		posY=0
		posXEnd=720
		posYEnd=NATIVE_HEIGHT
		images(MENU_DEFAULT_GRAPHIC)=Menu_Background_Left_Texture
		images(MENU_CONFIRM_GRAPHIC)=Menu_Background_Left_Confirm
	end object
	componentList.add(Menu_Background_Left)
  
  // Right background
	begin object class=UI_Sprite Name=Menu_Background_Right
		tag="Menu_Background_Right"
    bEnabled=true
		posX=720
		posY=0
		posXEnd=NATIVE_WIDTH
		posYEnd=NATIVE_HEIGHT
		images(0)=Menu_Background_Texture
	end object
	componentList.add(Menu_Background_Right)
  
  // Selection box
	begin object class=UI_Selector Name=Game_Menu_Selector
		tag="Game_Menu_Selector"
    bEnabled=true
		posX=17
		posY=50
    selectionOffset=(x=0,y=100)
    numberOfMenuOptions=4
    
    // Selection box
    begin object class=UI_Texture_Info Name=Selection_Box_Texture
      componentTextures.add(Texture2D'GUI.Menu_Selection_Box')
    end object

    // Selector sprite
    begin object class=UI_Sprite Name=Selector_Sprite
      tag="Selector_Sprite"
      images(0)=Selection_Box_Texture
      activeEffects.add((effectType=EFFECT_ALPHA_CYCLE, lifeTime=-1, elapsedTime=0, intervalTime=0.4, min=170, max=255))
    end object
    componentList.add(Selector_Sprite)
    
    // Selection arrow
    begin object class=UI_Texture_Info Name=Inactive_Selection_Arrow
      componentTextures.add(Texture2D'GUI.Menu_Selection_Arrow')
    end object
    
    // Inactive sprite
    begin object class=UI_Sprite Name=Inactive_Selector_Sprite
      tag="Inactive_Selector_Sprite"
      images(0)=Inactive_Selection_Arrow
      activeEffects.add((effectType=EFFECT_FLICKER, lifeTime=-1, elapsedTime=0, intervalTime=0.1, min=200, max=255))
    end object
    componentList.add(Inactive_Selector_Sprite)
    
	end object
	componentList.add(Game_Menu_Selector)
	
  // Party Displayer
	begin object class=ROTT_UI_Party_Display Name=Party_Displayer
		tag="Party_Displayer"
    bEnabled=true
    posX=60
    posY=544
    XOffset=200
    YOffset=0
	end object
	componentList.add(Party_Displayer)
	
  
}














