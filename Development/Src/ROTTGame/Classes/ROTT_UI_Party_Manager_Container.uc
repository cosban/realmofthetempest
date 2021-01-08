/*=============================================================================
 * ROTT_UI_Party_Manager_Container
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Description: This container displays info and status about a given party.
 *===========================================================================*/
 
class ROTT_UI_Party_Manager_Container extends UI_Container;

// Internal references
var private UI_Container infoContainer;

var private UI_Label headerLabel;
var private UI_Label heroClassLabels[3];
var private UI_Label heroLevelLabels[3];
var private UI_Label partyStatus;
var private UI_Label activityLabel;
var private UI_Sprite activityBox;


var private ROTT_UI_Party_Display partyDisplay;
var private UI_Sprite partyBackdrop;

/*=============================================================================
 * Initialize Component
 *
 * Description: This event is called as the UI is loaded.
 *              Our initial scene is drawn here.
 *===========================================================================*/
public function initializeComponent(optional string newTag = "") {
  local int i;

  super.initializeComponent(newTag);
  
  // Party Display
  partyDisplay = ROTT_UI_Party_Display(findComp("Party_Displayer"));

  // Party Display Backdrop
  partyBackdrop = findSprite("Party_Backdrop");
  
  // Party infos
  infoContainer = UI_Container(findComp("Party_Info_Container"));
  activityBox = infoContainer.findSprite("Party_Mgmt_Activity_Box");
  headerLabel = infoContainer.findLabel("Party_Header_Label");
  activityLabel = infoContainer.findLabel("Party_Mgmt_Activity_Label");
  
  for (i = 0; i < 3; i++) {
    heroClassLabels[i] = infoContainer.findLabel("Party_Mgmt_Hero_Class_Label_" $ i + 1);
    heroLevelLabels[i] = infoContainer.findLabel("Party_Mgmt_Hero_Level_Label_" $ i + 1);
  }
  
  partyStatus = infoContainer.findLabel("Party_Mgmt_Status_Label");
}

/*=============================================================================
 * renderPartyInfo()
 *
 * Takes a party as a paramter, and displays that party's status & info
 *===========================================================================*/
public function renderPartyInfo(ROTT_Party party) {
  local string labelText;
  local FontStyles labelFont;
  local int i;
  
  // Visibility settings
  if (party == none) {
    setEnabled(false);
    return;
  }
  setEnabled(true);
  activityBox.setEnabled(party.isShrineActive());
  
  // Set party portrait displays
  partyDisplay.renderParty(party);
  
  // Header text
  headerLabel.setText("Team #" $ party.partyIndex + 1);
  
  // Write hero classes
  for (i = 0; i < 3; i++) {
    if (i < party.getPartySize()) {
      // Draw hero information
      heroClassLabels[i].setText(party.getHero(i).myClass);
      heroLevelLabels[i].setText("Lvl " $ party.getHero(i).level);
    } else {
      // Hide hero information
      heroClassLabels[i].setText("");
      heroLevelLabels[i].setText("");
    }
  }
  
  // Write party status
  switch (party.partyStatus) {
    case PARTY_ACTIVE: 
      labelText = "Active"; 
      labelFont = DEFAULT_SMALL_GREEN; 
      break;
    case PARTY_IDLE:    
      labelText = "Idle";    
      labelFont = DEFAULT_SMALL_TAN; 
      break;
    case PARTY_WORSHIPPING: 
      labelText = "Worshipping"; 
      labelFont = DEFAULT_SMALL_BLUE; 
      break;
    case PARTY_MONSTER_HUNTING:
      labelText = "Hunting Monsters"; 
      labelFont = DEFAULT_SMALL_ORANGE; 
      break;
    case PARTY_TENDING_GARDENS:
      labelText = "Tending Gardens"; 
      labelFont = DEFAULT_SMALL_DARK_GREEN; 
      break;
  }
  
  partyStatus.setText(labelText);
  partyStatus.setFont(labelFont);
  
  // Write shrine activity
  switch (party.partyActivity) {
    case NO_SHRINE_ACTIVITY: 
      labelText = ""; 
      labelFont = DEFAULT_SMALL_GREEN; 
      break;
    case CLERICS_SHRINE:
    case COBALT_SANCTUM:
    case THE_ROSETTE_PILLARS:
    case LOCKSPIRE_SHRINE:
      labelText = "Worshipping";
      labelFont = DEFAULT_SMALL_BLUE; 
      break;
      
    case THE_UNDEAD:
    case THE_DEMONIC:
    case THE_SERPENTINE:
    case THE_BEASTS:
      labelText = "Hunting";
      labelFont = DEFAULT_SMALL_ORANGE; 
      break;
      
    case HAWKSPIRE_MEADOW:
    case LACEROOT_SHRINE:
    case FATEWOOD_GROVE:
    case MYRRHIAN_THICKET:
      labelText = "Gardening";
      labelFont = DEFAULT_SMALL_GREEN; 
      break;
      
  }
  
  activityLabel.setText(labelText);
  activityLabel.setFont(labelFont);
}

/*=============================================================================
 * Assets
 *===========================================================================*/
defaultProperties
{
  // Container draw settings
  bDrawRelative=true
  
  /** ===== Textures ===== **/
  // Party backdrop
	begin object class=UI_Texture_Info Name=Party_Member_Backdrops
    componentTextures.add(Texture2D'GUI.Party_Manager_Party_Member_Backdrops')
  end object
  
  // Info sprites
	begin object class=UI_Texture_Info Name=Party_Mgmt_Data_Component
    componentTextures.add(Texture2D'GUI.Team_Manager.Team_Info_Window_Background')
  end object
	begin object class=UI_Texture_Info Name=Party_Mgmt_Activity_Component
    componentTextures.add(Texture2D'GUI.PartyMGR_Raid_Component')
  end object
  
  /** ===== Components ===== **/
  // Backdrops
	begin object class=UI_Sprite Name=Party_Backdrop
		tag="Party_Backdrop"
    posX=-705
		posY=3
		images(0)=Party_Member_Backdrops
	end object
	componentList.add(Party_Backdrop)
  
  // Party Portraits Displayer
	begin object class=ROTT_UI_Party_Display Name=Party_Displayer
		tag="Party_Displayer" 
    xOffset=204
    posX=-701
    posY=3
    displayMode=MANAGER_PORTRAITS
	end object
	componentList.add(Party_Displayer)
  
	begin object class=UI_Container Name=Party_Info_Container
		tag="Party_Info_Container"
    
    // Party info container background
    begin object class=UI_Sprite Name=Party_Mgmt_Data_Background
      tag="Party_Mgmt_Data_Background" 
      posX=0
      posY=0
      images(0)=Party_Mgmt_Data_Component
    end object
    componentList.add(Party_Mgmt_Data_Background)
    
    // Party header
    begin object class=UI_Label Name=Party_Header_Label
      tag="Party_Header_Label"
      posX=18
      posY=17
      posXEnd=637
      posYEnd=67
      alignX=CENTER
      alignY=CENTER
      padding=(top=0, left=14, right=18, bottom=6)
      fontStyle=DEFAULT_MEDIUM_WHITE
      labelText="Team #1"
    end object
    componentList.add(Party_Header_Label)
    
    // Hero labels
    begin object class=UI_Label Name=Party_Mgmt_Hero_Class_Label_1
      tag="Party_Mgmt_Hero_Class_Label_1" 
      posX=18
      posY=74
      posXEnd=330
      posYEnd=124
      alignX=LEFT
      alignY=CENTER
      padding=(top=0, left=14, right=18, bottom=6)
      fontStyle=DEFAULT_SMALL_TAN
      labelText="Valkyrie"
    end object
    componentList.add(Party_Mgmt_Hero_Class_Label_1)
    begin object class=UI_Label Name=Party_Mgmt_Hero_Class_Label_2
      tag="Party_Mgmt_Hero_Class_Label_2"
      posX=18
      posY=132
      posXEnd=330
      posYEnd=182
      alignX=LEFT
      alignY=CENTER
      padding=(top=0, left=14, right=18, bottom=6)
      fontStyle=DEFAULT_SMALL_TAN
      labelText="Wizard"
    end object
    componentList.add(Party_Mgmt_Hero_Class_Label_2)
    begin object class=UI_Label Name=Party_Mgmt_Hero_Class_Label_3
      tag="Party_Mgmt_Hero_Class_Label_3"
      posX=18
      posY=190
      posXEnd=330
      posYEnd=240
      alignX=LEFT
      alignY=CENTER
      padding=(top=0, left=14, right=18, bottom=6)
      fontStyle=DEFAULT_SMALL_TAN
      labelText="Goliath"
    end object
    componentList.add(Party_Mgmt_Hero_Class_Label_3)
    
    // Hero level labels
    begin object class=UI_Label Name=Party_Mgmt_Hero_Level_Label_1
      tag="Party_Mgmt_Hero_Level_Label_1" 
      posX=18
      posY=74
      posXEnd=330
      posYEnd=124
      alignX=RIGHT
      alignY=CENTER
      padding=(top=0, left=14, right=18, bottom=6)
      fontStyle=DEFAULT_SMALL_WHITE
      labelText="Lvl 5"
    end object
    componentList.add(Party_Mgmt_Hero_Level_Label_1)
    begin object class=UI_Label Name=Party_Mgmt_Hero_Level_Label_2
      tag="Party_Mgmt_Hero_Level_Label_2"
      posX=18
      posY=132
      posXEnd=330
      posYEnd=182
      alignX=RIGHT
      alignY=CENTER
      padding=(top=0, left=14, right=18, bottom=6)
      fontStyle=DEFAULT_SMALL_WHITE
      labelText="Lvl 6"
    end object
    componentList.add(Party_Mgmt_Hero_Level_Label_2)
    begin object class=UI_Label Name=Party_Mgmt_Hero_Level_Label_3
      tag="Party_Mgmt_Hero_Level_Label_3"
      posX=18
      posY=190
      posXEnd=330
      posYEnd=240
      alignX=RIGHT
      alignY=CENTER
      padding=(top=0, left=14, right=18, bottom=6)
      fontStyle=DEFAULT_SMALL_WHITE
      labelText="Lvl 4"
    end object
    componentList.add(Party_Mgmt_Hero_Level_Label_3)
    
    // Party status
    begin object class=UI_Label Name=Party_Mgmt_Status_Label
      tag="Party_Mgmt_Status_Label"
      posX=342
      posY=74
      posXEnd=637
      posYEnd=124
      alignX=LEFT
      alignY=CENTER
      padding=(top=0, left=14, right=18, bottom=6)
      fontStyle=DEFAULT_SMALL_GREEN
      labelText="Idle"
    end object
    componentList.add(Party_Mgmt_Status_Label)
    
    // Activity Box (fifth continer box)
    begin object class=UI_Sprite Name=Party_Mgmt_Activity_Box
      tag="Party_Mgmt_Activity_Box"
      bEnabled=true
      posX=342
      posY=133
      images(0)=Party_Mgmt_Activity_Component
    end object
    componentList.add(Party_Mgmt_Activity_Box)
    
    // Activity Label
    begin object class=UI_Label Name=Party_Mgmt_Activity_Label
      tag="Party_Mgmt_Activity_Label"
      posX=342
      posY=132
      posXEnd=637
      posYEnd=182
      alignX=LEFT
      alignY=CENTER
      padding=(top=0, left=14, right=18, bottom=6)
      fontStyle=DEFAULT_SMALL_TAN
      labelText=""
    end object
    componentList.add(Party_Mgmt_Activity_Label)
    
    /* Progress bar
    begin object class=UI_Sprite Name=Party_Mgmt_Experience_Bar_Back_1
      tag="Party_Mgmt_Experience_Bar_Back_1" 
      bEnabled=false
      posX=1082
      posY=225
      images(0)=Experience_Bar_Back_Black
    end object
    componentList.add(Party_Mgmt_Experience_Bar_Back_1)
    
    begin object class=UI_Sprite Name=Party_Mgmt_Experience_Tube_1
      tag="Party_Mgmt_Experience_Tube_1" 
      posX=1100
      posY=236
      images(0)=Stat_Tube_EXP
    end object
    componentList.add(Party_Mgmt_Experience_Tube_1)
    
    begin object class=UI_Sprite Name=Party_Mgmt_Experience_Bar_Frame_1
      tag="Party_Mgmt_Experience_Bar_Frame_1"  
      posX=1082
      posY=225
      images(0)=Experience_Bar_Frame
    end object
    componentList.add(Party_Mgmt_Experience_Bar_Frame_1)
    */
  end object
  componentList.add(Party_Info_Container)
}
	