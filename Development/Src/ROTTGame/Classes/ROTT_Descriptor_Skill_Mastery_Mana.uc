/*=============================================================================
 * ROTT_Descriptor_Skill_Mastery_Mana
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * This is a mastery skill, providing a permanent boost to the hero.
 *===========================================================================*/

class ROTT_Descriptor_Skill_Mastery_Mana extends ROTT_Descriptor_Hero_Skill;

/*=============================================================================
 * initialize()
 *
 * this function should be called by the descriptor container to set headers
 * and paragraph formatting info
 *===========================================================================*/
public function setUI() {
  // Set header
  h1(
    "Mana",
  );
  
  // Set header
  h2(
    "",
  );
  
  // Set paragraph information
  p1(
    "Permanent increase to mana.",
    "",
    "",
  );
  
  // Set skill information for p2 and p3
  skillInfo(      
    "Required Focus: %focus",
    "+%mana Max mana",
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
  
  switch (type) {
    case MASTERY_REQ_FOCUS:
      attribute = getStats("Req", level);
      break;
    case PASSIVE_MANA_BOOST:
      attribute = getStats("Stat", level);
      break;
  }
  
  return attribute;
}

/*=============================================================================
 * getStats()
 *===========================================================================*/
function int getStats(string StatType, int SkillLevel) {

	local int iStat, iReq, i, j, k;
	
	if (SkillLevel == 0)
	{
		return 0;
	}
	
	iStat = 0;
	iReq = 0;
	i = SkillLevel;
	j = 48;
	k = 13;
	
	do
	{
		//Do %SkillLevel times
		i = i - 1;
		
		k = k + 3;
		iReq = iReq + k;
		
		if (iReq % 5 != 0 && iReq%2 != 0 )
		{
			Do
			{
				iReq = iReq + 1;
				k = k + 1;				
			} until (iReq%5 == 0 || iReq%2 == 0);
		}
		
		iStat = iStat + j;
		j = j + (12 * i) + 6;
		
	} until (i <= 0);
		
		
	switch (StatType)
	{
		case "Stat":
			return iStat;
		case "Req":
			return iReq;
	}
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties 
{
  // Level lookup info
  skillIndex=MASTERY_MANA
  parentTree=MASTERY_TREE

  // Skill Attributes
  skillAttributes.add((attributeSet=INACTIVE_SET,mechanicType=MASTERY_REQ_FOCUS,tag="%focus",font=DEFAULT_SMALL_RED,returnType=INTEGER));
  skillAttributes.add((attributeSet=PASSIVE_SET,mechanicType=PASSIVE_MANA_BOOST,tag="%mana",font=DEFAULT_SMALL_GREEN,returnType=INTEGER));
}


/*

function int GetUniMana(string StatType, int SkillLevel)
{

	local int iStat, iReq, i, j, k;
	
	if (SkillLevel == 0)
	{
		return 0;
	}
	
	iStat = 0;
	iReq = 0;
	i = SkillLevel;
	j = 48;
	k = 13;
	
	do
	{
		//Do %SkillLevel times
		i = i - 1;
		
		k = k + 3;
		iReq = iReq + k;
		
		if (iReq % 5 != 0 && iReq%2 != 0 )
		{
			Do
			{
				iReq = iReq + 1;
				k = k + 1;				
			} until (iReq%5 == 0 || iReq%2 == 0);
		}
		
		iStat = iStat + j;
		j = j + (12 * i) + 6;
		
	} until (i <= 0);
		
		
	switch (StatType)
	{
		case "Stat":
			return iStat;
			break;
		case "Req":
			return iReq;
			break;
	}
}

*/












