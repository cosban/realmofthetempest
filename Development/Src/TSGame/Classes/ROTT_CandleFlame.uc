class ROTT_CandleFlame extends Z_UTEmit_HitEffect;

var ParticleSystemComponent FlameComp;

defaultproperties
{
	Begin Object Class=ParticleSystemComponent Name=PSCFlameComp
		Translation=(X=0.0,Y=0.0,Z=0.0)
		Template=ParticleSystem'MyPackage.CandleLight_1A';
		bAcceptsLights=false
		bAutoActivate=true
	End Object
	FlameComp=PSCFlameComp
	Components.Add(PSCFlameComp)
}