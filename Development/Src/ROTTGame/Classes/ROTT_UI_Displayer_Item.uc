/*=============================================================================
 * ROTT_UI_Displayer_Item
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Used to display an item on screen
 *===========================================================================*/

class ROTT_UI_Displayer_Item extends UI_Container; /// Warning: this inheritance needs to be updated to ROTT_UI_Displayer

// Display settings
var private bool bShowIfSingular;

// Item sprite
var private UI_Sprite itemSprite;

// Quantity label
var private UI_Label quantityLabel;

/*============================================================================= 
 * initializeComponent
 *
 * This is called as the UI is loaded.  Our initial scene is drawn here.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  super.initializeComponent(newTag);
  
  // Internal references
  itemSprite = findSprite("Item_Sprite");
  quantityLabel = findLabel("Item_Quantity_Label");
  
}

/*=============================================================================
 * elapseTimer()
 *
 * Time is passed to non-actors through the scene that contains them
 *===========================================================================*/
public function elapseTimer(float deltaTime, float gameSpeedOverride) {
  super.elapseTimer(deltaTime, gameSpeedOverride);
  
  
}

/*=============================================================================
 * updateDisplay()
 *
 * Given a hero, this updates the UI with their info
 *===========================================================================*/
public function updateDisplay(ROTT_Inventory_Item item) {
  // Draw item information
  if (item != none) {
    setEnabled(true);
    
    // Show item graphic
    itemSprite.copySprite(item.itemSprite, 0, true);
    
    // Show quantity only for stacked items
    if (bShowIfSingular || item.quantity > 1 || item.quantity == 0) {
      quantityLabel.setText(item.quantity);
    } else {
      quantityLabel.setText("");
    }
  } else {
    setEnabled(false);
  }
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  bDrawRelative=true
  
  // Hide by default
  bShowIfSingular=false
  
  // Item graphic
  begin object class=UI_Sprite Name=Item_Sprite
    tag="Item_Sprite"
    posX=0
    posY=0
    posXEnd=128
    posYEnd=128
  end object
  componentList.add(Item_Sprite)
  
  // Quantity label
  begin object class=UI_Label Name=Item_Quantity_Label
    tag="Item_Quantity_Label"
    posX=0
    posY=0
    posXEnd=125
    posYEnd=127
    AlignX=RIGHT
    AlignY=BOTTOM
    fontStyle=DEFAULT_LARGE_WHITE
    labelText=""
  end object
  componentList.add(Item_Quantity_Label)
  
}














