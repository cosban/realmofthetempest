/*=============================================================================
 * ROTT_UI_Displayer_Combat_Enemy
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This displays an enemies visual information.
 * (See: ROTT_Combat_Enemy.uc)
 *===========================================================================*/

class ROTT_UI_Displayer_Combat_Enemy extends ROTT_UI_Displayer_Combat;



/// this whole thing could be cleaned up quite a bit, possibly by batching together the enemy / champ components into their own displayers



const NO_RESIZE = true;

// Internal references 
var privatewrite UI_Sprite uiBackground;
var privatewrite UI_Sprite uiFrame;

var privatewrite UI_Sprite tunaBar;
var privatewrite UI_Sprite hpBar;
var privatewrite UI_Sprite demoralizationMark;
var privatewrite UI_Sprite portrait;
var privatewrite UI_Sprite skillAnimation;
var privatewrite UI_Label monsterLabel;

var privatewrite ROTT_UI_Status_Label statusLabel;

// Animation settings
var private ROTTTimer animationTimer;
var private UI_Texture_Storage spriteSheet;
var private int animatorIndex;

/*============================================================================= 
 * initializeComponent()
 *
 * This is called as the UI is loaded.  Our initial scene is drawn here.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  super.initializeComponent(newTag);
}

/*=============================================================================
 * validAttachment()
 *
 * Called to check if the displayer attachment is valid. Returns true if it is.
 *===========================================================================*/
protected function bool validAttachment() {
  // This displayer requires an enemy attachment
  return (enemy != none);
}

/*=============================================================================
 * attachmentUpdate()
 *
 * Called when a new object is attached
 *===========================================================================*/
protected function attachmentUpdate() {
  local int i;
  
  // Clear all visibility
  for (i = 0; i < componentList.length; i++) {
    if (UI_Label_Combat(componentList[i]) == none) componentList[i].setEnabled(false);
  }
  
  // Skip if no enemy is attached
  if (enemy == none) return;
  
  // Set new sprite
  
  // Set references based on enemy elite status
  if (enemy.bLargeDisplay) {
    uiBackground = findSprite("Elite_UI_Back_Sprite");
    uiFrame = findSprite("Elite_UI_Frame_Sprite");
    portrait = findSprite("Enemy_Portrait");
    
    hpBar = findSprite("Elite_UI_HP_Bar_Sprite");
    tunaBar = findSprite("Elite_UI_TUNA_Bar_Sprite");
    skillAnimation = findSprite("Elite_Skill_Animation");
    monsterLabel = findLabel("Elite_Name_Label");
    statusLabel = ROTT_UI_Status_Label(findComp("Elite_Status_Label"));
  } else {
    uiBackground = findSprite("Enemy_UI_Back_Sprite"); 
    uiFrame = findSprite("Enemy_UI_Frame_Sprite");
    portrait = findSprite("Elite_Portrait");
    
    hpBar = findSprite("Enemy_UI_HP_Bar_Sprite");
    tunaBar = findSprite("Enemy_UI_TUNA_Bar_Sprite");
    skillAnimation = findSprite("Skill_Animation");
    monsterLabel = findLabel("Enemy_Name_Label");
    statusLabel = ROTT_UI_Status_Label(findComp("Enemy_Status_Label"));
  }
  
  // Enemy portrait
  portrait.modifyTexture(enemy.getPortrait()); 
  
  // Demoralization marker
  demoralizationMark = findSprite("Enemy_Demoralization_Marker");
  
  // Show unit info
  updateDisplay();
  showDetail(gameInfo.optionsCookie.showCombatDetail);
}

/*=============================================================================
 * showDetail()
 *
 * This is called to hide or show extra information about the unit.
 *===========================================================================*/
public function showDetail(bool bShow) {
  local string detailText;
  
  // Threshold marker
  demoralizationMark.setEnabled(bShow);
  statusLabel.setEnabled(bShow);
  
  // Text
  if (bShow) {
    detailText = "Lvl " $ enemy.level $ ". " $ enemy.monsterName;
  } else {
    detailText = "";
  }
  
  monsterLabel.setText(detailText);
}

/*=============================================================================
 * updateDisplay()
 *
 * This updates the UI with the info of the attached combat unit.  
 * Returns true when there actually exists a unit to display, false otherwise.
 *===========================================================================*/
public function bool updateDisplay() {
  // Check if parent displayer fails
  if (!super.updateDisplay()) return false;
  
  // Handle visibility
  uiBackground.setEnabled(enemy != none);
  uiFrame.setEnabled(enemy != none);
  
  hpBar.setEnabled(enemy != none);
  tunaBar.setEnabled(enemy != none);
  portrait.setEnabled(enemy != none);
  skillAnimation.setEnabled(enemy != none);
  monsterLabel.setEnabled(enemy != none);
  statusLabel.setEnabled(enemy != none);

  // Draw bar lengths
  hpBar.setHorizontalMask(enemy.getHealthRatio());
  tunaBar.setHorizontalMask(enemy.getTunaRatio());
  
  // Move demoralization mark
  if (enemy.bLargeDisplay) {
    demoralizationMark.updatePosition(
      getX() - 190 + 577 * enemy.getMoraleRatio(),
      getY() - 73
    );
  } else {
    demoralizationMark.updatePosition(
      getX() + 3 + 188 * enemy.getMoraleRatio(),
      getY() - 5
    );
  }
  
  // Successfully drew hero information
  return true;
}

/*=============================================================================
 * elapseTimer()
 *
 * Time is passed to non-actors through the scene that contains them
 *===========================================================================*/
public function elapseTimer(float deltaTime, float gameSpeedOverride) {
  // The parent will erase temporary combat labels over time
  super.elapseTimer(deltaTime, gameSpeedOverride);
}

/*=============================================================================
 * addStatus()
 *
 * Called to add a status to be displayed in by this label
 *===========================================================================*/
public function addStatus(ROTT_Descriptor_Hero_Skill skillInfo) {
  statusLabel.addStatus(skillInfo);
}

/*=============================================================================
 * removeStatus()
 *
 * Called to remove a status from being displayed by this label
 *===========================================================================*/
public function removeStatus(ROTT_Descriptor_Hero_Skill skillInfo) {
  statusLabel.removeStatus(skillInfo);
}

/*=============================================================================
 * debuffEffect()
 *
 * This is called when a unit recieves a debuff
 *===========================================================================*/
public function debuffEffect() {
  portrait.addAlphaEffect(0.7, 0.35);
}

/*=============================================================================
 * takeDamageEffect()
 *
 * This is called when a unit takes damage
 *===========================================================================*/
public function takeDamageEffect() {
  portrait.addFlickerEffect(0.7, 0.150);
}

/*=============================================================================
 * showSkillEffects()
 *
 * Given a "sprite sheet" this will animate a skill animation
 *===========================================================================*/
public function showSkillEffects(UI_Texture_Storage sprites) {
  // Allocate sprite reference
  spriteSheet = sprites;
  
  // Remove timer (temporary hack)
  animatorIndex = 0;
  if (animationTimer != none) animationTimer.destroy();
  
  // Create animation timer
  animationTimer = gameInfo.spawn(class'ROTTTimer');
  animationTimer.makeTimer(0.05, LOOP_ON, nextSkillFrame);
  
}

/*=============================================================================
 * onDeath()
 *
 * This is called when the unit's life hits zero
 *===========================================================================*/
public function onDeath() {
  // Extended flicker effect (usually 0.7 sec)
  portrait.addFlickerEffect(1.0, 0.150);
  
  // Quickly clear out the queues
  bClearQueues = true;
}

/*=============================================================================
 * unitDestroyed()
 * 
 * When the unit becomes 'none' this event is called.  Damage labels may still
 * persist.
 *===========================================================================*/
public function unitDestroyed() {
  // Delete skill animation timer
  if (animationTimer != none) animationTimer.destroy();
  
  // Clear effects
  skillAnimation.clearSprite();
  portrait.clearEffects();
  
  // Reset
  statusLabel.reset();
}

/*=============================================================================
 * onAnalysisComplete()
 * 
 * This function is called after a battle is done, and after battle analysis
 * is finished.
 *===========================================================================*/
public function onAnalysisComplete() {
  statusLabel.reset(); /// probably dont need this
}

/*=============================================================================
 * showDamage()
 *
 * Called when the unit takes damage
 *===========================================================================*/
public function showDamage(int damage, bool bCrit) {
  makeLabel(
    "-" $ damage, 
    FONT_LARGE, 
    (bCrit) ? COLOR_GOLD : COLOR_GRAY, 
    LABEL_TYPE_DAMAGE
  );
}

/*=============================================================================
 * onResisted()
 *
 * Called when the displayed unit has resisted an effect
 *===========================================================================*/
public function onResisted() {
  makeLabel(
    "resisted", 
    FONT_MEDIUM_ITALICS, 
    COLOR_GRAY, 
    LABEL_TYPE_RESIST
  );
}

/*=============================================================================
 * onMissed()
 *
 * Called when an attack misses the displayed unit
 *===========================================================================*/
public function onMissed() {
  makeLabel(
    "missed", 
    FONT_MEDIUM_ITALICS, 
    COLOR_GRAY, 
    LABEL_TYPE_RESIST
  ); 
}

/*=============================================================================
 * onStatDiminished()
 *
 * Called when a stat is diminished for the displayed unit
 *===========================================================================*/
public function onStatDiminished(float value, MechanicTypes targetStat) {
  local ColorStyles msgColor;
  local string msg;
  
  // Set UI message
  switch (targetStat) {
    case REDUCE_STRENGTH:  msg = "-" $ int(value) $ " strength";     break;
    case REDUCE_COURAGE:   msg = "-" $ int(value) $ " courage";      break;
    case REDUCE_FOCUS:     msg = "-" $ int(value) $ " focus";        break;
    case REDUCE_SPEED:     msg = "-" $ int(value) $ " speed";        break;
    case REDUCE_ACCURACY:  msg = "-" $ int(value) $ " accuracy";     break;
    case REDUCE_DODGE:     msg = "-" $ int(value) $ " dodge";        break;
    case REDUCE_ARMOR:     msg = "-" $ int(value) $ " armor";        break;
    case ADD_HEALTH_DRAIN: msg = "-" $ int(value) $ " health / s";   break;
  }
  
  // Set UI color
  switch (targetStat) {
    case REDUCE_STRENGTH:  msgColor = COLOR_ORANGE;  break;
    case REDUCE_COURAGE:   msgColor = COLOR_GOLD;    break;
    case REDUCE_FOCUS:     msgColor = COLOR_BLUE;    break;
    case REDUCE_SPEED:     msgColor = COLOR_YELLOW;  break;
    case REDUCE_ACCURACY:  msgColor = COLOR_GREEN;   break;
    case REDUCE_DODGE:     msgColor = COLOR_PURPLE;  break;
    case REDUCE_ARMOR:     msgColor = COLOR_TAN;     break;
    case ADD_HEALTH_DRAIN: msgColor = COLOR_RED;     break;
  }
  
  // Display stat change text
  makeLabel(msg, FONT_MEDIUM_ITALICS, msgColor, LABEL_TYPE_STAT_CHANGE);
  
  // Enable debuff effect
  debuffEffect();
}

/*=============================================================================
 * improveStat()
 *
 * Called when a stat improvement has been made
 *===========================================================================*/
public function improveStat(float value, float total, MechanicTypes targetStat) {
  local ColorStyles msgColor;
  local string fullMsg;
  
  // Set enemy UI message
  switch (targetStat) {
    case ADD_STRENGTH:         fullMsg = "+" $ int(value) $ " strength";  break;
    case ADD_COURAGE:          fullMsg = "+" $ int(value) $ " courage";   break;
    case ADD_FOCUS:            fullMsg = "+" $ int(value) $ " focus";     break;
    case ADD_SPEED:            fullMsg = "+" $ int(value) $ " speed";     break;
    case ADD_ACCURACY:         fullMsg = "+" $ int(value) $ " accuracy";  break;
    case ADD_DODGE:            fullMsg = "+" $ int(value) $ " dodge";     break;
    case ADD_ARMOR:            fullMsg = "+" $ int(value) $ " armor";     break;
    case AMPLIFY_NEXT_DAMAGE:  fullMsg = "+" $ int(value) $ "% damage";   break;
    case ELEMENTAL_MULTIPLIER: fullMsg = "+" $ int(value) $ "% damage";   break;
    case PHYSICAL_MULTIPLIER:  fullMsg = "+" $ int(value) $ "% damage";   break;
    case ADD_STRENGTH_PERCENT: fullMsg = "+" $ int(value) $ "% strength"; break;
    case ADD_COURAGE_PERCENT:  fullMsg = "+" $ int(value) $ "% courage";  break;
  }
  
  // Set UI color
  switch (targetStat) {
    case ADD_STRENGTH:         msgColor = COLOR_ORANGE; break;
    case ADD_COURAGE:          msgColor = COLOR_GOLD;   break;
    case ADD_FOCUS:            msgColor = COLOR_BLUE;   break;
    case ADD_SPEED:            msgColor = COLOR_YELLOW; break;
    case ADD_ACCURACY:         msgColor = COLOR_GREEN;  break;
    case ADD_DODGE:            msgColor = COLOR_PURPLE; break;
    case ADD_ARMOR:            msgColor = COLOR_TAN;    break;
    case ELEMENTAL_MULTIPLIER: msgColor = COLOR_CYAN;   break;
    case PHYSICAL_MULTIPLIER:  msgColor = COLOR_ORANGE; break;
    case AMPLIFY_NEXT_DAMAGE:  msgColor = COLOR_ORANGE; break;
    case ADD_EXTRA_MANA_REGEN:
    case ADD_MANA_REGEN:       msgColor = COLOR_CYAN;   break;
    case ADD_HEALTH_REGEN:     msgColor = COLOR_RED;    break;
    case ADD_STRENGTH_PERCENT: msgColor = COLOR_TAN;    break;
    case ADD_COURAGE_PERCENT:  msgColor = COLOR_TAN;    break;
    default:
      yellowLog("Unhandled stat boost: " $ MechanicTypes(targetStat));
  }
  
  // Total stat message
  makeLabel(fullMsg, FONT_MEDIUM_ITALICS, msgColor, LABEL_TYPE_STAT_REPORT);
  
}
  














/*=============================================================================
 * makeLabel()
 *
 * Creates a label to show feedback for combat actions
 *===========================================================================*/
protected function UI_Label makeLabel
(
  coerce string text,
  optional CombatFonts fontIndex = FONT_LARGE,
  optional ColorStyles colorIndex = COLOR_GRAY,
  optional LabelClass labelType = LABEL_TYPE_RESIST
) 
{
  local UI_Label label;
  
  // Regular make label routine
  label = super.makeLabel(text, fontIndex, colorIndex, labelType);
  
  // Adjust text location
  
  switch (labelType) {
    case LABEL_TYPE_STAT_CHANGE: 
    case LABEL_TYPE_STAT_REPORT: 
    case LABEL_TYPE_HEALTH_GAIN: 
    case LABEL_TYPE_MANA_GAIN:  
    case LABEL_TYPE_MANA_DAMAGE:
      label.updatePosition(getX() + 100, getY() + 20, getX() + 360, getY() + 360);
      break;
    case LABEL_TYPE_DAMAGE:
      label.updatePosition(getX() + 100 - rand(100), getY() + 20 - rand(50), getX() + 360, getY() + 360);
      break;
    case LABEL_TYPE_RESIST:
      label.updatePosition(getX() + 120, getY() - 20, getX() + 360, getY() + 280);
      break;
    default:
      yellowLog("Warning (!) Unhandled label type.", DEBUG_COMBAT);
      break;
  }
  
  // Sets home position data
  label.postInit();
  
  // Return reference of this label
  return label;
}

/*=============================================================================
 * nextSkillFrame()
 * 
 * Called from a timer to animate a skill
 *===========================================================================*/
public function nextSkillFrame() {
  //if (skillAnimation.copySprite(spriteSheet, animatorIndex, NO_RESIZE)) {
  if (skillAnimation.drawNextFrame()) {
    animatorIndex++;
  } else {
    animatorIndex = 0;
    animationTimer.destroy();
  }
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  bDrawRelative=true
  
  // Animation modes for each label class
  animationModes(LABEL_TYPE_STAT_REPORT)=ANIMATE_SLOW_BOUNCE
  animationModes(LABEL_TYPE_STAT_CHANGE)=ANIMATE_UP_AND_FADE
  animationModes(LABEL_TYPE_HEALTH_GAIN)=ANIMATE_UP_AND_FADE
  animationModes(LABEL_TYPE_MANA_GAIN)=ANIMATE_UP_AND_FADE
  animationModes(LABEL_TYPE_DAMAGE)=ANIMATE_UP_BOUNCE
  animationModes(LABEL_TYPE_RESIST)=ANIMATE_STILL
  
	/** ===== Textures ===== **/
	// Enemy health and TUNA
	begin object class=UI_Texture_Info Name=Enemy_UI_Back
    componentTextures.add(Texture2D'GUI.Enemy_UI_Back')
  end object
	begin object class=UI_Texture_Info Name=Enemy_UI_HP_Bar
    componentTextures.add(Texture2D'GUI.Enemy_UI_HP_Bar')
  end object
	begin object class=UI_Texture_Info Name=Enemy_UI_TUNA_Bar
    componentTextures.add(Texture2D'GUI.Enemy_UI_TUNA_Bar')
  end object
	begin object class=UI_Texture_Info Name=Enemy_UI_Frame
    componentTextures.add(Texture2D'GUI.Enemy_UI_Frame')
  end object
	
  // Portraits
	begin object class=UI_Texture_Info Name=Place_Holder_240
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Placeholder_240') 
  end object
	begin object class=UI_Texture_Info Name=Place_Holder_360
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Placeholder_360')
  end object
  
	/** ===== UI Components ===== **/
  // Enemy UI Background
	begin object class=UI_Sprite Name=Enemy_UI_Back_Sprite
		tag="Enemy_UI_Back_Sprite"
    posX=0
    posY=0
    images(0)=Enemy_UI_Back
	end object
	componentList.add(Enemy_UI_Back_Sprite)
	
  // Enemy Health
	begin object class=UI_Sprite Name=Enemy_UI_HP_Bar_Sprite
		tag="Enemy_UI_HP_Bar_Sprite"
    posX=10
    posY=10
    images(0)=Enemy_UI_HP_Bar
	end object
	componentList.add(Enemy_UI_HP_Bar_Sprite)
	
  // Enemy Tuna
	begin object class=UI_Sprite Name=Enemy_UI_TUNA_Bar_Sprite
		tag="Enemy_UI_TUNA_Bar_Sprite"
    posX=19
    posY=33
    images(0)=Enemy_UI_TUNA_Bar
	end object
	componentList.add(Enemy_UI_TUNA_Bar_Sprite)
	
  // Enemy UI Frame
	begin object class=UI_Sprite Name=Enemy_UI_Frame_Sprite
		tag="Enemy_UI_Frame_Sprite"
    posX=0
    posY=0
    images(0)=Enemy_UI_Frame
	end object
	componentList.add(Enemy_UI_Frame_Sprite)
	
  // Enemy Portrait
	begin object class=UI_Sprite Name=Enemy_Portrait
		tag="Enemy_Portrait"
    bAnchor=true
    anchorX=106
    anchorY=165
		images(0)=Place_Holder_360
	end object
	componentList.add(Enemy_Portrait)
	
  // Skill animation sprite
	begin object class=UI_Sprite Name=Skill_Animation
		tag="Skill_Animation"
    posX=-14
    posY=75
    posXEnd=226
    posYEnd=315
    images(0)=none
	end object
	componentList.add(Skill_Animation)
	
  // Monster name
	begin object class=UI_Label Name=Enemy_Name_Label
		tag="Enemy_Name_Label"
    posX=-6
    posY=-31
		posXEnd=NATIVE_WIDTH
		posYEnd=NATIVE_HEIGHT
		AlignX=LEFT
		AlignY=TOP
    fontStyle=DEFAULT_SMALL_WHITE
		labelText=""
	end object
	componentList.add(Enemy_Name_Label)
	
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
	/** ===== Textures ===== **/
	// Enemy health and TUNA
	begin object class=UI_Texture_Info Name=Elite_UI_Back
    componentTextures.add(Texture2D'GUI.Champ_UI_Back')
  end object
	begin object class=UI_Texture_Info Name=Elite_UI_HP_Bar
    componentTextures.add(Texture2D'GUI.Champ_UI_HP_Bar')
  end object
	begin object class=UI_Texture_Info Name=Elite_UI_TUNA_Bar
    componentTextures.add(Texture2D'GUI.Champ_UI_TUNA_Bar')
  end object
	begin object class=UI_Texture_Info Name=Elite_UI_Frame
    componentTextures.add(Texture2D'GUI.Champ_UI_Frame')
  end object
	
	/** ===== UI Components ===== **/
  // Elite UI Background
	begin object class=UI_Sprite Name=Elite_UI_Back_Sprite
		tag="Elite_UI_Back_Sprite"
    posX=-194
    posY=-68
    images(0)=Elite_UI_Back
	end object
	componentList.add(Elite_UI_Back_Sprite)
	
  // Elite Health
	begin object class=UI_Sprite Name=Elite_UI_HP_Bar_Sprite
		tag="Elite_UI_HP_Bar_Sprite"
    posX=-183
    posY=-58
    images(0)=Elite_UI_HP_Bar
	end object
	componentList.add(Elite_UI_HP_Bar_Sprite)
	
  // Elite Tuna
	begin object class=UI_Sprite Name=Elite_UI_TUNA_Bar_Sprite
		tag="Elite_UI_TUNA_Bar_Sprite"
    posX=-75
    posY=-34
    images(0)=Elite_UI_TUNA_Bar
	end object
	componentList.add(Elite_UI_TUNA_Bar_Sprite)
	
  // Elite UI Frame
	begin object class=UI_Sprite Name=Elite_UI_Frame_Sprite
		tag="Elite_UI_Frame_Sprite"
    posX=-194
    posY=-68
    images(0)=Elite_UI_Frame
	end object
	componentList.add(Elite_UI_Frame_Sprite)
	
  // Elite Portrait
	begin object class=UI_Sprite Name=Elite_Portrait
		tag="Elite_Portrait"
    bAnchor=true
    anchorX=106
    anchorY=195 
    images(0)=Place_Holder_360
	end object
	componentList.add(Elite_Portrait)
	
  // Skill animation sprite
	begin object class=UI_Sprite Name=Elite_Skill_Animation
		tag="Elite_Skill_Animation"
    posX=-74
    posY=-4
    posXend=286
    posYend=356
    images(0)=none
	end object
	componentList.add(Elite_Skill_Animation)
	
  // Monster name
	begin object class=UI_Label Name=Elite_Name_Label
		tag="Elite_Name_Label"
    posX=-194
    posY=-103
		posXEnd=406
		posYEnd=NATIVE_HEIGHT
		AlignX=CENTER
		AlignY=TOP
    fontStyle=DEFAULT_MEDIUM_WHITE
		labelText=""
	end object
	componentList.add(Elite_Name_Label)
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  // Demoralization Marker
	begin object class=UI_Texture_Info Name=Demoralization_Marker
    componentTextures.add(Texture2D'GUI.Demoralization_Marker')
  end object
  
  // Demoralization threshold marker
	begin object class=UI_Sprite Name=Enemy_Demoralization_Marker
		tag="Enemy_Demoralization_Marker"
    posX=3 // + 188
    posY=-7
    images(0)=Demoralization_Marker
	end object
	componentList.add(Enemy_Demoralization_Marker)
	
  // Status label
	begin object class=ROTT_UI_Status_Label Name=Enemy_Status_Label
		tag="Enemy_Status_Label"
    posX=0
    posY=0
		posXEnd=214
		posYEnd=140
	end object
	componentList.add(Enemy_Status_Label)
	
  // Status label
	begin object class=ROTT_UI_Status_Label Name=Elite_Status_Label
		tag="Elite_Status_Label"
    posX=0
    posY=-25
		posXEnd=214
		posYEnd=29
	end object
	componentList.add(Elite_Status_Label)
	
  
}



















