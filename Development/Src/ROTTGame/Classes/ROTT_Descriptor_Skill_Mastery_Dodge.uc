/*=============================================================================
 * ROTT_Descriptor_Skill_Mastery_Dodge
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * This is a mastery skill, providing a permanent boost to the hero.
 *===========================================================================*/

class ROTT_Descriptor_Skill_Mastery_Dodge extends ROTT_Descriptor_Hero_Skill;

/*=============================================================================
 * initialize()
 *
 * this function should be called by the descriptor container to set headers
 * and paragraph formatting info
 *===========================================================================*/
public function setUI() {
  // Set header
  h1(
    "Dodge",
  );
  
  // Set header
  h2(
    ""
  );
  
  // Set paragraph information
  p1(
    "Permanent increase to dodge rating.",
    "",
    ""
  );
  
  // Set skill information for p2 and p3
  skillInfo(      
    "Required Vitality: %vitality",
    "Required Courage: %courage",
    "+%dodge Dodge rating"
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
    case MASTERY_REQ_VITALITY:
      attribute = getStats("Req1", level); //requirement(2, 3);
      break;
    case MASTERY_REQ_COURAGE:
      attribute = getStats("Req2", level); //requirement(1, 3);
      break;
    case PASSIVE_DODGE_BOOST:
      attribute = 48 * level + 10 * (level / 2) + 10 * (level / 4);
      break;
  }
  
  return attribute;
}

/*=============================================================================
 * requirement()
 *===========================================================================
private function int requirement() {
  local int req, ReqTotal, i, j;
  local float k;
  
  ReqTotal = 32;
  k = 1.1;
  
  for (i = 0; i < level; i++)  {
    k = k * 1.007;
    k = k + 0.14;

    ReqTotal = round(ReqTotal * k);
    
    req = round(ReqTotal * (a/b));
    
    if (req % 5 != 0 && req % 2 != 0) {
      req++;    
      k = k + 0.013;
    }
  }
  
  return req;
}*/

/*=============================================================================
 * getStats()
 *===========================================================================*/
private function int getStats(string StatType, int level) {
  local int iStat, iReq1, iReq2, ReqTotal, i, j;
  local float k;
  
  if (level == 0) return 0;
  
  iStat = 0;
  ReqTotal = 32;
  j = 18;
  k = 1.1;
  
  for (i = 0; i < level; i++)  {
    k = k * 1.007;
    k = k + 0.14;

    ReqTotal = round(ReqTotal * k);
    
    iReq1 = round(ReqTotal * (2.0/3.0));
    iReq2 = round(ReqTotal * (1.0/3.0));
    
    
    if (iReq1 % 5 != 0 && iReq1%2 != 0 )
    {
      do
      {
        iReq1 = iReq1 + 1;    
        k = k + 0.013;        
      } until (iReq1%5 == 0 || iReq1%2 == 0);
    }
    
    if (iReq2 % 5 != 0 && iReq2%2 != 0 )
    {
      do
      {
        iReq2 = iReq2 + 1;      
        k = k + 0.013;
      } until (iReq2%5 == 0 || iReq2%2 == 0);
    }
    
    j = j + (5 * i) + 6;
    iStat = iStat + j;
  }
  
  
  switch (StatType)  {
    case "Stat":      return iStat;
    case "Req1":      return iReq1;
    case "Req2":      return iReq2;
  }
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties 
{
  // Level lookup info
  skillIndex=MASTERY_DODGE
  parentTree=MASTERY_TREE

  // Skill Attributes
  skillAttributes.add((attributeSet=INACTIVE_SET,mechanicType=MASTERY_REQ_VITALITY,tag="%vitality",font=DEFAULT_SMALL_RED,returnType=INTEGER));
  skillAttributes.add((attributeSet=INACTIVE_SET,mechanicType=MASTERY_REQ_COURAGE,tag="%courage",font=DEFAULT_SMALL_RED,returnType=INTEGER));
  skillAttributes.add((attributeSet=PASSIVE_SET,mechanicType=PASSIVE_DODGE_BOOST,tag="%dodge",font=DEFAULT_SMALL_GREEN,returnType=INTEGER));
}

//function int j() {
//  local int iStat, i, j;
//  
//  iStat = 0;
//  j = 18;
//  
//  for (i = 0; i < level; i++)  {
//    j += (5 * i) + 6;
//    iStat += j;
//  }
//  
//  return iStat;
//}

/*
function int GetUniDodge(string StatType, int level) {
  local int iStat, iReq1, iReq2, ReqTotal, i, j;
  local float k;
  
  if (level == 0) return 0;
  
  iStat = 0;
  ReqTotal = 32;
  j = 18;
  k = 1.1;
  
  for (i = 0; i < level; i++)  {
    k = k * 1.007;
    k = k + 0.14;

    ReqTotal = round(ReqTotal * k);
    
    iReq1 = round(ReqTotal * (2.0/3.0));
    iReq2 = round(ReqTotal * (1.0/3.0));
    
    
    if (iReq1 % 5 != 0 && iReq1%2 != 0 )
    {
      do
      {
        iReq1 = iReq1 + 1;    
        k = k + 0.013;        
      } until (iReq1%5 == 0 || iReq1%2 == 0);
    }
    
    if (iReq2 % 5 != 0 && iReq2%2 != 0 )
    {
      do
      {
        iReq2 = iReq2 + 1;      
        k = k + 0.013;
      } until (iReq2%5 == 0 || iReq2%2 == 0);
    }
    
    j = j + (5 * i) + 6;
    iStat = iStat + j;
  }
  
  
  switch (StatType)  {
    case "Stat":      return iStat;
    case "Req1":      return iReq1;
    case "Req2":      return iReq2;
  }
}
*/













