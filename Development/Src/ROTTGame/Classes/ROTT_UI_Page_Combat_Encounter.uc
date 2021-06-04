/*============================================================================= 
 * ROTT_UI_Page_Combat_Encounter
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This class displays an enemy encounter, and handles player 
 * input for combat interactions.
 *===========================================================================*/
 
class ROTT_UI_Page_Combat_Encounter extends ROTT_UI_Page;

// Internal References
var privatewrite ROTT_UI_Displayer_Combat_Hero heroDisplayers[3];
var privatewrite ROTT_UI_Displayer_Combat_Enemy enemyDisplayers[3];

var public UI_Label glyphFeedback;

var privatewrite ROTT_UI_Scene_Combat_Encounter someScene;

/*============================================================================= 
 * Initialize Component
 *
 * Description: This event is called as the UI is loaded.
 *              Our initial scene is drawn here.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  local int i;
  
  // Draw each component
  super.initializeComponent(newTag);
  
  someScene = ROTT_UI_Scene_Combat_Encounter(outer);
  
  // Combat unit displayers
  for (i = 0; i < 3; i++) {
    // Enemy displayers
    enemyDisplayers[i] = new class'ROTT_UI_Displayer_Combat_Enemy';
    componentList.addItem(enemyDisplayers[i]);
    enemyDisplayers[i].initializeComponent();
    enemyDisplayers[i].updatePosition(229 + (i*385), 105);
    enemyDisplayers[i].linkReferences();
  }
  
  // Combat unit displayers
  for (i = 0; i < 3; i++) {
    // Hero displayers
    heroDisplayers[i] = new class'ROTT_UI_Displayer_Combat_Hero';
    componentList.addItem(heroDisplayers[i]);
    heroDisplayers[i].initializeComponent();
    heroDisplayers[i].updatePosition(687 + (i*230), 443);
    heroDisplayers[i].displayerDelay = i * 0.125;
  }
  
  glyphFeedback = findLabel("Glyph_Feedback_Label");
  
}

/*============================================================================= 
 * onPushPageEvent()
 *
 * This event is called every time the page is pushed.
 *===========================================================================*/
event onPushPageEvent() {
  
}

/*============================================================================= 
 * onPopPageEvent()
 *
 * 
 *===========================================================================*/
event onPopPageEvent() {
  scriptTrace();
  redLog("Error: I should never pop, I should never lock, and i should never drop it");
}

/*============================================================================= 
 * onSceneActivation()
 *
 * This event is called every time the parent scene is activated
 *===========================================================================*/
public function onSceneActivation() {
  local int i;
  
  glyphFeedback.setText("");
  
  // Hide all enemy displayers before assigning them to enemies
  for (i = 0; i < 3; i++) {
    enemyDisplayers[i].attachDisplayer(none);
  }
  
  // Attach each hero display
  for (i = 0; i < 3; i++) {
    heroDisplayers[i].attachDisplayer(gameInfo.getActiveParty().getHero(i));
    heroDisplayers[i].showDetail(gameInfo.optionsCookie.showCombatDetail);
  }
}

/*============================================================================= 
 * onSceneDeactivation()
 *
 * This event is called every time the parent scene is deactivated
 *===========================================================================*/
public function onSceneDeactivation() {
  
}

/*============================================================================= 
 * showCombatNotification()
 *
 * Shows a message in the center of the enemy encounter display area
 *===========================================================================*/
public function showCombatNotification(string message) {
  local UI_Label notificationLabel;
  notificationLabel = makeLabel(message);
  notificationLabel.updatePosition(
    ,
    ,
    ,
    580
  );
}

/*=============================================================================
 * Controls
 *
 * ControllerId     the controller that generated this input key event
 * Key              the name of the key which an event occured for
 * EventType        the type of event which occured
 * AmountDepressed  for analog keys, the depression percent.
 *
 * Returns: true to consume the key event, false to pass it on.
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
  return true;
}

public function onNavigateLeft();
public function onNavigateRight();
protected function navigateUp();
protected function navigateDown();

/*=============================================================================
 * elapseTimers()
 *
 * Ticks every frame. 
 *===========================================================================*/
public function elapseTimers(float deltaTime) {
  super.elapseTimers(deltaTime);
  
  if (someScene.bPaused) return;
  
  // Pass elapsed time to combat units
  gameInfo.playerProfile.getActiveParty().elapseTime(deltaTime * gameInfo.gameSpeed);
  if (gameInfo.enemyEncounter != none) {
    gameInfo.enemyEncounter.elapseTime(deltaTime * gameInfo.gameSpeed);
  }
}

/*============================================================================= 
 * deleteComp
 *===========================================================================*/
event deleteComp() {
  local int i;
  
  super.deleteComp();
  
  // Clean combat unit displayers
  for (i = 0; i < 3; i++) {
    heroDisplayers[i] = none;
    enemyDisplayers[i] = none;
  }
}

/*============================================================================= 
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  /** ===== Textures ===== **/
  // Background
  begin object class=UI_Texture_Info Name=Combat_Background
    componentTextures.add(Texture2D'GUI.Combat_Background')
  end object
  
  // Menu
  begin object class=UI_Texture_Info Name=Combat_Menu
    componentTextures.add(Texture2D'GUI.Combat_Menu')
  end object
  
  /** ===== UI Components ===== **/
  tag="Page_Combat_Encounter"
  posX=0
  posY=0
  posXEnd=NATIVE_WIDTH
  posYEnd=NATIVE_HEIGHT
  
  // Background
  begin object class=UI_Sprite Name=Combat_Encounter_Background
    tag="Combat_Encounter_Background"
    posX=0
    posY=0
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    images(0)=Combat_Background
  end object
  componentList.add(Combat_Encounter_Background)
  
  // Combat Menu
  begin object class=UI_Sprite Name=Combat_Encounter_Menu
    tag="Combat_Encounter_Menu"
    posX=0
    posY=0
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    images(0)=Combat_Menu
  end object
  componentList.add(Combat_Encounter_Menu)
  
  // Enemy displayers
  /** Enemy UI is dynamically created in init() function above **/
  
  // Glyph feedback label
  begin object class=UI_Label Name=Glyph_Feedback_Label
    tag="Glyph_Feedback_Label"
    posX=405
    posY=551
    posXEnd=679
    posYEnd=617
    AlignX=CENTER
    AlignY=CENTER
    fontStyle=DEFAULT_SMALL_RED
    labelText="Health+ (#TOTAL)"
  end object
  componentList.add(Glyph_Feedback_Label)
}




































