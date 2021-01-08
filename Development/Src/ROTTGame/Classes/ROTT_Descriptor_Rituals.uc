/*=============================================================================
 * ROTT_Descriptor_Rituals
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Stores design information for rituals, such as ritual costs.
 *===========================================================================*/
  
class ROTT_Descriptor_Rituals extends ROTTObject
abstract;

enum RitualTypes {
  RITUAL_EXPERIENCE_BOOST,
  RITUAL_PHYSICAL_DAMAGE,
  RITUAL_MANA_REGEN,
  
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
  }
  
  // Return list
  return costList;
}

/*=============================================================================
 * descriptors
 *===========================================================================*/
defaultProperties 
{
  
}







