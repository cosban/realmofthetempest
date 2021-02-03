/*=============================================================================
 * ROTT_UI_Page_Party_Conscription
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: The conscription page is a window that displays the cost
 * of conscription, and allows the player to purchase a new party.
 *===========================================================================*/
 
class ROTT_UI_Page_Party_Conscription extends ROTT_UI_Page;

/**
var private UI_Label goldCost;
var private UI_Label gemCost;
var private UI_Label goldInventory;
var private UI_Label gemInventory;
**/

/*============================================================================= 
 * Initialize Component
 *
 * Description: This event is called as the UI is loaded.
 *              Our initial scene is drawn here.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  super.initializeComponent(newTag);
  
  ///goldCost = findLabel("Gold_Cost");
  ///gemCost = findLabel("Gem_Cost");
  ///goldInventory = findLabel("Gold_Inventory");
  ///gemInventory = findLabel("Gem_Inventory");
}

/*============================================================================= 
 * onPushPageEvent()
 *
 * This event is called every time the page is pushed.
 *===========================================================================*/
event onPushPageEvent() {
  refresh();
}

/*=============================================================================
 * refresh()
 *
 * Called to update the gold and gems
 *===========================================================================*/
public function refresh() {
  local int i;
  // Set Blessing price tag
  setCostValues(gameInfo.getConscriptionCost());
  
  // Refresh costs
  for (i = 0; i < componentList.length; i++) {
    if (ROTT_UI_Displayer_Cost(componentList[i]) != none) {
      ROTT_UI_Displayer_Cost(componentList[i]).refresh();
    }
  }
}

/*=============================================================================
 * Button controls
 *===========================================================================*/
protected function navigationRoutineA() {
  if (gameInfo.deductCosts(gameInfo.getConscriptionCost())) {
    // Purchase conscription, add party to profile
    ROTT_UI_Scene_Party_Manager(outer).conscription();
    parentScene.popPage();
    
    // Sfx
    gameInfo.sfxBox.playSfx(SFX_WORLD_DOOR);
    gameInfo.sfxBox.playSfx(SFX_WORLD_SHRINE);
  } else {
    // Sfx
    gameInfo.sfxBox.playSfx(SFX_MENU_INSUFFICIENT);
  }
}

protected function navigationRoutineB() {
  parentScene.popPage();
  
  // Sfx
  gameInfo.sfxBox.playSfx(SFX_MENU_BACK);
}

/*=============================================================================
 * D-Pad controls
 *===========================================================================*/
protected function navigateDown();
protected function navigateUp();
public function onNavigateLeft();
public function onNavigateRight();

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  // Culling
  cullTags.add("Party_Info_Container")
  
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
  begin object class=UI_Texture_Info Name=Party_Mgmt_Window
    componentTextures.add(Texture2D'GUI.Party_Mgmt_Window')
  end object
  
  // Button
  begin object class=UI_Texture_Info Name=Button_Add_Team
    componentTextures.add(Texture2D'GUI.Button_Add_Team')
  end object
  
  /** ===== UI Components ===== **/
  // Window
  begin object class=UI_Sprite Name=Conscription_Window
    tag="Conscription_Window"
    bEnabled=true
    posX=720
    posY=0
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    images(0)=Party_Mgmt_Window
  end object
  componentList.add(Conscription_Window)
  
  begin object class=UI_Sprite Name=Button_Conscription_Sprite
    tag="Button_Conscription_Sprite"
    bEnabled=true
    posX=852
    posY=624
    images(0)=Button_Add_Team
  end object
  componentList.add(Button_Conscription_Sprite)
  
  /** ===== Textures ===== **/
  // Mgmt Window - Title Label
  begin object class=UI_Label Name=Header_Label
    tag="Header_Label"
    posX=720
    posY=112
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    fontStyle=DEFAULT_LARGE_TAN
    AlignX=CENTER
    AlignY=TOP
    labelText="Conscription"
  end object
  componentList.add(Header_Label)
  
  // Gold Cost Displayer
  begin object class=ROTT_UI_Displayer_Cost Name=Gold_Cost
    tag="Gold_Cost"
    posX=720
    posY=180
    currencyType=class'ROTT_Inventory_Item_Gold'
    costDescriptionText="Gold cost:"
    costValue=100
  end object 
  componentList.add(Gold_Cost)
  
  // Gem Gost Displayer
  begin object class=ROTT_UI_Displayer_Cost Name=Gem_Cost
    tag="Gem_Cost"
    posX=720
    posY=322
    currencyType=class'ROTT_Inventory_Item_Gem'
    costDescriptionText="Gem cost:"
    costValue=100
  end object
  componentList.add(Gem_Cost)
  
  /**
  // Mgmt Window - Description Labels
  begin object class=UI_Label Name=Mgmt_Window_Label_1
    tag="Mgmt_Window_Label_1"
    posX=720
    posY=151
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    AlignX=CENTER
    AlignY=TOP
    labelText=""
  end object
  componentList.add(Mgmt_Window_Label_1)
  
  begin object class=UI_Label Name=Mgmt_Window_Label_2
    tag="Mgmt_Window_Label_2"
    posX=720
    posY=189
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    AlignX=CENTER
    AlignY=TOP
    labelText="Creates a new team of adventurers."
  end object
  componentList.add(Mgmt_Window_Label_2)
  
  begin object class=UI_Label Name=Mgmt_Window_Label_3
    tag="Mgmt_Window_Label_3"
    posX=720
    posY=216
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    AlignX=CENTER
    AlignY=TOP
    labelText="Other teams may be assigned passive"
  end object
  componentList.add(Mgmt_Window_Label_3)
  
  begin object class=UI_Label Name=Mgmt_Window_Label_4
    tag="Mgmt_Window_Label_4"
    posX=720
    posY=243
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    AlignX=CENTER
    AlignY=TOP
    labelText="activities to provide bonuses."
  end object
  componentList.add(Mgmt_Window_Label_4)
  
  // Gold cost
  begin object class=UI_Label Name=Gold_Cost_Label
    tag="Gold_Cost_Label"
    posX=973
    posY=358
    posXEnd=1163
    posYEnd=388
    fontStyle=DEFAULT_SMALL_TAN
    AlignX=CENTER
    AlignY=CENTER
    labelText="Gold cost"
  end object
  componentList.add(Gold_Cost_Label)
  
  begin object class=UI_Label Name=Gold_Inventory_Label
    tag="Gold_Inventory_Label"
    posX=1163
    posY=358
    posXEnd=1317
    posYEnd=388
    fontStyle=DEFAULT_SMALL_TAN
    AlignX=CENTER
    AlignY=CENTER
    labelText="You have"
  end object
  componentList.add(Gold_Inventory_Label)
  
  begin object class=UI_Label Name=Gold_Cost
    tag="Gold_Cost"
    posX=973
    posY=388
    posXEnd=1163
    posYEnd=418
    AlignX=CENTER
    AlignY=CENTER
    labelText="1520"
  end object
  componentList.add(Gold_Cost)
  
  begin object class=UI_Label Name=Gold_Inventory
    tag="Gold_Inventory"
    posX=1163
    posY=388
    posXEnd=1317
    posYEnd=418
    AlignX=CENTER
    AlignY=CENTER
    labelText="780"
  end object
  componentList.add(Gold_Inventory)
  
  // Gem cost labels
  begin object class=UI_Label Name=Gem_Cost_Label
    tag="Gem_Cost_Label"
    posX=973
    posY=483
    posXEnd=1163
    posYEnd=513
    fontStyle=DEFAULT_SMALL_TAN
    AlignX=CENTER
    AlignY=CENTER
    labelText="Gem cost"
  end object
  componentList.add(Gem_Cost_Label)
  
  begin object class=UI_Label Name=Gem_Inventory_Label
    tag="Gem_Inventory_Label"
    posX=1163
    posY=483
    posXEnd=1317
    posYEnd=513
    fontStyle=DEFAULT_SMALL_TAN
    AlignX=CENTER
    AlignY=CENTER
    labelText="You have"
  end object
  componentList.add(Gem_Inventory_Label)
  
  begin object class=UI_Label Name=Gem_Cost
    tag="Gem_Cost"
    posX=973
    posY=513
    posXEnd=1163
    posYEnd=543
    AlignX=CENTER
    AlignY=CENTER
    labelText="165"
  end object
  componentList.add(Gem_Cost)
  
  begin object class=UI_Label Name=Gem_Inventory
    tag="Gem_Inventory"
    posX=1163
    posY=513
    posXEnd=1317
    posYEnd=543
    AlignX=CENTER
    AlignY=CENTER
    labelText="1899"
  end object
  componentList.add(Gem_Inventory)
  **/
  // Mgmt Window Selection Box
  begin object class=UI_Selector Name=Selection_Box
    tag="Selection_Box"
    bEnabled=true
    posX=866
    posY=632
    selectionOffset=(x=0,y=80)
    numberOfMenuOptions=1
    
    // Selection texture
    begin object class=UI_Texture_Info Name=Selection_Box_Texture
      componentTextures.add(Texture2D'GUI.Mgmt_Window_Selector')
    end object

    // Selector sprite
    begin object class=UI_Sprite Name=Selector_Sprite
      tag="Selector_Sprite"
      images(0)=Selection_Box_Texture
      activeEffects.add((effectType = EFFECT_ALPHA_CYCLE, lifeTime = -1, elapsedTime = 0, intervalTime = 0.4, min = 170, max = 255))
    end object
    componentList.add(Selector_Sprite)
    
  end object
  componentList.add(Selection_Box)
}



















