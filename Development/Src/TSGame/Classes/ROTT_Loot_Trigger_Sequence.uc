/*=============================================================================
 * ROTT_Loot_Trigger_Sequence
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: Used to link a trigger to a chest object in kismet.
 *===========================================================================*/

class ROTT_Loot_Trigger_Sequence extends SequenceAction;

// Loot generation information
var(Loot) ROTT_Resource_Chest lootSource;

// Chest empty or not
var private bool chestEmpty;

/*=============================================================================
 * activated()
 *
 * Called when the kismet node recieves an impulse
 *===========================================================================*/
event activated() {
  // Skip looting process if transitioning to combat, or if empty
  if (ROTT_Game_Info(class'WorldInfo'.static.GetWorldInfo().game).bEncounterActive || chestEmpty) return;
  
  // Use target or specified source
  if (ROTT_Resource_Chest(targets[0]) != none && lootSource == none) {
    lootSource = ROTT_Resource_Chest(targets[0]);
  }
  
  // Open the chest
  lootSource.openChest();
  
  // Empty the chest
  chestEmpty = true;
}

/*=============================================================================
 * Default properties
 *===========================================================================*/
defaultproperties
{
	ObjName="OpenChest"
	ObjCategory="ROTT" 
	
	bCallHandler=false
}