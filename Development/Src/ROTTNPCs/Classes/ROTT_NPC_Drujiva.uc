/*=============================================================================
 * ROTT_NPC_Drujiva
 *
 * Author: Otay
 * Bramble Gate Studios (All rights reserved)
 *
 * Tethered to the mountain shrine, Drujiva is the druid sage that fused with
 * the spirit of the land.  Drujiva requests the player's help in restoring the
 * land from corruption, but is in fact already corrupt by Dominus.
 *===========================================================================*/

class ROTT_NPC_Drujiva extends ROTT_NPC_Container;

// Macros for formatting dialog content
`DEFINE NEW_NODE(TOPIC, MODE)           addDialogNode(`TOPIC, `MODE, 
`DEFINE ADD_OPTIONS(TOPIC, MODE)        addOptions(`TOPIC, `MODE, 
`DEFINE ADD_REPLY(TOPIC, MODE, INDEX)   addReplyChain(`TOPIC, `MODE, `INDEX,

`DEFINE ENDNODE );

/*=============================================================================
 * initDialogue()
 * 
 * This sets all the dialog content
 *===========================================================================*/
public function initDialogue() {
  super.initDialogue();
  
  // Introduction
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "Drujiva speaking, I'm the druid sage of this", 
    "mountain shrine"
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "Heal beneath this four spirit house, as the", 
    "queen of this mountain peak shines holy light down for us."
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "Won't you. . . will you help recover this shrine?", 
    "Our only need is to retrieve the golden ornaments."
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "The golden ornaments have become sprawled out,", 
    "now in the hands of evil, in the chaos of this. . ."
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "this. . . black magic tragedy.", 
    ""
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "Retrieve the golden ornaments of chaos from the fallen citadels", 
    "of Rhunia, Etzland, Haxlyn, Valimor, and Kalroth."
  `ENDNODE
  
  `NEW_NODE(INTRODUCTION, NUETRAL)
    "Then shall we. . . find hope in order.", 
    ""
  `ENDNODE
  
  setInquiry(
    "Goodnight",
    "",
    "",
    "",
    
    BEHAVIOR_GOODBYE,
    BEHAVIOR_NONE,
    BEHAVIOR_NONE,
    BEHAVIOR_NONE
  );
  
  // Greeting
  `NEW_NODE(GREETING, NUETRAL)
    "From the form of each branch of the Sister's Oak, stems hope.", 
    "Let's find this hope together."
  `ENDNODE
  
  /**
  "I sense you have brought the keys to our salvation."
  "Well done."
  [Offer items][Goodbye]
  
  **/
  
  /// --------------------------------------------------------------
  
  /** 
  
  [Pause, 3 second delay] 
  
  [Music starts] 
    (0:00)
  
  [Data corruption symptoms, letters falling like the matrix]
    
  [Dialog remains locked, and blank, as music plays]
  
  [Drujiva sprite flicker]
    (0:08)
  
  [Continue dialog with a fixed pace]
    (0:16)
  
  **/
  
  
  /// --------------------------------------------------------------
  
  /**
  
  "Do you know where black magic comes from?"
  ""
  
  "It comes from bones."
  ""
  
  "Ironic how the structure of all you sick organic machines was 
  built on the desire and devastation of the all knowing void."
  
  "Black magic is in your ivory core, little ant."
  ""
    (0:32)
  
  "And I've come to rip the marrow through every living throat,"
  "one at a time."
  
  "Except you of course, loyal champion."
  ""
  
  "I've had many servants under my thrall,"
  "and I have never harmed them."
  
  "The imp that scavanged my bones after my inceneration,"
  ""
  
  "The sage's son, who buried my remains here,"
  ""
  
  "They live through me, and I through them,"
  "just as the druid sage is here now."
  
  "Drujiva is no longer Drujiva."
  ""
  
  "I've long since soaked this land in the charcoal of my blackened bones."
  ""
  
  "So much for the impervious spirit of the mountain."
  ""
  
  "Hope belongs to me."
  ""
    (Dominus disappears, player control resumed at goodbye option)
    [Goodbye]
  
  **/
  
  /// --------------------------------------------------------------
  
  /** 
  
  [Credits start @ Rhunia outskirts]
   {Bramble Gate Studios presents: Realm of the Tempest}
   {Written by Otay}
   {Designed by Otays}
   {Art by Otaykins}
   {Programmed by Otay}
   {Music by Otays}
   {}
   
  [music fades into black magic]
  [game menu ignores input and rapid cycles selections, +other buggy effects]
  (this forces the player to walk to Rhunia)
  (Rhunia should load in Greater Oblivion mode)
  (Options for lesser / greater oblivion mode should only appear from talonovia)
  
  
  
  **/
  
  
  /// --------------------------------------------------------------
  
}

/*=============================================================================
 * Default properties
 *===========================================================================*/
defaultProperties
{
  // NPC identity
  npcName=GENERIC
  
  // Background
  begin object class=UI_Texture_Info Name=NPC_Background_Dark_Gray
    componentTextures.add(Texture2D'GUI_NPC_Dialog.NPC_Background_Dark_Gray'
  end object
  
  // Sprite container for transfer
  begin object class=UI_Texture_Storage Name=NPC_Background
    tag="NPC_Background"
    images(0)=NPC_Background_Dark_Gray
  end object
  npcBackground=NPC_Background
  
  // NPC Texture
  begin object class=UI_Texture_Info Name=NPC_Black_Gatekeeper
    componentTextures.add(Texture2D'Monsters.Enemy_Portrait_Lycanthrox_Orange_360')
  end object
  
  // Sprite container for transfer
  begin object class=UI_Texture_Storage Name=NPC_Sprites
    tag="NPC_Sprites"
    images(0)=NPC_Black_Gatekeeper
  end object
  npcSprites=NPC_Sprites
}





