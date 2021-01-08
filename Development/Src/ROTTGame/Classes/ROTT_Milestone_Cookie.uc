/*=============================================================================
 * ROTT_Milestone_Cookie
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: Stores milestone data separate from profiles.
 *===========================================================================*/
 
class ROTT_Milestone_Cookie extends ROTTObject
dependsOn(ROTT_Game_Player_Profile);

enum SaveState {
  SAVE_EMPTY,
  SAVE_FILLED
};

// Store best milestone times
var privatewrite float bestTimes[SpeedRunMilestones];
var privatewrite SaveState savedTimes[SpeedRunMilestones];

/*=============================================================================
 * recordMilestone()
 * 
 * Called to record a milestone time, returns true if personal best.
 *===========================================================================*/
public function bool recordMilestone(int milestoneIndex, float newTime) {
  if (savedTimes[milestoneIndex] == SAVE_EMPTY) {
    bestTimes[milestoneIndex] = newTime;
    savedTimes[milestoneIndex] = SAVE_FILLED;
    return true;
  }
  
  if (newTime < bestTimes[milestoneIndex]) {
    // Store the new time
    bestTimes[milestoneIndex] = newTime;
    gameInfo.saveMilestones();
    return true;
  }
  return false;
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  
}