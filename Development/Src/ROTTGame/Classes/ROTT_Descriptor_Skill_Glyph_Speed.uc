/*=============================================================================
 * ROTT_Descriptor_Skill_Glyph_Speed
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * This is a glyph skill, collected in combat to provide Speed boost.
 *===========================================================================*/
 
class ROTT_Descriptor_Skill_Glyph_Speed extends ROTT_Descriptor_Hero_Skill;

/*=============================================================================
 * initialize()
 *
 * this function should be called by the descriptor container to set headers
 * and paragraph formatting info
 *===========================================================================*/
public function setUI() {
  // Set header
  h1(
    "Speed",
  );
  
  // Set header
  h2(
    "",
  );
  
  // Set paragraph information
  p1(
    "Collect this glyph during",
    "combat to increase speed rating.",
    "",
  );
  
  // Set skill information for p2 and p3
  skillInfo(      
    "Chance to spawn: %spawn%",
    "+%speed to speed rating per Glyph",
    ""
  );
}


/*=============================================================================
 * attributeInfo()
 *
 * This function should hold all equations pertaining to the skill's behavior.
 *===========================================================================*/
protected function float attributeInfo
(
  AttributeTypes type, 
  ROTT_Combat_Hero hero, 
  int level
) 
{
  local float attribute; attribute = 0; 
  
  if (level == 0) return 0;
  
  switch (type) {
    case GLYPH_SPAWN_CHANCE:
      attribute = 40;
      break;
    case GLYPH_SPEED_BOOST:
      attribute = speedRating(level);
      break;
  }
  
  return attribute;
}

private function int speedRating(int level) {
  local int speed, i, delta;
  
  speed = 4;
  delta = 2;
  
  for (i = 0; i < level; i++) {
    speed = speed + delta;
    
    if (i%2 == 0 && i != 0) {
      delta = delta + 3;
    } else {
      delta = delta + 2;
    }
  } 
  return speed;
}

/*============================================================================= 
 * Default Properties
 *===========================================================================*/
defaultProperties 
{
  // Level lookup info
  skillIndex=GLYPH_TREE_SPEED
  parentTree=GLYPH_TREE
  
  // Glyph Attributes
  skillAttributes.add((attributeSet=GLYPH_SET,mechanicType=GLYPH_SPAWN_CHANCE,tag="%spawn",font=DEFAULT_SMALL_BLUE,returnType=INTEGER));
  skillAttributes.add((attributeSet=GLYPH_SET,mechanicType=GLYPH_SPEED_BOOST,tag="%speed",font=DEFAULT_SMALL_GREEN,returnType=INTEGER));
  
}

// #test#
/*
function int s2(int lv) {
  local int s;
  s = (5 * ((lv * (lv / 2)) / 2)) + lv % 2 + 5;
  return s;
}
*/

/**
  
function int GetSpeed(string StatType, int SkillLevel)
{
  local int s, i, j;
  
  s = 4;
  j = 2;
  
  for (i = 0; i < level; i++) {
    s = s + j;
    
    if (i%2 == 0 && i != 0) {
      j = j + 3;
    } else {
      j = j + 2;
    }
  } 
  
}

i:0 j: 2    s: 5+1    d:
i:1 j: 4    s: 10     d: 5
i:2 j: 6    s: 15+1   d: 5
i:3 j: 9    s: 25     d: 10
i:4 j: 11   s: 35+1   d: 10
i:5 j: 14   s: 50     d: 15

**/


















