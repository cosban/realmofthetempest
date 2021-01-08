/*============================================================================= 
 * ROTT_Resource_Gem_SkM
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: A skeletal mesh with a particle system for a collectible gem.
 *===========================================================================*/

class ROTT_Resource_Gem_SkM extends Actor;

// Graphics internal references
var private skeletalMeshComponent gemSkeleton;
var private ParticleSystemComponent gemSparkle;

function postBeginPlay() {
	super.postBeginPlay();
  
	gemSkeleton.attachComponentToSocket(gemSparkle, 'Sparkle_Socket');
  
	gemSparkle.activateSystem();
}

simulated function tick(float deltaTime) {
	setRotation(
    RInterpTo(
      rotation, 
      rotation + rot(0, 30000, 0), 
      deltaTime, 
      0.75
    )
  );
}

/*============================================================================= 
 * Default Properties
 *===========================================================================*/
defaultproperties
{
  // Gem skeletal mesh
	Begin Object Class=SkeletalMeshComponent Name=Gem_Skeletal_Mesh
		SkeletalMesh=SkeletalMesh'ROTT_Resources.Resource_Gem'
		LightingChannels=(Cinematic_8=True)
	End Object
	gemSkeleton=Gem_Skeletal_Mesh
  components.add(Gem_Skeletal_Mesh)
	
  // Gem sparkle
	Begin Object Class=ParticleSystemComponent Name=PSC_Gem_Sparkle
    Template=ParticleSystem'ROTT_Resources.PS_Resource_Gold'
	End Object
	gemSparkle=PSC_Gem_Sparkle
  components.add(PSC_Gem_Sparkle)
  
}




















