/*=============================================================================
 * ROTT_Combat_Enemy_Watcher
 *
 * Lore: Their lantern is not a lantern... but instead it is a special package
 *  with many pockets.
 *  
 * Abilities:
 *  
 *===========================================================================*/
class ROTT_Combat_Enemy_Watcher extends ROTT_Combat_Enemy
  dependsOn(ROTT_Worlds_Encounter_Info);
  
/*=============================================================================
 * initStats()
 *
 * Called before all other initialization functions
 *===========================================================================*/
public function initStats
(
  EnemyTypes enemyType, 
  SpawnTypes spawnerType
)
{
  // Sprite assignment handled in super class
  super.initStats(enemyType, spawnerType);
  
  // Set stat modifiers for individual clans here
  switch (clanColor) {
    case CLAN_BLUE:
    case CLAN_CYAN:
    case CLAN_GREEN:
    case CLAN_GOLD:
    case CLAN_ORANGE:
    case CLAN_RED:
    case CLAN_VIOLET:
    case CLAN_PURPLE:
    case CLAN_BLACK: 
    case CLAN_WHITE:
      // Fixed stat points per level
      armorPerLvl = 0;
      baseStatsPerLvl[PRIMARY_VITALITY] = 5;
      baseStatsPerLvl[PRIMARY_STRENGTH] = 4;
      baseStatsPerLvl[PRIMARY_COURAGE] = 2;
      baseStatsPerLvl[PRIMARY_FOCUS] = 2;
      
      // Randomly rolled stat variation
      randStatsPerLvl = 1;
      
      // Stat preferences (must add up to 100)
      statPreferences[PRIMARY_VITALITY] = 35;
      statPreferences[PRIMARY_STRENGTH] = 30;
      statPreferences[PRIMARY_COURAGE] = 35;
      statPreferences[PRIMARY_FOCUS] = 0;

      // Affinities
      statAffinities[PRIMARY_VITALITY] = AVERAGE;
      statAffinities[PRIMARY_STRENGTH] = AVERAGE;
      statAffinities[PRIMARY_COURAGE] = AVERAGE;
      statAffinities[PRIMARY_FOCUS] = MINOR;
      
      break;
    default:
      yellowLog("Warning (!) No " $ default.monsterName $ " constructor defined for class " $ enemyType);
      break;
  }
}

/*=============================================================================
 * Default Properties
 *===========================================================================*/
defaultProperties
{
  monsterName="Watcher"
  
  // Exp boost
  expAmp=3
  
  // Positive drop rate modifiers
  itemDropRates.add((dropType=class'ROTT_Inventory_Item_Charm_Eluvi',chanceOverride=,minOverride=,maxOverride=,chanceAmp=2,quantityAmp=))
  
  // Negative drop rate modifiers
  ///itemDropRates.add((dropType=class'ROTT_Inventory_Item_Charm_Eluvi',chanceOverride=,minOverride=,maxOverride=,chanceAmp=0,quantityAmp=))
  
  // Currency modifiers
  itemDropRates.add((dropType=class'ROTT_Inventory_Item_Gold',chanceOverride=,minOverride=,maxOverride=,chanceAmp=,quantityAmp=1.75))
  itemDropRates.add((dropType=class'ROTT_Inventory_Item_Gem',chanceOverride=100,minOverride=,maxOverride=,chanceAmp=,quantityAmp=3))
  
  // Sprites 240x240
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Watcher_Blue_240
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Watcher_Blue_240')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Watcher_Cyan_240
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Watcher_Cyan_240')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Watcher_Green_240
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Watcher_Green_240')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Watcher_Gold_240
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Watcher_Gold_240')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Watcher_Orange_240
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Watcher_Orange_240')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Watcher_Red_240
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Watcher_Red_240')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Watcher_Violet_240
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Watcher_Violet_240')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Watcher_Purple_240
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Watcher_Purple_240')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Watcher_Black_240
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Watcher_Black_240')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Watcher_White_240
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Watcher_White_240')
  end object
  
  // Sprite options
  begin object class=UI_Texture_Storage Name=Enemy_Sprite_Container
    tag="Enemy_Sprite_Container"
    images(CLAN_BLUE)=Enemy_Portrait_Watcher_Blue_240
    images(CLAN_CYAN)=Enemy_Portrait_Watcher_Cyan_240
    images(CLAN_GREEN)=Enemy_Portrait_Watcher_Green_240
    images(CLAN_GOLD)=Enemy_Portrait_Watcher_Gold_240
    images(CLAN_ORANGE)=Enemy_Portrait_Watcher_Orange_240
    images(CLAN_RED)=Enemy_Portrait_Watcher_Red_240
    images(CLAN_VIOLET)=Enemy_Portrait_Watcher_Violet_240
    images(CLAN_PURPLE)=Enemy_Portrait_Watcher_Purple_240
    images(CLAN_BLACK)=Enemy_Portrait_Watcher_Black_240
    images(CLAN_WHITE)=Enemy_Portrait_Watcher_White_240
  end object
  enemySprites=Enemy_Sprite_Container
  
  // Sprites 360x360
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Watcher_Blue_360
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Watcher_Blue_360')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Watcher_Cyan_360
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Watcher_Cyan_360')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Watcher_Green_360
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Watcher_Green_360')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Watcher_Gold_360
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Watcher_Gold_360')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Watcher_Orange_360
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Watcher_Orange_360')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Watcher_Red_360
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Watcher_Red_360')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Watcher_Violet_360
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Watcher_Violet_360')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Watcher_Purple_360
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Watcher_Purple_360')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Watcher_Black_360
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Watcher_Black_360')
  end object
  begin object class=UI_Texture_Info Name=Enemy_Portrait_Watcher_White_360
    componentTextures.add(Texture2D'Monsters_Disc_2.Enemy_Portrait_Watcher_White_360')
  end object
  
  // Sprite options
  begin object class=UI_Texture_Storage Name=Champ_Sprite_Container
    tag="Champ_Sprite_Container"
    images(CLAN_BLUE)=Enemy_Portrait_Watcher_Blue_360
    images(CLAN_CYAN)=Enemy_Portrait_Watcher_Cyan_360
    images(CLAN_GREEN)=Enemy_Portrait_Watcher_Green_360
    images(CLAN_GOLD)=Enemy_Portrait_Watcher_Gold_360
    images(CLAN_ORANGE)=Enemy_Portrait_Watcher_Orange_360
    images(CLAN_RED)=Enemy_Portrait_Watcher_Red_360
    images(CLAN_VIOLET)=Enemy_Portrait_Watcher_Violet_360
    images(CLAN_PURPLE)=Enemy_Portrait_Watcher_Purple_360
    images(CLAN_BLACK)=Enemy_Portrait_Watcher_Black_360
    images(CLAN_WHITE)=Enemy_Portrait_Watcher_White_360
  end object
  champSprites=Champ_Sprite_Container
  
}




















