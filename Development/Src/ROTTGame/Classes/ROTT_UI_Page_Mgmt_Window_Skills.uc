/*=============================================================================
 * ROTT_UI_Page_Mgmt_Window_Skills
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This management window allows player to allocate unspent stat 
 * points 
 *===========================================================================*/
 
class ROTT_UI_Page_Mgmt_Window_Skills extends ROTT_UI_Page_Mgmt_Window;

// Menu options
enum StatsMenuOptions {
  SKILL_INVEST_1,
  SKILL_EQUIP_PRIMARY,
  SKILL_EQUIP_SECONDARY
};

/*=============================================================================
 * Button controls
 *===========================================================================*/
protected function navigationRoutineA() {
  local ROTT_Combat_Hero hero;
  local byte selection;
  local byte tree;
  
  // Get player's selection info
  hero = parentScene.getSelectedHero();
  selection = sceneManager.getSelectedSkill();
  tree = sceneManager.getSelectedtree();

  // Execute player choice
  switch (selectionBox.getSelection()) {
    case SKILL_INVEST_1: investSkillPoint(hero, tree, selection);   break;
    case SKILL_EQUIP_PRIMARY: setPrimarySkill(hero, selection);     break;
    case SKILL_EQUIP_SECONDARY: setSecondarySkill(hero, selection); break;
  }
}

/*=============================================================================
 * Assets
 *===========================================================================*/
defaultProperties
{
  // Number of menu options
  selectOptionsCount=3
  
  /** ===== Input ===== **/
  begin object class=ROTT_Input_Handler Name=Input_A
    inputName="XBoxTypeS_A"
    buttonComponent=none
  end object
  inputList.add(Input_A)
  
  /** ===== Textures ===== **/
  // Passive Skill Management
  begin object class=UI_Texture_Info Name=Button_Invest_1
    componentTextures.add(Texture2D'GUI.Button_Invest_1')
  end object
  begin object class=UI_Texture_Info Name=Button_Set_Primary
    componentTextures.add(Texture2D'GUI.Button_Set_Primary')
  end object
  begin object class=UI_Texture_Info Name=Button_Set_Secondary
    componentTextures.add(Texture2D'GUI.Button_Set_Secondary')
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
  
  begin object class=UI_Sprite Name=Button_Set_Primary_Sprite
    tag="Button_Set_Primary_Sprite"
    posX=132
    posY=624
    images(0)=Button_Set_Primary
  end object
  componentList.add(Button_Set_Primary_Sprite)
  
  begin object class=UI_Sprite Name=Button_Set_Secondary_Sprite
    tag="Button_Set_Secondary_Sprite"
    posX=132
    posY=704
    images(0)=Button_Set_Secondary
  end object
  componentList.add(Button_Set_Secondary_Sprite)
  
}
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  