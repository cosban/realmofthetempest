/*=============================================================================
 * CheckpointZone
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: When a player reaches this volume, their respawn location is
 * updated based on a related checkpoint marker.
 *===========================================================================*/

class ROTT_Checkpoint extends Actor
	ClassGroup(ROTT_Objects)
	placeable;

// Editor appearance
var const transient SpriteComponent EditorSprite;

// Game collision
var	CylinderComponent CylinderComponent;

// Checkpoint ID
var() privatewrite int Checkpoint_Index;

/*=============================================================================
 * PostBeginPlay()
 *
 * Description: Initilize the graphics and the portal state based on player
 *              profile information
 *===========================================================================*/
event PostBeginPlay() {
  ROTT_Game_Info(WorldInfo.Game).setCheckpointInfo(Checkpoint_Index, location, rotation);
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultproperties
{
  // Editor sprite
	Begin Object Class=SpriteComponent Name=Sprite
		Sprite=Texture2D'MyPackage.Checkpoint_Icon'
		HiddenGame=true
		HiddenEditor=false
		AlwaysLoadOnClient=False
		AlwaysLoadOnServer=False
		SpriteCategoryName="Navigation"
		Scale=2.0
	End Object
	Components.Add(Sprite)
	EditorSprite=Sprite
	
  // Editor arrow
	Begin Object Class=ArrowComponent Name=Arrow
		ArrowColor=(R=150,G=200,B=255)
		ArrowSize=2.5
		bTreatAsASprite=True
		HiddenGame=true
		AlwaysLoadOnClient=False
		AlwaysLoadOnServer=False
		SpriteCategoryName="Navigation"
	End Object
	Components.Add(Arrow)
	
  // Game collision
	Begin Object Class=CylinderComponent Name=CollisionCylinder LegacyClassName=NavigationPoint_NavigationPointCylinderComponent_Class
		CollisionRadius=+0050.000000
		CollisionHeight=+0050.000000
	End Object
	CollisionComponent=CollisionCylinder
	CylinderComponent=CollisionCylinder
	Components.Add(CollisionCylinder)

	bCollideActors=false
	
	bCollideWhenPlacing=true
	
  // Checkpoint ID
	Checkpoint_Index=-1
}
