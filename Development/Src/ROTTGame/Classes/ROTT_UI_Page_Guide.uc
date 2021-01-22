/*=============================================================================
 * ROTT_UI_Page_Guide
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: 
 *
 *===========================================================================*/
 
class ROTT_UI_Page_Guide extends ROTT_UI_Page;

// Internal references
var private UI_Label header;

/*============================================================================= 
 * initializeComponent()
 *
 * Called once, when the scene is first initialized.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  super.initializeComponent(newTag);
  
  // Internal references
  header = UI_Label(findComp("Guide_Info_Labels"));
}

/*============================================================================= 
 * onPushPageEvent()
 *
 * This event is called every time the page is pushed.
 *===========================================================================*/
event onPushPageEvent() {
  // Render profile information
  refresh();
}

/*=============================================================================
 * onFocusMenu()
 *
 * Called when a menu is given focus.  Assign controls, and enable graphics.
 *===========================================================================*/
event onFocusMenu() {
  
}

/*============================================================================= 
 * refresh()
 *
 * This function should ensure that any data thats been changed will be 
 * correctly updated on the UI.
 *===========================================================================*/
public function refresh() {
  // Render profile information
  ///...
}

/*=============================================================================
 * D-Pad controls
 *===========================================================================*/
public function bool preNavigateUp();
public function bool preNavigateDown();

public function onNavigateLeft();
public function onNavigateRight();

/*=============================================================================
 * Button controls
 *===========================================================================*/
protected function navigationRoutineA() {
  
}

protected function navigationRoutineB() {
  // Sfx
  gameinfo.sfxBox.playSFX(SFX_MENU_BACK);
  
  // Pop this page
  parentScene.popPage();
}

 
/*=============================================================================
 * Assets
 *===========================================================================*/
defaultProperties
{
  bDrawRelative=true
  posX=0
  
  /** ===== Input ===== **/
	begin object class=ROTT_Input_Handler Name=Input_B
    inputName="XBoxTypeS_B"
    buttonComponent=none
	end object
  inputList.add(Input_B)
  
  /** ===== Textures ===== **/
  // Guide Background
	begin object class=UI_Texture_Info Name=Guide_Background
    componentTextures.add(Texture2D'GUI.Guide_Background')
  end object
  
  /** ===== UI Components ===== **/
  // Background
	begin object class=UI_Sprite Name=Background
		tag="Background"
		posX=0
		posY=0
		images(0)=Guide_Background
	end object
	componentList.add(Background)

  // Info
	begin object class=UI_Label Name=Guide_Info_Labels1
		tag="Guide_Info_Labels1"
		posX=60
		posY=201
    AlignX=Left
    AlignY=Top
		fontStyle=DEFAULT_SMALL_TAN
		labelText="Press LB to activate singing, resulting in \nmore elite monster encounters."
	end object
	componentList.add(Guide_Info_Labels1)
  
	begin object class=UI_Label Name=Guide_Info_Labels2
		tag="Guide_Info_Labels2"
		posX=60
		posY=301
    AlignX=Left
    AlignY=Top
		fontStyle=DEFAULT_SMALL_TAN
		labelText="Press RB to activate Prayer to encounter \nenemies less frequently."
	end object
	componentList.add(Guide_Info_Labels2)
  
	begin object class=UI_Label Name=Guide_Info_Labels3
		tag="Guide_Info_Labels3"
		posX=60
		posY=401
    AlignX=Left
    AlignY=Top
		fontStyle=DEFAULT_SMALL_TAN
		labelText="Press B to crouch to encounter enemies \nmore frequently."
	end object
	componentList.add(Guide_Info_Labels3)
  
  
	begin object class=UI_Label Name=Guide_Info_Labels4
		tag="Guide_Info_Labels4"
		posX=60
		posY=501
    AlignX=Left
    AlignY=Top
		fontStyle=DEFAULT_SMALL_TAN
		labelText="Press Y in combat to show / hide stats."
	end object
	componentList.add(Guide_Info_Labels4)
  
	begin object class=UI_Label Name=Guide_Info_Labels5
		tag="Guide_Info_Labels5"
		posX=60
		posY=601
    AlignX=Left
    AlignY=Top
		fontStyle=DEFAULT_SMALL_TAN
		labelText="Press LT to increase gamespeed with \ntemporal magic."
	end object
	componentList.add(Guide_Info_Labels5)
  
	begin object class=UI_Label Name=Guide_Info_Labels6
		tag="Guide_Info_Labels6"
		posX=60
		posY=701
    AlignX=Left
    AlignY=Top
		fontStyle=DEFAULT_SMALL_RED
		labelText="Quests are a work in progress.  Explore or \nspeedrun bosses for extra challenge."
	end object
	componentList.add(Guide_Info_Labels6)
  
  
}











