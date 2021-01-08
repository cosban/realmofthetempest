/*=============================================================================
 * UI_Selector_2D
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This class defines the behavior and graphics of a 2D selector
 *===========================================================================*/
  
class UI_Selector_2D extends UI_Sprite;
 
struct intPair {
  var int x, y;
};

var private int homeX;              // Position for home index
var private int homeY;              // Position for home index
var private int selectorWidth;      // Sprite width
var private int selectorHeight;     // Sprite height

var public intPair selectOffset;    // Distance from neighboring spaces
var public intPair selectionCoords; // The space which this selector occupies
var public intPair homeCoords;      // The default space for selector to start
var public intPair gridSize;        // Total size of 2d selection space

var private bool wrapSelection;

// Render offsets
struct offsetNode {
  var int xCoord;
  var int yCoord;
  
  var int xOffset;
  var int yOffset;
};
var editinline instanced array<offsetNode> renderOffsets;

// Navigation skips
enum NavDirections {
  NAV_LEFT,
  NAV_RIGHT,
  NAV_UP,
  NAV_DOWN
};

struct navNode {
  var int xCoord;
  var int yCoord;
  
  var NavDirections skipDirection;
};
var editinline instanced array<navNode> navSkips;

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
  selectorWidth = getXEnd() - getX();
  selectorHeight = getYEnd() - getY();
}
  
/*=============================================================================
 * getCoordinates()
 *
 * Description: Accessor for selection coordinates (x,y)
 *===========================================================================*/
public function intPair getCoordinates() {
  return selectionCoords;
}

/*=============================================================================
 * getSelection()
 *
 * Description: Accessor for selection coordinates (x,y)
 *===========================================================================*/
public function int getSelection() {
  return selectionCoords.x + selectionCoords.y * gridSize.x;
}

/**=============================================================================
 * clearSelection()
 *
 * 
 *===========================================================================*/
public function clearSelection() {
  resetSelection();
  setEnabled(false);
}

/**=============================================================================
 * resetSelection()
 *
 * 
 *===========================================================================*/
public function resetSelection() {
  selectionCoords = homeCoords;
  renderUpdate();
}


/*=============================================================================
 * forceSelect()
 *
 * Moves selector to specified coordinates
 *===========================================================================*/
public function forceSelect(int xIndex, int yIndex) {
  selectionCoords.x = xIndex;
  selectionCoords.y = yIndex;
  
  renderUpdate();
}

/*=============================================================================
 * Movement
 *
 * Description: Changes menu selection
 *===========================================================================*/
public function moveLeft() {
  local int distance;
  
  if (selectionCoords.x == 0) {
    if (wrapSelection == true) {
      selectionCoords.x = gridSize.x - 1;
    } else {
      return; 
    }
  } else {
    distance = (isNavSkipped(NAV_LEFT) == true) ? 2 : 1;
    selectionCoords.x -= distance;
  }
  
  renderUpdate();
}

public function moveRight() {
  local int distance;
  
  distance = (isNavSkipped(NAV_RIGHT) == true) ? 2 : 1;
  
  if (selectionCoords.x + distance < gridSize.x) {
    selectionCoords.x += distance;
  } else if (wrapSelection == true) {
    selectionCoords.x += distance;
    if (gridSize.x != 0) selectionCoords.x = selectionCoords.x % gridSize.x;
  }
  renderUpdate();
}

public function moveUp() {
  local int distance;
  
  if (selectionCoords.y == 0) {
    if (wrapSelection == true) {
      selectionCoords.y = gridSize.y - 1;
    } else {
      return; 
    }
  } else {
    distance = (isNavSkipped(NAV_UP) == true) ? 2 : 1;
    selectionCoords.y -= distance;
  }
  renderUpdate();
}

public function moveDown() {
  local int distance;
  if (selectionCoords.y + 1 < gridSize.y) {
    distance = (isNavSkipped(NAV_DOWN) == true) ? 2 : 1;
    selectionCoords.y += distance;
  } else if (wrapSelection == true) {
    selectionCoords.y = 0;
  }
  
  renderUpdate();
}

/*=============================================================================
 * isNavSkipped()
 *
 * Given a direction, this function returns true if navigation skip applies
 * for the selector's coordinates
 *===========================================================================*/
private function bool isNavSkipped(NavDirections direction) {
  local int i;
  // Search through navigation skips
  for (i = 0; i < navSkips.Length; i++) {
    if (navSkips[i].xCoord == selectionCoords.x) {
      if (navSkips[i].yCoord == selectionCoords.y) {
        if (navSkips[i].skipDirection == direction) {
          return true;
        }
      }
    }
  }
  return false;
}

/*=============================================================================
 * renderUpdate()
 *
 * Draw the position of the selector
 *===========================================================================*/
private function renderUpdate() {
  local offsetNode node;
  local int i;
  local int x;
  local int y;
  x = selectionCoords.x;
  y = selectionCoords.y;
  
  // Update start coordinates
  updatePosition(
    homeX + selectOffset.x * x,
    homeY + selectOffset.y * y,
    ,
  
  );
  
  // Search through offsets (2D arrays not supported, so this is hacky)
  for (i = 0; i < renderOffsets.Length; i++) {
    node = renderOffsets[i];
    if (x == node.xCoord && y == node.yCoord) {
      // Update start coordinates
      updatePosition(
        getX() + node.xOffset,
        getY() + node.yOffset
      );
    }
  }
  
  // Set end coordinates
  updatePosition(
    ,
    ,
    getX() + selectorWidth,
    getY() + selectorHeight
  );
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
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  selectOffset=(x=0,y=0)      // Distance from neighboring spaces
  selectionCoords=(x=0,y=0)   // The space which this selector occupies
  gridSize=(x=4,y=4)          // Total size of 2d selection space
  wrapSelection=false         // Wraps top-bottom and left-right if true
}







