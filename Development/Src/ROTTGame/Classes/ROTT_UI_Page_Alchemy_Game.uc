/*=============================================================================
 * ROTT_UI_Page_Alchemy_Game
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: The game for starting the alchemy game.
 *===========================================================================*/
 
class ROTT_UI_Page_Alchemy_Game extends ROTT_UI_Page;

// Game manager
var private ROTT_UI_Alchemy_Tile_Manager tileManager;

// Internal references
var private UI_Selector selector;

// Transition variables
var private bool bGameOver;
var private float transitionDelay;

/*============================================================================= 
 * Initialize Component
 *
 * Description: This event is called as the UI is loaded.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  super.initializeComponent(newTag);
  
  // Internal references
  selector = UI_Selector(findComp("Alchemy_Game_Selector"));
  tileManager = ROTT_UI_Alchemy_Tile_Manager(findComp("Alchemy_Tiles"));
  
}

/*=============================================================================
 * onFocusMenu()
 *
 * Called when a menu is given focus.  Assign controls, and enable graphics.
 *===========================================================================*/
event onFocusMenu() {
  
}

/*============================================================================= 
 * onPushPageEvent()
 *
 * This event is called every time the page is pushed.
 *===========================================================================*/
event onPushPageEvent() {
  findSprite("Game_Fade_In").addEffectToQueue(FADE_OUT, 0.25);
  selector.forceSelection(2, 2);
  tileManager.reset();
  tileManager.setPattern1();
}

/*=============================================================================
 * elapseTimers()
 *
 * Increments time every engine tick.
 *===========================================================================*/
public function elapseTimers(float deltaTime) {
  super.elapseTimers(deltaTime);
  
  // Game over transitioning
  if (bGameOver) {
    // Track delay until transition
    transitionDelay -= deltaTime;
    
    // Check if time is complete
    if (transitionDelay <= 0) {
      // Change to game over page
      parentScene.popPage();
      parentScene.pushPageByTag("Page_Alchemy_Game_Over");
      bGameOver = false;
      selector.setActive(true);
      
      // Sound effect
      gameInfo.sfxbox.playSfx(SFX_ALCHEMY_GAME_OVER);
      
    }
  } else {
    // Check for game over
    if (tileManager.tiles[selector.getSelection()].getHeatState() == HEATED) {
      // Copy round reached
      ROTT_UI_Scene_Service_Alchemy(parentScene).enchantmentLevel = tileManager.level;
      
      // Sound effect
      gameInfo.sfxbox.playSfx(SFX_ALCHEMY_DEATH);
      
      // Start game over transition
      bGameOver = true;
      transitionDelay = 1.5;
      selector.setActive(false);
      selector.inactiveSprite.clearEffects();
      selector.inactiveSprite.addFlickerEffect(-1, 0.1, 0, 200, 255);
      selector.inactiveSprite.addEffectToQueue(DELAY, 0.8);
      selector.inactiveSprite.addEffectToQueue(FADE_OUT, 0.01);
    }
  }
}

/*============================================================================*
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
  // A button press
  if (Key == 'XBoxTypeS_A' && Event == IE_Pressed) pressA();
  
  return super.onInputKey(ControllerId, Key, Event, AmountDepressed, bGamepad);
}

/*============================================================================*
 * Button controls
 *===========================================================================*/
protected function pressA() {
  // Attempt to claim tile
  tileManager.claim(selector.getSelection());
  
}

protected function navigationRoutineB();

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  /** ===== Input ===== **/
  //begin object class=ROTT_Input_Handler Name=Input_A
  //  inputName="XBoxTypeS_A"
  //  buttonComponent=none
  //end object
  //inputList.add(Input_A)
  
  /** ===== Textures ===== **/
  // Background
  begin object class=UI_Texture_Info Name=Game_Background
    componentTextures.add(Texture2D'ROTT_Alchemy.Alchemy_Menu_Background')
  end object
  
  /** ===== Components ===== **/
  // Background
  begin object class=UI_Sprite Name=Alchemy_Game_Background
    tag="Alchemy_Game_Background"
    posX=0
    posY=0
    posXEnd=NATIVE_WIDTH
    posYEnd=NATIVE_HEIGHT
    images(0)=Game_Background
  end object
  componentList.add(Alchemy_Game_Background)
  
  // Alchemy Tiles
  begin object class=ROTT_UI_Alchemy_Tile_Manager Name=Alchemy_Tiles
    tag="Alchemy_Tiles"
    posX=370
    posY=100
  end object
  componentList.add(Alchemy_Tiles)
  
  // Selector
  begin object class=UI_Selector Name=Alchemy_Game_Selector
    tag="Alchemy_Game_Selector"
    bEnabled=true
    bActive=true
    bWrapAround=false
    navSound=SFX_ALCHEMY_GAME_MOVE
    posX=369
    posY=100
    navigationType=SELECTION_2D
    selectionOffset=(x=140,y=140)  // Distance from neighboring spaces
    gridSize=(x=5,y=5)             // Total size of 2d selection space
    
    // Selector
    begin object class=UI_Texture_Info Name=Game_Selector
      componentTextures.add(Texture2D'ROTT_Alchemy.Game.Alchemy_Game_Selector')
    end object
    
    // Selector sprite
    begin object class=UI_Sprite Name=Selector_Sprite
      tag="Selector_Sprite"
      images(0)=Game_Selector
      activeEffects.add((effectType = EFFECT_ALPHA_CYCLE, lifeTime = -1, elapsedTime = 0, intervalTime = 0.8, min = 235, max = 255))
    end object
    componentList.add(Selector_Sprite)
    
    // Inactive sprite
    begin object class=UI_Sprite Name=Inactive_Selector_Sprite
      tag="Inactive_Selector_Sprite"
      images(0)=Game_Selector
      activeEffects.add((effectType=EFFECT_FLICKER, lifeTime=-1, elapsedTime=0, intervalTime=0.1, min=200, max=255))
    end object
    componentList.add(Inactive_Selector_Sprite)
    
  end object
  componentList.add(Alchemy_Game_Selector)
  
  // Fade effects
  begin object class=UI_Sprite Name=Game_Fade_In
    // Texture
    begin object class=UI_Texture_Info Name=Black_Texture
      componentTextures.add(Texture2D'GUI.Black_Square')
    end object
    
    tag="Game_Fade_In"
    posX=343
    posY=73
    posXEnd=1097
    posYEnd=827
    images(0)=Black_Texture
    drawColor=(r=255,g=255,b=255,a=50)
    
  end object
  componentList.add(Game_Fade_In)
  
}

















/// //¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/// //                        Crafting
/// //_______________________________________________________________________________________________________________________
/// 
/// 
/// function deactivateTile(int TileX, int TileY, float Delay, float DownTime)
/// {
///   CraftTileY[TileY].CraftTileX[TileX].DownDelay = Delay;
///   CraftTileY[TileY].CraftTileX[TileX].DownTime = DownTime;
///   
///   UpdateDrawInfo("Craft_Game_Targeter_" $ TileY $ "x" $ TileX, 1);
///   GUIVisualComponent(FindComponentByTag("Craft_Game_Targeter_" $ TileY $ "x" $ TileX)).SetSlowFlicker(3);
/// 
/// }
/// 
/// function LevelUpTile()
/// {
///   if (CraftTileY[CraftSelectY].CraftTileX[CraftSelectX].Level >= CraftRound)
///     return;
///   
///   CraftTileY[CraftSelectY].CraftTileX[CraftSelectX].Level++;
///   CraftTileY[CraftSelectY].CraftTileX[CraftSelectX].ActivedThisRound = true;
///   Render_Tile_Level(CraftSelectX, CraftSelectY);
///   
///   ClaimedTiles++;
///   
///   /** SFX **/
///   if ( ClaimedTiles < 25 )
///   {
///     PlaySFX( AC_Cheerwave_01_b );
///   } else {
///     Reset_Craft_Grid();
///   }
/// }
/// 
/// function Initialize_Craft_Game()
/// {
///   local int TileX, TileY;
///   local int PosX, PosY, EndX, EndY;
///   
///   /** Turn off game timer **/
///   RoTTHUD(Outer).SetTimer(0.0, false, 'Craft_Game_Tick');
///   
///   /** Define array length **/
///   CraftTileY.Length = 6;
///   
///   /** Initital Game Variables **/
///   CraftRound = 1;
///   CraftPatternIndex = 0;
///   CraftCollectionIndex = 1;
///   
///   /** Draw and position Labels **/
///   redlog ("CraftLevelBonus" $ CraftLevelBonus);
///   MoveLabel("Craft_Game_Lives_Label", 362, 32, 1440, 900, "Lives: " $ Remaining_Craft_Attempts);
///   MoveLabel("Craft_Game_Level_Label", 0, 32, 1078, 900, "Level Bonus: " $ CraftLevelBonus);
///   
///   /** Initialize Patterns **/
///   InitializeCraftPatterns();
///   
///   /** Set component positions **/
///   TileY = 1;
///   do
///   {
///     /** Define array lengths **/
///     CraftTileY[TileY].CraftTileX.Length = 6;
///     
///     TileX = 1;
///     do
///     {
///       PosX = 230 + (140*TileX);
///       EndX = PosX + 140;
///       PosY = -40 + (140*TileY);
///       EndY = PosY + 140;
///       
///       RenderImage("Craft_Game_Tile_Level_" $ TileY $ "x" $ TileX,   PosX, PosY, EndX, EndY);
///       RenderImage("Craft_Game_Targeter_" $ TileY $ "x" $ TileX,   PosX, PosY, EndX + 12, EndY + 12);
///       SetImageAlpha("Craft_Game_Targeter_" $ TileY $ "x" $ TileX, 190);
///       RenderImage("Craft_Game_Tile_" $ TileY $ "x" $ TileX,   PosX, PosY, EndX, EndY);
///       
///       /** Reset game variables **/
///       CraftTileY[TileY].CraftTileX[TileX].Level = 0;
///       UpdateDrawInfo("Craft_Game_Tile_Level_" $ TileY $ "x" $ TileX, 0);
///       CraftTileY[TileY].CraftTileX[TileX].ActivedThisRound = false;
///       CraftTileY[TileY].CraftTileX[TileX].DownDelay = 0.0;
///       CraftTileY[TileY].CraftTileX[TileX].DownTime = 0.0;
///       
///       /** Store Visual components **/
///       CraftTileY[TileY].CraftTileX[TileX].Background_VC = GUIVisualComponent(FindComponentByTag("Craft_Game_Tile_" $ TileY $ "x" $ TileX));
///       CraftTileY[TileY].CraftTileX[TileX].Target_VC = GUIVisualComponent(FindComponentByTag("Craft_Game_Targeter_" $ TileY $ "x" $ TileX));
///       
///       TileX++;
///     } until (TileX >= 6);
///     
///     TileY++;
///   } until (TileY >= 6);
///   
///   CraftSelectX = 3;
///   CraftSelectY = 3;
///   
///   CraftGameActive = false;
///   CraftGameOver = false;
///   UpdateDrawInfo("Craft_Game_Selector" ,0);
///   
///   PosX = 230 + (140*3);
///   EndX = PosX + 152;
///   PosY = -40 + (140*3);
///   EndY = PosY + 152;
///   RenderImage("Craft_Game_Selector",   PosX, PosY, EndX, EndY);
///   
///   Render_Craft_Page();
/// }
/// 
/// function InitializeCraftPatterns()
/// {
///   local int PtrnIndex, ClctIndex;
///   
///   ClctIndex = 1;
///   PtrnIndex = 2;
///   
///   AddPatternTarget(ClctIndex, PtrnIndex, 1, 1);
///   AddPatternTarget(ClctIndex, PtrnIndex, 5, 5);
///   PtrnIndex++;
///   AddPatternTarget(ClctIndex, PtrnIndex, 2, 1);
///   AddPatternTarget(ClctIndex, PtrnIndex, 4, 5);
///   PtrnIndex++;
///   AddPatternTarget(ClctIndex, PtrnIndex, 3, 1);
///   AddPatternTarget(ClctIndex, PtrnIndex, 3, 5);
///   PtrnIndex++;
///   AddPatternTarget(ClctIndex, PtrnIndex, 4, 1);
///   AddPatternTarget(ClctIndex, PtrnIndex, 2, 5);
///   PtrnIndex++;
///   AddPatternTarget(ClctIndex, PtrnIndex, 5, 1);
///   AddPatternTarget(ClctIndex, PtrnIndex, 1, 5);
///   PtrnIndex++;
///   AddPatternTarget(ClctIndex, PtrnIndex, 5, 2);
///   AddPatternTarget(ClctIndex, PtrnIndex, 1, 4);
///   PtrnIndex++;
///   AddPatternTarget(ClctIndex, PtrnIndex, 5, 3);
///   AddPatternTarget(ClctIndex, PtrnIndex, 1, 3);
///   PtrnIndex++;
///   AddPatternTarget(ClctIndex, PtrnIndex, 5, 4);
///   AddPatternTarget(ClctIndex, PtrnIndex, 1, 2);
///   PtrnIndex++;
///   
///   AddPatternTarget(ClctIndex, PtrnIndex, 4, 4);
///   AddPatternTarget(ClctIndex, PtrnIndex, 2, 2);
///   PtrnIndex++;
///   AddPatternTarget(ClctIndex, PtrnIndex, 3, 4);
///   AddPatternTarget(ClctIndex, PtrnIndex, 3, 2);
///   PtrnIndex++;
///   AddPatternTarget(ClctIndex, PtrnIndex, 2, 4);
///   AddPatternTarget(ClctIndex, PtrnIndex, 4, 2);
///   PtrnIndex++;
///   AddPatternTarget(ClctIndex, PtrnIndex, 2, 3);
///   AddPatternTarget(ClctIndex, PtrnIndex, 4, 3);
///   PtrnIndex++;
///   
///   AddPatternTarget(ClctIndex, PtrnIndex, 3, 3);
///   PtrnIndex++;
///   
///   PatternCollection[ClctIndex].NextTargetDelay = 0.5;
///   PatternCollection[ClctIndex].NextTargetTime = 0.5;
///   PatternCollection[ClctIndex].DownDelay = 1.50;
///   PatternCollection[ClctIndex].DownTime = 2.0;
///   
///   /** Pattern #2 **/
///   
///   ClctIndex = 2;
///   PtrnIndex = 2;
///   
///   
///   
///   AddPatternTarget(ClctIndex, PtrnIndex, 3, 3);
///   PtrnIndex++;
///   
///   AddPatternTarget(ClctIndex, PtrnIndex, 2, 3);
///   AddPatternTarget(ClctIndex, PtrnIndex, 3, 2);
///   AddPatternTarget(ClctIndex, PtrnIndex, 3, 4);
///   AddPatternTarget(ClctIndex, PtrnIndex, 4, 3);
///   PtrnIndex++;
///   
///   AddPatternTarget(ClctIndex, PtrnIndex, 1, 3);
///   AddPatternTarget(ClctIndex, PtrnIndex, 3, 1);
///   AddPatternTarget(ClctIndex, PtrnIndex, 3, 5);
///   AddPatternTarget(ClctIndex, PtrnIndex, 5, 3);
///   PtrnIndex++;
///   
///   /** Delay **/
///   PtrnIndex++;
///   
///   AddPatternTarget(ClctIndex, PtrnIndex, 1, 1);
///   AddPatternTarget(ClctIndex, PtrnIndex, 1, 2);
///   AddPatternTarget(ClctIndex, PtrnIndex, 1, 4);
///   AddPatternTarget(ClctIndex, PtrnIndex, 1, 5);
///   AddPatternTarget(ClctIndex, PtrnIndex, 2, 1);
///   AddPatternTarget(ClctIndex, PtrnIndex, 2, 2);
///   AddPatternTarget(ClctIndex, PtrnIndex, 2, 4);
///   AddPatternTarget(ClctIndex, PtrnIndex, 2, 5);
///   AddPatternTarget(ClctIndex, PtrnIndex, 4, 1);
///   AddPatternTarget(ClctIndex, PtrnIndex, 4, 2);
///   AddPatternTarget(ClctIndex, PtrnIndex, 4, 4);
///   AddPatternTarget(ClctIndex, PtrnIndex, 4, 5);
///   AddPatternTarget(ClctIndex, PtrnIndex, 5, 1);
///   AddPatternTarget(ClctIndex, PtrnIndex, 5, 2);
///   AddPatternTarget(ClctIndex, PtrnIndex, 5, 4);
///   AddPatternTarget(ClctIndex, PtrnIndex, 5, 5);
///   
///   PatternCollection[ClctIndex].NextTargetDelay = 1.0;
///   PatternCollection[ClctIndex].NextTargetTime = 1.0;
///   PatternCollection[ClctIndex].DownDelay = 1.25;
///   PatternCollection[ClctIndex].DownTime = 0.50;
///   
///   
///   /** Pattern #3 **/
///   
///   ClctIndex = 3;
///   PtrnIndex = 1;
///   
///   PtrnIndex++;
///   AddPatternTarget(ClctIndex, PtrnIndex, 1, 1);
///   AddPatternTarget(ClctIndex, PtrnIndex, 1, 3);
///   AddPatternTarget(ClctIndex, PtrnIndex, 1, 5);
///   AddPatternTarget(ClctIndex, PtrnIndex, 2, 2);
///   AddPatternTarget(ClctIndex, PtrnIndex, 2, 4);
///   AddPatternTarget(ClctIndex, PtrnIndex, 3, 1);
///   AddPatternTarget(ClctIndex, PtrnIndex, 3, 3);
///   AddPatternTarget(ClctIndex, PtrnIndex, 3, 5);
///   AddPatternTarget(ClctIndex, PtrnIndex, 4, 2);
///   AddPatternTarget(ClctIndex, PtrnIndex, 4, 4);
///   AddPatternTarget(ClctIndex, PtrnIndex, 5, 1);
///   AddPatternTarget(ClctIndex, PtrnIndex, 5, 3);
///   AddPatternTarget(ClctIndex, PtrnIndex, 5, 5);
///   PtrnIndex++;
///   PtrnIndex++;
///   
///   AddPatternTarget(ClctIndex, PtrnIndex, 1, 2);
///   AddPatternTarget(ClctIndex, PtrnIndex, 1, 4);
///   AddPatternTarget(ClctIndex, PtrnIndex, 2, 1);
///   AddPatternTarget(ClctIndex, PtrnIndex, 2, 3);
///   AddPatternTarget(ClctIndex, PtrnIndex, 2, 5);
///   AddPatternTarget(ClctIndex, PtrnIndex, 3, 2);
///   AddPatternTarget(ClctIndex, PtrnIndex, 3, 4);
///   AddPatternTarget(ClctIndex, PtrnIndex, 4, 1);
///   AddPatternTarget(ClctIndex, PtrnIndex, 4, 3);
///   AddPatternTarget(ClctIndex, PtrnIndex, 4, 5);
///   AddPatternTarget(ClctIndex, PtrnIndex, 5, 2);
///   AddPatternTarget(ClctIndex, PtrnIndex, 5, 4);
///   PtrnIndex++;
///   PtrnIndex++;
///   
///   AddPatternTarget(ClctIndex, PtrnIndex, 1, 1);
///   AddPatternTarget(ClctIndex, PtrnIndex, 1, 3);
///   AddPatternTarget(ClctIndex, PtrnIndex, 1, 5);
///   AddPatternTarget(ClctIndex, PtrnIndex, 2, 2);
///   AddPatternTarget(ClctIndex, PtrnIndex, 2, 4);
///   AddPatternTarget(ClctIndex, PtrnIndex, 3, 1);
///   AddPatternTarget(ClctIndex, PtrnIndex, 3, 3);
///   AddPatternTarget(ClctIndex, PtrnIndex, 3, 5);
///   AddPatternTarget(ClctIndex, PtrnIndex, 4, 2);
///   AddPatternTarget(ClctIndex, PtrnIndex, 4, 4);
///   AddPatternTarget(ClctIndex, PtrnIndex, 5, 1);
///   AddPatternTarget(ClctIndex, PtrnIndex, 5, 3);
///   AddPatternTarget(ClctIndex, PtrnIndex, 5, 5);
///   PtrnIndex++;
///   PtrnIndex++;
///   
///   AddPatternTarget(ClctIndex, PtrnIndex, 1, 2);
///   AddPatternTarget(ClctIndex, PtrnIndex, 1, 4);
///   AddPatternTarget(ClctIndex, PtrnIndex, 2, 1);
///   AddPatternTarget(ClctIndex, PtrnIndex, 2, 3);
///   AddPatternTarget(ClctIndex, PtrnIndex, 2, 5);
///   AddPatternTarget(ClctIndex, PtrnIndex, 3, 2);
///   AddPatternTarget(ClctIndex, PtrnIndex, 3, 4);
///   AddPatternTarget(ClctIndex, PtrnIndex, 4, 1);
///   AddPatternTarget(ClctIndex, PtrnIndex, 4, 3);
///   AddPatternTarget(ClctIndex, PtrnIndex, 4, 5);
///   AddPatternTarget(ClctIndex, PtrnIndex, 5, 2);
///   AddPatternTarget(ClctIndex, PtrnIndex, 5, 4);
///   PtrnIndex++;
///   PtrnIndex++;
///   
///   PatternCollection[ClctIndex].NextTargetDelay = 1.25;
///   PatternCollection[ClctIndex].NextTargetTime = 1.25;
///   PatternCollection[ClctIndex].DownDelay = 1.8;
///   PatternCollection[ClctIndex].DownTime = 0.2;
///   
///   /** Pattern #4 **/
///   
///   ClctIndex = 4;
///   PtrnIndex = 1;
///   
///   AddPatternTarget(ClctIndex, PtrnIndex, 1, 1);
///   AddPatternTarget(ClctIndex, PtrnIndex, 2, 2);
///   AddPatternTarget(ClctIndex, PtrnIndex, 3, 3);
///   AddPatternTarget(ClctIndex, PtrnIndex, 4, 4);
///   AddPatternTarget(ClctIndex, PtrnIndex, 5, 5);
///   AddPatternTarget(ClctIndex, PtrnIndex, 5, 1);
///   AddPatternTarget(ClctIndex, PtrnIndex, 4, 2);
///   AddPatternTarget(ClctIndex, PtrnIndex, 2, 4);
///   AddPatternTarget(ClctIndex, PtrnIndex, 1, 5);
///   PtrnIndex++;
///   
///   AddPatternTarget(ClctIndex, PtrnIndex, 1, 2);
///   AddPatternTarget(ClctIndex, PtrnIndex, 1, 3);
///   AddPatternTarget(ClctIndex, PtrnIndex, 1, 4);
///   AddPatternTarget(ClctIndex, PtrnIndex, 2, 1);
///   AddPatternTarget(ClctIndex, PtrnIndex, 2, 3);
///   AddPatternTarget(ClctIndex, PtrnIndex, 2, 5);
///   AddPatternTarget(ClctIndex, PtrnIndex, 3, 1);
///   AddPatternTarget(ClctIndex, PtrnIndex, 3, 2);
///   AddPatternTarget(ClctIndex, PtrnIndex, 3, 4);
///   AddPatternTarget(ClctIndex, PtrnIndex, 3, 5);
///   AddPatternTarget(ClctIndex, PtrnIndex, 4, 1);
///   AddPatternTarget(ClctIndex, PtrnIndex, 4, 3);
///   AddPatternTarget(ClctIndex, PtrnIndex, 4, 5);
///   AddPatternTarget(ClctIndex, PtrnIndex, 5, 2);
///   AddPatternTarget(ClctIndex, PtrnIndex, 5, 3);
///   AddPatternTarget(ClctIndex, PtrnIndex, 5, 4);
///   PtrnIndex++;
///   
///   
///   AddPatternTarget(ClctIndex, PtrnIndex, 1, 1);
///   AddPatternTarget(ClctIndex, PtrnIndex, 2, 2);
///   AddPatternTarget(ClctIndex, PtrnIndex, 3, 3);
///   AddPatternTarget(ClctIndex, PtrnIndex, 4, 4);
///   AddPatternTarget(ClctIndex, PtrnIndex, 5, 5);
///   AddPatternTarget(ClctIndex, PtrnIndex, 5, 1);
///   AddPatternTarget(ClctIndex, PtrnIndex, 4, 2);
///   AddPatternTarget(ClctIndex, PtrnIndex, 2, 4);
///   AddPatternTarget(ClctIndex, PtrnIndex, 1, 5);
///   PtrnIndex++;
///   
///   AddPatternTarget(ClctIndex, PtrnIndex, 1, 2);
///   AddPatternTarget(ClctIndex, PtrnIndex, 1, 3);
///   AddPatternTarget(ClctIndex, PtrnIndex, 1, 4);
///   AddPatternTarget(ClctIndex, PtrnIndex, 2, 1);
///   AddPatternTarget(ClctIndex, PtrnIndex, 2, 3);
///   AddPatternTarget(ClctIndex, PtrnIndex, 2, 5);
///   AddPatternTarget(ClctIndex, PtrnIndex, 3, 1);
///   AddPatternTarget(ClctIndex, PtrnIndex, 3, 2);
///   AddPatternTarget(ClctIndex, PtrnIndex, 3, 4);
///   AddPatternTarget(ClctIndex, PtrnIndex, 3, 5);
///   AddPatternTarget(ClctIndex, PtrnIndex, 4, 1);
///   AddPatternTarget(ClctIndex, PtrnIndex, 4, 3);
///   AddPatternTarget(ClctIndex, PtrnIndex, 4, 5);
///   AddPatternTarget(ClctIndex, PtrnIndex, 5, 2);
///   AddPatternTarget(ClctIndex, PtrnIndex, 5, 3);
///   AddPatternTarget(ClctIndex, PtrnIndex, 5, 4);
///   PtrnIndex++;
///   
///   PatternCollection[ClctIndex].NextTargetDelay = 2.5;
///   PatternCollection[ClctIndex].NextTargetTime = 2.5;
///   PatternCollection[ClctIndex].DownDelay = 2.0;
///   PatternCollection[ClctIndex].DownTime = 0.2;
///   
///   /** Pattern #5 **/
///   
///   ClctIndex = 5;
///   PtrnIndex = 2;
///   
///   AddPatternTarget(ClctIndex, PtrnIndex, 2, 2);
///   PtrnIndex++;
///   
///   AddPatternTarget(ClctIndex, PtrnIndex, 1, 2);
///   AddPatternTarget(ClctIndex, PtrnIndex, 2, 1);
///   AddPatternTarget(ClctIndex, PtrnIndex, 3, 2);
///   AddPatternTarget(ClctIndex, PtrnIndex, 2, 3);
///   PtrnIndex++;
///   
///   AddPatternTarget(ClctIndex, PtrnIndex, 4, 2);
///   AddPatternTarget(ClctIndex, PtrnIndex, 2, 4);
///   PtrnIndex++;
///   
///   AddPatternTarget(ClctIndex, PtrnIndex, 2, 5);
///   AddPatternTarget(ClctIndex, PtrnIndex, 5, 2);
///   PtrnIndex++;
///   
///   /** **/
///   AddPatternTarget(ClctIndex, PtrnIndex, 4, 4);
///   PtrnIndex++;
///   
///   AddPatternTarget(ClctIndex, PtrnIndex, 4, 3);
///   AddPatternTarget(ClctIndex, PtrnIndex, 3, 4);
///   AddPatternTarget(ClctIndex, PtrnIndex, 4, 5);
///   AddPatternTarget(ClctIndex, PtrnIndex, 5, 4);
///   PtrnIndex++;
///   
///   AddPatternTarget(ClctIndex, PtrnIndex, 2, 4);
///   AddPatternTarget(ClctIndex, PtrnIndex, 4, 2);
///   PtrnIndex++;
///   
///   AddPatternTarget(ClctIndex, PtrnIndex, 1, 4);
///   AddPatternTarget(ClctIndex, PtrnIndex, 4, 1);
///   PtrnIndex++;
///   
///   /** Delay **/
///   PtrnIndex++;
///   
///   AddPatternTarget(ClctIndex, PtrnIndex, 1, 1);
///   AddPatternTarget(ClctIndex, PtrnIndex, 1, 3);
///   AddPatternTarget(ClctIndex, PtrnIndex, 1, 5);
///   AddPatternTarget(ClctIndex, PtrnIndex, 3, 1);
///   AddPatternTarget(ClctIndex, PtrnIndex, 3, 3);
///   AddPatternTarget(ClctIndex, PtrnIndex, 3, 5);
///   AddPatternTarget(ClctIndex, PtrnIndex, 5, 1);
///   AddPatternTarget(ClctIndex, PtrnIndex, 5, 3);
///   AddPatternTarget(ClctIndex, PtrnIndex, 5, 5);
///   
///   PatternCollection[ClctIndex].NextTargetDelay = 1.0;
///   PatternCollection[ClctIndex].NextTargetTime = 1.0;
///   PatternCollection[ClctIndex].DownDelay = 1.25;
///   PatternCollection[ClctIndex].DownTime = 1.0;
///   
///   
///   
///   /*
///   
///   AddPatternTarget(ClctIndex, PtrnIndex, 1, 1);
///   AddPatternTarget(ClctIndex, PtrnIndex, 1, 2);
///   AddPatternTarget(ClctIndex, PtrnIndex, 1, 3);
///   AddPatternTarget(ClctIndex, PtrnIndex, 1, 4);
///   AddPatternTarget(ClctIndex, PtrnIndex, 1, 5);
///   AddPatternTarget(ClctIndex, PtrnIndex, 2, 1);
///   AddPatternTarget(ClctIndex, PtrnIndex, 2, 2);
///   AddPatternTarget(ClctIndex, PtrnIndex, 2, 3);
///   AddPatternTarget(ClctIndex, PtrnIndex, 2, 4);
///   AddPatternTarget(ClctIndex, PtrnIndex, 2, 5);
///   AddPatternTarget(ClctIndex, PtrnIndex, 3, 1);
///   AddPatternTarget(ClctIndex, PtrnIndex, 3, 2);
///   AddPatternTarget(ClctIndex, PtrnIndex, 3, 3);
///   AddPatternTarget(ClctIndex, PtrnIndex, 3, 4);
///   AddPatternTarget(ClctIndex, PtrnIndex, 3, 5);
///   AddPatternTarget(ClctIndex, PtrnIndex, 4, 1);
///   AddPatternTarget(ClctIndex, PtrnIndex, 4, 2);
///   AddPatternTarget(ClctIndex, PtrnIndex, 4, 3);
///   AddPatternTarget(ClctIndex, PtrnIndex, 4, 4);
///   AddPatternTarget(ClctIndex, PtrnIndex, 4, 5);
///   AddPatternTarget(ClctIndex, PtrnIndex, 5, 1);
///   AddPatternTarget(ClctIndex, PtrnIndex, 5, 2);
///   AddPatternTarget(ClctIndex, PtrnIndex, 5, 3);
///   AddPatternTarget(ClctIndex, PtrnIndex, 5, 4);
///   AddPatternTarget(ClctIndex, PtrnIndex, 5, 5);
///   PtrnIndex++;
///   */
///   
/// }
/// 
/// function AddPatternTarget(int CollectionIndex, int PatternIndex, int TileX, int TileY)
/// {
///   if (PatternCollection.Length <= CollectionIndex)
///     PatternCollection.Length = CollectionIndex + 1;
///     
///   if (PatternCollection[CollectionIndex].TargetCollection.Length <= PatternIndex)
///     PatternCollection[CollectionIndex].TargetCollection.Length = PatternIndex + 1;
///   
///   PatternCollection[CollectionIndex].TargetCollection[PatternIndex].TileX.AddItem(TileX);
///   PatternCollection[CollectionIndex].TargetCollection[PatternIndex].TileY.AddItem(TileY);
/// }
/// 
/// function Clear_Craft_Targets()
/// {
///   local int TileX, TileY;
///   
///   /** Clear Targeters **/
///   TileY = 1;
///   do
///   {
///     TileX = 1;
///     do
///     {
///       UpdateDrawInfo("Craft_Game_Targeter_" $ TileY $ "x" $ TileX, 0);
///       
///       TileX++;
///     } until (TileX >= 6);
///     
///     TileY++;
///   } until (TileY >= 6);
///   
/// }
/// 
/// function Craft_Game_Tick()
/// {
///   local int TileX, TileY;
///   
///   Render_Craft_Page();
///   Craft_Gameplay_Update();
///   
///   /** Set component positions **/
///   TileY = 1;
///   do
///   {
///     TileX = 1;
///     do
///     {
///       if (CraftTileY[TileY].CraftTileX[TileX].DownTime > 0.0 && CraftTileY[TileY].CraftTileX[TileX].DownDelay <= 0.0)
///         CraftTileY[TileY].CraftTileX[TileX].DownTime -= 0.025;
/// 
///       if (CraftTileY[TileY].CraftTileX[TileX].DownDelay > 0)
///         CraftTileY[TileY].CraftTileX[TileX].DownDelay -= 0.025;
///       
///       if (CraftTileY[TileY].CraftTileX[TileX].DownDelay <= 0)
///       {
///         CraftTileY[TileY].CraftTileX[TileX].Target_VC.SetEnabled(false);
///         CraftTileY[TileY].CraftTileX[TileX].Target_VC.bAutoFlicker = false;
///       }
///       
///       TileX++;
///     } until (TileX >= 6);
///     
///     TileY++;
///   } until (TileY >= 6);
///   
///   /** Flicker Toggle **/
///   CraftFlicker = !CraftFlicker;
/// }
/// 
/// function Render_Craft_Page()
/// {
///   local int TileX, TileY;
///   
///   /** Set component positions **/
///   TileY = 1;
///   do
///   {
///     TileX = 1;
///     do
///     {
///       /** Draw Background **/
///       if (CraftTileY[TileY].CraftTileX[TileX].DownTime > 0.0 
///       &&  CraftTileY[TileY].CraftTileX[TileX].DownDelay <= 0)
///       {
///         CraftTileY[TileY].CraftTileX[TileX].Background_VC.images[0] = CraftTileY[TileY].CraftTileX[TileX].Background_VC.images[3];
///         
///       } else {
///         if (CraftTileY[TileY].CraftTileX[TileX].ActivedThisRound)
///         {
///           CraftTileY[TileY].CraftTileX[TileX].Background_VC.images[0] = CraftTileY[TileY].CraftTileX[TileX].Background_VC.images[2];
///         } else {
///           CraftTileY[TileY].CraftTileX[TileX].Background_VC.images[0] = CraftTileY[TileY].CraftTileX[TileX].Background_VC.images[1];
///         }
///       }
///       
///       /** Draw Targets **
///       if (CraftTileY[TileY].CraftTileX[TileX].DownDelay > 0)
///       {
///         UpdateDrawInfo("Craft_Game_Targeter_" $ TileY $ "x" $ TileX, 1);
///         SetImageAlpha("Craft_Game_Targeter_" $ TileY $ "x" $ TileX, (CraftFlicker) ? 128 : 255);
///       } else {
///         UpdateDrawInfo("Craft_Game_Targeter_" $ TileY $ "x" $ TileX, 0);
///       }
///       */
///       
///       TileX++;
///     } until (TileX >= 6);
///     
///     TileY++;
///   } until (TileY >= 6);
///   
/// }
/// 
/// function Render_Craft_Game_Selector()
/// {
///   local int PosX, PosY, EndX, EndY;
///   
///   PosX = 230 + (140*CraftSelectX);
///   EndX = PosX + 152;
///   PosY = -40 + (140*CraftSelectY);
///   EndY = PosY + 152;
///   RenderImage("Craft_Game_Selector", PosX, PosY, EndX, EndY);
/// }
/// 
/// function Render_Tile_Level(int TileX, int TileY)
/// {
///   /** Draw Tile Level **/
///   UpdateDrawInfo("Craft_Game_Tile_Level_" $ TileY $ "x" $ TileX, CraftTileY[TileY].CraftTileX[TileX].Level, "Craft_Game_Tile_Level_1x1");
/// }
/// 
/// function Craft_Gameplay_Update()
/// {
///   /** Check for game over **/
///   if (CraftTileY[CraftSelectY].CraftTileX[CraftSelectX].DownTime > 0 && CraftTileY[CraftSelectY].CraftTileX[CraftSelectX].DownDelay <= 0)
///   {
///     /** Game Over **/
///     Remaining_Craft_Attempts--;
///     CraftGameActive = false;
///     CraftGameOver = true;
///     RoTTHUD(Outer).SetTimer(0.0, true, 'Craft_Game_Tick');
///     RoTTHUD(Outer).SetTimer(1.5, false, 'Craft_Game_Over_Tick');
///     
///     /** Death SFX **/
///     PlaySFX( AC_SFX_Craft_Death );
///     
///   }
///   
///   PatternCollection[CraftCollectionIndex].NextTargetTime -= 0.025;
///   
///   if (PatternCollection[CraftCollectionIndex].NextTargetTime <= 0)
///   {
///     CraftPatternIndex++;
///     
///     if (PatternCollection[CraftCollectionIndex].TargetCollection.Length <= CraftPatternIndex)
///     {
///       /** Randomize **/
///       CraftCollectionIndex = Rand(PatternCollection.Length - 1) + 1;
///       CraftPatternIndex = 0;
///     }
///     
///     PatternCollection[CraftCollectionIndex].NextTargetTime = PatternCollection[CraftCollectionIndex].NextTargetDelay * CraftSpeedAmp();
///     
///     SetTargets();
///   }
/// }
/// 
/// function Craft_Game_Over_Tick()
/// {
///   if (Remaining_Craft_Attempts != 0)
///   {
///     /** +1 at the start of each round **/
///     CraftLevelBonus++;
///     
///     /** Initialize Game **/
///     Initialize_Craft_Game();
///     
///   } else {
///     /** Push game over page **/
///     Push_Craft_GameOver();
///     
///     /** Gameover SFX **/
///     PlaySFX( AC_SFX_Craft_Gameover );
///     
///   }
///   
///   ClaimedTiles = 0;
///   
///   /* CLEAR TARGETS */
///   Clear_Craft_Targets();
///   
///   /** Update Lives GUI **/
///   MoveLabel("Craft_Game_Lives_Label", 362, 32, 1440, 900, "Lives: " $ Remaining_Craft_Attempts);
///   
///   UpdateDrawInfo("Craft_Game_Selector" ,0);
///   CraftGameOver = false;
/// }
/// 
/// function float CraftSpeedAmp()
/// {
///   local float SpeedAmp;
///   
///   switch (CraftRound)
///   {
///     case 1:
///       SpeedAmp = 1.0;
///       break;
///     case 2:
///       SpeedAmp = 0.6;
///       break;
///     case 3:
///       SpeedAmp = 0.4;
///       break;
///     case 4:
///       SpeedAmp = 0.3;
///       break;
///     default:
///       SpeedAmp = 0.25;
///       break;
///     
///   }
///   
///   return SpeedAmp;
/// }
/// 
/// function Reset_Craft_Grid()
/// {
///   local int TileY, TileX;
///   
///   /* All 25 claimed! */
///   /** CraftClear SFX **/
///   PlaySFX( AC_SFX_Craft_Clear );
///   
///   /** Reset count **/
///   ClaimedTiles = 0;
///   
///   /** Reset acivated tiles **/
///   TileY = 1;
///   do
///   {
///     TileX = 1;
///     do
///     {
///       CraftTileY[TileY].CraftTileX[TileX].ActivedThisRound = false;
///       UpdateDrawInfo("Craft_Game_Tile_Level_" $ TileY $ "x" $ TileX, 0);
///       
///       /** Reset down times **/
///       CraftTileY[TileY].CraftTileX[TileX].Background_VC.images[0] = None;
///       CraftTileY[TileY].CraftTileX[TileX].DownTime = 0.0;
///       
///       /** Hide targeters **/
///       CraftTileY[TileY].CraftTileX[TileX].Target_VC.SetEnabled(false);
///       CraftTileY[TileY].CraftTileX[TileX].Target_VC.bAutoFlicker = false;
///       
///       TileX++;
///     } until (TileX >= 6);
///     
///     TileY++;
///   } until (TileY >= 6);
///   
///   /** Next Round **/
///   CraftRound++;
///   CraftLevelBonus++;
///   
///   /** Update GUI **/
///   MoveLabel("Craft_Game_Level_Label", 0, 32, 1078, 900, "Level Bonus: " $ CraftLevelBonus);
///   
///   /** Finished! **/
///   if (CraftRound >= 9)
///   {
///     CraftGameActive = false;
///     CraftGameOver = true;
///     RoTTHUD(Outer).SetTimer(0.0, true, 'Craft_Game_Tick');
///     RoTTHUD(Outer).SetTimer(1.5, false, 'Craft_Game_Over_Tick');
///     
///     /** Victory SFX **/
///     PlaySFX( AC_Cheerwave_03 );
///     
///   }
///   
///   /** Next Pattern **/
///   CraftPatternIndex = 0;
///   CraftCollectionIndex = Rand(PatternCollection.Length - 1) + 1;
///   PatternCollection[CraftCollectionIndex].NextTargetTime = 0.6;
/// }
/// 
/// function SetTargets()
/// {
///   local int TileX, TileY;
///   local float DownDelay, DownTime;
///   local int i;
///   
///   if (PatternCollection[CraftCollectionIndex].TargetCollection[CraftPatternIndex].TileX.Length == 0)
///     return;
///   
///   DownDelay = PatternCollection[CraftCollectionIndex].DownDelay * CraftSpeedAmp();
///   DownTime = PatternCollection[CraftCollectionIndex].DownTime * CraftSpeedAmp();
///   
///   do
///   {
///     TileX = PatternCollection[CraftCollectionIndex].TargetCollection[CraftPatternIndex].TileX[i];
///     TileY = PatternCollection[CraftCollectionIndex].TargetCollection[CraftPatternIndex].TileY[i];
///     
///     deactivateTile(TileX, TileY, DownDelay, DownTime);
///     i++;
///   } until (i >= PatternCollection[CraftCollectionIndex].TargetCollection[CraftPatternIndex].TileX.Length);
///   
/// }
/// 
/// function CraftGameNavigateUp()
/// {
///   if (CraftSelectY > 1 && CraftGameActive)
///     CraftSelectY--;
/// }
/// 
/// function CraftGameNavigateDown()
/// {
///   if (CraftSelectY < 5 && CraftGameActive)
///     CraftSelectY++;
/// }
/// 
/// function CraftGameNavigateLeft()
/// {
///   if (CraftSelectX > 1 && CraftGameActive)
///     CraftSelectX--;
/// }
/// 
/// function CraftGameNavigateRight()
/// {
///   if (CraftSelectX < 5 && CraftGameActive)
///     CraftSelectX++;
/// }
/// 
/// function CraftGameSelectA()
/// {
///   if (CraftGameOver)
///     return;
///     
///   if (CraftGameActive == false)
///   {
///     if (Remaining_Craft_Attempts > 0)
///     {
///       UpdateDrawInfo("Craft_Game_Selector", 1);
///       CraftGameActive = true;
///       RoTTHUD(Outer).SetTimer(0.025, true, 'Craft_Game_Tick');
///     } else {
///       PopPage();
///       PushPage(GUIPage(FindComponentByTag("NPCPage")));
///     }
///     
///   } else {
///     LevelUpTile();
///   }
/// }













