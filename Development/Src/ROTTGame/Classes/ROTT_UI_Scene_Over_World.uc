/*=============================================================================
 * ROTT_UI_Scene_Over_World
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This scene is displayed while the player roams through various
 * 3D worlds.
 *===========================================================================*/

class ROTT_UI_Scene_Over_World extends ROTT_UI_Scene;

// Page references
var privatewrite ROTT_UI_Page_Over_World overWorldPage;
var privatewrite ROTT_UI_Page_Chest chestPage;
var privatewrite ROTT_UI_Page_Messaging messagingPage;
var privatewrite ROTT_UI_Page_Shrine_Notification shrineNotificationPage;
var privatewrite ROTT_UI_Page_Shrine_Options shrineOptionsPage;

// Respawn transition
var privatewrite ROTT_UI_Page_Transition respawnTransitionPageIn;
var privatewrite ROTT_UI_Page_Transition respawnTransitionPageOut;

// Combat transition
var privatewrite ROTT_UI_Page_Transition transitionToCombat;

// Npc transition
var privatewrite ROTT_UI_Page_Transition transitionToNPC;
var privatewrite ROTT_UI_Page_Transition transitionFromNPC;

// Door portal
var privatewrite ROTT_UI_Page_Transition transitionDoorPortal;

// Combat Npc prelude transition
var privatewrite ROTT_UI_Page_Transition transitionToPreludeNPC;

// Portal transition
var privatewrite ROTT_UI_Page_Transition portalPage;

// Respawn transition delay
var private float respawnTransDelay; 

/*=============================================================================
 * initScene()
 *
 * Called when this scene is created
 *===========================================================================*/
event initScene() {
  // References
  overWorldPage = ROTT_UI_Page_Over_World(findComp("Page_Over_World"));
  chestPage = ROTT_UI_Page_Chest(findComp("Page_Chest_Interface"));
  messagingPage = ROTT_UI_Page_Messaging(findComp("Page_Messaging"));
  shrineNotificationPage = ROTT_UI_Page_Shrine_Notification(findComp("Page_Shrine_Notification"));
  shrineOptionsPage = ROTT_UI_Page_Shrine_Options(findComp("Page_Shrine_Options"));
  
  // Transition references
  respawnTransitionPageIn = ROTT_UI_Page_Transition(findComp("Page_Respawn_Transition_In"));
  respawnTransitionPageOut = ROTT_UI_Page_Transition(findComp("Page_Respawn_Transition_Out"));
  transitionToCombat = ROTT_UI_Page_Transition(findComp("Page_Combat_Transition"));
  transitionDoorPortal = ROTT_UI_Page_Transition(findComp("Page_Door_Portal_Enter"));
  transitionToNPC = ROTT_UI_Page_Transition(findComp("Page_NPC_Transition_Away"));
  transitionFromNPC = ROTT_UI_Page_Transition(findComp("Page_NPC_Transition_Back"));
  transitionToPreludeNPC = ROTT_UI_Page_Transition(findComp("Page_Prelude_NPC_Transition_Away"));
  portalPage = ROTT_UI_Page_Transition(findComp("Page_Portal_Transition"));
  
  super.initScene();
  
  // Push initial stack
  pushPage(overWorldPage);
  gameInfo.pauseGame();
}

/*=============================================================================
 * loadScene()
 *
 * Called when switching to this scene
 *===========================================================================*/
event loadScene() {
  super.loadScene();
}

/*=============================================================================
 * unloadScene()
 *
 * Called when switching to a different scene
 *===========================================================================*/
event unloadScene(){
  super.unloadScene();
  
  if (pageTagIsUp("Page_Shrine_Options")) popPage("Page_Shrine_Options");
}

/*=============================================================================
 * elapseTimer()
 *
 * Increments time every engine tick.
 *===========================================================================*/
public function elapseTimer(float deltaTime, float gameSpeedOverride) {
  if (respawnTransDelay > 0) {
    respawnTransDelay -= deltaTime;
    if (respawnTransDelay <= 0) respawnTransitionIn();
  }
}

/*=============================================================================
 * npcPreludeTransition()
 * 
 * Called when opening an npc dialog before combat
 *===========================================================================*/
public function npcPreludeTransition() {
  // World to NPC transition
  pushPage(transitionToPreludeNPC);
}

/*=============================================================================
 * npcExitTransition()
 * 
 * Called when exiting an NPC dialog
 *===========================================================================*/
public function npcExitTransition() {
  // Exit transition
  pushPage(transitionFromNPC, false);
}

/*=============================================================================
 * enableMessageMode()
 * 
 * This switches out from the normal over world hud to messaging mode.
 *===========================================================================*/
public function enableMessageMode() {
  // Show messaging UI
  pushPage(messagingPage);
}

/*=============================================================================
 * enableMonumentInterface()
 * 
 * This shows the monument interface.
 *===========================================================================*/
public function enableMonumentInterface(string textLine1, string textLine2) {
  // Show monumentInterface
  pushPage(shrineNotificationPage);
  shrineNotificationPage.setText(textLine1, textLine2);
}

/*=============================================================================
 * disableMonumentInterface()
 * 
 * This hides the monument interface.
 *===========================================================================*/
public function disableMonumentInterface() {
  popPage(shrineNotificationPage.tag);
}

/*=============================================================================
 * submitMessage()
 * 
 * This parses a players message for cheat codes and such.
 *===========================================================================*/
public function submitMessage(string message) {
  // Close page
  popPage();
  
  // Check for public commands
  if (parseCommand(message)) {
    gameInfo.showGameplayNotification("Command accepted");
    return;
  }
  
  // Check for public cheats
  if (parseCheat(message)) {
    gameInfo.showGameplayNotification("Cheat enabled");
    return;
  }
  
  // Check for dev cheats
  if (parseDevCheat(message)) {
    gameInfo.showGameplayNotification("Cheat enabled");
    return;
  }
  
  // Custom commands
  switch (message) {
    case "taylor":
      gameInfo.showGameplayNotification("7ay is bae");
      return;
    case "ghostgoats":
      gameInfo.showGameplayNotification("Ghost Goats rules");
      return;
    case "gdq":
      gameInfo.showGameplayNotification("Heck yeah");
      return;
  }
}

/*=============================================================================
 * parseCommand()
 * 
 * Returns true if the given message is a command, and executes the command.
 *===========================================================================*/
public function bool parseCommand(string message) {
  // Custom commands
  switch (message) {
    case "music on":
      gameInfo.jukeBox.setVolume(1.0);
      return true;
    case "music off":
      gameInfo.jukeBox.setVolume(0.0);
      return true;
    case "profile":
      // Shows graphic statistics
      gameInfo.consoleCommand("PROFILEGAME 10");
      return true;
    case "stat":
      // Shows graphic statistics
      gameInfo.consoleCommand("STAT D3D9RHI");
      return true;
  }
  
  // Report that this is not a command
  return false;
}

/*=============================================================================
 * parseCheat()
 * 
 * Returns true if the given message is a PUBLIC cheat, and enables it.
 *===========================================================================*/
public function bool parseCheat(string message) {
  // Custom commands
  switch (message) {
    case "the highwind calls my name":
      sceneManager.raveSelectors();
      return true;
    case "the highwind screams my name":
      sceneManager.raveMode();
      return true;
  }
  
  // Report that this is not a command
  return false;
}

/*=============================================================================
 * parseDevCheat()
 * 
 * Returns true if the given message is a dev-only cheat, and enables it.
 *===========================================================================*/
public function bool parseDevCheat(string message) {
  local ROTT_Party party;
  local ROTT_Combat_Hero hero;
  local int i;
  
  // Ignore dev cheats for public release mode
  if (!gameInfo.bDevMode) return false; 
  
  // Custom commands
  switch (message) {
    case "honk honk":
      // 3 level ups for all heroes
      party = gameInfo.playerProfile.getActiveParty();
      
      hero = party.getHero(0);
      hero.addExpByPercent(3.00);
      
      hero = party.getHero(1);
      if (hero != none) {
        hero.addExpByPercent(3.00);
      }
      
      hero = party.getHero(2);
      if (hero != none) {
        hero.addExpByPercent(3.00);
      }
      return true;
    case "chemical witchcraft":
      // Skip mana checks
      gameInfo.playerProfile.cheatManaSkip = !gameInfo.playerProfile.cheatManaSkip;
      return true;
    case "google krishna":
      // No enemy battles
      gameInfo.playerProfile.cheatNoEncounters = !gameInfo.playerProfile.cheatNoEncounters;
      return true;
    case "you cant unwom the pom":
      // Skip hero deaths
      gameInfo.playerProfile.cheatInvincibility = !gameInfo.playerProfile.cheatInvincibility;
      return true;
    case "anime no gf":
      // Add currency
      gameInfo.playerProfile.addCurrency(class'ROTT_Inventory_Item_Gold', 100000);
      gameInfo.playerProfile.addCurrency(class'ROTT_Inventory_Item_Gem', 100000);
      
      gameInfo.playerProfile.addCurrency(class'ROTT_Inventory_Item_Herb', 25);
      gameInfo.playerProfile.addCurrency(class'ROTT_Inventory_Item_Herb_Unjah', 25);
      gameInfo.playerProfile.addCurrency(class'ROTT_Inventory_Item_Herb_Saripine', 25);
      gameInfo.playerProfile.addCurrency(class'ROTT_Inventory_Item_Herb_Koshta', 25);
      gameInfo.playerProfile.addCurrency(class'ROTT_Inventory_Item_Herb_Xuvi', 25);
      gameInfo.playerProfile.addCurrency(class'ROTT_Inventory_Item_Herb_Zeltsi', 25);
      gameInfo.playerProfile.addCurrency(class'ROTT_Inventory_Item_Herb_Aquifinie', 25);
      gameInfo.playerProfile.addCurrency(class'ROTT_Inventory_Item_Herb_Jengsu', 25);
      gameInfo.playerProfile.addCurrency(class'ROTT_Inventory_Item_Charm_Myroka', 25);
      gameInfo.playerProfile.addCurrency(class'ROTT_Inventory_Item_Charm_Shukisu', 25);
      gameInfo.playerProfile.addCurrency(class'ROTT_Inventory_Item_Charm_Erazi', 25);
      gameInfo.playerProfile.addCurrency(class'ROTT_Inventory_Item_Charm_Cerok', 25);
      gameInfo.playerProfile.addCurrency(class'ROTT_Inventory_Item_Charm_Bayuta', 25);
      gameInfo.playerProfile.addCurrency(class'ROTT_Inventory_Item_Charm_Eluvi', 25);
      gameInfo.playerProfile.addCurrency(class'ROTT_Inventory_Item_Charm_Kamita', 25);
      gameInfo.playerProfile.addCurrency(class'ROTT_Inventory_Item_Bottle_Faerie_Bones', 10);
      gameInfo.playerProfile.addCurrency(class'ROTT_Inventory_Item_Bottle_Swamp_Husks', 10);
      gameInfo.playerProfile.addCurrency(class'ROTT_Inventory_Item_Bottle_Harrier_Claws', 10);
      gameInfo.playerProfile.addCurrency(class'ROTT_Inventory_Item_Bottle_Yinras_ore', 10);
      gameInfo.playerProfile.addCurrency(class'ROTT_Inventory_Item_Bottle_Nettle_Roots', 1);
      gameInfo.playerProfile.addCurrency(class'ROTT_Inventory_Item_Charm_Zogis_Anchor', 1);
      return true;
    case "she her for help":
      // Opens all portals
      gameInfo.playerProfile.unlockAllPortals();
      return true;
    case "feather melts tempo":
      // +1 to all enchantments
      for (i = 0; i < class'ROTT_Descriptor_Enchantment_List'.static.countEnchantmentEnum(); i++) {
        gameInfo.playerProfile.enchantmentLevels[i] += 5;
      }
      return true;
    case "new heart":
      // reset all enchantments
      for (i = 0; i < class'ROTT_Descriptor_Enchantment_List'.static.countEnchantmentEnum(); i++) {
        gameInfo.playerProfile.enchantmentLevels[i] = 0;
      }
      return true;
  }
  
  // Report that this is not a dev cheat
  return false;
}

/*=============================================================================
 * combatTransition()
 * 
 * This pushes an effect to transition into combat
 *===========================================================================*/
public function combatTransition() {
  // Transition
  pushPage(transitionToCombat, true); /// why would we want to push unfocused?
}

/*=============================================================================
 * portalTransition()
 * 
 * This pushes an effect to transition through a portal
 *===========================================================================*/
public function portalTransition(string mapName) {
  local int i;
  
  // Prevent doubling transition pages
  for (i = 0; i < pageStack.length; i++) {
    if (pageStack[i] == portalPage) return;
  }
  portalPage.destinationWorld = mapName;
  pushPage(portalPage);
}

/*=============================================================================
 * onPlayerFall()
 * 
 * Called when the player falls off the map.
 *===========================================================================*/
public function onPlayerFall() {
  pushPage(respawnTransitionPageOut); ///, false);
  sfxBox.playSFX(SFX_WORLD_FALLING);
}

/*=============================================================================
 * fadeIn()
 * 
 * This effect is called after combat
 *===========================================================================*/
public function fadeIn() {
  // World fade in
  overWorldPage.fadeInWorld();
  
  // Pause game
  gameInfo.pauseGame();
  
  // Chest ui
  pushPage(chestPage);
  
  // Transfer mob bounty
  chestPage.setItems(gameInfo.enemyEncounter.itemPackage);
  
  // Delete mob
  gameInfo.enemyEncounter = none;
}

/*=============================================================================
 * updateCurrency()
 * 
 * This immediately updates the overworld HUD to the given values.
 *===========================================================================*/
public function updateCurrency(int gold, int gems) { 
  overWorldPage.updateCurrency(gold, gems);
}

/*=============================================================================
 * updateHeroesStatus()
 * 
 * This updates hero display info, like health and mana
 *===========================================================================*/
public function updateHeroesStatus() { 
  if (overWorldPage == none) return;
  
  // Update overworld HUD 
  overWorldPage.updateHeroesStatus();
}

/*=============================================================================
 * transitionCompletion()
 *
 * Called by a transition page when it completes a transition animation
 *===========================================================================*/
public function transitionCompletion(string tag) {
  switch (tag) {
    case "Page_Respawn_Transition_Out":
      // Black out the screen
      UI_Sprite(findComp("World_Black_Screen")).setEnabled(true);
      
      // Respawn player
      gameInfo.tempestPawn.respawnPlayer();
      gameInfo.pauseGame();
      
      // Start timer delay for transitioning back in
      respawnTransDelay = 0.5;
      break;
    case "Page_NPC_Transition_Away":
    case "Page_Prelude_NPC_Transition_Away":
      // NPC launching delegate
      gameInfo.queuedNPC();
    case "Page_Door_Portal_Enter":
      // Move player to new checkpoint
      ///gameInfo.tempestPawn.respawnPlayer();
      break;
  }
}

/*=============================================================================
 * startDoorTransition()
 *
 * Called to pull up the transition for entering a door.
 *===========================================================================*/
public function startDoorTransition() {
  local int i;
  
  for (i = 0; i < pageStack.length; i++) {
    // Page is already up
    if (pageStack[i] == transitionDoorPortal) {
      return;
    }
  }
  
  pushPage(transitionDoorPortal);
  // on complete: gameInfo.tempestPawn.respawnPlayer();
}

/*=============================================================================
 * startTransitionToNPC()
 *
 * Called from NPC volumes to trigger a transfer into npc scene
 *===========================================================================*/
public function startTransitionToNPC() {
  local int i;
  
  for (i = 0; i < pageStack.length; i++) {
    // Page is already up
    if (pageStack[i] == transitionToNPC) {
      return;
    }
  }
  
  pushPage(transitionToNPC);
}

/*=============================================================================
 * respawnTransitionIn()
 *
 * Called when the respawn transition should start
 *===========================================================================*/
private function respawnTransitionIn() {
  // Remove black screen
  UI_Sprite(findComp("World_Black_Screen")).setEnabled(false);
  
  // Add transition effect
  pushPage(respawnTransitionPageIn, false);
  
  // Unfreeze player controls
  gameInfo.respawnTransitionIn();
}

/*=============================================================================
 * deleteScene()
 *
 * Deletes scene references for garbage collection
 *===========================================================================*/
public function deleteScene() {
  super.deleteScene();
  
  overWorldPage = none;
  messagingPage = none;
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties 
{
  // Allow controls
  bAllowOverWorldControl=true
  
  // Never show cursor if true
  bHideCursorOverride=true
  
  // Over World Page
  begin object class=ROTT_UI_Page_Over_World Name=Page_Over_World
    tag="Page_Over_World"
    bEnabled=false
  end object
  pageComponents.add(Page_Over_World)

  // Chest Interface page
  begin object class=ROTT_UI_Page_Chest Name=Page_Chest_Interface
    tag="Page_Chest_Interface"
    bEnabled=false
  end object
  pageComponents.add(Page_Chest_Interface)

  // Messaging page
  begin object class=ROTT_UI_Page_Messaging Name=Page_Messaging
    tag="Page_Messaging"
    bEnabled=false
  end object
  pageComponents.add(Page_Messaging)
  
  // Monument interface page
  begin object class=ROTT_UI_Page_Shrine_Notification Name=Page_Shrine_Notification
    tag="Page_Shrine_Notification"
    bEnabled=false
  end object
  pageComponents.add(Page_Shrine_Notification)
  
  // Shrine options page
  begin object class=ROTT_UI_Page_Shrine_Options Name=Page_Shrine_Options
    tag="Page_Shrine_Options"
    bEnabled=false
  end object
  pageComponents.add(Page_Shrine_Options)

  // Combat Transition Page
  begin object class=ROTT_UI_Page_Transition Name=Page_Combat_Transition
    tag="Page_Combat_Transition"
    bEnabled=false
    bConsumeInput=true
    
    effectConfig=OUT_FROM_OVER_WORLD_TRANSITION
    
    // Destination
    destinationScene=SCENE_COMBAT_ENCOUNTER
  end object
  pageComponents.add(Page_Combat_Transition)

  // NPC Transition page (back to world)
  begin object class=ROTT_UI_Page_Transition Name=Page_NPC_Transition_Back
    tag="Page_NPC_Transition_Back"
    bEnabled=false
    
    // Transition speed
    tilesPerTick=8
    
    // Sorter effect config
    effectConfig=NPC_TRANSITION_IN
    
    // Destination
    destinationScene=NO_SCENE
  end object
  pageComponents.add(Page_NPC_Transition_Back)
  
  // NPC Transition page (away from world)
  begin object class=ROTT_UI_Page_Transition Name=Page_NPC_Transition_Away
    tag="Page_NPC_Transition_Away"
    bEnabled=false
    
    // Transition speed
    tilesPerTick=12
    
    // Sorter effect config
    effectConfig=NPC_TRANSITION_OUT
    
    // Destination
    destinationScene=NO_SCENE
  end object
  pageComponents.add(Page_NPC_Transition_Away)
  
  // NPC Prelude transition page (away from world)
  begin object class=ROTT_UI_Page_Transition Name=Page_Prelude_NPC_Transition_Away
    tag="Page_Prelude_NPC_Transition_Away"
    bEnabled=false
    
    effectConfig=OUT_FROM_OVER_WORLD_TRANSITION
    
    // Destination
    destinationScene=NO_SCENE
  end object
  pageComponents.add(Page_Prelude_NPC_Transition_Away)
  
  // Respawn Transition Page (out)
  begin object class=ROTT_UI_Page_Transition Name=Page_Respawn_Transition_Out
    tag="Page_Respawn_Transition_Out"
    bEnabled=false
    tilesPerTick=20
    
    // Sorter effect config
    effectConfig=RESPAWN_START_TRANSITION
    
    // Destination
    destinationScene=NO_SCENE
  end object
  pageComponents.add(Page_Respawn_Transition_Out)

  // Respawn Transition Page (in)
  begin object class=ROTT_UI_Page_Transition Name=Page_Respawn_Transition_In
    tag="Page_Respawn_Transition_In"
    bEnabled=false
    tilesPerTick=20
    
    // Sorter effect config
    effectConfig=RESPAWN_END_TRANSITION
    
    // Destination
    destinationScene=NO_SCENE
  end object
  pageComponents.add(Page_Respawn_Transition_In)

  // NPC Transition page (away from world)
  begin object class=ROTT_UI_Page_Transition Name=Page_Door_Portal_Enter
    tag="Page_Door_Portal_Enter"
    bEnabled=false
    bConsumeInput=false
    
    // Transition speed
    tilesPerTick=20
    
    // Sorter effect config
    effectConfig=DOOR_PORTAL_TRANSITION_OUT
    
    // Destination
    destinationScene=NO_SCENE
  end object
  pageComponents.add(Page_Door_Portal_Enter)
  
  
  // Portal Transition Page
  begin object class=ROTT_UI_Page_Transition Name=Page_Portal_Transition
    tag="Page_Portal_Transition"
    bEnabled=false
    bUseColor=true
    tilesPerTick=10
    
    // Sorter effect config
    effectConfig=PORTAL_TRANSITION
    
    // Destination
    destinationScene=NO_SCENE
  end object
  pageComponents.add(Page_Portal_Transition)

  // Black Texture
  begin object class=UI_Texture_Info Name=Black_Texture
    componentTextures.add(Texture2D'GUI.Black_Square')
  end object
  
  // Black screen 
  begin object class=UI_Sprite Name=World_Black_Screen
    tag="World_Black_Screen"
    bEnabled=false
    posX=0
    posY=0
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    images(0)=Black_Texture
    bMandatoryScaleToWindow=true
  end object
  uiComponents.add(World_Black_Screen)
  
}










