/*=============================================================================
 * Player Profile
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This is essentially a saved game profile, containing all
 *              of a players progress in the game.
 *===========================================================================*/

class ROTT_Game_Player_Profile extends ROTTObject
dependsOn(ROTT_NPC_Container)
dependsOn(ROTT_Descriptor_Enchantment_List);

// Username, name of the profile
var privatewrite string username;

// Game modes
enum GameModes {
  MODE_CASUAL,
  MODE_HARDCORE,
  MODE_TOUR,
};

// Username, name of the profile
var privatewrite GameModes gameMode;

// Elapsed game time (excluding load times)
var privatewrite float elapsedPlayTime;

// Milestones for speedruns
enum SpeedRunMilestones {
  MILESTONE_AZRA_KOTH,
  MILESTONE_HYRIX,
  MILESTONE_KHOMAT,
  MILESTONE_VILIROTH,
  MILESTONE_TYTHIZERUS,
};

// Status for tracking milestone progress
enum MilestoneStatus {
  MILESTONE_INCOMPLETE,
  MILESTONE_JUST_COMPLETED,
  MILESTONE_FINISHED
};

// Data for a single milestone
struct MilestoneInfo {
  var MilestoneStatus status;
  var bool bPersonalBest;
  var float milestoneTime;
  var string milestoneDescription;
  var string milestoneTimeFormatted;
};

// Stores all milestone information for this profile
var privatewrite MilestoneInfo milestoneList[SpeedRunMilestones];

// Stores save data, to access actual variable use getNumberOfParties()
var private int numberOfParties;

// The party controlled by the player is at this index
var public byte activePartyIndex;

// Units controlled by player
var privatewrite ROTT_Party_System partySystem;   

// Players items (inventory items)
var privatewrite ROTT_Inventory_Package_Player playerInventory;   
var privatewrite int savedItemCount;   
var privatewrite class<ROTT_Inventory_Item> firstSavedItemType;   /// head of linked list, the rest is in each item

// Portals unlocked by player
var privatewrite PortalState mapLocks[MapNameEnum];  

// Enchantment levels from minigames
var public int enchantmentLevels[EnchantmentEnum];  

// Profile data
var public int totalGoldEarned;
var public int totalGemsEarned;
var public int encounterCount;
var public float timeTemporallyAccelerated;

// Enchantment data
///var privatewrite ROTT_Descriptor_Enchantment_List enchantmentData;

//==================================================//


// Player's action toward conflict
enum ConflictStatus {
  NOT_STARTED,
  ACTION_TAKEN,
  ACTION_SKIPPED
};

// Conflict information storage
struct ConflictInfo {
  var TopicList topicIndex;
  var ConflictStatus status;
  var bool bReversed;
};

var privatewrite array<ConflictInfo> conflictData;

// NPC information for active topics for conversation
enum TopicStatus {
  INACTIVE,
  ACTIVE
};

// A list of 
var privatewrite TopicStatus activeTopics[TopicList];

// Topic history information
enum TopicHistory {
  NOT_DISCUSSED,
  REPLIED,
  COMPLETED
};

// History status for all topics for a single npc
struct NpcHistoryRecord {
  var TopicHistory npcTopicHistory[TopicList];
};

// A list of dialog records for every npc
var privatewrite NpcHistoryRecord npcRecords[NPCs];


//==================================================//

// Portal destination checkpoint
var public int arrivalCheckpoint;

// Secrets
var public bool hyperUnlocked;

// Time tracking
var public bool bTrackTime;

// UI Preferences
var public bool showOverworldDetail;

// Activity statuses
var public bool bPraying;
var public bool bSinging;

// Cheats
var public bool cheatNoEncounters;
var public bool cheatManaSkip;
var public bool cheatInvincibility;

/*=============================================================================
 * newGameSetup
 * 
 * Description: This function is called for new games
 *===========================================================================*/
public function newGameSetup(byte newGameMode) {
  // Make party System
  partySystem = new(self) class'ROTT_Party_System';
  partySystem.initSystem();
  
  // Make inventory
  playerInventory = new(self) class'ROTT_Inventory_Package_Player';
  playerInventory.linkReferences();
  
  // Portal system
  initNewGamePortals();
  
  // Set initial event progress (enables NPC greetings)
  activateTopic(INTRODUCTION);
  
  // Set game mode
  setGameMode(GameModes(newGameMode));
}

/*=============================================================================
 * setGameMode()
 *
 * Sets a game mode, should remain unchanged.
 *===========================================================================*/
public function setGameMode(GameModes newGameMode) {
  gameMode = newGameMode;
  
  switch (gameMode) {
    case MODE_CASUAL:
      break;
    case MODE_HARDCORE:
      // Add luck boost
      enchantmentLevels[OMNI_SEEKER] = 10;
      break;
    case MODE_TOUR:
      // Disable encounters
      /// Feature implemented through game mode
      break;
  }
  
}

/*=============================================================================
 * toggleOverworldDetail()
 *
 * This function modifies the data for tracking overworld detail visibility.
 *===========================================================================*/
public function toggleOverworldDetail() {
  showOverworldDetail = !showOverworldDetail;
}

/*=============================================================================
 * elapseTime()
 *
 * This function is called every tick.
 *===========================================================================*/
public function elapseTime(float deltaTime) {
  if (bTrackTime) elapsedPlayTime += deltaTime / gameInfo.gameSpeed;
}

/*=============================================================================
 * formatMilestoneTime()
 *
 * Returns a formatted version of the current time
 *===========================================================================*/
private function formatMilestoneTime
(
  SpeedRunMilestones milestoneIndex, 
  float milestoneTime
) 
{
  local string formatted;
  
  // Get formatted time from milestone cookie
  formatted = gameInfo.milestoneCookie.formatMilestoneTime(milestoneTime);
  
  // Store time
  milestoneList[milestoneIndex].milestoneTimeFormatted = formatted;
}

/*=============================================================================
 * updateMilestone()
 *
 * This function is called to update milestone progress.
 *===========================================================================*/
public function updateMilestone
(
  SpeedRunMilestones milestoneIndex, 
  MilestoneStatus progress
) 
{
  // Check for valid progress
  if (milestoneList[mileStoneIndex].status < progress) {
    // Mark progress
    milestoneList[mileStoneIndex].status = progress;
    
    // Record time for completion
    if (progress == MILESTONE_FINISHED) {
      milestoneList[mileStoneIndex].milestoneTime = elapsedPlayTime;
      formatMilestoneTime(mileStoneIndex, elapsedPlayTime);
      
      // Check for personal best
      if (gameInfo.recordMilestone(mileStoneIndex, elapsedPlayTime)) {
        milestoneList[mileStoneIndex].bPersonalBest = true;
      }
    }
  } else {
    yellowLog("Warning (!) Invalid progress for milestone");
  }
}

/*=============================================================================
 * processPendingMilestone()
 *
 * Returns a pending milestone if one can be found.
 *===========================================================================*/
public function bool processPendingMilestone(out MilestoneInfo milestone) {
  local int i;
  
  // Scan for milestone updates
  for (i = 0; i < SpeedRunMilestones.enumCount; i++) {
    if (milestoneList[i].status == MILESTONE_JUST_COMPLETED) {
      // Update milestone progress in profile
      updateMilestone(
        SpeedRunMilestones(i), 
        MILESTONE_FINISHED
      );
      
      // Set out milestone argument
      milestone = milestoneList[i];
      return true;
    }
  }
  return false;
}

/*=============================================================================
 * findItem()
 *
 * This function just shortens the path for finding items.
 *===========================================================================*/
public function ROTT_Inventory_Item findItem(class<ROTT_Inventory_Item> itemClass) {
  return playerInventory.findItem(itemClass);
}

/*=============================================================================
 * addCurrency()
 *
 * Used to add currencies or shrine items (independent from drop level info)
 *===========================================================================*/
public function addCurrency
(
  class<ROTT_Inventory_Item> itemClass, 
  int amount, 
  optional bool bSkipCurrencyUpdate = false
) 
{
  local ROTT_Inventory_Item item;

  // Create item
  item = new itemClass;
  item.initialize();
  item.setQuantity(amount);
  
  // Move item to inventory
  playerInventory.addItem(item);
  
  if (bSkipCurrencyUpdate) return;
}

/*=============================================================================
 * canDeductItem()
 *
 * Checks if an item can be deducted.  Returns true if sufficient items.
 *===========================================================================*/
public function bool canDeductItem(ItemCost cost) {
  if (cost.quantity < 0) {
    yellowLog("Warning (!) Cost is negative?");
    return false;
  }
  
  // Return true if cost is zero
  if (cost.quantity == 0) return true;
  
  // Return false if the item is not in inventory
  if (findItem(cost.currencyType) == none) return false;
  
  // Check if item quantity is sufficient
  return cost.quantity <= findItem(cost.currencyType).quantity;
}
 
/*=============================================================================
 * deductItem()
 *
 * Subtracts a quantity cost from the inventory if sufficient funds.
 * Returns true if sufficient funds, false if insufficient.
 *===========================================================================*/
public function bool deductItem(ItemCost costInfo) {
  // Check if we can deduct this cost
  if (!canDeductItem(costInfo)) return false;
  
  // Deduct cost from inventory
  return playerInventory.deductItem(costInfo);
}

/*=============================================================================
 * nameProfile()
 *
 * Sets a name for this profile
 *===========================================================================*/
public function nameProfile(string profileName) {
  username = profileName;
}
 
/*=============================================================================
 * These references must be linked after GUI initialization events
 *===========================================================================*/
public function linkGUIReferences(ROTT_UI_Scene_Manager sceneMgr) {
  super.linkGUIReferences(sceneMgr);
  
  // Pass down references all children
  `assert(isRefComplete() == true);
  
  // # here we want to copy scene manager reference down?
}

/*============================================================================= 
 * saveGame()
 *
 * Description: Saves each child component of the player profile
 * (See ROTT_Game_Info.saveGame())
 *===========================================================================*/
public function saveGame
(
  optional bool transitionMode = false, 
  optional int arrivalIndex = -1
) 
{
  local ROTT_Combat_Hero heroUnit;
  local ROTT_Party party;
  local string folder;
  local int i, j;
  
  // Set arrival checkpoint
  arrivalCheckpoint = arrivalIndex;
  
  // Get file path
  folder = (transitionMode == true) ? "temp" : "save";
  
  // Save items
  savedItemCount = playerInventory.count();
  if (playerInventory.count() > 0) firstSavedItemType = playerInventory.itemList[0].class;
  
  for (i = 0; i < playerInventory.count(); i++) {
    // Store item types
    if (i+1 < playerInventory.count()) {
      playerInventory.itemList[i].nextSavedItemType = playerInventory.itemList[i+1].class;
    }
    
    // Save item
    class'Engine'.static.BasicSaveObject(playerInventory.itemList[i], folder $ "\\items\\item[" $ i $ "].bin", true, 0);
  }
  
  // Save number of parties for load procedure
  numberOfParties = partySystem.getNumberOfParties();
  activePartyIndex = partySystem.activePartyIndex;
  
  // Save parties and heroes
  for (i = 0; i < partySystem.getNumberOfParties(); i++) {
    // Get party
    party = partySystem.getParty(i);
    party.prepareSaveInfo();
    
    // Save Party
    class'Engine'.static.BasicSaveObject(party, folder $ "\\party[" $ i $ "].bin", true, 0);
    
    for (j = 0; j < party.getPartySize(); j++) {
      // Get hero
      heroUnit = party.getHero(j);
      
      // Save hero
      class'Engine'.static.BasicSaveObject(heroUnit, folder $ "\\hero[" $ i $ "][" $ j $ "].bin", true, 0);
    }
  }
}

/*============================================================================= 
 * loadGame()
 *
 * Description: Saves each child component of the player profile
 * (See ROTT_Game_Info.saveGame())
 *===========================================================================*/
public function loadGame(optional bool transitionMode = false) {
  local ROTT_Party party;
  local ROTT_Combat_Hero tempHero;
  local ROTT_Inventory_Item tempItem;
  local string path;
  local string folder;
  local int i, j; 
  
  folder = (transitionMode == true) ? "temp" : "save";
  
  // Reset player inventory
  playerInventory = new(self) class'ROTT_Inventory_Package_Player';
  playerInventory.linkReferences();
  
  // Load player items
  for (i = 0; i < savedItemCount; i++) {
    if (i == 0) {
      // Load first item type
      tempItem = new(self) firstSavedItemType;
    } else {
      tempItem = new(self) tempItem.nextSavedItemType;
    }
    // Load item from memory
    class'Engine'.static.BasicLoadObject(tempItem, folder $ "\\items\\item[" $ i $ "].bin", true, 0);
    tempItem.initialize();
    
    // Store item to inventory
    playerInventory.loadItem(tempItem);
  }
  
  // Load party system 
  partySystem = new(self) class'ROTT_Party_System';
  
  // Load all parties
  for (i = 0; i < numberOfParties; i++) { 
    // Load party info
    party = new(partySystem) class'ROTT_Party';
    path = folder $ "\\party[" $ i $ "].bin";
    
    // Load a party
    if (class'Engine'.static.BasicLoadObject(party, path, true, 0)) {
      
      // Reset data structures (remove bad pointers from save file?)
      party.initialize(i);
      
      // Place party into profile
      partySystem.loadParty(party);

      // Load all party members
      for (j = 0; j < party.saveInfoPartySize; j++) { 
        // Load a hero
        tempHero = new(party) party.heroSaveTypes[j];
        path = folder $ "\\hero[" $ i $ "][" $ j $ "].bin";
  
        if (class'Engine'.static.BasicLoadObject(tempHero, path, true, 0)) {
          partySystem.getParty(i).loadHero(tempHero);
        }
      }
    }
  }
  
  debugProfileDump();
  
  // Set active party
  partySystem.setActiveParty(activePartyIndex);
}

/*============================================================================= 
 * setEventStatus()
 *
 * This function sets the status for an event
 *===========================================================================*/
public function setEventStatus(TopicList topic, ConflictStatus status) {
  local ConflictInfo info;
  local int i;
  
  // Check for invalid topics
  switch (topic) {
    case INTRODUCTION:
    case ETZLAND_HERO:
    case END_OF_ACTIVATED_TOPICS:
    case INQUERY_MODE:
    case INQUERY_OBELISK:
    case INQUERY_TOMB:
    case INQUERY_GOLEM:
    case GREETING:
      yellowLog("Warning (!) Cannot set event info for topic: " $ topic);
      return;
  }
  
  // Scan through events
  for (i = 0; i < conflictData.length; i++) {
    // If it already exists, flip the reverse value
    if (conflictData[i].topicIndex == topic) {
      // Reverse status
      /// problematic: this should only happen once per map
      conflictData[i].bReversed = !conflictData[i].bReversed;
      
      // Flip status
      if (conflictData[i].status == ACTION_TAKEN) {
        conflictData[i].status = ACTION_SKIPPED;
      } else {
        conflictData[i].status = ACTION_TAKEN;
      }
      return;
    }
  }
  
  // Add to new info to the list if it wasnt found before
  info.topicIndex = topic;
  info.status = status;
  conflictData.addItem(info);
}

/*============================================================================= 
 * getEventStatus()
 *
 * This function returns the status of a given event
 *===========================================================================*/
public function ConflictStatus getEventStatus(TopicList topic) {
  local int i;
  
  // Scan through events
  for (i = 0; i < conflictData.length; i++) {
    // Check if topic matches event data
    if (conflictData[i].topicIndex == topic) {
      return conflictData[i].status;
    }
  }
  
  return NOT_STARTED;
}

/*============================================================================= 
 * healActiveParty
 *
 * Description: This function heals the active party
 *
 * Usage: From 3D world only?
 *===========================================================================*/
public function healActiveParty() {
  partySystem.getActiveParty().restoreAll();
  sfxBox.playSFX(SFX_WORLD_SHRINE);
  gameInfo.showGameplayNotification("You have been healed");
}

/*=============================================================================
 * getHeroCount()
 *
 * Returns the number of heros
 *===========================================================================*/
public function int getHeroCount() {
  local int i, heroCount;
  
  for (i = 0; i < partySystem.getNumberOfParties(); i++) {
    heroCount += partySystem.getParty(i).getPartySize();
  }
  
  return heroCount;
}

/*=============================================================================
 * getTotalBossesSlain()
 *
 * 
 *===========================================================================*/
public function int getTotalBossesSlain() {
  local int i, slayCount;
  
  for (i = 0; i < partySystem.getNumberOfParties(); i++) {
    slayCount += partySystem.getParty(i).getTotalBossesSlain();
  }
  
  return slayCount;
}

/*=============================================================================
 * getTotalMonstersSlain()
 *
 * 
 *===========================================================================*/
public function int getTotalMonstersSlain() {
  local int i, slayCount;
  
  for (i = 0; i < partySystem.getNumberOfParties(); i++) {
    slayCount += partySystem.getParty(i).getTotalMonsersSlain();
  }
  
  return slayCount;
}

/*=============================================================================
 * getEncounterCount()
 *
 * 
 *===========================================================================*/
public function int getEncounterCount() {
  return encounterCount;
}

/*=============================================================================
 * getTotalGemsEarned()
 *
 * 
 *===========================================================================*/
public function int getTotalGemsEarned() {
  return totalGemsEarned;
}

/*=============================================================================
 * getTotalGoldEarned()
 *
 * 
 *===========================================================================*/
public function int getTotalGoldEarned() {
  return totalGoldEarned;
}

/*=============================================================================
 * getNumberOfParties()
 *
 * Returns the number of parties on this profile
 *===========================================================================*/
public function int getNumberOfParties() {
  return partySystem.getNumberOfParties();
}


/**============================================================================= 
 * getDialogStart
 *
 * Returns the index for an event which the npc wishes to discuss with the
 * player.
 *===========================================================================
public function EventList getDialogStart(NPCs targetNPC) { 
  local int i;
  
  ///cyanlog("  Checking events & player progress");
  for (i = 0; i < EventList.EnumCount; i++) {
    ///cyanlog("   Checking if " $ targetNPC $ " is ready to talk about " $ string(i));
    // Check if this conversation has already happened
    if (npcInteractions[targetNPC].dialogueProgress[i] == NOT_STARTED) {
      ///cyanlog("   " $ npcInteractions[targetNPC].dialogueProgress[i]);
      ///cyanlog("   " $ playerEvents[i]);
      // Check if the event is ready to be discussed
      if (playerEvents[i] != NOT_STARTED) {
        ///cyanlog("    " $ targetNPC $ " is ready to talk about " $ EventList(i));
        return EventList(i);
      }
    }
  }
  
  return SKIP_ALL_EVENTS;
}
*/
/*============================================================================= 
 * resetTopic()
 *
 * This is used to make greetings repeat
 *===========================================================================*/
public function resetTopic(NPCs npcName, TopicList topic) {
  npcRecords[npcName].npcTopicHistory[topic] = NOT_DISCUSSED;
}

/*============================================================================= 
 * completeTopic()
 *
 * This is used to progress through topics
 *===========================================================================*/
public function completeTopic(NPCs npcName, TopicList topic) {
  // Never save inquiry progress
  if (topic == INQUERY_MODE) return;
  
  npcRecords[npcName].npcTopicHistory[topic] = COMPLETED;
}

/*============================================================================= 
 * activateTopic()
 *
 * Used to flag a topic for discussion with NPCs
 *===========================================================================*/
public function activateTopic(TopicList topic) {
  activeTopics[topic] = ACTIVE;
}

/*=============================================================================
 * toggleEventStatus()
 *
 * Switches the state of a monument shrine when the player activates a ritual.
 *===========================================================================*/
public function bool toggleEventStatus(TopicList targetTopic) {
  local bool bMonumentWasActive;
  
  // Get monument status
  bMonumentWasActive = getEventStatus(targetTopic) == ACTION_TAKEN;
  
  if (bMonumentWasActive) {
    // Set event to inactive
    setEventStatus(targetTopic, ACTION_SKIPPED);
  } else {
    // Set event to activated
    setEventStatus(targetTopic, ACTION_TAKEN);
  }
  
  // Return current state
  return !bMonumentWasActive;
}

/*============================================================================= 
 * getEnchantBoost()
 *
 * Returns the bonus provided by the given enchantment
 *===========================================================================*/
public function int getEnchantBoost(coerce byte enchantmentIndex) {
  local int bonus;
  
  bonus = enchantmentLevels[enchantmentIndex];
  bonus *= class'ROTT_Descriptor_Enchantment_List'.static.getEnchantment(enchantmentIndex).bonusPerLevel;
  
  return bonus;
}

/*============================================================================= 
 * initNewGamePortals()
 *
 * Description: initializes the map lock system for a new game
 *===========================================================================*/
public function initNewGamePortals() {
  // Open portals by default
  setPortalUnlocked(MAP_TALONOVIA_TOWN);
  setPortalUnlocked(MAP_RHUNIA_WILDERNESS);
  
  // Placeholder maps
  setPortalUnlocked(MAP_TALONOVIA_SHRINE);
}

/*============================================================================= 
 * setPortalUnlocked()
 *
 * Description: Unlocks a portal
 *===========================================================================*/
public function setPortalUnlocked(MapNameEnum unlockMap) {
  mapLocks[unlockMap] = GATE_OPEN;
}

/*============================================================================= 
 * getActiveParty()
 *
 * Description: returns the party that is currently controlled by the player
 *===========================================================================*/
public function ROTT_Party getActiveParty() {
  return partySystem.getActiveParty();
}

/*============================================================================= 
 * unlockAllPortals()
 *
 * This is a cheat that opens all portals
 *===========================================================================*/
public function unlockAllPortals() {
  local int i;
  
  for (i = 0; i < arrayCount(mapLocks); i++) {
    mapLocks[i] = GATE_OPEN;
  }
}

/*============================================================================= 
 * debugProfileDump
 *
 * Description: This function shows all the parties and heroes in the profile
 *===========================================================================*/
private function debugProfileDump() {
  local int i;
  local int j;
  
  grayLog("Player profile:", DEBUG_PLAYER_PROFILE);
  for (i = 0; i < partySystem.getNumberOfParties(); i++) {
    greenlog(" Team #" $ i, DEBUG_PLAYER_PROFILE);
    for (j = 0; j < partySystem.getParty(i).getPartySize(); j++) {
      darkgreenlog("  Hero["$j$"]: " $ partySystem.getParty(i).getHero(j).myClass, DEBUG_PLAYER_PROFILE);
    }
  }
  grayLog(" ", DEBUG_PLAYER_PROFILE);
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  // Portal checkpoint
  arrivalCheckpoint=-1
  
  // Milestone notification info
  milestoneList(MILESTONE_AZRA_KOTH)=(milestoneDescription="Az'ra Koth defeated")
  milestoneList(MILESTONE_HYRIX)=(milestoneDescription="Hyrix defeated")
  milestoneList(MILESTONE_KHOMAT)=(milestoneDescription="Khomat defeated")
  milestoneList(MILESTONE_VILIROTH)=(milestoneDescription="Viliroth defeated")
  milestoneList(MILESTONE_TYTHIZERUS)=(milestoneDescription="Tythizerus defeated")
}


















