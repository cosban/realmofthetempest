/*=============================================================================
 * ROTT_UI_Scene_Combat_Encounter
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This scene displays a combat scenario.
 *===========================================================================*/

class ROTT_UI_Scene_Combat_Encounter extends ROTT_UI_Scene;

// Page references
var privatewrite ROTT_UI_Page_Combat_Encounter combatPage;
var privatewrite ROTT_UI_Page_Combat_Glyph_Grid glyphPage;
var privatewrite ROTT_UI_Page_Combat_Action_Panel actionsPanel;
var privatewrite ROTT_UI_Page_Combat_Targeting targetingPage;
var privatewrite ROTT_UI_Page_Transition transitionPage;
var privatewrite ROTT_UI_Page_Transition transitionPageOut;

// begin battle delay
var private ROTTTimer combatDelay;  // Delay before combat starts
var private ROTTTimer outDelay;     // Delay during victory transition
var privatewrite bool bPaused;

/*=============================================================================
 * initScene()
 *
 * Called when this scene is created
 *===========================================================================*/
event initScene() {
  // References
  combatPage = ROTT_UI_Page_Combat_Encounter(findComp("Page_Combat_Encounter"));
  glyphPage = ROTT_UI_Page_Combat_Glyph_Grid(findComp("Page_Glyph_Grid"));
  actionsPanel = ROTT_UI_Page_Combat_Action_Panel(findComp("Page_Action_Panel"));
  targetingPage = ROTT_UI_Page_Combat_Targeting(findComp("Page_Targeting"));
  transitionPage = ROTT_UI_Page_Transition(findComp("Page_Transition_In"));
  transitionPageOut = ROTT_UI_Page_Transition(findComp("Page_Transition_Out"));
  
  super.initScene();
  pushPage(combatPage); /// ? 
}

/*=============================================================================
 * loadScene()
 *
 * Called every time the scene is opened (AKA "switched to")
 *===========================================================================*/
event loadScene() {
  local ROTT_Combat_Hero hero;
  local int i;
  
  super.loadScene();
  
  // Pause player movement
  gameInfo.pauseGame();
  
  // Clear pagestack except combat background
  for (i = pageStack.length; i > 1; i--) {
    popPage();
  }
  
  // Initial page stack
  pushPage(glyphPage);
  pushPage(transitionPage);
  
  // Link enemies to UI components
  gameInfo.enemyEncounter.setUIComponents();
  
  // Init hero and enemy UI elements
  for (i = 0; i < 3; i++) {
    hero = gameInfo.getActiveParty().getHero(i);
    if (hero != none) {
      // Cache attack graphics
      cacheTextures(hero.attackAbility.skillAnim);
      
      // Cache skill graphics
      cacheTextures(hero.primaryScript.skillAnim);
      cacheTextures(hero.secondaryScript.skillAnim);
      cacheTextures(hero.primaryScript.altSkillAnim);
      cacheTextures(hero.secondaryScript.altSkillAnim);
      
      // Cache passive skill graphics
      /// ...
      
      // Attach component
      hero.uiComponent = combatPage.heroDisplayers.heroDisplayers[hero.partyIndex];
      
      // Reset interface for new battle
      hero.uiComponent.resetUI();
    }
  }
  
  // Start paused and transition in
  pauseScene(); 
  combatDelay = gameInfo.spawn(class'ROTTTimer');
  combatDelay.makeTimer(1.15, LOOP_OFF, beginBattle);
}

/*=============================================================================
 * unloadScene()
 *
 * Called when switching to a different scene
 *===========================================================================*/
event unloadScene() {
  // Cleanup timer references
  if (combatDelay != none) combatDelay.destroy();
  
  // Notify parties the battle is over to reset UI displays
  gameInfo.getActiveParty().battleEnd();
  gameInfo.enemyEncounter.battleEnd();
}

/*=============================================================================
 * pauseScene()
 *
 * Called when the scene pauses
 *===========================================================================*/
event pauseScene(){
  super.pauseScene();
  
  bPaused = true;
}

/*=============================================================================
 * unpauseScene()
 *
 * Called when the scene pauses
 *===========================================================================*/
event unpauseScene(){
  super.unpauseScene();
  
  bPaused = false;
}

/*=============================================================================
 * Process an input key event 
 *
 * @return  true to consume the key event, false to pass it on.
 *===========================================================================*/
function bool onInputKey
(
  int ControllerId, 
  name Key, 
  EInputEvent Event, 
  float AmountDepressed = 1.f, 
  bool bGamepad = false 
)
{
  // Scene wide controls
  switch (Key) {
    case 'XboxTypeS_LeftTrigger': 
      /// this would be tricky to move to new input system
      if (Event == IE_Pressed) gameinfo.SetGameSpeed(4);
      if (Event == IE_Released) gameinfo.SetGameSpeed(1);
      break;
    case 'XBoxTypeS_Y': 
      /// this should be moved to new input system
      if (Event == IE_Pressed) {
        toggleCombatDetail();
      }
      break;
  } 
  
  return super.onInputKey(ControllerID, Key, Event, AmountDepressed, bGamepad);
}

/*=============================================================================
 * updateHeroReady()
 *
 * Switches to actions page if it is not already up
 *===========================================================================*/
public function updateHeroReady() {
  if (topPage() == glyphPage) {
    // Remove glyph panel
    popPage();
    
    // Push action panel after time delay
    pushNextActionPanel();
  }
}

/*=============================================================================
 * readyHeroHasDied()
 *
 * Update the action panel since the hero using it has died
 *===========================================================================*/
public function readyHeroHasDied() {
  if (topPage() == actionsPanel) {
    actionsPanel.readyHeroHasDied();
  } else if (topPage() == targetingPage) {
    targetingPage.readyHeroHasDied();
  }
}

/*=============================================================================
 * elapseTimers()
 *
 * Increments time every engine tick.
 *===========================================================================*/
public function elapseTimer(float deltaTime, float gameSpeedOverride) {
  super.elapseTimer(deltaTime, gameSpeedOverride);
}

/*=============================================================================
 * popTargetPage()
 *
 * This is called when a combat action has been confirmed (not when backing out
 * from target page)
 *
 * Post condition: Action panel or glyph panel should be up
 *===========================================================================*/
public function popTargetPage() {
  // Pop target page
  popPage("Page_Targeting");
  
  // Dequeue the hero
  if (gameInfo.getActiveParty().dequeueReadyHero()) {
    // Pop action panel, and push glyph page
    switchPage(glyphPage);
  } else {
    // Push next action panel
    pushNextActionPanel();
  }
}

/*=============================================================================
 * pushNextActionPanel()
 *
 * This is called to push the action panel with a time delay
 *===========================================================================*/
public function pushNextActionPanel() {
  if (pageStack[pageStack.length - 1] == actionsPanel) {
    // Pop action panel page
    popPage();
  }
  
  // Check if there are ready units for action panel usage
  if (gameInfo.getActiveParty().readyUnits.length > 0) {
    pushPage(actionsPanel);
  } else {
    pushPage(glyphPage);
  }
}

/*=============================================================================
 * switchPage()
 *
 * Pops the top page and pushes the given page
 *===========================================================================*/
public function switchPage(ROTT_UI_Page page) {
  popPage();
  pushPage(page);
}

/*=============================================================================
 * beginBattle()
 *
 * Allows input and unpauses time flow
 *===========================================================================*/
private function beginBattle() {
  local int i;
  
  unpauseScene();
  combatDelay.destroy();
  
  // Make sure transition page is removed
  for (i = pageStack.length - 1; i > 0; i--) {
    if (pageStack[i].tag == "Page_Transition_In") {
      popPage("Page_Transition_In");
    }
  }
}

/*=============================================================================
 * endBattle()
 *
 * Called when the enemies are defeated, prepares UI to switch to victory
 * and analysis pages.
 *===========================================================================*/
public function endBattle() {
  // Disable input
  pauseScene();
  
  // Remove auto selection timer
  if (actionsPanel.turboDelay != none) actionsPanel.turboDelay.destroy();
  if (targetingPage.turboDelay != none) targetingPage.turboDelay.destroy();

  // Pop targeting page
  if (topPage() == targetingPage) {
    popPage("Page_Targeting");
  }
  
  // Transition out
  pushPage(transitionPageOut);
}

/*=============================================================================
 * toggleCombatDetail()
 *
 * Called when the player presses Y in a combat scenario
 *===========================================================================*/
public function toggleCombatDetail() {
  local int i;
  
  // Toggle option settings
  gameInfo.optionsCookie.toggleCombatDetail();
  
  // Toggle UI display
  combatPage.heroDisplayers.toggleCombatDetail();
  for (i = 0; i < 3; i++) {
    if (gameInfo.enemyEncounter.getEnemy(i) != none) {
      gameInfo.getEnemyUI(i).showDetail(gameInfo.optionsCookie.showCombatDetail);
    }
  }
}

/*=============================================================================
 * setGlyphFeedback()
 *
 * Used to report glyph collection info to the screen
 *===========================================================================*/
public function setGlyphFeedback(string text, FontStyles font) {
  combatPage.glyphFeedback.setText(text);
  combatPage.glyphFeedback.setFont(font);
  combatPage.glyphFeedback.resetEffects();
  combatPage.glyphFeedback.addEffectToQueue(DELAY, 2.0);
  combatPage.glyphFeedback.addEffectToQueue(FADE_OUT, 2.0);
}

/*=============================================================================
 * deleteScene()
 *
 * Deletes scene references for garbage collection
 *===========================================================================*/
public function deleteScene() {
  super.deleteScene();
  
  combatPage = none;
  glyphPage = none;
  actionsPanel = none;
  targetingPage = none;
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  // Scene frame
  begin object class=ROTT_UI_Screen_Frame Name=Screen_Frame
    tag="Screen_Frame"
    bEnabled=true
  end object
  uiComponents.add(Screen_Frame)
  
  // Combat Encounter Page
  begin object class=ROTT_UI_Page_Combat_Encounter Name=Page_Combat_Encounter
    tag="Page_Combat_Encounter"
    bEnabled=false
  end object
  pageComponents.add(Page_Combat_Encounter)
  
  // Glyph Grid
  begin object class=ROTT_UI_Page_Combat_Glyph_Grid Name=Page_Glyph_Grid
    tag="Page_Glyph_Grid"
    bEnabled=false
  end object
  pageComponents.add(Page_Glyph_Grid)
  
  // Action Panel
  begin object class=ROTT_UI_Page_Combat_Action_Panel Name=Page_Action_Panel
    tag="Page_Action_Panel"
    bEnabled=false
  end object
  pageComponents.add(Page_Action_Panel)
  
  // Targeting page
  begin object class=ROTT_UI_Page_Combat_Targeting Name=Page_Targeting
    tag="Page_Targeting"
    bEnabled=false
  end object
  pageComponents.add(Page_Targeting)
  
  // Transition Page (in)
  begin object class=ROTT_UI_Page_Transition Name=Page_Transition_In
    tag="Page_Transition_In"
    bEnabled=false
    
    // Sorter effect config
    effectConfig=INTO_COMBAT_TRANSITION
    
    // Destination
    destinationScene=NO_SCENE
  end object
  pageComponents.add(Page_Transition_In)

  // Transition Page (out)
  begin object class=ROTT_UI_Page_Transition Name=Page_Transition_Out
    tag="Page_Transition_Out"
    bEnabled=false
    
    // Sorter effect config
    effectConfig=RIGHT_SWEEP_TRANSITION_OUT
    
    // Destination
    destinationScene=SCENE_COMBAT_RESULTS
  end object
  pageComponents.add(Page_Transition_Out)

  
}















