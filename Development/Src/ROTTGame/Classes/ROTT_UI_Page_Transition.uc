/*============================================================================= 
 * ROTT_UI_Page_Transition
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This page displays transition graphics for encounters and what
 * not
 *===========================================================================*/
 
class ROTT_UI_Page_Transition extends ROTT_UI_Page
dependsOn(ROTT_UI_Scene_Manager);

// Tile count for transition effect
// 60x60 tiles, 1440x900 resolution, 1440/60 * 900/60
const TILE_COUNT = 360; 

const TILES_PER_ROW = 24;
const COLUMN_PER_ROW = 15;

// Defines whether or not controls will be consumed by this page, or pasesd on
var private bool bConsumeInput;

// Store color of tile
var private color tileColor;

// Transition effects
var private float delayTime;
var private float elapsedDelay;
var private bool bDelayTimer;

// Transition delay (seconds)
var private float transitionDelay;

// Tile sorting information
struct TileInfo {
  var int index;
  var int distance;
};

var private array<TileInfo> blackTileIndices;
var private array<TileInfo> colorTileIndices;

// Internal references
var private UI_Texture_Storage tileGraphics;
var private UI_Sprite blackSquares[TILE_COUNT];
var private UI_Sprite colorSquares[TILE_COUNT];

// Enable or disable colored tile layer
var private bool bUseColor;
var private bool bBlackTilesWait;

// Delay until black layer comes
var private float colorTileDelay;
var private float delayElapsed;
  
// Transition direction, this is black to clear or clear to black
enum TransitionMode {
  TRANSITION_OUT,
  TRANSITION_IN
};
var private TransitionMode transitionStyle;

// Sorting direction (Not to be confused with transition direction)
var private bool bReverse;

// Tiles drawn per tick, (effectively the transition speed)
var private int tilesPerTick;

// Tiles drawn so far
var private int tileCount;
var private int colorTileCount;

// Elapsed time for transition
var private float elapsedTime;

// Effect enabled
var private bool bEffectEnabled;

// Optional: Scene to switch into after transition
var public DisplayScenes destinationScene;

// Optional: Page to switch into after transition
var public ROTT_UI_Page destinationPage;

// Optional: Page to switch into after transition
var public string destinationWorld;

// Fade control
var private float fadeTime;

// Config styles for sorter effects and transition styles
// (I guess we have to do this here because the constructors are fucking moronic)
enum EffectConfigs {
  INTO_COMBAT_TRANSITION,
  OUT_FROM_OVER_WORLD_TRANSITION,
  RIGHT_SWEEP_TRANSITION_IN,
  RIGHT_SWEEP_TRANSITION_OUT,
  PORTAL_TRANSITION,
  RANDOM_SORT_TRANSITION,
  RESPAWN_END_TRANSITION,
  RESPAWN_START_TRANSITION,
  NPC_TRANSITION_IN,
  NPC_TRANSITION_OUT,
  DOOR_PORTAL_TRANSITION_OUT,
};
var private EffectConfigs effectConfig;

// Effect functions
var private array<delegate<tileSorter> > sorterEffects;
delegate int tileSorter(int index);

/*============================================================================= 
 * initializeComponent()
 *
 * Called once, when the scene is first initialized.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  local int i, j, index;
  
  // Draw each component
  super.initializeComponent(newTag);
  
  // Internal references
  tileGraphics = UI_Texture_Storage(findComp("Tile_Sprites"));
  
  // Column iteration
  for (j = 0; j < COLUMN_PER_ROW; j++) {
    // Row iteration
    for (i = 0; i < TILES_PER_ROW; i++) {
      // Calculate index
      index = j * TILES_PER_ROW + i;
      
      // Create sprites
      colorSquares[index] = new class'UI_Sprite';
      colorSquares[index].images.addItem(new class'UI_Texture_Info');
      colorSquares[index].images[0].componentTextures.addItem(Texture2D'GUI.White_Square');
      colorSquares[index].drawColor = tileColor;
      componentList.addItem(colorSquares[index]);
      colorSquares[index].bMandatoryScaleToWindow = true;
      colorSquares[index].initializeComponent();
      colorSquares[index].drawLayer = TOP_LAYER;
      
      // Set position
      colorSquares[index].updatePosition(i * 60, j * 60);
      
      // Create sprites
      blackSquares[index] = new class'UI_Sprite';
      blackSquares[index].images.addItem(new class'UI_Texture_Info');
      blackSquares[index].images[0].componentTextures.addItem(Texture2D'GUI.Black_Square');
      componentList.addItem(blackSquares[index]);
      blackSquares[index].bMandatoryScaleToWindow = true;
      blackSquares[index].initializeComponent();
      blackSquares[index].drawLayer = TOP_LAYER;
      
      // Set position
      blackSquares[index].updatePosition(i * 60, j * 60);
    }
  }
  
  // Set up config style
  switch (effectConfig) {
    case RIGHT_SWEEP_TRANSITION_IN:
      // Transition speed
      tilesPerTick = 20;
      
      // Transition direction
      transitionStyle = TRANSITION_IN;
      
      // Sorter effects
      sorterEffects.addItem(sortMethod8);
      break;
      
    case RIGHT_SWEEP_TRANSITION_OUT:
      // Transition speed
      tilesPerTick = 20;
      
      // Transition direction
      transitionStyle = TRANSITION_OUT;
      
      // Sorter effects
      sorterEffects.addItem(sortMethod8);
      break;
      
    case RESPAWN_START_TRANSITION:
      // Transition speed
      tilesPerTick = 14;
      
      // Transition direction
      transitionStyle = TRANSITION_OUT;
      
      // Sorter effects
      sorterEffects.addItem(sortMethod7);
      break;
      
    case RESPAWN_END_TRANSITION:
      // Transition speed
      tilesPerTick = 14;
      
      // Transition direction
      transitionStyle = TRANSITION_IN;
      
      // Sorter effects
      sorterEffects.addItem(sortMethod7);
      break;
      
    case INTO_COMBAT_TRANSITION:
      // Transition speed
      tilesPerTick = 14;
      
      // Transition direction
      transitionStyle = TRANSITION_IN;
      
      // Sorter effects
      sorterEffects.addItem(sortMethod6);
      break;
      
    case OUT_FROM_OVER_WORLD_TRANSITION:
      // Transition direction
      transitionStyle = TRANSITION_OUT;
      
      // Transition destination
      ///destinationScene = SCENE_COMBAT_ENCOUNTER;
      
      // Sorter effects
      sorterEffects.addItem(sortMethod1);
      sorterEffects.addItem(sortMethod2);
      sorterEffects.addItem(sortMethod3);
      sorterEffects.addItem(sortMethod4);
      sorterEffects.addItem(sortMethod5);
      break;
    case PORTAL_TRANSITION:
      // Transition direction
      transitionStyle = TRANSITION_OUT;
      
      // Transition destination
      destinationScene = NO_SCENE;
      
      // Sorter effects (Circle)
      sorterEffects.addItem(sortMethod1);
      
      // Fade effects
      fadeTime=1.0;
      break;
    case RANDOM_SORT_TRANSITION:
      // Transition direction
      transitionStyle = TRANSITION_OUT;
      
      // Sorter effects (Random tiles)
      sorterEffects.addItem(sortMethod5);
      break;
    case NPC_TRANSITION_IN:
      // Transition direction
      transitionStyle = TRANSITION_IN;
      bReverse = true;
      
      // Sorter effects (sortMethod9 is midline vertical)
      sorterEffects.addItem(sortMethod9);
      break;
    case NPC_TRANSITION_OUT:
      // Transition direction
      transitionStyle = TRANSITION_OUT;
      bReverse = false;
      
      // Sorter effects (sortMethod9 is midline vertical)
      sorterEffects.addItem(sortMethod9);
      break;
    case DOOR_PORTAL_TRANSITION_OUT:
      // Transition direction
      transitionStyle = TRANSITION_IN;
      bReverse = true;
      
      // Sorter effects (sortMethod9 is midline vertical)
      sorterEffects.addItem(sortMethod9);
      break;
    default:
      yellowLog("Warning (!) Transition page has no config.");
      break;
      
  }
}

/*============================================================================= 
 * onPushPageEvent()
 *
 * This event is called every time the page is pushed.
 *===========================================================================*/
event onPushPageEvent() {
  local bool displayState;
  local int i;
  
  // Transition direction
  displayState = (transitionStyle != TRANSITION_OUT);
  
  // Clear graphics
  for (i = 0; i < TILE_COUNT; i++) {
    blackSquares[i].setEnabled(displayState);
    blackSquares[i].setColor(0,0,0,255);/// ???
    colorSquares[i].setEnabled(displayState && bUseColor);
    colorSquares[i].drawColor.r = tileColor.r; /// ???
    colorSquares[i].drawColor.g = tileColor.g; /// ???
    colorSquares[i].drawColor.b = tileColor.b; /// ???
    colorSquares[i].drawColor.a = tileColor.a; /// ???
  }
  
  // Select random sorting algorithm
  tileSort(sorterEffects[rand(sorterEffects.length)]);
  
  // Set effect timer
  if (effectConfig == PORTAL_TRANSITION) {
    gameinfo.SetGameSpeed(1);
  }
  tileCount = 0;
  colorTileCount = 0;
  elapsedTime = 0;
  bEffectEnabled = true;
  elapsedDelay = 0;
  
  // Reset delay tracking 
  delayElapsed = 0;
  if (bUseColor) {
    bBlackTilesWait = true;
  } else {
    colorTileDelay = 0;
  }
}

/*============================================================================= 
 * onPopPageEvent()
 *
 * This event is called when the page is removed
 *===========================================================================*/
event onPopPageEvent() {
  // Trigger on completion event
  if (ROTT_UI_Scene(outer) != none) {
    ROTT_UI_Scene(outer).transitionCompletion(tag);
  }
}

/*=============================================================================
 * elapseTimers()
 *
 * Ticks every frame. 
 *===========================================================================*/
public function elapseTimers(float deltaTime) {
  // Ignore speed modifiers
  deltaTime /= gameInfo.gameSpeed;
  
  // Delay black tiles
  if (bUseColor && bBlackTilesWait) {
    delayElapsed += deltaTime;
    if (delayElapsed >= colorTileDelay) {
      bBlackTilesWait = false;
    }
  }
  
  if (bDelayTimer) {
    // Track elapsed delay time
    elapsedDelay += deltaTime;
    
    // Execute delayed scene switch from this transition
    if (elapsedDelay >= delayTime) switchSceneDelay();
  }
  
  // Track time
  if (bEffectEnabled) {
    elapsedTime += deltaTime;
    renderTiles();
  }
  super.elapseTimers(deltaTime);
  
}

/*============================================================================= 
 * onSceneActivation()
 *
 * This event is called every time the parent scene is activated
 *===========================================================================*/
public function onSceneActivation() {
  
}

/*============================================================================= 
 * onSceneDeactivation()
 *
 * This event is called every time the parent scene is deactivated
 *===========================================================================*/
public function onSceneDeactivation() {
  
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
function bool onInputKey( 
  int ControllerId, 
  name Key, 
  EInputEvent Event, 
  float AmountDepressed = 1.f, 
  bool bGamepad = false) 
{
  switch (Key) {
    // Button inputs
    case 'XboxTypeS_LeftTrigger':
    return false;
      super.onInputKey(ControllerId, Key, Event, AmountDepressed, bGamepad);
      return (effectConfig == PORTAL_TRANSITION);
      
    case 'XBoxTypeS_Start':
      // Consume input
      return true;
  }
  
  return bConsumeInput;
}

public function onNavigateLeft();
public function onNavigateRight();
protected function navigateUp();
protected function navigateDown();

/*============================================================================= 
 * tileSort()
 *
 * Sorts tiles for transition effect
 *===========================================================================*/
private function tileSort(delegate<tileSorter> sorter) {
  local TileInfo newTile;
  local int i;
  
  // Reset array
  blackTileIndices.length = 0;
  colorTileIndices.length = 0;
  
  // Populate list
  for (i = 0; i < TILE_COUNT; i++) {
    newTile.index = i;
    newTile.distance = sorter(i);
    blackTileIndices.addItem(newTile);
    colorTileIndices.addItem(newTile);
  }
  
  blackTileIndices.sort(tileComparison);
  colorTileIndices.sort(tileComparison);
  
  if (bReverse) {
    reverseArray(blackTileIndices);
    reverseArray(colorTileIndices);
  }
}

/*============================================================================= 
 * tileComparison()
 *
 * Compares distance between tiles.  Negative result signifies out of order.
 *===========================================================================*/
private function int tileComparison(TileInfo a, TileInfo b) {
  if (a.distance < b.distance) {
    return -1;
  } else if (a.distance > b.distance) {
    return 1;
  } else {
    return 0;
  }
}

/*============================================================================= 
 * sortMethod1()
 *
 * Circle effect
 *===========================================================================*/
private function int sortMethod1(int index) {
  // Distance to x=1/2, y=1/2
  return distanceFormula(
    blackSquares[index].getX(), 
    blackSquares[index].getY(), 
    NATIVE_WIDTH / 2,
    NATIVE_HEIGHT / 2
  );
}

/*============================================================================= 
 * sortMethod2()
 *
 * Four corners effect
 *===========================================================================*/
private function int sortMethod2(int index) {
  local float d1, d2, d3, d4;
  
  // Distance to MIN(four corners)
  d1 = distanceFormula(
    blackSquares[index].getX(), 
    blackSquares[index].getY(), 
    0,
    0
  );
  
  d2 = distanceFormula(
    blackSquares[index].getX(), 
    blackSquares[index].getY(), 
    NATIVE_WIDTH,
    0
  );
  
  d3 = distanceFormula(
    blackSquares[index].getX(), 
    blackSquares[index].getY(), 
    0,
    NATIVE_HEIGHT
  );
  
  d4 = distanceFormula(
    blackSquares[index].getX(), 
    blackSquares[index].getY(), 
    NATIVE_WIDTH,
    NATIVE_HEIGHT
  );
  
  d1 = fMin(d1, d2);
  d2 = fMin(d3, d4);
  
  return fMin(d1, d2);
}

/*============================================================================= 
 * sortMethod3()
 *
 * Vertical lines effect
 *===========================================================================*/
private function int sortMethod3(int index) {
  local float d1, d2;
  
  // Distance to MIN(x=1/3, x=2/3)
  d1 = abs(blackSquares[index].getX() - (NATIVE_WIDTH / 4));
  d2 = abs(blackSquares[index].getX() - (3 * NATIVE_WIDTH / 4));
  return fMin(d1, d2);
}

/*============================================================================= 
 * sortMethod4()
 *
 * Horizontal midline effect
 *===========================================================================*/
private function int sortMethod4(int index) {
  // Distance to Y = 1/2
  return abs(blackSquares[index].getY() - (NATIVE_HEIGHT / 2));
}

/*============================================================================= 
 * sortMethod5()
 *
 * Randomized effect
 *===========================================================================*/
private function int sortMethod5(int index) {
  // Random method
  return rand(10);
}

/*============================================================================= 
 * sortMethod6()
 *
 * Vertical curtain effect downward, used only for opening combat
 *===========================================================================*/
private function int sortMethod6(int index) {
  // Distance to Y = 1
  return abs(blackSquares[index].getY() - NATIVE_HEIGHT);
}

/**============================================================================= 
 * sortMethod7()
 *
 * Vertical curtain effect upward, used only for opening combat
 *===========================================================================*/
private function int sortMethod7(int index) {
  // Distance to Y = 0
  return abs(blackSquares[index].getY());
}

/*============================================================================= 
 * sortMethod8()
 *
 * Horizontal curtain effect
 *===========================================================================*/
private function int sortMethod8(int index) {
  // Distance to X = 1
  return abs(blackSquares[index].getX() - NATIVE_WIDTH);
}

/*============================================================================= 
 * sortMethod9()
 *
 * Vertical midline effect
 *===========================================================================*/
private function int sortMethod9(int index) {
  // Distance to X = 1/2
  return abs(blackSquares[index].getX() - (NATIVE_WIDTH / 2));
}

/*============================================================================= 
 * renderTiles()
 *
 * Timer allocated function for drawing tiles effects to the screen
 *===========================================================================*/
private function renderTiles() {
  local bool displayState;
  local int index, k, tileMax;
  
  // Transition direction
  displayState = (transitionStyle == TRANSITION_OUT);
  
  // Black tiles
  if (bBlackTilesWait == false) {
    tileMax = tilesPerTick * (elapsedTime) / 0.025 - tileCount;
    for (k = 0; k < tileMax; k++) {
      // Check for remaining indices
      if (blackTileIndices.length == 0) {
        endTransition();
        break;
      }
      
      // Render a random batch from the sorted list 
      index = rand(30);
      if (index >= blackTileIndices.length) index = rand(blackTileIndices.length);
      blackSquares[blackTileIndices[index].index].setEnabled(displayState);
      
      if (fadeTime != 0) {
        blackSquares[blackTileIndices[index].index].addEffectToQueue(DELAY, 0.005 * (rand(14)));
        blackSquares[blackTileIndices[index].index].addEffectToQueue((displayState) ? FADE_IN : FADE_OUT, fadeTime);
      } else {
        ///blackSquares[blackTileIndices[index].index].setColor(0,0,0,255); ///.setAlpha(255);
      }
      blackTileIndices.remove(index, 1);
    }
    tileCount += k;
  }
  
  // Colored tiles
  if (bUseColor) {
    tileMax = tilesPerTick * elapsedTime / 0.025 - colorTileCount;
    for (k = 0; k < tileMax; k++) {
      // Check for remaining indices
      if (colorTileIndices.length == 0) {
        return;
      }
      
      // Render a random batch from the sorted list
      index = rand(30);
      if (index >= colorTileIndices.length) index = rand(colorTileIndices.length);
      colorSquares[colorTileIndices[index].index].setEnabled(displayState);
      ///colorSquares[colorTileIndices[index].index].maxAlpha = tileColor.a;
      colorSquares[colorTileIndices[index].index].drawColor.a = tileColor.a;
      if (fadeTime != 0) {
        colorSquares[colorTileIndices[index].index].addEffectToQueue(DELAY, 0.005 * (rand(14)));
        colorSquares[colorTileIndices[index].index].addEffectToQueue((displayState) ? FADE_IN : FADE_OUT, fadeTime);
      }
      colorTileIndices.remove(index, 1);
    }
    colorTileCount += k;
  }
  
}

/*============================================================================= 
 * endTransition()
 *
 * Called when the rendering of all the tiles is complete
 *===========================================================================*/
private function endTransition() {
  // Set effect timer
  delayTime = transitionDelay + fadeTime;
  bDelayTimer = true;
  
  // Remove timer reference
  bEffectEnabled = false;
}

/*============================================================================= 
 * switchSceneDelay()
 *
 * Called some time after the transition effect completes
 *===========================================================================*/
private function switchSceneDelay() {
  bDelayTimer = false;
  
  // Handle world transfer
  if (destinationWorld != "none") {
    gameInfo.consoleCommand("open " $ destinationWorld);
    return;
  }
  
  // Remove this transition page
  parentScene.popPage(tag);
  
  // Switch scene if transitioning out from a scene
  if (destinationScene != NO_SCENE) {
    sceneManager.switchScene(destinationScene);
  }
  
  // Push page if specified
  if (destinationPage != none) {
    sceneManager.scene.pushPage(destinationPage);
  }
  
}

/*============================================================================= 
 * distanceFormula()
 *
 * Returns the distance between two points on a cartesian plane
 *===========================================================================*/
private function float distanceFormula(float x1, float y1, float x2, float y2) {
  local float x, y;
  
  x = abs(x2 - x1);
  y = abs(y2 - y1);
  
  return sqrt(y * y + x * x);
}

/*============================================================================= 
 * distanceFormula()
 *
 * Returns the distance between two points on a cartesian plane
 *===========================================================================*/
private function reverseArray(out array<TileInfo> tileSet) {
  local array<TileInfo> tempSet;
  
  // Move all tileSet entries to temp array
  while (tileSet.length > 0) {
    tempSet.addItem(tileSet[0]);
    tileSet.remove(0, 1);
  }
  // Move back in reverse order
  while (tempSet.length > 0) {
    tileSet.addItem(tempSet[tempSet.length - 1]);
    tempSet.remove(tempSet.length - 1, 1);
  }
}

/*============================================================================= 
 * deleteComp
 *===========================================================================*/
event deleteComp() {
  super.deleteComp();
}

/*============================================================================= 
 * defaultProperties
 *===========================================================================*/
defaultProperties
{
  bMandatoryScaleToWindow=true
  
  // Transition delay
  transitionDelay=0.5
  
  // "Speed" of transition
  tilesPerTick=7
  
  // Transition direction
  transitionStyle=TRANSITION_OUT
  
  // Transition destination
  destinationScene=SCENE_COMBAT_ENCOUNTER
  destinationWorld="none"
  
  // Fade option
  fadeTime=0
  
  // Color tile effect
  bUseColor=false
  colorTileDelay=0.65
  
  // Tile color
  tileColor=(R=0,G=187,B=255,A=130)
  
	/** ===== Textures ===== **/
  // Tile sprite
	begin object class=UI_Texture_Info Name=Black_Square
		componentTextures.add(Texture2D'GUI.Black_Square')
	end object
	begin object class=UI_Texture_Info Name=White_Square
		componentTextures.add(Texture2D'MyPackage.Materials.White')
	end object
  
	/** ===== UI Components ===== **/
	tag="Over_World_Page"
	posX=0
	posY=0
	posXEnd=NATIVE_WIDTH
	posYEnd=NATIVE_HEIGHT
	
  // Black tile texture
	begin object class=UI_Texture_Storage Name=Tile_Sprites
		tag="Tile_Sprites"
    textureWidth=60
    textureHeight=60
		images(0)=Black_Square
		images(1)=White_Square
	end object
	componentList.add(Tile_Sprites)
	
}








