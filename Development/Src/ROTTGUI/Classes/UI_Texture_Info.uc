/*=============================================================================
 * UI_Texture_Info
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: Stores textures and some drawing options
 *===========================================================================*/
 
class UI_Texture_Info extends object;

// Stored texture for UI use 
var public array<texture> componentTextures;

// Selected texture index
var privatewrite int textureIndex;

// Pixel offset to start and end the UV tiling
var privatewrite vector2d subUVStart;
var privatewrite vector2d subUVEnd;

// Color to be multiplied through the whole texture
var public color drawColor;

// Vertical "Alpha Mask" Ratio
var public float vertRatio;

// Horizontal "Alpha Mask" Ratio
var public float horizontalRatio;

// Mirrors texture horizontally when true
var public bool bMirroredHorizontal;

/*===========================================================================*/

`include(ROTTColorLogs.h)

/*=============================================================================
 * Initialize Component
 *
 * Description: This event is called as the UI is loaded.
 *===========================================================================*/
event initializeInfo() {
  // Check for a valid texture selection
  if (componentTextures.length == 0) return;
  if (componentTextures[textureIndex] == none) return;
  
  // Check for default end points
  if (subUVEnd.X == 0.0 || subUVEnd.Y == 0.0) {
    // Assign end points from texture size
    if (Texture2D(componentTextures[textureIndex]) != none) {
      subUVEnd.X = Texture2D(componentTextures[textureIndex]).sizeX;
      subUVEnd.Y = Texture2D(componentTextures[textureIndex]).sizeY;
    } else if (TextureRenderTarget2D(componentTextures[textureIndex]) != none) {
      subUVEnd.X = TextureRenderTarget2D(componentTextures[textureIndex]).sizeX;
      subUVEnd.Y = TextureRenderTarget2D(componentTextures[textureIndex]).sizeY;
    }
  }
}

/*============================================================================= 
 * getSizeX()
 *
 * 
 *============================================================================*/
public function int getSizeX() {
  if (componentTextures.length == 0) {
    yellowLog("Warning (!) Textures are blank for " $ self);
    return 0;
  }
  return Texture2D(componentTextures[textureIndex]).sizeX;
}

/*============================================================================= 
 * getSizeY()
 *
 * 
 *============================================================================*/
public function int getSizeY() {
  if (textureIndex >= componentTextures.length) {
    yellowLog("Warning (!) No texture info for " $ self);
    return 0;
  }
  return Texture2D(componentTextures[textureIndex]).sizeY;
}

/*============================================================================= 
 * getTexture()
 *
 * 
 *============================================================================*/
public function texture getTexture() {
  if (textureIndex >= componentTextures.length) {
    yellowLog("Warning (!) No texture info for " $ self);
    return none;
  }
  return componentTextures[textureIndex];
}

/*============================================================================= 
 * selectTexture()
 *
 * Given an index, a texture is selected
 *============================================================================*/
public function selectTexture(int index) {
  // Select texture
  textureIndex = index;
  
  // Check validity of selection
  if (getTexture() == none) {
    yellowLog("Warning (!) Selected invalid texture");
  }
}

/*============================================================================= 
 * randomizeTexture()
 *
 * Randomly selects a texture
 *============================================================================*/
public function randomizeTexture() {
  selectTexture(rand(componentTextures.length));
  violetLog("Randomly selected: " $ textureIndex);
}

/*============================================================================= 
 * randomizeOrientation()
 *
 * Randomly selects an orientation (left or right)
 *============================================================================*/
public function randomizeOrientation() {
  bMirroredHorizontal = rand(2521) % 2 == 1;
}

/*============================================================================= 
 * drawTexture()
 *
 * Draws the component to the screen, necessary for every frame.
 *============================================================================*/
public function drawTexture
(
  Canvas C, 
  vector2D topLeft, 
  vector2D bottomRight, 
  color parentColor
) 
{
  local Rotator r;
  
  // Check for a texture to draw
  if (componentTextures.length == 0) return;
  if (componentTextures[textureIndex] == none) return;
  
  // Modify coordinates for vertical and horizontal masking
  topLeft.Y += (bottomRight.Y - topLeft.Y) * (1.0 - vertRatio);
  bottomRight.X -= (bottomRight.X - topLeft.X) * (1.0 - horizontalRatio);
  
  // Set coordinate positioning
  if (bMirroredHorizontal) {
    c.setPos(2 * topLeft.X - bottomRight.X, topLeft.Y); /// incorrect top left info? goodluck
  } else {
    c.setPos(topLeft.X, topLeft.Y);
  }
  
  c.setDrawColorStruct(class'UI_Component'.static.multiplyColors(parentColor, drawColor));
  
  // Modify coordinates for mirroring
  if (bMirroredHorizontal) {
    // Draw texture mirrored
    r.yaw = 0;
    r.roll = 0;
    r.pitch = 65536 / 2;
    c.drawRotatedTile(
      componentTextures[textureIndex], 
      r,
      (bottomRight.X - topLeft.X) * 2, 
      bottomRight.Y - topLeft.Y,
      
      subUVStart.X,
      subUVStart.Y,
      subUVEnd.X * 2, 
      subUVEnd.Y,
      
      0.5,
      0.5
    );
    
  } else {
    // Draw texture standard
    c.drawTile(
      componentTextures[textureIndex], 
      bottomRight.X - topLeft.X, 
      bottomRight.Y - topLeft.Y,
      subUVStart.X,
      subUVStart.Y + subUVEnd.Y * (1.0 - vertRatio),
      subUVEnd.X * (horizontalRatio), 
      subUVEnd.Y * (vertRatio)
    );
    
  }
}

/*=============================================================================
 * deleteInfo()
 *===========================================================================*/
event deleteInfo() {
  componentTextures.length = 0;
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  drawColor=(R=255,G=255,B=255,A=255)
  
  vertRatio=1.f
  horizontalRatio=1.f
}


















