/*=============================================================================
 * ROTT_Descriptor_Skill_Mastery_Life
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * This is a mastery skill, providing a permanent boost to the hero.
 *===========================================================================*/

class ROTT_Descriptor_Skill_Mastery_Life extends ROTT_Descriptor_Hero_Skill;

/*=============================================================================
 * initialize()
 *
 * this function should be called by the descriptor container to set headers
 * and paragraph formatting info
 *===========================================================================*/
public function setUI() {
  // Set header
  h1(
    "Life",
  );
  
  // Set header
  h2(
    "",
  );
  
  // Set paragraph information
  p1(
    "Permanent increase to health.",
    "",
    "",
  );
  
  // Set skill information for p2 and p3
  skillInfo(      
    "Required Courage: %courage",
    "+%health Max health",
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
    case MASTERY_REQ_COURAGE:
      attribute = getStats("Req", level);
      break;
    case PASSIVE_HEALTH_BOOST:
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
	j = 136;
	k = 22;
	
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
				k = k + 7;				
			} until (iReq%5 == 0 || iReq%2 == 0);
		}
		
		iStat = iStat + j;
		j = j + (15 * i) + 10;
		
	} until (i <= 0);
  
	switch (StatType)	{
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
  skillIndex=MASTERY_LIFE
  parentTree=MASTERY_TREE

  // Skill Attributes
  skillAttributes.add((attributeSet=INACTIVE_SET,mechanicType=MASTERY_REQ_COURAGE,tag="%courage",font=DEFAULT_SMALL_RED,returnType=INTEGER));
  skillAttributes.add((attributeSet=PASSIVE_SET,mechanicType=PASSIVE_HEALTH_BOOST,tag="%health",font=DEFAULT_SMALL_GREEN,returnType=INTEGER));
}

/*

function int GetUniHealth(string StatType, int SkillLevel)
{

	local int iStat, iReq, i, j, k;
	
	if (SkillLevel == 0)
	{
		return 0;
	}
	
	iStat = 0;
	iReq = 0;
	i = SkillLevel;
	j = 136;
	k = 22;
	
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
				k = k + 7;				
			} until (iReq%5 == 0 || iReq%2 == 0);
		}
		
		iStat = iStat + j;
		j = j + (15 * i) + 10;
		
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
















