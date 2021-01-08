/*=============================================================================
 * ROTT_Descriptor_Skill_Mastery_Accuracy
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * This is a mastery skill, providing a permanent boost to the hero.
 *===========================================================================*/

class ROTT_Descriptor_Skill_Mastery_Accuracy extends ROTT_Descriptor_Hero_Skill;

/*=============================================================================
 * initialize()
 *
 * this function should be called by the descriptor container to set headers
 * and paragraph formatting info
 *===========================================================================*/
public function setUI() {
  // Set header
  h1(
    "Accuracy",
  );
  
  // Set header
  h2(
    "",
  );
  
  // Set paragraph information
  p1(
    "Permanent increase to accuracy rating.",
    "",
    "",
  );
  
  // Set skill information for p2 and p3
  skillInfo(      
    "Required Strength: %strength",
    "Required Focus: %focus",
    "+%accuracy Accuracy rating"
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
    case MASTERY_REQ_STRENGTH:
      attribute = getStats("Req1", level);
      break;
    case MASTERY_REQ_FOCUS:
      attribute = getStats("Req2", level);
      break;
    case PASSIVE_ACCURACY_BOOST:
      attribute = 48 * level + 10 * (level / 2) + 10 * (level / 4);
      break;
  }
  
  return attribute;
}

/*=============================================================================
 * getStats()
 *===========================================================================*/
function int getStats(string StatType, int SkillLevel) {
	local int iReq1, iReq2; ///iStat
	
	// Level 0 does not exist 
	if (SkillLevel == 0)
		return 0;
	
	
	// Strength Requirement 
	iReq1 = (SkillLevel*11) + (SkillLevel * (SkillLevel-1)) + 1;
	if (iReq1 % 5 != 0 && iReq1%2 != 0 )
		iReq1++;
	
	// Focus Requirement 
	iReq2 = (SkillLevel*21) + (SkillLevel * 2 * (SkillLevel-1)) + 4;
	if (iReq2 % 5 != 0 && iReq2%2 != 0 )
		iReq2++;
	
	// Accuracy 
	///iStat = (SkillLevel*27) + (SkillLevel * 3 * (SkillLevel-1)) + 1;
	///if (iStat % 5 != 0 && iStat%2 != 0 )
	///	iStat++;
		
	switch (StatType)
	{
		///case "Stat":
		///	return iStat;
		case "Req1":
			return iReq1;
		case "Req2":
			return iReq2;
	}
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties 
{
  // Level lookup info
  skillIndex=MASTERY_ACCURACY
  parentTree=MASTERY_TREE

  // Skill Attributes
  skillAttributes.add((attributeSet=INACTIVE_SET,mechanicType=MASTERY_REQ_STRENGTH,tag="%strength",font=DEFAULT_SMALL_RED,returnType=INTEGER));
  skillAttributes.add((attributeSet=INACTIVE_SET,mechanicType=MASTERY_REQ_FOCUS,tag="%focus",font=DEFAULT_SMALL_RED,returnType=INTEGER));
  skillAttributes.add((attributeSet=PASSIVE_SET,mechanicType=PASSIVE_ACCURACY_BOOST,tag="%accuracy",font=DEFAULT_SMALL_GREEN,returnType=INTEGER));
}
























