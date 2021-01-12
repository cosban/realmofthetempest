/*=============================================================================
 *  ROTT_Party
 *
 *  Author: Otay
 *  Bramble Gate Studios (All rights reserved)
 *
 *  Description: This object manages a party of hero units.
 *  (For enemy units, see: ROTT_Mob.uc)
 *
 *===========================================================================*/

class ROTT_Party extends ROTTObject;

// The members of the party are stored here
var private array<ROTT_Combat_Hero> heroUnits;  

// The units with full TUNA (in order)
var privatewrite array<ROTT_Combat_Hero> readyUnits;  

// The types of units that can be members of this party
var private class<ROTT_Combat_Hero> heroTypes[HeroClassEnum];

// The types of the units that are in this party (for save/load purposes)
var privatewrite array<class<ROTT_Combat_Hero> > heroSaveTypes;

// Party size for save info, only used when saving
var privatewrite int saveInfoPartySize;  

// Party index corresponds to this party's position in the parent data structure
var privatewrite int partyIndex;

enum PartyStatusModes {
  PARTY_ACTIVE,           // Green  - Party currently controlled by player
  PARTY_IDLE,             // Tan
  PARTY_WORSHIPPING,      // Blue 
  PARTY_MONSTER_HUNTING,  // Orange  
  PARTY_TENDING_GARDENS   // Dark Green
};
var privatewrite PartyStatusModes partyStatus;

// Shrine activities --- [Move to shrine activity descriptor]
enum PassiveShrineActivies {
  NO_SHRINE_ACTIVITY,
  
  CLERICS_SHRINE,
  COBALT_SANCTUM,
  THE_ROSETTE_PILLARS,
  LOCKSPIRE_SHRINE,
  
  THE_UNDEAD,
  THE_DEMONIC,
  THE_SERPENTINE,
  THE_BEASTS,
  
  HAWKSPIRE_MEADOW,
  LACEROOT_SHRINE,
  FATEWOOD_GROVE,
  MYRRHIAN_THICKET
  
};

// Stores the shrine activity selected for this party
var public PassiveShrineActivies partyActivity;

// Damage to be dealt at respawn
var private int pendingDamage;

// Total glyph count
var public int glyphCount[GlyphEnum];

/*=============================================================================
 * isShrineActive()
 *
 * Returns true if this party is performing a shrine activity, false otherwise.
 *===========================================================================*/
public function bool isShrineActive() {
  return (partyActivity != NO_SHRINE_ACTIVITY);
}

/*=============================================================================
 * initialize()
 *
 * This function is called when new parties are created.
 *===========================================================================*/
public function initialize(int index) {
  linkReferences();
  
  // Store the index for this party's position in the parent data structure
  partyIndex = index;
  
  heroUnits.length = 0;
  readyUnits.length = 0;
}

/*=============================================================================
 * getUnspentHeroesRange()
 *
 * Returns an array of valid selection indices
 *===========================================================================*/
public function array<bool> getUnspentHeroesRange() {
  local array<bool> bArray;
  local int i;
  
  bArray.length = 3;
  
  for (i = 0; i < getPartySize(); i++) {
    bArray[i] = getHero(i).hasUnspentPoints();
  }
  
  return bArray;
}

/*=============================================================================
 * getValidHeroesRange()
 *
 * Returns an array of valid selection indices
 *===========================================================================*/
public function array<bool> getValidHeroesRange() {
  local array<bool> bArray;
  local int i;
  
  bArray.length = 3;
  
  for (i = 0; i < getPartySize(); i++) {
    bArray[i] = true;
  }
  
  return bArray;
}

/*=============================================================================
 * getSpiritualProwess()
 *
 * Returns spiritual prowess rating
 *===========================================================================*/
public function int getSpiritualProwess() {
  local int prowess;
  local int i;
  
  for (i = 0; i < getPartySize(); i++) {
    prowess += getHero(i).getSpiritualProwess();
  }
  
  return prowess;
}
  
/*=============================================================================
 * getHuntingProwess()
 *
 * Returns hunting prowess rating
 *===========================================================================*/
public function int getHuntingProwess() {
  local int prowess;
  local int i;
  
  for (i = 0; i < getPartySize(); i++) {
    prowess += getHero(i).getHuntingProwess();
  }
  
  return prowess;
}

/*=============================================================================
 * getBotanicalProwess()
 *
 * Returns botanical prowess rating
 *===========================================================================*/
public function int getBotanicalProwess() {
  local int prowess;
  local int i;
  
  for (i = 0; i < getPartySize(); i++) {
    prowess += getHero(i).getBotanicalProwess();
  }
  
  return prowess;
}

/*=============================================================================
 * addHero()
 *
 * This function adds a hero to the party. 
 *===========================================================================*/
public function addHero(HeroClassEnum classInfo) {
  local ROTT_Combat_Hero newUnit;
  
  // Create unit
  newUnit = new(self) heroTypes[classInfo];
  newUnit.initialize();
  newUnit.setInitialStats(heroUnits.length);
  
  // Store unit
  heroUnits.addItem(newUnit);
  heroSaveTypes.addItem(heroTypes[classInfo]);
}

/*=============================================================================
 * removeHero()
 *
 * Used during character creation to switch to another class selection.
 *===========================================================================*/
public function removeHero() {
  // Removes a single item from the last position
  heroUnits.remove(heroUnits.length - 1, 1);
  heroSaveTypes.remove(heroSaveTypes.length - 1, 1);
}

/*=============================================================================
 * checkInParty()
 *
 * Returns true if the specified class is already in this party
 *===========================================================================*/
public function bool checkInParty(HeroClassEnum charClass) {
  local int i;
  
  for (i = 0; i < getPartySize(); i++) {
    if (heroUnits[i].myClass == charClass) {
      return true;
    }
  }
  return false;
}

/*=============================================================================
 * getHero()
 *
 * This function accesses a hero.
 *===========================================================================*/
public function ROTT_Combat_Hero getHero(int index) {
  if (index < getPartySize()) return heroUnits[index];
  return none;
}

/*=============================================================================
 * getRandomHero()
 *
 * This function returns a random hero.
 *===========================================================================*/
public function ROTT_Combat_Hero getRandomHero() {
  local array<ROTT_Combat_Hero> validTargets;  
  local int i, j;
  
  // Populate a list of valid targets (living units)
  for (i = 0; i < heroUnits.length; i++) {
    if (!heroUnits[i].bDead) {
      // Add default
      validTargets.addItem(heroUnits[i]); 
      
      // Add extras
      for (j = 0; j < heroUnits[i].statBoosts[ADD_TARGET]; j++) {
        validTargets.addItem(heroUnits[i]); 
        
        // Cap
        if (validTargets.length > 5) break;
      }
    }
  }
  
  // Randomly select a living unit 
  return validTargets[rand(validTargets.length)];
  
}

/*=============================================================================
 * loadHero()
 *
 * This function loads a hero into the party from a save file.
 *===========================================================================*/
public function loadHero(ROTT_Combat_Hero newHero) {
  // Set up references to skill data and what not
  newHero.initialize();
  
  // Add the hero to the party
  heroUnits.addItem(newHero);
}

/*=============================================================================
 * getPartySize()
 *
 * Accessor for party size.
 *===========================================================================*/
public function int getPartySize() {
  return heroUnits.length;
}

/*=============================================================================
 * getLivingUnitCount()
 *
 * Returns the number of units that are not dead
 *===========================================================================*/
public function int getLivingUnitCount() {
  local int total;
  local int i;
  
  // Count living units
  for (i = 0; i < getPartySize(); i++) {
    if (!heroUnits[i].bDead) {
      total++;
    }
  }
  
  return total;
}

/*=============================================================================
 * battlePrep()
 *
 * This function has two phases, clearing hero info, followed by initializing
 * combat settings (such as attack times and passive buffs.)
 *===========================================================================*/
public function battlePrep() {
  local array<float> ratios;
  local int index;
  local int i;
  
  // Clear hero information
  for (i = 0; i < heroUnits.length; i++) {
    heroUnits[i].skillReset();
    heroUnits[i].battleInit();
  }
  
  violetLog(" $ " $ heroUnits[1].statBoosts[ADD_ATTACK_TIME_PERCENT]);
  
  // Tuna ratios
  ratios.addItem(0.25);
  ratios.addItem(0.50);
  ratios.addItem(0.75);
  
  // Set initial random tuna
  for (i = 0; i < heroUnits.length; i++) {
    index = rand(ratios.length);
    heroUnits[i].setTUNA(ratios[index]);
    
    ratios.remove(index, 1);
  }
  
  violetLog(" $2 " $ heroUnits[1].statBoosts[ADD_ATTACK_TIME_PERCENT]);
  
  // Clear ready units
  readyUnits.length = 0;
  
  // Clear glyph statistics
  for (i = 0; i < class'ROTT_Combat_Object'.static.getGlyphSkillCount(); i++) {
    glyphCount[i] = 0;
  }
  
  // Pass down battle initialization call
  for (i = 0; i < heroUnits.length; i++) {
    heroUnits[i].battlePrep();
  }
  violetLog(" $3 " $ heroUnits[1].statBoosts[ADD_ATTACK_TIME_PERCENT]);
  
}

/*=============================================================================
 * battleEnd()
 *
 * This function is called after a battle is done, and after battle analysis
 * is finished.
 *===========================================================================*/
public function battleEnd() {
  local int i;
  
  // Pass notification through heroes
  for (i = 0; i < heroUnits.length; i++) {
    heroUnits[i].skillReset();
    heroUnits[i].battleEnd();
  }
}

/*=============================================================================
 * onAnalysisComplete()
 *
 * This function is called after a battle is done, and after battle analysis
 * is finished.
 *===========================================================================*/
public function onAnalysisComplete() {
  local int i;
  
  // Pass notification through heroes
  for (i = 0; i < heroUnits.length; i++) {
    heroUnits[i].onAnalysisComplete();
  }
}

/*=============================================================================
 * restoreAll()
 *
 * Restores health and mana to all members of the party.
 *===========================================================================*/
public function restoreAll(optional bool bHealDead = true) {
  local int i;
  for (i = 0; i < getPartySize(); i++) {
    if (bHealDead || !getHero(i).bDead) getHero(i).restore();
  }
}

/*=============================================================================
 * trapDamage()
 *
 * Called before combat is triggered from player falling or hitting a trap.
 *===========================================================================*/
public function trapDamage() {
  local int i;
  
  for (i = 0; i < getPartySize(); i++) {
    if (!getHero(i).bDead) getHero(i).setLifePercent(0.6);
  }
}

/*=============================================================================
 * fuseTeamHpMp()
 *
 * Called from the fusion skill to equalize a portion of the teams Hp and Mp.
 *===========================================================================*/
public function fuseTeamHpMp(float transferTotal) {
  local float totalHp, totalMp;
  local float avgHpRatio, avgMpRatio;
  local float deltaHp, deltaMp;
  local float fuseHp, fuseMp;
  local int sign;
  local int i;
  
  // Sum health and mana ratios
  for (i = 0; i < getPartySize(); i++) {
    // Ignore dead units
    if (!getHero(i).bDead) {
      // Sum ratios for average
      avgHpRatio += getHero(i).getHealthRatio();
      avgMpRatio += getHero(i).getManaRatio();
      
      // Sum totals
      totalHp += getHero(i).subStats[MAX_HEALTH];
      totalMp += getHero(i).subStats[MAX_MANA];
    }
  }
  
  // Calculate average ratio line
  avgHpRatio /= getLivingUnitCount();
  avgMpRatio /= getLivingUnitCount();
  
  // Distribute fusion based on proportions of health and mana pools
  fuseHp = transferTotal * (totalHp / (totalHp + totalMp));
  fuseMp = transferTotal * (totalMp / (totalHp + totalMp));
  
  // Calculate desired transfer amount to reach average
  for (i = 0; i < getPartySize(); i++) {
    if (!getHero(i).bDead) {
      deltaHp += abs((getHero(i).subStats[CURRENT_HEALTH]) - (avgHpRatio * getHero(i).subStats[MAX_HEALTH]));
      deltaMp += abs((getHero(i).subStats[CURRENT_MANA]) - (avgMpRatio * getHero(i).subStats[MAX_MANA]));
    }
  }
  
  // Cap transfer amount if it exceeds distance sum
  if (fuseHp > deltaHp) {
    // Switch to other pool
    fuseMp += fuseHp - deltaHp;
    
    // Cap
    fuseHp = deltaHp;
  }
  if (fuseMp > deltaMp) {
    // Switch to other pool
    fuseHp += fuseMp - deltaMp;
    
    // Final cap of Hp
    if (fuseHp > deltaHp) fuseHp = deltaHp;
    
    // Cap
    fuseMp = deltaMp;
  }
  
  // Distribute Hp Mp
  for (i = 0; i < getPartySize(); i++) {
    if (!getHero(i).bDead) {
      // Health
      if (deltaHp != 0) {
        sign = (getHero(i).getHealthRatio() <= avgHpRatio) ? 1 : -1;
        getHero(i).transferHp(sign * 
          abs((getHero(i).subStats[CURRENT_HEALTH]) - (avgHpRatio * getHero(i).subStats[MAX_HEALTH])) *
          (fuseHp / deltaHp));
      }
      
      // Mana
      if (deltaMp != 0) {
        sign = (getHero(i).getManaRatio() <= avgMpRatio) ? 1 : -1;
        getHero(i).transferMp(sign * 
          abs((getHero(i).subStats[CURRENT_MANA]) - (avgMpRatio * getHero(i).subStats[MAX_MANA])) *
          (fuseMp / deltaMp));
      }
      
      //cyanlog("MP Transfer: " $ sign * fuseMp * (getHero(i).subStats[CURRENT_MANA] / totalMp));
    }
  }
}

/*=============================================================================
 * setPartyStatus()
 *
 * Sets the party status (idle, active, praying, hunting)
 *===========================================================================*/
public function setPartyStatus(PartyStatusModes status) {
  partyStatus = status;
}

/*=============================================================================
 * prepareSaveInfo()
 * 
 * Updates info before saving data
 *===========================================================================*/
public function prepareSaveInfo() {
  saveInfoPartySize = heroUnits.length;
}

/*=============================================================================
 * readyHero()
 * 
 * Adds a unit to the ready queue after completing TUNA time
 *===========================================================================*/
public function readyHero(ROTT_Combat_Hero hero) {
  // Queue
  readyUnits.addItem(hero);
  
  // Switch to action panel UI
  if (readyUnits.length == 1) {
    gameInfo.getCombatScene().updateHeroReady();
  }
}

/*=============================================================================
 * dequeueReadyHero()
 * 
 * Removes a unit after they have executed a combat action
 *===========================================================================*/
public function bool dequeueReadyHero() {
  // Dequeue
  readyUnits.remove(0, 1);
  
  return (readyUnits.length == 0);
}

/*=============================================================================
 * elapseTime()
 *
 * This function is called every tick.
 *============================================================================*/
public function elapseTime(float deltaTime) {
  local int i;
  
  for (i = 0; i < getPartySize(); i++) {
    getHero(i).elapseTime(deltaTime);
  }
}

/*=============================================================================
 * addExp()
 *
 * Provides exp to all heroes after battle
 *============================================================================*/
public function addExp(int expPoints) {
  local int i;
  
  // Give exp if units are alive
  for (i = 0; i < getPartySize(); i++) {
    if (!getHero(i).bDead) getHero(i).addExp(expPoints);
    if (getHero(i).bDead) getHero(i).deathPenaltyExp();
  }
}

/*=============================================================================
 * prepExpAnim()
 *
 * Prep exp animation (hide real exp)
 *============================================================================*/
public function prepExpAnim() {
  local int i;
  
  for (i = 0; i < getPartySize(); i++) {
    getHero(i).bPrepExp = true;
  }
}

/*=============================================================================
 * startExpAnim()
 *
 * Exp animation
 *============================================================================*/
public function startExpAnim() {
  local int i;
  
  for (i = 0; i < getPartySize(); i++) {
    getHero(i).startExpAnim();
  }
}

/*=============================================================================
 * skipExpAnim()
 *
 * Skips all exp animation
 *============================================================================*/
public function skipExpAnim() {
  local int i;
  
  for (i = 0; i < getPartySize(); i++) {
    getHero(i).skipExpAnim();
  }
}

/*=============================================================================
 * elapseExpTime()
 *
 * Called from the victory UI to track time
 *============================================================================*/
public function elapseExpTime(float deltaTime) {
  local int i;
  
  for (i = 0; i < getPartySize(); i++) {
    getHero(i).elapseExpTime(deltaTime);
  }
}

/*=============================================================================
 * debugSaveTypes()
 *
 * Shows the classes saved for this party for debugging
 *============================================================================*/
public function debugSaveTypes() {
  local int i;
  
  for (i = 0; i < heroSaveTypes.length; i++) {
    darkCyanLog(" Save types (" $ i $ "): " $ heroSaveTypes[i]);
  }
}

/*=============================================================================
 * tryGlyphSpawn()
 *
 * This function determines if a glyph will populate into the grid during combat
 *============================================================================*/
public function bool tryGlyphSpawn(GlyphEnum glyph) {
  local int i;
  local int chance;
  local int roll;
  
  // Scan party
  for (i = 0; i < getPartySize(); i++) {
    // Sum hero chances
    chance = getHero(i).getGlyphChance(glyph);
    if (chance > 0) break;
  }

  // Roll random number
  roll = rand(100);
  
  return (roll < chance);
}

/*=============================================================================
 * onDeath()
 *
 * This function is called when a unit in this party dies
 *============================================================================*/
public function onDeath() {
  local int i;
  
  // Remove this unit from ready queue
  for (i = 0; i < readyUnits.length; i++) {
    if (readyUnits[i].bdead) {
      // Dequeue dead unit
      readyUnits.remove(i, 1);
      
      // Check if the dead unit is currently using the action panel
      if (i == 0) gameInfo.getCombatScene().readyHeroHasDied();
    }
  }
  
  // Check for gameover
  for (i = 0; i < heroUnits.length; i++) { 
    if (!heroUnits[i].bDead) return;
  }
  
  // Load game over screen
  gameInfo.consoleCommand("open " $ gameInfo.getMapFileName(MAP_UI_GAME_OVER));
}

/*=============================================================================
 * Default Properties
 *============================================================================*/
defaultProperties 
{
  heroTypes[VALKYRIE]=ROTT_Combat_Hero_Valkyrie
  heroTypes[WIZARD]=ROTT_Combat_Hero_Wizard
  heroTypes[GOLIATH]=ROTT_Combat_Hero_Goliath
  heroTypes[TITAN]=ROTT_Combat_Hero_Titan
  heroTypes[ASSASSIN]=ROTT_Combat_Hero_Assassin
}



























