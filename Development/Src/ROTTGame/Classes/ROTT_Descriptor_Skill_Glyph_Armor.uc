/*=============================================================================
 * ROTT_Descriptor_Skill_Glyph_Armor
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * This is a glyph skill, collected in combat to provide armor boost.
 *===========================================================================*/

class ROTT_Descriptor_Skill_Glyph_Armor extends ROTT_Descriptor_Hero_Skill;
 
/*=============================================================================
 * initialize()
 *
 * this function should be called by the descriptor container to set headers
 * and paragraph formatting info
 *===========================================================================*/
public function setUI() {
  // Set header
  h1(
    "Armor",
  );
  
  // Set header
  h2(
    "",
  );
  
  // Set paragraph information
  p1(
    "Collect this glyph during",
    "combat to increase armor rating.",
    "",
  );
  
  // Set skill information for p2 and p3
  skillInfo(      
    "Chance to spawn: %spawn%",
    "+%armor Armor rating per Glyph",
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
      attribute = 80;
      break;
    case GLYPH_ARMOR_BOOST:
      attribute = level;//float(int(1 + (0.384 * level) + (0.2545 * level * level)));
      break;
  }
  
  return attribute;
}

/*============================================================================= 
 * Default Properties
 *===========================================================================*/
defaultProperties 
{
  // Level lookup info
  skillIndex=GLYPH_TREE_ARMOR
  parentTree=GLYPH_TREE
  
  // Glyph Attributes
  skillAttributes.add((attributeSet=GLYPH_SET,mechanicType=GLYPH_SPAWN_CHANCE,tag="%spawn",font=DEFAULT_SMALL_BLUE,returnType=INTEGER));
  skillAttributes.add((attributeSet=GLYPH_SET,mechanicType=GLYPH_ARMOR_BOOST,tag="%armor",font=DEFAULT_SMALL_GREEN,returnType=INTEGER));
  
}

/*
function int GetArmor(string StatType, int SkillLevel)
{
  //This function is for the armor glyph stats
  
  //Desired outcome
  // Skill level    Chance    Armor

  //  1        40      1
  //  2        55      1
  //  3        70      1
  //  4        85      1
  //  5        55      2
  //  6        70      2
  //  7        85      2
  //  8        55      3
  //  9        70      3
  //  10      85      3

  
  local int iArmor, i, j, k;
  
  iArmor = 0;
  //iChance = 20;
  i = 0;
  j = 1;
  k = 2;
  
  do
  {
    
    iArmor = iArmor + j;
    
    if (k == 3)
    {
      k = 1;
      j++;
    }
    
    k = k + 1;

    i++;
  } until (i >= skillLevel);
    
    
  switch (StatType)
  {
    case "Stat":
      return iArmor;
      break;
    case "Chance":
      return 80;
      break;
  }
}
**/














