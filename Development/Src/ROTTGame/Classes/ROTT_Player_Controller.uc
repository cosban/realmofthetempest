/*=============================================================================
 * ROTT_Player_Controller
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This player controller file dictates over world gameplay
 *===========================================================================*/

class ROTT_Player_Controller extends GamePlayerController
dependsOn(ROTT_UI_Page);

// Player control settings
const PLAYER_CROUCH_SPEED = 320;
const PLAYER_SPRINT_SPEED = 980;
const GLIDE_TIME = 0.9;

// Mode constants
const LOCKED   = true;
const UNLOCKED = false;

// Player lock variables
var public bool bRotationLock;
var public bool bJumpCrouchLock;
var public bool bSprintLock;
var public bool bGlideLockUntilGround;

// Status
var privatewrite bool bGliding;
var privatewrite bool bStomping;
var privatewrite bool bCrouching;

// Monster control:
//  - Standing      [ Default spawning ]
//  - Crouching     [ Half common spawn chance ]    { B button }           ---- Possibly increase spawn frequency
//  - Singing       [ Double elite spawn chance ]   { Left bumper }
//  - Praying       [ Alternative spawns ]          { Right bumper }       ---- Possibly reduce spawn frequency

// Player control variables
var privatewrite float remainingGlideTime;

// Useful references
var public ROTT_Game_Info gameInfo;
var public ROTT_Player_Pawn tempestPawn;

`include(ROTTColorLogs.h)

/*=============================================================================
 * PostBeginPlay()
 *
 * 
 *===========================================================================*/
simulated event postBeginPlay() {
  super.PostBeginPlay();
  
  // Establish some useful references
  gameInfo = ROTT_Game_Info(worldInfo.game);
  
  // Gives player controller link to gameInfo
  gameInfo.setPlayerController(self);
}

/*=============================================================================
 * ROTT References
 *===========================================================================*/
public function setPostLoginReferences() {
  tempestPawn = ROTT_Player_Pawn(pawn);
  gameInfo.setPawn(tempestPawn);
  tempestPawn.setController(self);
}

/*=============================================================================
 * trackGlideTime()
 * 
 * Tracks the remaining time for gliding
 *===========================================================================*/
public function trackGlideTime(float deltaTime) {
  remainingGlideTime -= deltaTime;
  if (remainingGlideTime <= 0) {
    releaseGlide();
  }
}

/*=============================================================================
 * toggleCrouch()
 *
 * Swaps in and out of crouch position via controls from: UDKInput.ini
 *===========================================================================*/
exec function toggleCrouch() {
  if (bJumpCrouchLock) return;
  
  // Set crouch attributes on pawn
  (bCrouching) ? releaseCrouch() : setCrouch();
}

/*=============================================================================
 * setCrouch()
 *
 * Set crouch mode
 *===========================================================================*/
public function setCrouch() {
  if (bJumpCrouchLock) return;
  
  // Set status
  bCrouching = true;
  
  // Call event on pawn
  tempestPawn.onCrouch();
}

/*=============================================================================
 * releaseCrouch()
 *
 * Release crouch mode
 *===========================================================================*/
public function releaseCrouch() {
  if (bJumpCrouchLock) return;
  
  // Set status
  bCrouching = false;
  
  // Call event on pawn
  tempestPawn.onCrouchRelease();
}

/*=============================================================================
 * setGlide()
 *
 * Starts glide mode controls from: UDKInput.ini
 *===========================================================================*/
exec function setGlide() {
  if (bStomping) return;
  if (bGlideLockUntilGround) return;
  if (tempestPawn.Physics != PHYS_Falling) return; 
  
  // Apply glide settings
  bGliding = true;
  remainingGlideTime = GLIDE_TIME;
  
  // Lock glide until ground is touched
  bGlideLockUntilGround = true;
  
  // Call event on pawn
  tempestPawn.onGlide();
}

/*=============================================================================
 * releaseGlide()
 *
 * Swaps in and out of crouch position via controls from: UDKInput.ini
 *===========================================================================*/
exec function releaseGlide() {
  // Apply glide settings
  bGliding = false;
  remainingGlideTime = 0;
  
  // Call event on pawn
  tempestPawn.onGlideRelease();
}

/*=============================================================================
 * setStomp()
 *
 * Called when the player stomps down from mid air
 *===========================================================================*/
public function setStomp() {
  // Cancel glide
  if (bGliding) releaseGlide();
  
  // Set status
  bStomping = true;
  
  // Call event on pawn
  tempestPawn.onStomp();
}

/*=============================================================================
 * releaseStomp()
 *
 * Called when the glide ability is stopped
 *===========================================================================*/
public function releaseStomp() {
  // Set status
  bStomping = false;
  
  // Call event on pawn
  tempestPawn.onStompRelease();
}

/*=============================================================================
 * playerSing()
 *
 * Swaps in and out of singing state, which changes monster spawn settings
 *===========================================================================*/
exec function playerSing() {
  gameInfo.playerProfile.bSinging = !gameInfo.playerProfile.bSinging;
  gameInfo.getOverWorldPage().updateSingingStatus(gameInfo.playerProfile.bSinging);
}

/*=============================================================================
 * playerPray()
 *
 * Swaps in and out of praying state, which changes monster spawn settings
 *===========================================================================*/
exec function playerPray() {
  gameInfo.playerProfile.bPraying = !gameInfo.playerProfile.bPraying;
  gameInfo.getOverWorldPage().updatePrayerStatus(gameInfo.playerProfile.bPraying);
}

/*=============================================================================
 * setInitialControls()
 *
 * Applies initial control settings.  (UI Scene worlds have no pawn controls)
 *===========================================================================*/
public function setInitialControls() {
  // Set camera control based on map
  switch (gameInfo.getCurrentMap()) {
    // Locked camera scenes
    case MAP_UI_TITLE_MENU: 
    case MAP_UI_CREDITS:
    case MAP_UI_GAME_OVER:
      //tempestPawn.overrideCamera();
      break;
    // Over World maps
    default:
      tempestPawn.releaseCamera();
      break;
  }
  
  // Freeze controls until a level is loaded
  enablePlayerControls(false);
}

/*=============================================================================
 * enablePlayerControls()
 *
 * Dictates whether player has Over World control.
 *===========================================================================*/
public function enablePlayerControls(bool bEnabled) {
  if (bEnabled == true) {
    tempestPawn.groundSpeed = getGroundSpeed();     // Movement
    bRotationLock = UNLOCKED;                       // Rotation
    bJumpCrouchLock = UNLOCKED;                     // Jump
    bSprintLock = UNLOCKED;                         // Sprint
  } else {
    tempestPawn.groundSpeed = 0;                    // Movement
    bRotationLock = LOCKED;                         // Rotation
    bJumpCrouchLock = LOCKED;                       // Jump
    bSprintLock = LOCKED;                           // Sprint
  }
}

/*=============================================================================
 * updateRotation()
 *
 * Player controller function for rotating the pawn camera 
 *===========================================================================*/
public function updateRotation(float deltaTime) {
  local Rotator  deltaRot, newRotation, viewRotation;
  
  // Rotation control lock
  if (bRotationLock == LOCKED) return;
  
  super.updateRotation(deltaTime);
  
  viewRotation = rotation;
  if (tempestPawn != none)  {
    tempestPawn.setDesiredRotation(viewRotation);
  }
  
  // Calculate Delta to be applied on viewRotation
  deltaRot.Pitch = PlayerInput.aLookUp;
  deltaRot.Yaw = PlayerInput.aTurn / 2;
  
  processviewRotation(deltaTime, viewRotation, deltaRot);
  setRotation(viewRotation);

  viewShake(deltaTime);

  newRotation = viewRotation;
  newRotation.roll = rotation.roll;
  
  if (tempestPawn != none) {
    tempestPawn.faceRotation(NewRotation, deltatime);
  }
}

/*=============================================================================
 * getGroundSpeed()
 *===========================================================================*/
private function int getGroundSpeed() {
  return (bCrouching) ? PLAYER_CROUCH_SPEED : PLAYER_SPRINT_SPEED;
}

exec function SetMinMax(optional float _fMin, optional float _fMax) {
  class'Engine'.static.GetEngine().MinSmoothedFrameRate = FMax(30,_fMin);
  class'Engine'.static.GetEngine().MaxSmoothedFrameRate = FMax(_fMin, _fMax);
}

/*=============================================================================
 * destructor
 *===========================================================================*/
event destroyed() {
  super.destroyed();
  
  gameInfo = none;
  tempestPawn = none;
}

/*=============================================================================
 * Default properties
 *===========================================================================*/
defaultProperties
{
  // Controls and camera
  InputClass=class'ROTTGame.ROTT_Player_Input'
  CameraClass=class'ROTT_Player_Camera'
  
  // Player activity variables
  bCrouching=false
}
















