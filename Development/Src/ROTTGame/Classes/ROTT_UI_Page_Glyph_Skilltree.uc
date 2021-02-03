/*=============================================================================
 * ROTT_UI_Page_Glyph_Skilltree
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: 
 *===========================================================================*/
  
class ROTT_UI_Page_Glyph_Skilltree extends ROTT_UI_Page_Hero_Tree_Info;

// Internal references
var private ROTT_UI_Character_Sheet_Header header;
var private ROTT_UI_Tree_Highlights highlights;

/*=============================================================================
 * Initialize Component
 *
 * Description: This event is called as the UI is loaded.
 *              Our initial scene is drawn here.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  super.initializeComponent(newTag);
  
  // Internal references
  header = ROTT_UI_Character_Sheet_Header(findComp("Character_Sheet_Header"));
  skilltreeBackground = findSprite("Glyph_Skilltree_Background");
  skillSelectionBox = UI_Selector_2D(findComp("Glyph_Tree_Selection_Box"));
  highlights = ROTT_UI_Tree_Highlights(findComp("Skill_Highlights"));
}

/*=============================================================================
 * D-Pad controls
 *===========================================================================*/
public function onNavigateLeft() {
  super.onNavigateLeft();
  
  switch (controlState) {
    case VIEW_MODE:
    case RESET_VIEW_MODE:
      // Change view to class skill tree
      someScene.switchPage(CLASS_SKILLTREE);
      break;
  }
}

public function onNavigateRight() {
  super.onNavigateRight();
  
  switch (controlState) {
    case VIEW_MODE:
    case RESET_VIEW_MODE:
      // Change view to master tree
      someScene.switchPage(MASTERY_SKILLTREE);
      break;
  }
}

/*============================================================================= 
 * renderHeroData()
 *
 * Given a hero, this displays all of its information to the screen
 *===========================================================================*/
protected function renderHeroData(ROTT_Combat_Hero hero) {
  // Header
  header.setDisplayInfo
  (
    pCase(hero.myClass),
    "Glyph skills",
    "",
    (hero.unspentSkillPoints != 0) ? "Skill Points" : "",
    (hero.unspentSkillPoints != 0) ? string(hero.unspentSkillPoints) : ""
  );
  
  // Draw highlights
  highlights.setGlyphHighlights(hero);
}

/*=============================================================================
 * Assets
 *===========================================================================*/
defaultProperties
{
  /** ===== Textures ===== **/
  // Glyph Skill Tree Background
  begin object class=UI_Texture_Info Name=Class_Skilltree_Background_Texture
    componentTextures.add(Texture2D'GUI.Glyph_Skill_Tree')
  end object
  
  // Skill Selection Box
  begin object class=UI_Texture_Info Name=Skill_Selection_Box
    componentTextures.add(Texture2D'GUI.Skill_Selection_Box')
  end object
  begin object class=UI_Texture_Info Name=Skill_Selection_Box_Red
    componentTextures.add(Texture2D'GUI.Skill_Selection_Box_Red')
  end object
  
  /** ===== UI Components ===== **/
  // Glyph Skilltree background
  begin object class=UI_Sprite Name=Glyph_Skilltree_Background
    tag="Glyph_Skilltree_Background"
    bEnabled=false
    posX=720
    posY=0
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    images(0)=Class_Skilltree_Background_Texture
  end object
  componentList.add(Glyph_Skilltree_Background)
  
  // Header
  begin object class=ROTT_UI_Character_Sheet_Header Name=Character_Sheet_Header
    tag="Character_Sheet_Header"
  end object
  componentList.add(Character_Sheet_Header)
  
  // Skill Highlights
  begin object class=ROTT_UI_Tree_Highlights Name=Skill_Highlights
    tag="Skill_Highlights"
  end object
  componentList.add(Skill_Highlights)
  
  // Class Tree Selector
  begin object class=UI_Selector_2D Name=Glyph_Tree_Selection_Box
    tag="Glyph_Tree_Selection_Box"
    bEnabled=false
    posX=803
    posY=171
    selectOffset=(x=216,y=216)  // Distance from neighboring spaces
    homeCoords=(x=1,y=0)        // The default space for the selector to start
    gridSize=(x=3,y=3)          // Total size of 2d selection space
    
    // Visual offsets
    renderOffsets(0)=(xCoord=1,yCoord=0,xOffset=0,yOffset=-108)
    renderOffsets(1)=(xCoord=1,yCoord=1,xOffset=0,yOffset=108)
    renderOffsets(2)=(xCoord=1,yCoord=2,xOffset=0,yOffset=-108)
    
    // Navigation skips
    navSkips(3)=(xCoord=1,yCoord=2,skipDirection=NAV_UP)
    
    // Draw Textures
    images(0)=Skill_Selection_Box
    images(1)=Skill_Selection_Box_Red
    
    // Alpha Effects
    activeEffects.add((effectType = EFFECT_ALPHA_CYCLE, lifeTime = -1, elapsedTime = 0, intervalTime = 0.4, min = 170, max = 255))
  end object
  componentList.add(Glyph_Tree_Selection_Box)
  
}










