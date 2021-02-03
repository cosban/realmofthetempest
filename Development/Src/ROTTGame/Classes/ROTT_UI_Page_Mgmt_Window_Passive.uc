/*=============================================================================
 * ROTT_UI_Page_Mgmt_Window_Passive
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This is the interface for skill management on a passive skill.
 *===========================================================================*/
 
class ROTT_UI_Page_Mgmt_Window_Passive extends ROTT_UI_Page_Mgmt_Window;

/*=============================================================================
 * D-Pad controls
 *===========================================================================*/
protected function navigateUp();
protected function navigateDown();
public function onNavigateLeft();
public function onNavigateRight();

/*=============================================================================
 * Button controls
 *===========================================================================*/
protected function navigationRoutineA() {
  local ROTT_Combat_Hero hero;
  local byte selection;
  local byte tree;
  
  // Get player's selection info
  hero = parentScene.getSelectedHero();
  selection = someScene.getSelectedSkill();
  tree = someScene.getSelectedtree(); 
  
  // Execute player choice
  switch (selectionBox.getSelection()) {
    case SKILL_INVEST_1: investSkillPoint(hero, tree, selection); break;
  }
}

/*=============================================================================
 * Assets
 *===========================================================================*/
defaultProperties
{
  // Number of menu options
  selectOptionsCount=1
  
  /** ===== Input ===== **/
  begin object class=ROTT_Input_Handler Name=Input_A
    inputName="XBoxTypeS_A"
    buttonComponent=none
  end object
  inputList.add(Input_A)
  
  /** ===== Textures ===== **/
  // Buttons
  begin object class=UI_Texture_Info Name=Button_Invest_1
    componentTextures.add(Texture2D'GUI.Button_Invest_1')
  end object
  begin object class=UI_Texture_Info Name=Info_Button_Passive
    componentTextures.add(Texture2D'GUI.Info_Button_Passive')
  end object
  
  /** ===== UI Components ===== **/
  // Buttons
  begin object class=UI_Sprite Name=Button_Invest_1_Sprite
    tag="Button_Invest_1_Sprite"
    posX=132
    posY=544
    images(0)=Button_Invest_1
  end object
  componentList.add(Button_Invest_1_Sprite)
  
  // Info button - Passive
  begin object class=UI_Sprite Name=Info_Button_Sprite
    tag="Info_Button_Sprite"
    posX=132
    posY=624
    images(0)=Info_Button_Passive
  end object
  componentList.add(Info_Button_Sprite)
}
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  