/*=============================================================================
 * UI_Tree_Selector
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: 
 *===========================================================================*/
  
class UI_Tree_Selector extends UI_Sprite;

// Grid dimensions
const GRID_WIDTH = 3;
const GRID_HEIGHT = 4;

// Tree Types
enum TreeTypes {
  WIZARD_TREE,
  VALKYRIE_TREE,
  GOLIATH_TREE,
  TITAN_TREE,
  ASSASSIN_TREE
};

var private TreeTypes treeType;

// Tree node config
enum NodeConfig {
  OFF,
  ON
};

var private NodeConfig row1[GRID_WIDTH];
var private NodeConfig row2[GRID_WIDTH];
var private NodeConfig row3[GRID_WIDTH];
var private NodeConfig row4[GRID_WIDTH];

// Pair
struct IntPair {
  var int x, y;
};

// Screen positioning
var private int homeX;               // X Screen position for the home index
var private int homeY;               // Y Screen position for the home index
var private int selectorWidth;       // Sprite width
var private int selectorHeight;      // Sprite height

// Column screen offset Y
var private int colOffsetY[GRID_WIDTH];

// Navigation
var private IntPair homeCoords;      // The default space for selector to start
var private IntPair selectionCoords; // The space which this selector occupies
var private IntPair selectOffset;    // Distance from neighboring spaces
var private IntPair gridSize;        // Total size of 2d selection space

// Setup variables
var private int rowCount;

/*=============================================================================
 * switchTreeType()
 *
 * Sets a new navigation mode for this selector.
 *===========================================================================*/
public function switchTreeType(TreeTypes setTreeType) {
  // Set tree type
  treeType = setTreeType;
  
  // Reset nav rows
  rowCount = 0;
  
  // Setup navigation nodes
  switch (treeType) {
    case WIZARD_TREE:
      row(OFF, ON, OFF);
      row(ON, ON, OFF);
      row(OFF, ON, ON);
      row(ON, ON, ON);
      break;
    case GOLIATH_TREE:
      row(OFF, ON, OFF);
      row(OFF, ON, ON);
      row(ON, ON, ON);
      row(OFF, ON, ON);
      break;
    case TITAN_TREE:
      row(OFF, ON, OFF);
      row(ON, ON, OFF);
      row(ON, OFF, ON);
      row(ON, ON, ON);
      break;
    case VALKYRIE_TREE:
      row(OFF, ON, OFF);
      row(OFF, ON, ON);
      row(ON, ON, ON);
      row(ON, ON, OFF);
      break;
    case ASSASSIN_TREE:
      
      break;
    default:
      yellowLog("Warning (!) Bad tree type: " $ tag);
      break;
  }
}

/*=============================================================================
 * initializeComponent
 *
 * This event is called as the UI is loaded.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  super.initializeComponent(newTag);
  
  // Initialize Selector
  homeX = getX();
  homeY = getY();
  selectionCoords = homeCoords;
  selectorWidth = getXEnd() - getX();
  selectorHeight = getYEnd() - getY();
  
  // Initialize navigation
  switchTreeType(treeType);
}

/*=============================================================================
 * getSelection()
 *
 * Description: Accessor for selection coordinates (x,y)
 *===========================================================================*/
public function int getSelection() {
  return selectionCoords.x + selectionCoords.y * gridSize.x;
}

/*=============================================================================
 * resetSelection()
 *
 * Description: Disabled the graphic, resets the index
 *===========================================================================*/
public function resetSelection() {
  selectionCoords = homeCoords;
  renderUpdate();
  setEnabled(false);
}

/*=============================================================================
 * Movement
 *
 * Description: Changes menu selection
 *===========================================================================*/
public function moveLeft() { 
  local IntPair returnPoint;
  
  returnPoint = selectionCoords;
  
  if (tryLeft()) {
    
  } else {
    // Revert if movement fails
    selectionCoords = returnPoint;
  }
}

public function moveRight() { 
  local IntPair returnPoint;
  
  returnPoint = selectionCoords;
  
  if (tryRight()) {
    
  } else {
    // Revert if movement fails
    selectionCoords = returnPoint;
  }
}

public function moveUp() { 
  local IntPair returnPoint;
  
  returnPoint = selectionCoords;
  
  if (tryUp()) {
    
  } else {
    // Revert if movement fails
    selectionCoords = returnPoint;
  }
}

public function moveDown() { 
  local IntPair returnPoint;
  
  returnPoint = selectionCoords;
  
  if (tryDown()) {
    
  } else {
    // Revert if movement fails
    selectionCoords = returnPoint;
  }
}

protected function bool tryLeft() { 
  // Try moving left
  selectionCoords.x -= 1;
  
  if (validCoords()) {
    return true;
  } else {
    do {
      // Try moving up/down
      selectionCoords.y += (selectionCoords.x == 1) ? -1 : 1;
      
      // Check
      if (selectionCoords.x < 0) return false;
      if (validCoords()) return true;
      
      // Try moving back up/down, and left
      selectionCoords.y -= (selectionCoords.x == 1) ? -1 : 1;
      selectionCoords.x -= 1;
      
      // Check
      if (selectionCoords.x < 0) return false;
      if (validCoords()) return true;
    } until (false);
  }
}

protected function bool tryRight() { 
  // Try moving right
  selectionCoords.x += 1;
  
  if (validCoords()) {
    return true;
  } else {
    do {
      // Try moving up/down
      selectionCoords.y += (selectionCoords.x == 1) ? -1 : 1;
      
      // Check
      if (selectionCoords.x >= GRID_WIDTH) return false;
      if (validCoords()) return true;
      
      // Try moving back up, and right
      selectionCoords.y -= (selectionCoords.x == 1) ? -1 : 1;
      selectionCoords.x += 1;
      
      // Check
      if (selectionCoords.x >= GRID_WIDTH) return false;
      if (validCoords()) return true;
    } until (false);
  }
}

protected function bool tryUp() { 
  do {
    // Try moving up
    selectionCoords.y -= 1;
    
    // Check
    if (selectionCoords.y < 0) return false;
    if (validCoords()) return true;
  } until (false);
}

protected function bool tryDown() { 
  do {
    // Try moving down
    selectionCoords.y += 1;
    
    // Check
    if (selectionCoords.y >= GRID_HEIGHT) return false;
    if (validCoords()) return true;
  } until (false);
}

/*=============================================================================
 * row
 * 
 * This defines the nodes for one row of the tree
 *===========================================================================*/
protected function row(NodeConfig node1, NodeConfig node2, NodeConfig node3) {
  rowCount++;
  
  if (rowCount > GRID_HEIGHT) {
    yellowLog("Warning (!) too many row() calls: " $ tag);
    return;
  }
  
  switch (rowCount) {
    case 1: row1[0] = node1; row1[1] = node2; row1[2] = node3; 
    case 2: row2[0] = node1; row2[1] = node2; row2[2] = node3; 
    case 3: row3[0] = node1; row3[1] = node2; row3[2] = node3; 
    case 4: row4[0] = node1; row4[1] = node2; row4[2] = node3; 
  }
}

/*=============================================================================
 * validCoords()
 *
 * This checks if the 
 *===========================================================================*/
private function bool validCoords() { 
  local bool bValid;
  
  // Check if coordinates are within the grid size
  if (selectionCoords.x < 0)            return false;
  if (selectionCoords.x >= GRID_WIDTH)  return false;
  if (selectionCoords.y < 0)            return false;
  if (selectionCoords.y >= GRID_HEIGHT) return false;
  
  // Check if the selection is within the node config
  switch (selectionCoords.y) {
    case 0: bValid = bool(row1[selectionCoords.x]); break;
    case 1: bValid = bool(row2[selectionCoords.x]); break;
    case 2: bValid = bool(row3[selectionCoords.x]); break;
    case 3: bValid = bool(row4[selectionCoords.x]); break;
  }
  
  // Draw the new selector position, if valid
  if (bValid) renderUpdate();
  return bValid;
}

/*=============================================================================
 * renderUpdate()
 *
 * Draws the selector position on screen based on selection coordinates
 *===========================================================================*/
private function renderUpdate() {
  local int x, y;
  
  // Player selection
  x = selectionCoords.x;
  y = selectionCoords.y;
  
  // Set selector start coordinates
  updatePosition(
    homeX + selectOffset.x * x,
    homeY + selectOffset.y * y,
  );
  
  // Set end coordinates
  updatePosition(
    ,
    ,
    getX() + selectorWidth,
    getY() + selectorHeight
  );
  
  shiftY(colOffsetY[selectionCoords.x]);
}

/*=============================================================================
 * raveHighwindCall()
 *
 * Called by a cheat that enables rave mode graphics on selectors.
 *===========================================================================*/
public function raveHighwindCall() {
  super.raveHighwindCall();
  
  addHueEffect();
}

/*=============================================================================
 * debugNodes()
 *
 * Dumps all the node info into the console
 *===========================================================================*/
private function debugNodes() {
  greenlog(row1[0]@row1[1]@row1[2]);
  greenlog(row2[0]@row2[1]@row2[2]);
  greenlog(row3[0]@row3[1]@row3[2]);
  greenlog(row4[0]@row4[1]@row4[2]);
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  // Navigation
  selectOffset=(x=216,y=216)            // Distance from neighboring spaces
  homeCoords=(x=1,y=0)                  // The space which this selector occupies
  gridSize=(x=GRID_WIDTH,y=GRID_HEIGHT) // Total size of 2d selection space
  
  // Tree type
  treeType=VALKYRIE_TREE
  
  // Column offsets
  colOffsetY(0)=-108
  colOffsetY(2)=-108

  // Alpha Effects
  activeEffects.add((effectType = EFFECT_ALPHA_CYCLE, lifeTime = -1, elapsedTime = 0, intervalTime = 0.4, min = 170, max = 255))
  
}











