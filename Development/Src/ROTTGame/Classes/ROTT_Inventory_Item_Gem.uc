/*============================================================================= 
 * ROTT_Inventory_Item_Gem
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Currency for gems
 *===========================================================================*/
 
class ROTT_Inventory_Item_Gem extends ROTT_Inventory_Item;

/*=============================================================================
 * getDropChance()
 *
 * Implemented in each item subclsas
 *===========================================================================*/
protected function float getDropChance(int dropLevel) {
  return 20.f;
}

/*=============================================================================
 * getMinQuantity()
 *
 * Implemented in each item subclsas
 *===========================================================================*/
protected function float getMinQuantity(int dropLevel) {
  // Min gem growth is Θ(n)
  return 0.01 * dropLevel + 0.2 * dropLevel / (1 + logn(dropLevel, 5)); 
}
  
/*=============================================================================
 * logn()
 *
 * Logarithm base n.
 *===========================================================================*/
public static function float logn(float input, float n) {
  return loge(input) / (loge(n)); 
}

/*=============================================================================
 * getMaxQuantity()
 *
 * Implemented in each item subclsas
 *===========================================================================*/
protected function float getMaxQuantity(int dropLevel) {
  // Max gem growth is Θ(nlogn)
  return getMinQuantity(dropLevel) + 0.05 * dropLevel * (1 + int((loge(dropLevel) / (loge(5))) / 5.f) / 100.f);
  /// return 0.15 * dropLevel * (1 + int(dropLevel / 5.f) / 20.f);
}

/*============================================================================= 
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  // Item categories
  category=ITEM_CATEGORY_CURRENCY
  
  // Display name
  itemName="Gems"
  
  // Item texture
  itemTexture=Texture2D'GUI.Item_Currency_Gem'
  
  // Item text color
  itemFont=DEFAULT_SMALL_TAN
}










