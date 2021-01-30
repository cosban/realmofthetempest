/*=============================================================================
 * ROTT_Descriptor_Rituals
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Stores design information for rituals, such as ritual costs.
 *===========================================================================*/
  
class ROTT_Descriptor_Rituals extends ROTTObject
dependsOn(ROTT_Game_Info)
abstract;

enum RitualTypes {
  RITUAL_EXPERIENCE_BOOST,
  RITUAL_PHYSICAL_DAMAGE,
  RITUAL_MANA_REGEN,
  RITUAL_MANA_BOOST,
  RITUAL_HEALTH_REGEN,
  RITUAL_HEALTH_BOOST,
  RITUAL_ARMOR,
  RITUAL_SKILL_POINT,
};
  
/*=============================================================================
 * getRitualCost()
 * 
 * returns the price for a shrine ritual
 *===========================================================================*/
public static function array<ItemCost> getRitualCost(RitualTypes ritualType) {
  local array<ItemCost> costList;
  local ItemCost costInfo;
  
  switch (ritualType) {
    case RITUAL_EXPERIENCE_BOOST:
      // Set cost
      costInfo.currencyType = class'ROTT_Inventory_Item_Herb';
      costInfo.quantity = 1;
      
      // Add to list
      costList.addItem(costInfo);
      break;
    case RITUAL_MANA_REGEN:
      // Set cost
      costInfo.currencyType = class'ROTT_Inventory_Item_Bottle_Harrier_Claws';
      costInfo.quantity = 1;
      
      // Add to list
      costList.addItem(costInfo);
      
      // Set cost
      costInfo.currencyType = class'ROTT_Inventory_Item_Charm_Kamita';
      costInfo.quantity = 1;
      
      // Add to list
      costList.addItem(costInfo);
      break;
    case RITUAL_PHYSICAL_DAMAGE:
      // Set cost
      costInfo.currencyType = class'ROTT_Inventory_Item_Charm_Eluvi';
      costInfo.quantity = 1;
      
      // Add to list
      costList.addItem(costInfo);
      
      // Set cost
      costInfo.currencyType = class'ROTT_Inventory_Item_Bottle_Swamp_Husks';
      costInfo.quantity = 1;
      
      // Add to list
      costList.addItem(costInfo);
      break;
    case RITUAL_HEALTH_BOOST:
      // Set cost
      costInfo.currencyType = class'ROTT_Inventory_Item_Charm_Cerok';
      costInfo.quantity = 2;
      
      // Add to list
      costList.addItem(costInfo);
      
      // Set cost
      ///costInfo.currencyType = class'ROTT_Inventory_Item_Gold';
      ///costInfo.quantity = 1000;
      ///
      ///// Add to list
      ///costList.addItem(costInfo);
      break;
    case RITUAL_HEALTH_REGEN:
      // Set cost
      costInfo.currencyType = class'ROTT_Inventory_Item_Bottle_Faerie_Bones';
      costInfo.quantity = 1;
      
      // Add to list
      costList.addItem(costInfo);
      
      // Set cost
      costInfo.currencyType = class'ROTT_Inventory_Item_Charm_Shukisu';
      costInfo.quantity = 1;
      
      // Add to list
      costList.addItem(costInfo);
      break;
    case RITUAL_MANA_BOOST:
      // Set cost
      costInfo.currencyType = class'ROTT_Inventory_Item_Charm_Myroka';
      costInfo.quantity = 1;
      
      // Add to list
      costList.addItem(costInfo);
      
      // Set cost
      costInfo.currencyType = class'ROTT_Inventory_Item_Charm_Eluvi';
      costInfo.quantity = 1;
      
      // Add to list
      costList.addItem(costInfo);
      break;
    case RITUAL_ARMOR:
      // Set cost
      costInfo.currencyType = class'ROTT_Inventory_Item_Charm_Cerok';
      costInfo.quantity = 1;
      
      // Add to list
      costList.addItem(costInfo);
      
      // Set cost
      costInfo.currencyType = class'ROTT_Inventory_Item_Gem';
      costInfo.quantity = 5;
      
      // Add to list
      costList.addItem(costInfo);
      break;
    case RITUAL_SKILL_POINT:
      // Set cost
      costInfo.currencyType = class'ROTT_Inventory_Item_Bottle_Yinras_ore';
      costInfo.quantity = 1;
      
      // Add to list
      costList.addItem(costInfo);
      
      // Set cost
      costInfo.currencyType = class'ROTT_Inventory_Item_Charm_Erazi';
      costInfo.quantity = 1;
      
      // Add to list
      costList.addItem(costInfo);
      
      // Set cost
      costInfo.currencyType = class'ROTT_Inventory_Item_Herb_Zeltsi';
      costInfo.quantity = 1;
      
      // Add to list
      costList.addItem(costInfo);
      break;
  }
  
  // Return list
  return costList;
}

/*=============================================================================
 * getRitualBoost()
 * 
 * returns the amplitude of the boost per ritual performance
 *===========================================================================*/
public static function float getRitualBoost(RitualTypes ritualType) {
  // Return amp by ritual type
  switch (ritualType) {
    case RITUAL_EXPERIENCE_BOOST:  return 1;
    case RITUAL_PHYSICAL_DAMAGE:   return 1;
    case RITUAL_MANA_BOOST:        return 15;
    case RITUAL_MANA_REGEN:        return 1;
    case RITUAL_HEALTH_BOOST:      return 10;
    case RITUAL_HEALTH_REGEN:      return 1;
    case RITUAL_ARMOR:             return 1;
    case RITUAL_SKILL_POINT:       return 1;
  }
  
  yellowLog("Warning (!) Unhandled ritual type: " $ ritualType);
  return 1;
}

/*=============================================================================
 * getRitualCount()
 * 
 * returns the number of rituals
 *===========================================================================*/
public static function int getRitualCount() {
  return RitualTypes.enumCount;
}

/*=============================================================================
 * descriptors
 *===========================================================================*/
defaultProperties 
{
  
}







