/*=============================================================================
 * ROTT_UI_Page_Title_Screen
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This class handles the display and controls for the title menu
 *===========================================================================*/
 
class ROTT_UI_Page_Title_Screen extends ROTT_UI_Page;
 
/** ============================== **/

enum UISceneStates {
  
  MENU_HIDDEN,
  GAMEPLAY_MENU_VISIBLE,
  GAMEMODE_MENU_VISIBLE,
  
  STOP_ALL_INPUT,
  
  RESTART_REQUIRED
  
};

var private UISceneStates currentUIScene;

/** ============================== **/

enum UIMenuOptions {
  
  NEW_GAME,
  CONTINUE_GAME
  
};

/** ============================== **/

const REQUIREMENTS_PASS = false;  // Used for the system settings hack
const REQUIREMENTS_FAIL = true;

// Internal references
var private UI_Selector menuSelector;
var private UI_Label gameVersionText;
var private UI_Sprite titleMenuOptions;
var private UI_Sprite gameModeMenuOptions;
var private UI_Sprite restartRequiredNotification;

// Timers
var private ROTTTimer fadeInTimer;     // Used to ignore inputs until fade in
var private ROTTTimer newGameTimer;    // Used to fade out before a new game

// Counts the number of invalid inputs for controller requirement message
var private int invalidInputs;

/*=============================================================================
 * initialize Component
 *
 * Called once, when the scene is first initialized.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  super.initializeComponent(newTag);
  
  // Internal references
  menuSelector = UI_Selector(findComp("Title_Menu_Selector"));
  gameVersionText = findLabel("Game_Version_Text");
  gameModeMenuOptions = findSprite("Game_Mode_Menu_Options");
  titleMenuOptions = findSprite("Title_Menu_Options");
  restartRequiredNotification = findSprite("Restart_Required_Notification");
  
  // Draw version info
	gameVersionText.setText(gameInfo.getVersionInfo()); 
  addEffectToComponent(DELAY, "Title_Fade_Component", 1.2);
  addEffectToComponent(FADE_OUT, "Title_Fade_Component", 0.8);
  
  // Set scene to no input, until fade in effects complete
  currentUIScene = STOP_ALL_INPUT;
  
  // Draw "restart required" dialogue, if necessary
  if (checkSystemSettings() == REQUIREMENTS_FAIL) {
    currentUIScene = RESTART_REQUIRED;
    restartRequiredNotification.setEnabled(true); 
  } else {
    // Time delay until input
    fadeInTimer = gameInfo.Spawn(class'ROTTTimer');
    fadeInTimer.makeTimer(1.6, LOOP_OFF, allowInput);
  }
  
  // Build and version info
  if (!gameInfo.bDevMode) {
    if (gameInfo.bQaMode) {
      findLabel("Dev_Build_Warning").setText("QA Mode: Phase " $ gameInfo.const.PHASE_INFO);
      findLabel("Dev_Build_Warning").setFont(DEFAULT_SMALL_ORANGE);
    } else {
      findLabel("Dev_Build_Warning").setText("");
    }
  } 
}

/*============================================================================*
 * Controls
 *
 * ControllerId     the controller that generated this input key event
 * Key              the name of the key which an event occured for
 * EventType        the type of event which occured
 * AmountDepressed  for analog keys, the depression percent.
 *
 * Returns: true to consume the key event, false to pass it on.
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
  /// Debug input
	//gameVersionText.setText(gameInfo.getVersionInfo() $ "                        " $ Key $ "  " $ AmountDepressed); 
  
  if (Key == 'Escape') gameInfo.consoleCommand("EXIT");
  switch (Key) {
    case 'Spacebar':
    ///case 'Enter':
    case 'w':
    case 'a':
    case 's':
    case 'd':
      invalidInputs++;
      if (invalidInputs == 2) {
        showControllerNotification();
      }
      break;
  }
  
  return super.onInputKey(ControllerId, Key, Event, AmountDepressed, bGamepad);
}

/*============================================================================*
 * showControllerNotification()
 *
 * Displays a message to the user that a controller is required.
 *===========================================================================*/
private function showControllerNotification() {
  findLabel("Controller_Notification_Label_Shadow").setEnabled(true);
  findLabel("Controller_Notification_Label").setEnabled(true);
  
  addEffectToComponent(DELAY, "Controller_Notification_Label", 3.1);
  addEffectToComponent(FADE_OUT, "Controller_Notification_Label", 1.35);
}

/*============================================================================*
 * hideControllerNotification()
 *
 * Hides a message to the user that a controller is required.
 *===========================================================================*/
private function hideControllerNotification() {
  findLabel("Controller_Notification_Label_Shadow").setEnabled(false);
  findLabel("Controller_Notification_Label").setEnabled(false);
}

/*=============================================================================
 * Button controls
 *===========================================================================*/
protected function navigationRoutineA() {
	switch (currentUIScene) {
    case MENU_HIDDEN:            showMenu();        break;
    case GAMEPLAY_MENU_VISIBLE:  menuSelect();      break;
    case GAMEMODE_MENU_VISIBLE:  modeMenuSelect();  break;
  }
  hideControllerNotification();
}

/*=============================================================================
 * requirementRoutineA()
 *
 * Returns true if input is valid for a button.  This function must be 
 * delegated to a button, because each button has different requirements.
 *===========================================================================*/
protected function bool requirementRoutineA() {
  // Ignore input when restart required
  if (currentUIScene == RESTART_REQUIRED) return false;
  
  // Ignore input when controls are locked (for fade in effects)
  if (currentUIScene == STOP_ALL_INPUT) return false;
  return true;
}

protected function navigationRoutineB() {
  // Back out of game mode selection
  if (currentUIScene == GAMEMODE_MENU_VISIBLE) {
    // Back out of scene
    currentUIScene = GAMEPLAY_MENU_VISIBLE;
    // Hide this menu
    titleMenuOptions.setEnabled(true);
    // Show game mode menu
    gameModeMenuOptions.setEnabled(false);
  
    // Sfx
    gameInfo.sfxBox.playSfx(SFX_MENU_BACK);
  }
}

/*=============================================================================
 * showMenu()
 *
 * This function pulls up the "New Game / Continue" menu
 *===========================================================================*/
private function showMenu() {
  // Update scene info
  currentUIScene = GAMEPLAY_MENU_VISIBLE;
  menuSelector.setActive(true);
  
  // Render menu scene
  titleMenuOptions.setEnabled(true);
  menuSelector.setEnabled(true);
  
  if (gameInfo.saveFileExist()) {
    titleMenuOptions.setDrawIndex(0);
  } else {
    titleMenuOptions.setDrawIndex(1);
  }
  
  // Sound effects
  gameinfo.sfxBox.playSFX(SFX_MENU_ACCEPT);
}

/*=============================================================================
 * modeMenuSelect()
 *
 * This function selects an option from the game mode menu
 *===========================================================================*/
private function modeMenuSelect() {
  whitelog("--+ New Game +--");
  
  // initiate fade out
  addEffectToComponent(FADE_IN, "Title_Fade_Component", 0.75);
  
  // Set new scene controls
  currentUIScene = STOP_ALL_INPUT; 
  
  // Audio controls
  gameinfo.sfxBox.playSFX(SFX_MENU_ACCEPT);
  jukebox.fadeOut(1);
  
  // Wait to launch new game
  newGameTimer = gameInfo.Spawn(class'ROTTTimer');
  newGameTimer.makeTimer(1.0, LOOP_OFF, showIntroPage);
  
  // Deactivate selector
  menuSelector.setActive(false);
  
  // Set game mode
  gameInfo.newGameSetup(GameModes(menuSelector.getSelection()));
  
}

/*=============================================================================
 * menuSelect()
 *
 * This function selects an option from the gameplay menu
 *===========================================================================*/
private function menuSelect() {
  switch (menuSelector.getSelection()) {
    case NEW_GAME:
      // Hide this menu
      titleMenuOptions.setEnabled(true);
      // Show game mode menu
      gameModeMenuOptions.setEnabled(true);
      
      // Update viewmode data for this menu
      currentUIScene = GAMEMODE_MENU_VISIBLE;
      
      // Reset selector
      menuSelector.resetSelection();
      menuSelector.setNumberOfMenuOptions(3);
      
      // Play audio
      gameinfo.sfxBox.playSFX(SFX_MENU_ACCEPT);
      break;
      
    case CONTINUE_GAME:
      whitelog("--+ Continue Game +--");
      // Attempt to load game
      if (gameInfo.loadSavedGame()) {
        // If loaded successfully, save for transition
        gameInfo.saveGame(true);
        
        // Queue transition
        gameInfo.sceneManager.sceneTitleScreen.transitionContinue();
        
        // Deactivate selector
        menuSelector.setActive(false);
      } else {
        // Save file does not exist, play sound
        gameinfo.sfxBox.playSFX(SFX_MENU_INSUFFICIENT); 
        redlog("Save file does not exist");
      }
      break;
  }
  
}

/*=============================================================================
 * Check System Settings
 *
 * Description: This function is a hacky way of forcing changes to some system 
 *              settings, which require a restart of the application. 
 *===========================================================================*/
private function bool checkSystemSettings() {
	local CustomSystemSettings settings;
	local ROTT_Cookie_Requirement cookie;

  settings = class'WorldInfo'.static.getWorldInfo().spawn(class'CustomSystemSettings');
	cookie = new(self) class'ROTT_Cookie_Requirement';
	
	// Hacky! check version info to see if the game has been run before
	if (class'Engine'.static.basicLoadObject(cookie, "Save\\version_cookie.bin", true, 0)) {
		if (cookie.sVersion == gameInfo.getVersionInfo()) {
			return REQUIREMENTS_PASS;
		}
	}
	
	// Force VSync (game looks awful without it)
	settings.setUseVsync(true);
	
	// Hacky! Save version info out to allow future requirement checks to pass
	cookie.sVersion = gameInfo.getVersionInfo();
	class'Engine'.static.basicSaveObject(cookie, "Save\\version_cookie.bin", true, 0);

	return REQUIREMENTS_FAIL; // restart required

}

/*=============================================================================
 * showIntroPage()
 *
 * 
 *===========================================================================*/
private function showIntroPage() { 
  parentScene.pushPageByTag("Page_Game_Intro");
  
  // Remove timer
  newGameTimer.destroy();
} 

/*=============================================================================
 * allowInput()
 *
 * Description: This function is delegated to a timer, thus no paramaters.
 *===========================================================================*/
private function allowInput() { 
  // Triggered after fade in, control is given to player
  currentUIScene = MENU_HIDDEN; 
  fadeInTimer.destroy();
  invalidInputs = 0;
} 

/*=============================================================================
 * deleteComp()
 *
 * Called for memory clean up
 *===========================================================================*/
event deleteComp() {
  super.deleteComp();
  
  if (fadeInTimer != none) fadeInTimer.destroy();     
  if (newGameTimer != none) newGameTimer.destroy();     
}

/*=============================================================================
 * Default Properties
 *
 * By convention, names and tags should use capitalized words separated by
 * underscores.  (e.g. Example_Component_Name)
 *===========================================================================*/
defaultProperties
{
  bMandatoryScaleToWindow=true
  
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
	begin object class=UI_Texture_Info Name=Title_Image_Texture
    componentTextures.add(Texture2D'GUI.Tempest_Stronghold_Title')
  end object
	begin object class=UI_Texture_Info Name=Title_Menu_Buttons_Texture
    componentTextures.add(Texture2D'GUI.Title_Menu_Buttons')
  end object
	begin object class=UI_Texture_Info Name=Title_Menu_Buttons_Disabled_Texture
    componentTextures.add(Texture2D'GUI.Title_Menu_Buttons_Disabled')
  end object
	begin object class=UI_Texture_Info Name=Game_Mode_Menu_Buttons_Texture
    componentTextures.add(Texture2D'GUI.Game_Mode_Menu_Buttons')
  end object
	begin object class=UI_Texture_Info Name=Black_Texture
		componentTextures.add(Texture2D'GUI.Black_Square')
	end object
	begin object class=UI_Texture_Info Name=Restart_Required_Texture
		componentTextures.add(Texture2D'GUI.RestartRequired')
	end object
	
  // Game title sprite
	begin object class=UI_Sprite Name=Game_Title_Image
		tag="Game_Title_Image"
		posX=420
		posY=160
		posXEnd=1020
		posYEnd=430
		images(0)=Title_Image_Texture
	end object
	componentList.add(Game_Title_Image)
  
  // Game Play Options
	begin object class=UI_Sprite Name=Title_Menu_Options
		tag="Title_Menu_Options"
    bEnabled=false
		posX=539
		posY=547
		images(0)=Title_Menu_Buttons_Texture
		images(1)=Title_Menu_Buttons_Disabled_Texture
	end object
	componentList.add(Title_Menu_Options)
	
  // Game Mode Options
	begin object class=UI_Sprite Name=Game_Mode_Menu_Options
		tag="Game_Mode_Menu_Options"
    bEnabled=false
		posX=539
		posY=547
		images(0)=Game_Mode_Menu_Buttons_Texture
	end object
	componentList.add(Game_Mode_Menu_Options)
	
  // Selector
	begin object class=UI_Selector Name=Title_Menu_Selector
		tag="Title_Menu_Selector"
    bEnabled=false
		posX=519
		posY=549
    selectionOffset=(x=0,y=71)
    numberOfMenuOptions=2
    
    // Selection texture
    begin object class=UI_Texture_Info Name=Selection_Box_Texture
      componentTextures.add(Texture2D'GUI.ContinueSelector')
    end object

    // Selector sprite
    begin object class=UI_Sprite Name=Selector_Sprite
      tag="Selector_Sprite"
      images(0)=Selection_Box_Texture
      activeEffects.add((effectType = EFFECT_ALPHA_CYCLE, lifeTime = -1, elapsedTime = 0, intervalTime = 0.4, min = 170, max = 255))
    end object
    componentList.add(Selector_Sprite)
    
    // Inactive sprite
    begin object class=UI_Sprite Name=Inactive_Selector_Sprite
      tag="Inactive_Selector_Sprite"
      images(0)=Selection_Box_Texture
      activeEffects.add((effectType=EFFECT_FLICKER, lifeTime=-1, elapsedTime=0, intervalTime=0.1, min=200, max=255))
    end object
    componentList.add(Inactive_Selector_Sprite)
    
	end object
	componentList.add(Title_Menu_Selector)
	
  // Restart info
	begin object class=UI_Sprite Name=Restart_Required_Notification
		tag="Restart_Required_Notification"
    bEnabled=false
		posX=390
		posY=540
		posXEnd=1050
		posYEnd=660
		images(0)=Restart_Required_Texture
	end object
	componentList.add(Restart_Required_Notification)
	
  // Version
	begin object class=UI_Label Name=Game_Version_Text
		tag="Game_Version_Text"
		posX=0
		posY=0
		posXEnd=NATIVE_WIDTH
		posYEnd=NATIVE_HEIGHT
		alignX=LEFT
		alignY=BOTTOM
		fontStyle=DEFAULT_SMALL_BEIGE
		labelText=""
	end object
	componentList.add(Game_Version_Text)
	
  // Build info
	begin object class=UI_Label Name=Dev_Build_Warning
		tag="Dev_Build_Warning"
		posX=95
		posY=0
		posXEnd=NATIVE_WIDTH
		posYEnd=NATIVE_HEIGHT
		alignX=LEFT
		alignY=BOTTOM
		fontStyle=DEFAULT_SMALL_RED
		labelText="Dev Build"
	end object
	componentList.add(Dev_Build_Warning)
	
  // Fade effects
	begin object class=UI_Sprite Name=Title_Fade_Component
		tag="Title_Fade_Component"
		posX=0
		posY=0
		posXEnd=NATIVE_WIDTH
		posYEnd=NATIVE_HEIGHT
		images(0)=Black_Texture
	end object
	componentList.add(Title_Fade_Component)
  
  
  // Notification for Controller requirement
	begin object class=UI_Label Name=Controller_Notification_Label_Shadow
		tag="Controller_Notification_Label_Shadow"
    bEnabled=false
		posX=0
		posY=500
		posXEnd=NATIVE_WIDTH
		posYEnd=550
    padding=(top=1, left=13, right=11, bottom=7)
		fontStyle=DEFAULT_LARGE_ORANGE
		labelText="A controller is required for play"
    activeEffects.add((effectType=EFFECT_ALPHA_CYCLE, lifeTime=-1, elapsedTime=0, intervalTime=0.4, min=220, max=255))
		alignX=CENTER
		alignY=CENTER
	end object
	componentList.add(Controller_Notification_Label_Shadow)
  
  // Notification for Controller requirement
	begin object class=UI_Label Name=Controller_Notification_Label
		tag="Controller_Notification_Label"
    bEnabled=false
		posX=0
		posY=500
		posXEnd=NATIVE_WIDTH
		posYEnd=550
		fontStyle=DEFAULT_LARGE_ORANGE
		labelText="A controller is required for play"
    activeEffects.add((effectType=EFFECT_ALPHA_CYCLE, lifeTime=-1, elapsedTime=0, intervalTime=0.4, min=200, max=255))
    activeEffects.add((effectType=EFFECT_FLIPBOOK, lifeTime=-1, elapsedTime=0, intervalTime=0.10, min=0, max=255))
    cycleStyles=(DEFAULT_LARGE_GOLD, DEFAULT_LARGE_ORANGE)
		alignX=CENTER
		alignY=CENTER
	end object
	componentList.add(Controller_Notification_Label)
  
}


















