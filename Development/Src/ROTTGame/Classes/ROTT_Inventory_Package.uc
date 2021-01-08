/*============================================================================= 
 * ROTT_Inventory_Package
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * A container that manages an inventory of items.
 *===========================================================================*/
 
class ROTT_Inventory_Package extends ROTTObject;

// Linked list type storage system
var privatewrite array<ROTT_Inventory_Item> itemList;

/*=============================================================================
 * takeInventory()
 *
 * Combines the current inventory with the given inventory.
 *===========================================================================*/
public function takeInventory(ROTT_Inventory_Package otherInventory) {
  local int i;
  
  // Add each item one by one, combining with existing quantities
  for (i = otherInventory.count() - 1; i >= 0; i--) {
    // Add item to inventory
    addItem(otherInventory.itemList[i]);
    
    // Remove item from inventory
    otherInventory.itemList.remove(i, 1);
  }
  
  // Sort the items
  sort();
}

/*=============================================================================
 * addItems()
 *
 * Combines the current item list with the given item list.
 *===========================================================================*/
public function addItems(array<ROTT_Inventory_Item> newItems) {
  local int i;
  
  // Add each item one by one, combining with existing quantities
  for (i = 0; i < newItems.length; i++) {
    addItem(newItems[i]);
  }
}

/*=============================================================================
 * addItem()
 *
 * Adds the item to the inventory list, while consolidating items by types.
 *===========================================================================*/
public function addItem(ROTT_Inventory_Item newItem) {
  local int i;
  
  // Look for the item already in the list
  for (i = 0; i < itemList.length; i++) {
    // Check by item type
    if (itemList[i].class == newItem.class) {
      // Combine quantities
      itemList[i].addQuantity(newItem.quantity);
      return;
    }
  }
  
  // Since the item is not already in the list, add it
  itemList.addItem(newItem);
  
  // Sort the items
  sort();
}

/*=============================================================================
 * findItem()
 *
 * Access an item by type
 *===========================================================================*/
public function ROTT_Inventory_Item findItem(class<ROTT_Inventory_Item> itemClass) {
  local int i;
  
  // Search fo ritem
  for (i = 0; i < itemList.length; i++) {
    if (itemList[i].class == itemClass) return itemList[i];
  }
  return none;
}

/*=============================================================================
 * deductItem()
 *
 * Subtracts a quantity cost from the inventory if sufficient funds.
 * Returns true if sufficient funds, false if insufficient.
 *===========================================================================*/
public function bool deductItem(ItemCost cost) {
  local bool bSuccess;
  local int i;
  
  // Deduct item quantity
  bSuccess = findItem(cost.currencyType).subtract(cost.quantity);
  
  // Remove items that reach zero quantity
  for (i = count() - 1; i >= 0; i--) {
    if (itemList[i].quantity == 0) {
      itemList.remove(i, 1);
    }
  }
  
  // Deduction successful
  return bSuccess;
}

/*=============================================================================
 * takeItem()
 *
 * Removes an item from the list, and returns the removed item by reference.
 *===========================================================================*/
public function ROTT_Inventory_Item takeItem(class<ROTT_Inventory_Item> itemType) {
  local ROTT_Inventory_Item item;
  local int i;
  
  // Look for the item
  for (i = 0; i < itemList.length; i++) {
    // Check by item type
    if (itemList[i].class == itemType) {
      item = itemList[i];
      itemList.remove(i, 1);
      return item;
    }
  }
  
  return none;
}

/*=============================================================================
 * sort()
 *
 * Organizes the items in order of: Currency, Shrine items, Equipables
 *===========================================================================*/
public function sort() {
  local array<class<ROTT_Inventory_Item> > orderedTypes;
  local ROTT_Inventory_Item sortedItem;
  local int targetIndex;
  local int i;
  
  // Set up order preferences (Currencies, then shrine items)
  orderedTypes.addItem(class'ROTT_Inventory_Item_Gold');
  orderedTypes.addItem(class'ROTT_Inventory_Item_Gem');
  orderedTypes.addItem(class'ROTT_Inventory_Item_Herb');
  orderedTypes.addItem(class'ROTT_Inventory_Item_Charm_Eluvi');
  orderedTypes.addItem(class'ROTT_Inventory_Item_Charm_Kamita');
  orderedTypes.addItem(class'ROTT_Inventory_Item_Charm_Bayuta');
  orderedTypes.addItem(class'ROTT_Inventory_Item_Bottle_Faerie_Bones');
  orderedTypes.addItem(class'ROTT_Inventory_Item_Bottle_Swamp_Husks');
  
  // Organize inventory for each ordered type
  for (i = 0; i < orderedTypes.length; i++) {
    // Remove the target item
    sortedItem = takeItem(orderedTypes[i]);
    
    // Check if the item exists
    if (sortedItem != none) {
      // Place item into list at desired index
      itemList.insertItem(targetIndex, sortedItem);
      
      // Increment to next index
      targetIndex++;
    }
  }
}

/*=============================================================================
 * count()
 *
 * Returns the number of different item types in this package.
 *===========================================================================*/
public function int count() {
  return itemList.length;
}

/*=============================================================================
 * clear()
 *
 * Removes all items.
 *===========================================================================*/
public function clear() {
  itemList.length = 0;
}

/*============================================================================= 
 * Default Properties
 *===========================================================================*/
defaultProperties
{

}


















