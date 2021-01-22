/*=============================================================================
 * ROTT_UI_Page_Stats_Inspection
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: Stats inspection displays primary stats, and substats, for a
 * hero selected from the party selection UI.
 *
 * (see: ROTT_UI_Page_Party_Selection.uc)
 * (see: ROTT_Combat_Hero.uc)
 *===========================================================================*/
 
class ROTT_UI_Page_Stats_Inspection extends ROTT_UI_Page_Hero_Info;

// Enchantment icon macros
`DEFINE ENCHANT_ICON(X, Y, N) \
  begin object class=UI_Sprite Name=Enchant_Boost_Icon_`N                                                             \n \
    tag="Enchant_Boost_Icon_`N"                                                                                       \n \
    posX=`X                                                                                                           \n \
    posY=`Y                                                                                                           \n \
    images(0)=Enchantment_Boost_Icon_1                                                                              \n \
  end object                                                                                                          \n \
  componentList.add(Enchant_Boost_Icon_`N)                                                                            \n \
  begin object class=UI_Sprite Name=Enchant_Boost_Upper_Icon_`N                                                       \n \
    tag="Enchant_Boost_Upper_Icon_`N"                                                                                 \n \
    posX=`X                                                                                                           \n \
    posY=`Y                                                                                                           \n \
    images(0)=Enchantment_Boost_Icon_2                                                                              \n \
    activeEffects.add((effectType=EFFECT_ALPHA_CYCLE, lifeTime=-1, elapsedTime=0, intervalTime=0.8, min=31, max=255)) \n \
  end object                                                                                                          \n \
  componentList.add(Enchant_Boost_Upper_Icon_`N)                                                                      \n \

`DEFINE ENCHANT_CHEV_ICON(X, Y, N) \
  begin object class=UI_Sprite Name=Enchant_Boost_Icon_`N                                                              \n \
    tag="Enchant_Boost_Icon_`N"                                                                                        \n \
    posX=`X                                                                                                            \n \
    posY=`Y                                                                                                            \n \
    images(0)=Enchantment_Chevron_Icon_1                                                                             \n \
  end object                                                                                                           \n \
  componentList.add(Enchant_Boost_Icon_`N)                                                                             \n \
  begin object class=UI_Sprite Name=Enchant_Boost_Upper_Icon_`N                                                        \n \
    tag="Enchant_Boost_Upper_Icon_`N"                                                                                  \n \
    posX=`X                                                                                                            \n \
    posY=`Y                                                                                                            \n \
    images(0)=Enchantment_Chevron_Icon_2                                                                             \n \
    activeEffects.add((effectType=EFFECT_ALPHA_CYCLE, lifeTime=-1, elapsedTime=0, intervalTime=0.8, min=31, max=255))  \n \
  end object                                                                                                           \n \
  componentList.add(Enchant_Boost_Upper_Icon_`N)                                                                       \n \

// Internal references
var private ROTT_UI_Character_Sheet_Header header;
var private UI_Sprite statsPageBackground;
var private UI_Sprite statsBoxes;
var private ROTT_UI_Stats_Selector statsSelector;
var private ROTT_UI_Statistic_Labels statisticLabels;
var private ROTT_UI_Statistic_Values statisticValues;
var private ROTT_UI_Displayer_Experience expInfo;

/*============================================================================= 
 * initializeComponent()
 *
 * Called once, when the scene is first initialized.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  super.initializeComponent(newTag);
  
  // Internal references
  header = ROTT_UI_Character_Sheet_Header(findComp("Character_Sheet_Header"));
  statsPageBackground = findSprite("Stats_Page_Background");
  statsBoxes = findSprite("Stats_Border_Boxes");
  statsSelector = ROTT_UI_Stats_Selector(findComp("Stats_Selector"));
  
  statisticLabels = ROTT_UI_Statistic_Labels(findComp("Statistic_Labels"));
  statisticValues = ROTT_UI_Statistic_Values(findComp("Statistic_Values"));
  expInfo = ROTT_UI_Displayer_Experience(findComp("Experience_Bar_UI"));
  
  // Initial control state
  controlState = VIEW_MODE;
}

/*============================================================================= 
 * onPushPageEvent()
 *
 * This event is called every time the page is pushed.
 *===========================================================================*/
event onPushPageEvent() {
  // Render selected hero
  refresh();
  
  // Determine stat operations based on what kind of service or utility is up
  if (parentScene.pageTagIsUp("Reinvest_Stat_UI")) {
    // Selector graphics
    statsSelector.setSelectorType(SELECTOR_UNINVEST_BOX);
    statsSelector.setEnabled(true);
    
    // Enable reset stat operations
    controlState = RESET_SELECTION_MODE;
    return;
  } 
  
  // Determine stat operations based on what kind of service or utility is up
  if (parentScene.pageTagIsUp("Service_Info_Blessings")) {
    // Selector graphics
    statsSelector.setSelectorType(SELECTOR_BLESSING_BOX);
    statsSelector.setEnabled(true);
    
    // Enable blessing operations
    controlState = BLESS_SELECTION_MODE;
    return;
  }
  
  // Default stat selection mode
  statsSelector.setSelectorType(SELECTOR_DEFAULT_BOX);
}

/*=============================================================================
 * onFocusMenu()
 *
 * Called when a menu is given focus.  Assign controls, and enable graphics.
 *===========================================================================*/
event onFocusMenu() {
  super.onFocusMenu();
  
  // Change display based on control state
  switch (controlState) {
    case VIEW_MODE: 
      if (someScene != none) someScene.enablePageArrows(true);
      break;
  }
  
  // Determine stat operations based on what kind of service or utility is up
  if (parentScene.pageTagIsUp("Reinvest_Stat_UI")) {
    // Selector graphics
    statsSelector.setSelectorType(SELECTOR_UNINVEST_BOX);
    return;
  } 
  
  // Determine stat operations based on what kind of service or utility is up
  if (parentScene.pageTagIsUp("Service_Info_Blessings")) {
    // Selector graphics
    statsSelector.setSelectorType(SELECTOR_BLESSING_BOX);
    return;
  }
  
  // Default stat selection mode
  statsSelector.setSelectorType(SELECTOR_DEFAULT_BOX);
}

/*============================================================================= 
 * refresh()
 *
 * This function should ensure that any data thats been changed will be 
 * correctly updated on the UI.
 *===========================================================================*/
public function refresh() {
  renderHeroData(parentScene.getSelectedHero());
}

/*=============================================================================
 * getSelectedStat()
 *
 * Returns an index for which stat the player has selected
 *===========================================================================*/
public function byte getSelectedStat() {
  return statsSelector.getSelection();
}

/*============================================================================= 
 * renderHeroData()
 *
 * Given a hero, this displays all of its information to the screen
 *===========================================================================*/
private function renderHeroData(ROTT_Combat_Hero hero) {
  local UI_Container enchantIcon;
  local int i;
  
  // Header
  header.setDisplayInfo
  (  
    pCase(hero.myClass), 
    "Level " $ hero.level,
    (hero.blessingCount > 0) ? "Blessings: " $ hero.blessingCount : "",
    (hero.unspentStatPoints != 0) ? "Stat Points" : "",
    (hero.unspentStatPoints != 0) ? string(hero.unspentStatPoints) : ""
  );
  
  // Stats
  statisticValues.renderHeroData(hero);
  expInfo.attachDisplayer(hero);
  
  // Icon boosts
  for (i = 0; i < class'ROTT_Descriptor_Enchantment_List'.static.countEnchantmentEnum(); i++) {
    enchantIcon = UI_Container(findComp("Enchant_Icons_" $ string(GetEnum(enum'EnchantmentEnum', i))));
    // Show or hide each enchantment boost
    if (enchantIcon != none) {
      if (gameInfo.playerProfile.enchantmentLevels[i] > 0) {
        enchantIcon.setEnabled(true);
      } else {
        enchantIcon.setEnabled(false);
      }
    }
  }
}

/*============================================================================= 
 * renderStatData()
 *
 * This passes a stat descriptor to the mgmt window
 *===========================================================================*/
private function renderStatData() {
  local ROTT_Combat_Hero hero;
  local ROTT_Descriptor descriptor;
  
  hero = parentScene.getSelectedHero();
  
  // Fetch stat descriptor
  descriptor = hero.statDescriptors.getScript(
    statsSelector.getSelection(),
    hero
  );
  
  someScene.setMgmtDescriptor(descriptor);
}

/*=============================================================================
 * D-Pad controls
 *===========================================================================*/
public function bool preNavigateUp() {
  switch (controlState) {
    case SELECTION_MODE:
      if (statsSelector.selectPrevious()) { 
        renderStatData();
        return true;
      }
      break;
    case RESET_SELECTION_MODE:
    case BLESS_SELECTION_MODE:
      if (statsSelector.selectPrevious()) { 
        return true;
      }
      break;
  }
  return false;
}

public function bool preNavigateDown() {
  switch (controlState) {
    case SELECTION_MODE:
      if (statsSelector.selectNext()) { 
        renderStatData();
        return true;
      }
      break;
    case RESET_SELECTION_MODE:
    case BLESS_SELECTION_MODE:
      if (statsSelector.selectNext()) { 
        return true;
      }
      break;
  }
  return false;
}

public function onNavigateLeft() {
  switch (controlState) {
    case VIEW_MODE:
      // Change view to master tree
      someScene.switchPage(MASTERY_SKILLTREE);
      break;
  }
}

public function onNavigateRight() {
  switch (controlState) {
    case VIEW_MODE:
      // Change view to class tree
      someScene.switchPage(CLASS_SKILLTREE);
      break;
  }
}

/*=============================================================================
 * Button controls
 *===========================================================================*/
protected function navigationRoutineA() {
  switch (controlState) {
    case VIEW_MODE:
      // Switch from page selection, to stat inspection
      controlState = SELECTION_MODE;
      someScene.enablePageArrows(false);
      statsSelector.setEnabled(true);
      someScene.pushMenu(MGMT_WINDOW_STATS);
      renderStatData();
      
      // Sfx
      gameinfo.sfxBox.playSFX(SFX_MENU_ACCEPT);
      break;
    case SELECTION_MODE:
      // Give to control to management window
      statsSelector.setSelectorType(SELECTOR_DEFAULT_ARROW);
      parentScene.focusTop();
      
      // Sfx
      gameinfo.sfxBox.playSFX(SFX_MENU_ACCEPT);
      break;
    case RESET_SELECTION_MODE:
      // Focus reset manager
      parentScene.pushPageByTag("Reset_Stat_Manager_UI"); 
      statsSelector.setSelectorType(SELECTOR_DEFAULT_ARROW);
      
      // Sfx
      gameinfo.sfxBox.playSFX(SFX_MENU_ACCEPT);
      break;
    case BLESS_SELECTION_MODE:
      // Focus blessing manager
      parentScene.pushPageByTag("Blessing_Management_UI"); 
      statsSelector.setSelectorType(SELECTOR_DEFAULT_ARROW);
      
      // Sfx
      gameinfo.sfxBox.playSFX(SFX_MENU_ACCEPT);
      break;
  }
}

protected function navigationRoutineB() {
  switch (controlState) {
    case VIEW_MODE:
      // Close menu
      parentScene.popPage();
      break;
    case SELECTION_MODE:
      // Change to view mode
      controlState = VIEW_MODE;
      
      // Remove Selection box
      statsSelector.setEnabled(false);
      
      // Close the mgmt window
      parentScene.popPage();
      break;
    case RESET_SELECTION_MODE:
      // Return to party selection
      statsSelector.setEnabled(false);
      parentScene.popPage();
      controlState = VIEW_MODE;
      break;
    case BLESS_SELECTION_MODE:
      // Return to party selection
      statsSelector.setEnabled(false);
      parentScene.popPage();
      break;
  }
  // Sfx
  gameinfo.sfxBox.playSFX(SFX_MENU_BACK);
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
  // Stats Background
	begin object class=UI_Texture_Info Name=Menu_Background_Stats
    componentTextures.add(Texture2D'GUI.Menu_Background_Stats')
  end object
  
  // Stat boxes background
  begin object class=UI_Texture_Info Name=Stat_Boxes_Background
    componentTextures.add(Texture2D'GUI.Stats_MainStat_Boxes')
  end object
  
  /** ===== UI Components ===== **/
  // Stats Page Background
	begin object class=UI_Sprite Name=Stats_Page_Background
		tag="Stats_Page_Background"
		posX=720
		posY=0
		posXEnd=NATIVE_WIDTH
		posYEnd=NATIVE_HEIGHT
		images(0)=Menu_Background_Stats
	end object
	componentList.add(Stats_Page_Background)

  // Header
	begin object class=ROTT_UI_Character_Sheet_Header Name=Character_Sheet_Header
		tag="Character_Sheet_Header"
	end object
	componentList.add(Character_Sheet_Header)
	
	// Stat Selection Boxes
	begin object class=UI_Sprite Name=Stats_Border_Boxes
		tag="Stats_Border_Boxes"
		posX=757
		posY=194
		images(0)=Stat_Boxes_Background
	end object
	componentList.add(Stats_Border_Boxes)
  
  // Stats Selection Component
  begin object class=ROTT_UI_Stats_Selector Name=Stats_Selector
    tag="Stats_Selector"
    posX=757
    posY=194
  end object
  componentList.add(Stats_Selector)
  
  // Statistic Labels
  begin object class=ROTT_UI_Statistic_Labels Name=Statistic_Labels
    tag="Statistic_Labels"
    posX=759
    posY=0
		posXEnd=1344
		posYEnd=765
  end object
  componentList.add(Statistic_Labels)
  
  // Statistic Values
  begin object class=ROTT_UI_Statistic_Values Name=Statistic_Values
    tag="Statistic_Values"
    posX=0
    posY=0
		posXEnd=1397
		posYEnd=NATIVE_HEIGHT
  end object
  componentList.add(Statistic_Values)
  
  // Experience Bar
	begin object class=ROTT_UI_Displayer_Experience Name=Experience_Bar_UI
		tag="Experience_Bar_UI"
		posX=720
		posY=737
		posXEnd=NATIVE_WIDTH
		posYEnd=NATIVE_HEIGHT
	end object
	componentList.add(Experience_Bar_UI)
  
  /** ===================================================================== **/
  
  // Enchantment boost icons
  begin object class=UI_Texture_Info Name=Enchantment_Boost_Icon_1
    componentTextures.add(Texture2D'GUI.Enchantment_Boost_Icon_1')
  end object
  begin object class=UI_Texture_Info Name=Enchantment_Boost_Icon_2
    componentTextures.add(Texture2D'GUI.Enchantment_Boost_Icon_2')
  end object
  begin object class=UI_Texture_Info Name=Enchantment_Chevron_Icon_1
    componentTextures.add(Texture2D'GUI.Enchantment_Chevron_Icon_1')
  end object
  begin object class=UI_Texture_Info Name=Enchantment_Chevron_Icon_2
    componentTextures.add(Texture2D'GUI.Enchantment_Chevron_Icon_2')
  end object
  
  // Infinity jewel enchantment
  begin object class=UI_Container Name=Enchant_Icons_INIFINITY_JEWEL  
    tag="Enchant_Icons_INIFINITY_JEWEL"        
    `ENCHANT_ICON(888, 208, 1) 
    `ENCHANT_ICON(901, 268, 2) 
    `ENCHANT_ICON(893, 352, 3) 
    `ENCHANT_ICON(850, 582, 4)                      
  end object                                             
  componentList.add(Enchant_Icons_INIFINITY_JEWEL)                    
  
  // Arcane Bloodprism enchantment
  begin object class=UI_Container Name=Enchant_Icons_ARCANE_BLOODPRISM
    tag="Enchant_Icons_ARCANE_BLOODPRISM"        
    `ENCHANT_ICON(1131, 208, 5)
  end object                                             
  componentList.add(Enchant_Icons_ARCANE_BLOODPRISM)                    
  
  // Rosewood Pendant enchantment
  begin object class=UI_Container Name=Enchant_Icons_ROSEWOOD_PENDANT
    tag="Enchant_Icons_ROSEWOOD_PENDANT"        
    `ENCHANT_CHEV_ICON(1157, 208, 6)
  end object                                             
  componentList.add(Enchant_Icons_ROSEWOOD_PENDANT)                    
  
  // Scorpion Talon enchantment
  begin object class=UI_Container Name=Enchant_Icons_SCORPION_TALON
    tag="Enchant_Icons_SCORPION_TALON"   
    `ENCHANT_ICON(1148, 268, 7) 
  end object                                             
  componentList.add(Enchant_Icons_SCORPION_TALON)                    
  
  // Griffins Trinket enchantment
  begin object class=UI_Container Name=Enchant_Icons_GRIFFINS_TRINKET
    tag="Enchant_Icons_GRIFFINS_TRINKET"   
    `ENCHANT_ICON(1170, 526, 8)  
    `ENCHANT_ICON(1123, 639, 9)  
  end object                                             
  componentList.add(Enchant_Icons_GRIFFINS_TRINKET)                    
  
  // Mystic Marble enchantment
  begin object class=UI_Container Name=Enchant_Icons_MYSTIC_MARBLE
    tag="Enchant_Icons_MYSTIC_MARBLE"   
    `ENCHANT_ICON(1114, 582, 10)
  end object                                             
  componentList.add(Enchant_Icons_MYSTIC_MARBLE)                    
  
  // Mystic Marble enchantment
  begin object class=UI_Container Name=Enchant_Icons_ETERNAL_SPELLSTONE
    tag="Enchant_Icons_ETERNAL_SPELLSTONE"   
    `ENCHANT_CHEV_ICON(1140, 582, 11)
  end object                                             
  componentList.add(Enchant_Icons_ETERNAL_SPELLSTONE)                    
  
  
  
  ///`ENCHANT_ICON(1258, 352, 8)          // GRIFFINS_TRINKET
  
}











