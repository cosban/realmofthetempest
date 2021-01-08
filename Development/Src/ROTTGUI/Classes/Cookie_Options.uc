/*=============================================================================
 * Cookie_Options
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: Stores game option data for saved files.
 *===========================================================================*/
 
class Cookie_Options extends object;

var float sfxVolume;
var float musicVolume;

var bool bTick1;
var bool bTick2;

var int scaleModeType;

var bool showCombatDetail;

/*=============================================================================
 * toggleCombatDetail()
 *
 * Shows or hides combat details, like hp and mp numbers
 *===========================================================================*/
public function toggleCombatDetail() {
  showCombatDetail = !showCombatDetail;
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  // Default display settings
  showCombatDetail=true 
  
}